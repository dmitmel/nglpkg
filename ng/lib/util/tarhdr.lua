--@: This module helps with reading TAR files.
--@: TODO: Actually document ng.tarhdr API
ng.module(
	"ng.lib.util.tarhdr"
)

ng.tarhdr = {}

function ng.tarhdr.decodeField(oct)
	local v = 0
	for i = 1, #oct do
		v = (v * 8) + (oct:byte(i) - 0x30)
	end
	return v
end

function ng.tarhdr.getInfo(sector)
	local info = {}
	info.path = sector:sub(1, 100)
	for i = 1, #info.path do if info.path:sub(i, i) == "\x00" then info.path = info.path:sub(1, i - 1) break end end
	info.access = ng.tarhdr.decodeField(sector:sub(101, 107))
	info.uid = ng.tarhdr.decodeField(sector:sub(109, 115))
	info.gid = ng.tarhdr.decodeField(sector:sub(117, 123))
	info.size = ng.tarhdr.decodeField(sector:sub(125, 135))
	info.sectors = math.ceil(info.size / 512)
	info.type = sector:sub(157, 157)
	if info.type == "5" then
		info.type = "directory"
	elseif info.type == "0" then
		info.type = "file"
	end
	-- Date? USTAR information (username/groupname)?
	return info
end

