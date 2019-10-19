--@: This module simply depends on all text encodings supported by NGLPKG.
--@: It doesn't actually do anything itself.
--@: 
--@: The encodings in question are:
ng.module(
	"ng.lib.encoding.all",
--@> DOC.lineHandler = function(l) if l:sub(-1) == "," then ng.doc.docPrint("[[" .. l:sub(3, -3) .. "]]") else ng.doc.docPrint("[[" .. l:sub(3, -2) .. "]]") DOC.lineHandler = ng.doc.lineHandlerDefault end end
	"ng.lib.encoding.latin1",
	"ng.lib.encoding.utf8",
	"ng.lib.encoding.utf16"
)

