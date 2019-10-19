--@> ng.doc.mixin()
--@: This module, when baked into an application, compresses the modules that come after it using DEFLATE.
--@: This can be useful if you use a lot of uncompressed resources (see [[ng.resource]]).
--@:
--@: DEFLATE is a standard compression format with reasonably good performance.
--@: NGLPKG contains a pure-Lua implementation of a DEFLATE decompressor, so there is no native binary cost to using DEFLATE for decompression.
--@: However, Windows users be warned: For compression (read: when baking), you need to have zlib1.dll on your system.
ng.module(
	"ng.appsize.deflate",
	"ng.lib.decompress.deflate"
)

