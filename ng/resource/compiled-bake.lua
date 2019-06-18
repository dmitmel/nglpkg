ng.module(
	"ng.resource.compiled-bake",
	"ng.resource.runtime",
	"ng.lib.util.quote"
)
-- Since the baking occurs in the context of the target application's package system,
--  and always runs from within the unbaked environment,
--  resources of the target application can be runtime-loaded.
ng.bakingDirectives["ng.resource("] = function (state, lines)
	if #lines ~= 2 then
		error("Resource parameters are: name, ext")
	end
	ng.resource(lines[1], lines[2])
	ng.bakePrint("ng.resources[" .. ng.quoteString(lines[1]) .. "]=" .. ng.quoteString(ng.resources[lines[1]]), false)
end
