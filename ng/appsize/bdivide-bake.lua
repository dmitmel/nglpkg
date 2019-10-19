--@> ng.doc.internal()
ng.module(
	"ng.appsize.bdivide-bake",
	"ng.lib.compress.bdivide",
	"ng.lib.util.quote"
)

ng.bakeCompression(function (allText)
	ng.bakePrint("loadstring(ng.decompressBDivide(" .. ng.quoteString(ng.compressBDivide(allText)) .. "))()")
end)

