--@> DOC.target = "03-BakingInfrastructure"
--@: This module provides the functions used when baking an application.
--@: Not those used as part of the application when baked, but the functions used in the tools that bake applications.
--@:

ng.module(
	"ng.boot-bake",
	"ng.lib.util.finder",
	"ng.atexit"
)

-- Start off by defining the baking framework.

--@: ng.bakeModules: Table, mapping module names to true when that module has already been completely baked.
--@: ng.bakingModules: Table, mapping module names to true when that module is being baked, but isn't done yet.
--@: ng.bakingDirectives: Table, mapping baking directive names to functions to run them: function(state, lines)
--@: TODO: OTHER STUFF

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

-- Output, compression, "session control"
function ng.bakeBegin(rootScheme)
	ng.bakeBegin = nil
	-- This contains all of the hidden state behind baking output & compression.
	-- This is the replacement ng.boot & ng.args = {...}
	local rootSchemeData = "ng={args={...}}"
	local cSchemeData = nil
	local cScheme = nil
	-- Actual functions used during bake
	ng.bakeCompression = function (scheme)
		-- Get rid of any existing compression scheme
		if cScheme then
			local oldScheme = cScheme
			local oldSchemeData = cSchemeData
			-- Has to happen before or the scheme would output to itself, which is of course bad...
			cScheme = nil
			cSchemeData = nil
			oldScheme(oldSchemeData)
		end
		-- Load in the new one
		if scheme then
			cScheme = scheme
			cSchemeData = ""
		end
	end
	ng.bakePrint = function (text, nonewline)
		if not nonewline then
			text = text .. "\n"
		end
		if not cScheme then
			rootSchemeData = rootSchemeData .. text
		else
			cSchemeData = cSchemeData .. text
		end
	end
	-- End of bake stuff
	ng.bakeEnd = function ()
		ng.bakeEnd = nil
		ng.atexit("ng._bakeFinish()")
		-- Delayed until the actual end of the program (ng.Z())
		ng._bakeFinish = function ()
			ng._bakeFinish = nil
			-- Remove support for compression (cannot use compression modules past this point, cSchemeData is locked to nil)
			local bc = ng.bakeCompression
			ng.bakeCompression = nil
			bc(nil)
			-- Remove support for printing (ng.bakeModule will always error past this point, rootSchemeData is finalized)
			ng.bakePrint = nil
			-- Code cannot possibly try to restart baking, so we're ready to pass control to the output scheme
			rootScheme(rootSchemeData)
		end
	end
end

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
	-- Also see boot.lua
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

