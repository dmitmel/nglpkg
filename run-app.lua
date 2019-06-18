local args = {...}

package.path = table.remove(args, 1)
local app = table.remove(args, 1)

require("ng.boot")
ng.args = args
require(app)
ng.Z()
