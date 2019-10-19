--@: Implements ng.encoding["UTF-16"] (see [[ng.lib.encoding.base]])
--@: This encoding is evil and should not exist, but Windows uses it.
ng.module(
	"ng.lib.encoding.utf16",
	"ng.lib.encoding.base"
)

do
	local function m(swap)
		local X, Y = 1, 2
		if swap then X, Y = 2, 1 end
		local function makeChar(n)
			if n >= 0x10000 then
				n = n - 0x10000
				return makeChar(math.floor(n / 0x400) + 0xD800) .. makeChar((n % 0x400) + 0xDC00)
			end
			if swap then
				return string.char(math.floor(n / 0x100), n % 0x100)
			end
			return string.char(n % 0x100, math.floor(n / 0x100))
		end
		return ng.Encoding(
			function (a)
				local x1 = a:byte(X) + (a:byte(Y) * 0x100)
				local x2
				if #a > 3 then
					x2 = a:byte(2 + X) + (a:byte(2 + Y) * 0x100)
				end
				if x1 >= 0xD800 and x1 < 0xDC00 and x2 and x2 >= 0xDC00 and x2 < 0xE000 then
					local c = ((x1 % 0x400) * 0x400) + (x2 % 0x400) + 0x10000
					return c, a:sub(5)
				end
				return x1, a:sub(3)
			end,
			makeChar
		)
	end
	ng.encoding["UTF-16LE"] = m(false)
	ng.encoding["UTF-16BE"] = m(true)
end
