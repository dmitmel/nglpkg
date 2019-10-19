--@: Implements ng.encoding["ISO-8859-1"] (see [[ng.lib.encoding.base]])
--@: This is also known as Latin-1.
ng.module(
	"ng.lib.encoding.latin1",
	"ng.lib.encoding.base"
)
ng.encoding["ISO-8859-1"] = ng.Encoding(
	function (a)
		return a:byte(), a:sub(2)
	end,
	function (a)
		if a >= 0 or a <= 0xFF then
			return string.char(a)
		end
	end
)
