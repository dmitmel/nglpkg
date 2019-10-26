--@> DOC.target = "00-Boot"
--@> DOC.module.MODULE = "ng (and how it works)"
--@: This is the basic file that makes up the 'framework' portion of NGLPKG.
--@:
--@: *Design* inspired by Impact, but with a much smaller runtime,
--@:  with baking removing unnecessary metadata.
--@:
--@: This is actually called: ng/boot.lua
--@: It isn't actually a real module.
--@:
--@: It defines the function ng.module(name, deps...), which is a baking directive (see [[ng.bake]])
--@: 
--@: ng.module defines that the module with the given name (that must be the same as the current module's name) has the given dependencies.
--@: 
--@: However, keep in mind that module dependencies in NGLPKG are not as straightforward as usual Lua dependencies.
--@: 
--@: If there is a module with "-selector" appended to the name, that will be used to work out which module to replace the target module with.
--@: (This allows for different implementations of a module to be used dependent on what is already there; it is pointless to use a pure-Lua DEFLATE decompressor if ZLib is already loaded.)
--@: 
--@: When baking, the baker will check for a module with "-bake" at the end, and if that is present, that will be run after the source module is included.

ng = {
	_modules = {},
	-- Only valid here and in baking-related code.
	-- Not valid in main application code.
	optRequire = function (name)
		local ok, res = pcall(require, name)
		if not ok then
			if not res:find("module '" .. name .. "' not found", 1, true) then
				error("during " .. name .. ": " .. res)
			end
			return
		end
		return res
	end,
	dynamicImport = function (name, reason)
		reason = reason or ""
		if not ng._modules[name] then
			-- Also see boot-bake.lua
			local fun = ng.optRequire(name .. "-selector")
			if fun then
				ng.dynamicImport(fun(ng._modules), " (selected) " .. reason)
				ng._modules[name] = true
			else
				require(name)
			end
		end
		if not ng._modules[name] then
			error("Failed to find module: " .. name .. reason)
		end
	end,
	module = function (name, ...)
		for _, dep in ipairs({...}) do
			ng.dynamicImport(dep, " needed by: " .. name)
		end
		ng._modules[name] = true
	end,
	-- Not valid in baked programs.
	-- This is used by bake-app.lua and run-app.lua to trigger 'atexit' callbacks.
	Z = function ()
	end
}

