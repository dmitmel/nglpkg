--@> ng.doc.internal()
ng.module(
	"ng.lib.decompress.deflate.huffman"
)

-- Huffman table stuff.
-- Trees in this use a flat table of numbers.
-- These numbers are encoded in a leading-one format,
--  as a simple mechanism to encode length.
-- Example valid Huffman table:
-- {
--  [0b010] = "hi ",
--  [0b0110] = "john",
--  [0b0111] = "david"
-- }
-- IMPORTANT NOTE REGARDING THE DEFLATE SPEC:
-- Huffman codes are defined as being essentially 'the order of the code is the order used in the bitstream'.
-- Endianness of the bitstream generally is little-endian.
-- This is described in a slightly awkward way.

ng.deflateHuffman = {
	decode = function (tree, get)
		local moved = false
		local l1v = 1
		while not tree[l1v] do
			local v = get()
			if not v then assert(not moved, "early eof") return end
			moved = true
			l1v = (l1v * 2) + v
		end
		return tree[l1v]
	end,
	toL1 = function (n, cl)
		local pow = math.floor(2 ^ cl)
		if n >= pow then error("To L1 not valid for " .. n .. "," .. cl .. ".") end
		return n + pow
	end,
	lclBits = function (firstSym, lastSym, codeLengths, maxBits)
		-- Method taken from RFC1951.
		-- That said, it needs a bit more explaination than given there, so:
		-- The symbols are effectively sorted majorly by code length (longest last),
		--  and minorly by symbol number (highest last).
		-- This produces a consistent list of symbols
		--  to code lengths that can be replicated every time.
		-- The way these are allocated relies on the code length ordering.
		-- Starting from the lowest codelength,
		--  every code length gets a given area of codespace.
		-- The allocation here is essentially numeric, despite this being a tree,
		--  so rather than reimplement a binary adder, they just use bitshifts and additions.
		-- I don't understand *how* this part works, or how it avoids all sorts of collisions,
		--  but it does, so I'm just going to shrug.
		-- It probably has something to do with the property that to
		--  reach any number above or equal to a power of two N,
		--  you must have the binary bit for a power of two above or equal to N set.
		-- (Would explain the shifting at least.)
		-- How this maps to the actual algorithm here is kind of a mess -
		--  the RFC1951 algorithm is more of an optimized implementation than a proof of
		--  how the algorithm successfully allocates tree space.
		local sy
		local tree = {}
		local blCount = {}
		-- Note the 0
		for i = 0, maxBits do
			blCount[i] = 0
		end
		for i = firstSym, lastSym do
			local cl = codeLengths[i]
			if cl ~= 0 then
				blCount[cl] = blCount[cl] + 1
			end
		end

		-- "After step 1, we have:"
		-- for i = 1, maxBits do print(i, blCount[i]) end

		-- This is a bit odd to understand -
		--  what happens in case of various obviously erroneous cases?
		-- For example, 4 cases with a bit length of 2 but
		--  one case with a bit length of 3.
		local code = 0
		local nextCode = {}

		for i = 1, maxBits do
			code = (code + blCount[i - 1]) * 2
			nextCode[i] = code
		end

		-- "Step 2 computes the following next_code values:"
		-- for i = 1, maxBits do print(i, nextCode[i]) end

		-- This part has some additional verification.
		local tbl = {}
		for i = firstSym, lastSym do
			local cl = codeLengths[i]
			if cl ~= 0 then
				local k = ng.deflateHuffman.toL1(nextCode[cl], cl)
				-- "Step 3 produces the following code values:"
				-- print(i, cl, k)
				assert(not tbl[k], "conflict @ " .. k)
				tbl[k] = i
				nextCode[cl] = nextCode[cl] + 1
			end
		end
		return tbl
	end
}

-- DEFLATE stuff
local lens = {}
for i = 0, 143 do lens[i] = 8 end
for i = 144, 255 do lens[i] = 9 end
for i = 256, 279 do lens[i] = 7 end
for i = 280, 287 do lens[i] = 8 end
ng.deflateHuffman.deflateFixedLit = ng.deflateHuffman.lclBits(0, 287, lens, 15)
lens = {}
for i = 0, 31 do
	lens[i] = 5
end
ng.deflateHuffman.deflateFixedDst = ng.deflateHuffman.lclBits(0, 31, lens, 15)
lens = nil

-- 'bs' here is a BitReader
ng.deflateHuffman.deflateDynamicSubcodes = function (distlens, dst, metatree, bs, flsb)
	local i = 0
	distlens[-1] = 0
	while i < dst do
		local instr = ng.deflateHuffman.decode(metatree, bs.getIntBit)
		if instr < 16 then
			distlens[i] = instr
			i = i + 1
		elseif instr == 16 then
			for j = 1, 3 + bs.getIntField(2, flsb) do
				distlens[i] = distlens[i - 1]
				i = i + 1
				if i > dst then error("Overflow") end
			end
		elseif instr == 17 then
			for j = 1, 3 + bs.getIntField(3, flsb) do
				distlens[i] = 0
				i = i + 1
				if i > dst then error("Overflow") end
			end
		elseif instr == 18 then
			for j = 1, 11 + bs.getIntField(7, flsb) do
				distlens[i] = 0
				i = i + 1
				if i > dst then error("Overflow") end
			end
		else
			error("unable to handle cl instruction " .. instr)
		end
	end
	distlens[-1] = nil
end

-- 'bs' here is a BitReader
ng.deflateHuffman.deflateDynamic = function (bs, flsb)
	local metalensi = {16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15}
	local metalens = {}
	for i = 0, 18 do metalens[i] = 0 end
	local ltl = bs.getIntField(5, flsb) + 257
	local dst = bs.getIntField(5, flsb) + 1
	local cln = bs.getIntField(4, flsb) + 4
	for i = 1, cln do
		metalens[metalensi[i]] = bs.getIntField(3, flsb)
	end
	local metatree = ng.deflateHuffman.lclBits(0, 18, metalens, 7)

	local alllens = {}
	ng.deflateHuffman.deflateDynamicSubcodes(alllens, ltl + dst, metatree, bs, flsb)
	local litlens = {}
	local distlens = {}
	for i = 0, ltl - 1 do
		litlens[i] = alllens[i]
	end
	for i = 0, dst - 1 do
		distlens[i] = alllens[ltl + i]
	end
	local littree = ng.deflateHuffman.lclBits(0, ltl - 1, litlens, 15)
	local dsttree = ng.deflateHuffman.lclBits(0, dst - 1, distlens, 15)
	return littree, dsttree
end

