-- NOT AN NG MODULE, BECAUSE THE BAKING STUFF WOULD FAIL IF YOU TRIED --

-- A simple application baker tool.
require("ng.boot-bake")

ng.bakeBegin(io.write)
for _, v in ipairs(ng.args) do
	ng.bakeModule(v)
end
ng.bakeEnd()

