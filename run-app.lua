-- Use LUA_PATH and LUA_CPATH.

local args = {...}

local app = table.remove(args, 1)

require("ng.boot")
ng.args = args
require(app)
ng.Z()
