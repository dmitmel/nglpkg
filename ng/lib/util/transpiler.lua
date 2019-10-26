--@: This module is used to automatically transpile applications.
--@:
--@: ng.transpile(name):
--@:  Tries to automatically transpile a module.
--@:
--@: Supported:
--@:  Nothing, yet
ng.module(
	"ng.lib.util.transpiler",
	"ng.lib.util.finder",
	"ng.wrap.fs"
)

function ng.transpiler(name)
	for _, place in ipairs(ng.finder(name, ".hxml")) do
		local luaPlace = place:sub(1, -5) .. "lua"
		local f = io.open(place, "rb")
		if f then
			f:close()
			-- Ok, so it's a Haxe module. What do we do?
			local dir, fn = ng.fs.dirname(place)
			io.stderr:write("Compiling " .. name .. " with Haxe. If the haxelib 'nglpkg' library is missing, use 'haxelib dev nglpkg .' in the SDK directory.\n")
			os.execute("haxe -C \"" .. dir .. "\" " .. fn)
			-- Now modify it to make it a valid NGLPKG module
			f = io.open(luaPlace, "rb")
			local dat = f:read("*a")
			f:close()
			f = io.open(luaPlace, "wb")
			f:write("--@> ng.doc.internal()\nng.module(\n\t\"" .. name .. "\"")
			local dependencies = {
				["ng.haxe-support"] = true
			}
			dat = dat:gsub("--IMPORT;\n  ([^;]+);", function (dep)
				if dep ~= "__lua__(x)" then
					dependencies[dep] = true
					return ""
				else
					return "error(\"Not a runtime kind of thing.\");"
				end
			end)
			for k, _ in pairs(dependencies) do
				f:write(",\n\t\"" .. k .. "\"")
			end
			f:write("\n)\n--PREPROCESSOR_HALT\ndo\n" .. dat .. "end\n")
			f:close()
			return
		end
	end
end

-- Enable automatic transpiling
do
	local r = require
	require = function (name, ...)
		ng.transpiler(tostring(name))
		return r(name, ...)
	end
end
