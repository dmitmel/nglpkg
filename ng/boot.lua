-- 'ng.runner.boot' : This is used at runtime to start up the module structure.
-- *Design* inspired by Impact, but with a much smaller runtime,
--  with baking removing unnecessary metadata,
--  and with the -selector feature to remove redundant code.
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
	_import = function (name, reason)
		if not ng._modules[name] then
			local fun = ng.optRequire(name .. "-selector")
			if fun then
				ng._import(fun(ng._modules), " (selected) " .. reason)
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
			ng._import(dep, " needed by: " .. name)
		end
		ng._modules[name] = true
	end,
	-- Not valid in baked programs.
	-- This is used by bake-app.lua and run-app.lua to trigger 'atexit' callbacks.
	Z = function ()
	end
}

