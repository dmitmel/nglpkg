--@: This module is useful if handling bitstreams, i.e. data which isn't aligned to this weird concept some may refer to as "bytes".
--@: In particular this is used by [[ng.lib.decompress.deflate.pure-lua]].
--@: TODO: Actually document ng.BitReader API
ng.module(
	"ng.lib.util.bitreader",
	"ng.wrap.ffi"
)

-- str: The actual byte data.
-- lsb: Direction bits are stored in a byte.
--      If false, bits are stored in the top bit of a byte, downwards.
--      This is the order in which data is usually written.
--      If true, bits are stored in the bottom (least-significant-bit) bit, upwards.
function ng.BitReader(str, lsb)
	local stra = ffi.cast("uint8_t*", str)
	local strc = #str
	local power = 0
	local powermul = 0
	local work = 0
	local function getIntBit()
		if power < 1 or power > 128 then
			if strc == 0 then return end
			work = stra[0]
			stra = stra + 1
			strc = strc - 1
			if lsb then
				power = 1
				powermul = 2
			else
				power = 128
				powermul = 0.5
			end
		end
		local w = math.floor(work / power) % 2
		power = math.floor(power * powermul)
		return w
	end
	return {
		skipToByte = function ()
			power = 0
		end,
		getAlignBytes = function (i)
			power = 0
			if i > strc then
				error("not enough bytes available (wanted "  .. i .. ", got " .. strc .. ")")
			end
			local n = ffi.string(stra, i)
			stra = stra + i
			strc = strc - i
			return n
		end,
		getIntBit = getIntBit,
		getStringBit = function ()
			return tostring(getIntBit() or "")
		end,
		-- flsb: Field LSB. Dictates the order in the stream that a field uses.
		-- False: Fields are stored top-bit-first, going downwards.
		-- True: Fields are stored bottom-bit-first, going upwards.
		-- Note that this *within* the array of bits -
		--  it does not change the bit-byte conversion order of the stream,
		--  merely controls how the field is stored within the stream.
		getIntField = function (n, flsb)
			local np = math.floor(2 ^ (n - 1))
			local nv = 0
			if flsb then
				np = 1
			end
			for i = 1, n do
				local nt = getIntBit()
				if not nt then
					if i == 1 then return end
					assert(nt)
				end
				if nt == 1 then
					nv = nv + np
				end
				if flsb then
					np = np * 2
				else
					np = math.floor(np / 2)
				end
			end
			return nv
		end
	}
end

