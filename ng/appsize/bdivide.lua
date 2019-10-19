--@> ng.doc.mixin()
--@: This module, when baked into an application, uses a custom compression algorithm to compress the rest of the application.
--@: However, this compression algorithm cannot handle bytes >= 0x80 (128), so it should typically be combined with an algorithm which does not have this limitation, such as DEFLATE.
ng.module(
	"ng.appsize.bdivide",
	"ng.lib.decompress.bdivide"
)

