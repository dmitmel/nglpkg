--@> ng.doc.internal()
ng.module(
	"ng.atexit.compiled-bake",
	"ng.resource",
	"ng.atexit.runtime",
	"ng.lib.util.quote"
)
ng.bakingDirectives["ng.atexit("] = function (state, lines)
	if #lines ~= 1 then
		error("There must only be one string - the code - in an atexit block.")
	end
	ng.atexit("ng.bakePrint(" .. ng.quoteString(lines[1]) .. ")")
end
