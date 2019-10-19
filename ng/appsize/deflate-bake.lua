--@> ng.doc.internal()
ng.module(
	"ng.appsize.deflate-bake",
	"ng.lib.compress.deflate",
	"ng.lib.util.quote"
)

ng.bakeCompression(function (allText)
	ng.bakePrint("loadstring(ng.decompressDeflate(" .. ng.quoteString(ng.compressDeflate(allText)) .. "))()")
end)

