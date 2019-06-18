ng.module(
	"ng.lib.encoding.utf8",
	"ng.lib.encoding.base"
)
ng.encoding["UTF-8"] = ng.Encoding(
	function (a)
		local ch = a:byte(1)
		local chm, bts, min
		if ch >= 0xC0 and ch < 0xE0 then
			-- 110xxxxx
			chm = ch % 0x20
			bts = 1
			min = 0x80
		elseif ch >= 0xE0 and ch < 0xF0 then
			-- 1110xxxx
			chm = ch % 0x10
			bts = 2
			min = 0x800
		elseif ch >= 0xF0 and ch < 0xF8 then
			-- 11110xxx
			chm = ch % 0x08
			bts = 3
			min = 0x10000
		elseif ch >= 0xF8 and ch < 0xFC then
			-- 111110xx
			chm = ch % 0x04
			bts = 4
			min = 0x200000
		elseif ch >= 0xFC and ch < 0xFE then
			-- 1111110x
			chm = ch % 0x02
			bts = 5
			min = 0x4000000
		end
		if not bts or (#a < (bts + 1)) then
			return ch, a:sub(2)
		end
		for i = 1, bts do
			local ch2 = a:byte(i + 1)
			if ch2 < 0x80 or ch2 >= 0xC0 then
				return ch, a:sub(2)
			end
			chm = (chm * 0x40) + (ch2 % 0x40)
		end
		if chm < min then
			return ch, a:sub(2)
		end
		return chm, a:sub(2 + bts)
	end,
	function (n)
		local bts = 0
		local st
		if n < 0 then
			return nil
		elseif n < 0x80 then
			return string.char(n)
		elseif n < 0x800 then
			bts = 1
			st = 0xC0
		elseif n < 0x10000 then
			bts = 2
			st = 0xE0
		elseif n < 0x200000 then
			bts = 3
			st = 0xF0
		elseif n < 0x4000000 then
			bts = 4
			st = 0xF8
		elseif n < 0x80000000 then
			bts = 5
			st = 0xFC
		else
			return nil
		end
		local ns = ""
		for i = 1, bts do
			ns = string.char(0x80 + (n % 0x40)) .. ns
			n = math.floor(n / 0x40)
		end
		return string.char(st + n) .. ns
	end
)

