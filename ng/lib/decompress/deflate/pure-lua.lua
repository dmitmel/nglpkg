ng.module(
	"ng.lib.decompress.deflate.pure-lua",
	"ng.lib.decompress.deflate.huffman",
	"ng.lib.util.bitreader",
	"ng.wrap.ffi"
)

-- While this is called "pure-lua", it does use FFI datastructures for performance reasons.

ng.decompressDeflate = function (data)
	-- DEFLATE decompressor (RFC1951)

	local bittblLength = {
		0, 0, 0, 0, 0, 0, 0, 0,
		1, 1, 1, 1, 2, 2, 2, 2,
		3, 3, 3, 3, 4, 4, 4, 4,
		5, 5, 5, 5, 0
	}
	local basetblLength = {
		3, 4, 5, 6, 7, 8, 9, 10,
		11, 13, 15, 17, 19, 23, 27, 31,
		35, 43, 51, 59, 67, 83, 99, 115,
		131, 163, 195, 227, 258
	}
	local bittblDist = {
		0, 0, 0, 0, 1, 1, 2, 2,
		3, 3, 4, 4, 5, 5, 6, 6,
		7, 7, 8, 8, 9, 9, 10, 10,
		11, 11, 12, 12, 13, 13
	}
	local basetblDist = {
		1, 2, 3, 4, 5, 7, 9, 13,
		17, 25, 33, 49, 65, 97, 129, 193,
		257, 385, 513, 769, 1025, 1537, 2049, 3073,
		4097, 6145, 8193, 12289, 16385, 24577
	}

	local rdr = ng.BitReader(data, true)

	local window = ffi.new("uint8_t[0x10000]")
	local windowNow = 0
	local flushedData = ""

	local function byte(n)
		window[windowNow] = n
		windowNow = (windowNow + 1) % 0x10000
		if windowNow == 0 then
			-- About to start rewriting.
			flushedData = flushedData .. ffi.string(window, 0x10000)
		end
	end

	local function decoderLD(code, bittbl, basetbl)
		return basetbl[code + 1] + rdr.getIntField(bittbl[code + 1], true)
	end
	local function decoderCore(lit, dst)
		while true do
			local v = ng.deflateHuffman.decode(lit, rdr.getIntBit)
			if v <= 255 then
				byte(v)
			elseif v == 256 then
				return
			elseif v <= 285 then
				-- This bit is NOT well-described. I'll leave notes:
				-- The first table, with the numbers from 257 to 285,
				-- describe the amount of extra length bits there are,
				-- which you then add to the lower bounds given in the first table.
				-- What's NOT noted here is how the distances work the same way, with a different table,
				--  that they give without clarification.
				-- You're just sort of left to infer that.
				-- Also, ignore the way the bit endianness is described, it'll just throw you off.
				-- These are, for bitstream purposes, LSB-first, unless there's a bug in my code.
				local len = decoderLD(v - 257, bittblLength, basetblLength)
				local dst = decoderLD(ng.deflateHuffman.decode(dst, rdr.getIntBit), bittblDist, basetblDist)
				for i = 1, len do
					byte(window[(windowNow - dst) % 0x10000])
				end
			else
				error("nt" .. v)
			end
		end
	end
	while true do
		local final = rdr.getIntBit()
		local typ = rdr.getIntField(2, true)
		if typ == 0 then
			rdr.skipToByte()
			local l1 = rdr.getIntField(16, true)
			local l2 = rdr.getIntField(16, true)
			-- l2 is supposed to be the "one's complement" of l1
			-- Presumably for verification purposes...?
			local str = rdr.getAlignBytes(l1)
			for i = 1, #str do
				byte(str:byte(i))
			end
		elseif typ == 1 then
			decoderCore(ng.deflateHuffman.deflateFixedLit, ng.deflateHuffman.deflateFixedDst)
		elseif typ == 2 then
			decoderCore(ng.deflateHuffman.deflateDynamic(rdr, true))
		else
			error("Block format " .. tostring(typ))
		end
		if final == 1 then break end
	end
	return flushedData .. ffi.string(window, windowNow)
end
