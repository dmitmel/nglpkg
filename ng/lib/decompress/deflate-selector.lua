return function (modules)
	if modules["ng.wrap.zlib"] then
		return "ng.lib.decompress.deflate.zlib"
	else
		return "ng.lib.decompress.deflate.pure-lua"
	end
end
