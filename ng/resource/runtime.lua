--@> DOC.module.MODULE = "ng.resource"
--@: Provides the ng.resource baking directive / function.
--@: 
--@: ng.resource(name, ext) allows adding files directly into the program.
--@: 
--@: The method used to find these files is the same as for Lua scripts, but ".lua" is removed and replaced with the given extension.
--@: A table, ng.resources, contains all resources by their names. (without the extension)
--@: 
--@: Example:
--@: 
--@: ng.resource(
--@:  "cattexts.cat01",
--@:  ".txt"
--@: )
--@: 
--@: io.write(ng.resources["cattexts.cat01"])

ng.module(
	"ng.resource.runtime",
	"ng.lib.util.finder"
)

ng.resources = {}
ng.resource = function (name, ext)
	if not ng.resources[name] then
		for _, fn in ipairs(ng.finder(name, ext)) do
			local f = io.open(fn, "rb")
			if f then
				local data = f:read("*a")
				f:close()
				ng.resources[name] = data
				return
			end
		end
		error("Unable to find resource " .. name)
	end
end
