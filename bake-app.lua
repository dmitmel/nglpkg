-- Performs the structural work to bake an application.
-- This bit gets complicated.

local args = {...}

package.path = args[1]

require("ng.boot")
require("ng.boot-bake")

for i = 2, #args do
	ng.bakeModule(args[i])
end
ng.bakeEnd()
ng.Z()
