-- NOT AN NG MODULE, DON'T TRY --

-- A simple application baker tool.
require("ng.boot-bake")

for _, v in ipairs(ng.args) do
	ng.bakeModule(v)
end
ng.bakeEnd()
ng.Z()
