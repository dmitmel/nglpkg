-- Notably, this avoids relying on ng stuff for a lot of things because it might interfere with testing.
-- Or, it provides some of those things.

local args = {...}

PROJECT_DIR = table.remove(args, 1)
NGLPKG_SDK = table.remove(args, 1)
if not (PROJECT_DIR and NGLPKG_SDK) then error("Use setup or setup.cmd") end
-- Batch backslash path convention can bite batch escaping rules, at least in Wine
if PROJECT_DIR:sub(-1) == " " then PROJECT_DIR = PROJECT_DIR:sub(1, -2) end
if NGLPKG_SDK:sub(-1) == " " then NGLPKG_SDK = NGLPKG_SDK:sub(1, -2) end

-- This allows "nglpkg-settings.lua" to do just about anything on startup before anything else has happened.
-- This is important for projects that need to configure package.path and package.cpath for their dependencies,
--  run their own setup steps for their dependencies...
pcall(require, "nglpkg-settings")

do
	if args[1] == "help" or not args[1] then
		print("NGLPKG SDK: " .. NGLPKG_SDK)
		print("Project: " .. PROJECT_DIR)
		print("")
		print("Usage:")
		print(" sdk <module> <args...>")
		print("  Runs the given module with the given arguments.")
		print("")
		print("See README.md for further information.")
	else
		-- Just a normal NG application testing lifecycle (regardless of if it's actually an NG module or not, see: ng.bake)
		require("ng.boot")
		local program = table.remove(args, 1)
		ng.args = args
		-- This doesn't support -selector, nor should it support -selector
		require(program)
		ng.Z()
	end
end

