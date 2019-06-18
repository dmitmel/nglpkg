ng.module(
	"ng.boot-bake",
	"ng.lib.util.finder"
)

-- Start off by defining the baking framework.

ng.bakeModules = {}
ng.bakingModules = {}
ng.bakingDirectives = {
	["ng.module("] = function (state, lines)
		if state.mod then
			error("module already defined")
		end
		state.mod = lines[1]
		for i = 2, #lines do
			-- Dependencies...
			ng.bakeModule(lines[i])
		end
	end
}

-- This set controls compression.

local function resetCompression()
	ng.bakePrint = function (text, nonewline)
		if nonewline then
			io.write(text)
		else
			print(text)
		end
	end
	ng.bakeEnd = function ()
	end
end

resetCompression()

ng.bakeCompression = function (scheme)
	ng.bakeEnd()
	local allText = ""
	ng.bakePrint = function (text, nonewline)
		if nonewline then
			allText = allText .. text
		else
			allText = allText .. text .. "\n"
		end
	end
	ng.bakeEnd = function ()
		resetCompression()
		scheme(allText)
	end
end

-- This is the replacement ng.boot & ng.args = {...}

ng.bakePrint("ng={args={...}}", true)

-- Module importing

-- The actual baker itself.
-- Like much of this, it borrows concepts from Impact, but implements differently.

ng.preprocessModule = function (name)
	for _, fn in ipairs(ng.finder(name, ".lua")) do
		local ff = io.open(fn, "r")
		if ff then
			local lines = {}
			while true do
				local l = ff:read()
				if not l then
					break
				end
				while l:sub(1, 1) == " " or l:sub(1, 1) == "\t" do
					l = l:sub(2)
				end
				if not l:match("^%-%-") then
					if l ~= "" then
						table.insert(lines, l)
					end
				end
			end
			ff:close()
			return lines
		end
	end
end

ng.bakeModule = function (mod)
	if ng.bakeModules[mod] then
		return
	end
	if ng.bakingModules[mod] then
		error("Baking reference loop for module " .. mod)
		return
	end
	ng.bakingModules[mod] = true
	local fun = ng.optRequire(mod .. "-selector")
	if fun then
		ng.bakeModule(fun(ng.bakeModules))
		ng.bakingModules[mod] = nil
		ng.bakeModules[mod] = true
		return
	end
	local rootlines = ng.preprocessModule(mod)
	if not rootlines then
		error("Missing module " .. mod)
	end
	local state = {}
	while #rootlines > 0 do
		if ng.bakingDirectives[rootlines[1]] then
			local directive = table.remove(rootlines, 1)
			local params = {}
			while true do
				local ln = table.remove(rootlines, 1)
				local str
				if ln == ")" then
					break
				elseif not ln then
					error("terminated file during baking directive")
				elseif ln:sub(1, 1) == "\"" and ln:sub(-1) == "\"" then
					str = ln:sub(2, -2)
				elseif ln:sub(1, 1) == "\"" and ln:sub(-2) == "\"," then
					str = ln:sub(2, -3)
				else
					error("invalid baking sub-directive")
				end
				table.insert(params, str)
			end
			ng.bakingDirectives[directive](state, params)
		else
			-- End of baking directives
			break
		end
	end
	if mod ~= state.mod then
		error("incorrect module ID in " .. mod)
	end
	-- Now actually bake
	for i = 1, #rootlines do
		ng.bakePrint(rootlines[i])
	end
	ng.optRequire(mod .. "-bake")
	ng.bakeModules[mod] = true
	ng.bakingModules[mod] = nil
end

