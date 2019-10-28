--@: This module helps with reading TAR files.
--@: TODO: Actually document ng.tarhdr info structure
ng.module(
	"ng.lib.util.tarhdr"
)

ng.tarhdr = {}

--@: ng.tarhdr.getInfo(sector): Given a 512-byte TAR header sector, read out the information.
function ng.tarhdr.getInfo(sector)
	local function decodeField(oct)
		local v = 0
		for i = 1, #oct do
			local contrib = (oct:byte(i) - 0x30)
			if contrib < 0 or contrib > 7 then contrib = 0 end
			v = (v * 8) + contrib
		end
		return v
	end
	local function clean(str)
		for i = 1, #str do if str:sub(i, i) == "\x00" then return str:sub(1, i - 1) end end
		return str
	end
	local info = {}
	info.path = clean(sector:sub(1, 100))
	info.access = decodeField(sector:sub(101, 107))
	info.uid = decodeField(sector:sub(109, 115))
	info.gid = decodeField(sector:sub(117, 123))
	info.size = decodeField(sector:sub(125, 135))
	info.sectors = math.ceil(info.size / 512)
	info.time = decodeField(sector:sub(137, 147))
	-- checksum is at 149, 156
	info.type = sector:sub(157, 157)
	info.linkPath = clean(sector:sub(158, 257))
	-- USTAR information (username/groupname)...?
	if sector:sub(258, 263) == "ustar\x00" then
		-- Yup!
		info.ustar = true
		local prefix = clean(sector:sub(346, 500))
		if prefix ~= "" then
			info.path = prefix .. "/" .. info.path
		end
		info.user = clean(sector:sub(266, 297))
		info.group = clean(sector:sub(298, 329))
		info.device = sector:sub(330, 345)
	end
	return info
end

--@: ng.tarhdr.makeSector(info): Given the output of getInfo, make a TAR header sector.
function ng.tarhdr.makeSector(info)
	local function encodeField(val, len)
		len = len - 1
		val = string.format("%o", val):sub(-len)
		while #val < len do
			val = "0" .. val
		end
		return val .. "\x00"
	end
	local function pad(str, len)
		len = len - 1
		while #str < len do str = str .. "\x00" end
		return str:sub(1, len) .. "\x00"
	end
	-- this prefix mechanism is weird, should we even try
	local pathPrefix = ""
	local pathMain = info.path
	local sector =
		pad(pathMain, 100) ..
		encodeField(info.access or 493, 8) ..
		encodeField(info.uid or 1000, 8) ..
		encodeField(info.gid or 1000, 8) ..
		encodeField(info.size, 12) ..
		encodeField(info.time or os.time(), 12) ..
		-- Checksum
		"        " ..
		(info.type or "0") ..
		pad(info.linkPath or "", 100) ..
		"ustar\x0000" ..
		pad(info.user or "user", 32) ..
		pad(info.group or "user", 32) ..
		pad(info.device or "", 16) ..
		pad(pathPrefix, 155) ..
		pad("", 12)
	local checksum = 0
	for i = 1, #sector do
		checksum = checksum + sector:byte(i)
	end
	-- patch in checksum
	return sector:sub(1, 148) .. encodeField(checksum, 8) .. sector:sub(157)
end
