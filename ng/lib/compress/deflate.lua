ng.module(
	"ng.lib.compress.deflate",
	"ng.wrap.zlib"
)

ng.compressDeflate = function (data)
	local zs = ffi.new("z_stream")

	if ng.zlib.deflateInit2_(zs, 9, 8, -15, 9, ng.zlibEnums.Z_DEFAULT_STRATEGY, ng.zlibVersion, ng.zlibStreamSize) ~= 0 then
		error("error initializing deflate")
	end

	local bound = ng.zlib.deflateBound(zs, #data)
	local buf = ffi.new("uint8_t[?]", bound)

	zs.inputStream = data
	zs.inputStreamAvailable = #data
	zs.outputStream = buf
	zs.outputStreamAvailable = bound

	if ng.zlib.deflate(zs, ng.zlibEnums.Z_FINISH) ~= ng.zlibEnums.Z_STREAM_END then
		error("error deflating & finishing")
	end
	ng.zlib.deflateEnd(zs) -- ignore return value
	return ffi.string(buf, zs.outputStreamCounter)
end

