--@> DOC.target = "01-B-Bakefile"
--@> ng.doc.command({"filename"}, "modules")
--@: For the general concept, see [[ng.bake]].
--@: This version writes the result of baking to a file.
require("ng.boot-bake")

-- Since the command-line isn't UTF-8 we mustn't require ng.wrap.fs
-- Just in case someone does, open the file early
local file = io.open(table.remove(ng.args, 1), "wb")

ng.bakeBegin(function (data)
	file:write(data)
	file:close()
end)
for _, v in ipairs(ng.args) do
	ng.bakeModule(v)
end
ng.bakeEnd()

