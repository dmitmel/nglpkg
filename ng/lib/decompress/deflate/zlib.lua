--@> DOC.module.MODULE = "ng.lib.decompress.deflate"
--@: This module allows decompressing DEFLATE-compressed data.
--@: The function ng.decompressDeflate(data) returns the resulting data, or errors if something goes wrong.

ng.module(
	"ng.lib.decompress.deflate.zlib",
	"ng.wrap.zlib"
)
-- Uses ZLIB to decompress a DEFLATE stream.
ng.decompressDeflate = function (data)
	local zs = ffi.new("z_stream")
	if ng.zlib.inflateInit2_(zs, -15, ng.zlibVersion, ng.zlibStreamSize) ~= 0 then
		error("Could not initialize deflater")
	end
	local out = ""
	zs.inputStream = data
	zs.inputStreamAvailable = #data
	zs.inputStreamCounter = 0
	local buf = ffi.new("uint8_t[65536]")
	local buflen = 65536
	while true do
		zs.outputStream = buf
		zs.outputStreamAvailable = 65536
		zs.outputStreamCounter = 0
		local err = ng.zlib.inflate(zs, ng.zlibEnums.Z_SYNC_FLUSH)
		out = out .. ffi.string(buf, zs.outputStreamCounter)
		if err == ng.zlibEnums.Z_STREAM_END then
			break
		elseif err == ng.zlibEnums.Z_BUF_ERROR then
			error("Z_BUF_ERROR, " .. #out .. " (improper finalization?)")
		elseif err ~= ng.zlibEnums.Z_OK then
			error("Error in deflater: " .. err)
		end
	end
	return out
end

