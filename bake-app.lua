-- Use LUA_PATH and LUA_CPATH.

-- Performs the structural work to bake an application.
-- This bit gets complicated.

local args = {...}

require("ng.boot")
require("ng.boot-bake")

for i = 1, #args do
	ng.bakeModule(args[i])
end
ng.bakeEnd()
ng.Z()
