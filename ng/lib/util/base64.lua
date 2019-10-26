--@: This module handles Base64.
--@: Before describing the API, the most important thing to note is the concept of "groups".
--@: "Groups" are 3 bytes long and 4 Base64 digits long.
--@: Base64 data is simply a series of these "groups", with a terminating group (2-4 digits) at the end.
--@:
ng.module(
	"ng.lib.util.base64"
)

ng.base64 = {}

do
	local baseRing = ""
	for i = 1, 26 do baseRing = baseRing .. string.char(64 + i) end
	for i = 1, 26 do baseRing = baseRing .. string.char(96 + i) end
	for i = 0, 9 do baseRing = baseRing .. i end
	baseRing = baseRing .. "+/"
	--@: ng.base64.baseRing : String with the Base64 character set.
	ng.base64.baseRing = baseRing
end

--@> DOC.functions = "ng.base64."
function ng.base64.encode(data, baseRing, fill)
	--@: Encodes Base64 data, returning the encoded output.
	--@: 'baseRing' defaults to ng.base64.baseRing
	baseRing = baseRing or ng.base64.baseRing
	--@: 'fill' defaults to "="
	fill = fill or "="
	local out = ""
	while #data > 0 do
		out = out .. ng.base64.encodeGroup(data:sub(1, 3), baseRing, fill)
		data = data:sub(4)
	end
	return out
end

function ng.base64.decode(data, baseRing)
	--@: Decodes Base64 data, returning the decoded output.
	--@: Invalid characters are ignored.
	--@: 'baseRing' defaults to ng.base64.baseRing
	baseRing = baseRing or ng.base64.baseRing
	local out = ""
	local workingGroup = ""
	for i = 1, #data do
		local ch = data:sub(i, i)
		local idx = baseRing:find(ch, 1, true)
		if idx then
			workingGroup = workingGroup .. ch
			if #workingGroup == 4 then
				out = out .. ng.base64.decodeGroup(workingGroup, baseRing)
				workingGroup = ""
			end
		end
	end
	if workingGroup ~= "" then
		out = out .. ng.base64.decodeGroup(workingGroup, baseRing)
	end
	return out
end

--@: Then there's the more "advanced" API on which the other API is based.
function ng.base64.encodeGroup(data, baseRing, fill)
	--@: Encodes a single group (1-3 bytes) into 4 characters.
	--@: baseRing/fill are not optional here.
	local paddedData = data
	while #paddedData < 3 do paddedData = paddedData .. "\x00" end
	assert(#paddedData == 3)
	-- With that in mind...
	local theInteger = (paddedData:byte(1) << 16) | (paddedData:byte(2) << 8) | paddedData:byte(3)
	local function digit(x) return (theInteger >> (x * 6)) & 0x3F end
	local function digit2(x) local p = digit(x) + 1 return baseRing:sub(p, p) end
	local group = digit2(3) .. digit2(2) .. digit2(1) .. digit2(0)
	-- Ok, we have a group: What do we do with it?
	if #data == 1 then
		return group:sub(1, 2) .. fill .. fill
	elseif #data == 2 then
		return group:sub(1, 3) .. fill
	elseif #data == 3 then
		return group
	else
		error("No valid data length")
	end
end
function ng.base64.decodeGroup(group, baseRing)
	--@: Decodes a single group (some amount of characters) into 0-3 bytes.
	--@: baseRing is not optional here.
	--@: Note that the input group MUST consist of characters in baseRing, and the fill character MUST be omitted.
	-- Try to output complete bytes of the group.
	local paddedGroup = group
	while #paddedGroup < 4 do paddedGroup = paddedGroup .. "A" end
	local data = ""
	local function digit(x) return baseRing:find(paddedGroup:sub(x, x), 1, true) - 1 end
	local theInteger = (digit(1) << 18) | (digit(2) << 12) | (digit(3) << 6) | digit(4)
	local data = string.char((theInteger >> 16) & 0xFF, (theInteger >> 8) & 0xFF, theInteger & 0xFF)
	if #group == 1 then
		-- 6 bits: No full bytes available
		return "", false
	elseif #group == 2 then
		-- 12 bits: One full byte available
		return data:sub(1, 1), false
	elseif #group == 3 then
		-- 18 bits: Two full bytes available
		return data:sub(1, 2), false
	elseif #group == 4 then
		-- 24 bits: It's all available
		return data, true
	else
		error("No valid group length")
	end
end

