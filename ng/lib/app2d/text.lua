ng.module(
	"ng.lib.app2d.text",
	"ng.resource",
	"ng.lib.app2d.base",
	"ng.lib.app2d.font",
	"ng.lib.app2d.draw",
	"ng.lib.encoding.utf8"
)

ng.app2d.text = function (ox, oy, size, str, col)
	local function m(n)
		return (n - 1) * size / 32
	end
	local base = ox
	for ch in ng.encoding["UTF-8"]:iterate(str) do
		if ch == 10 or ch == 9 then
			ox = base
			oy = oy + m(32)
		else
			local spc = ng.app2d.fontDrawChar(ch, function (xA, yA, xB, yB)
				ng.app2d.lineEx({ox + m(xA), oy + m(yA), ox + m(xB), oy + m(yB)}, col)
			end)
			if spc then
				ox = ox + m(spc)
			else
				ox = ng.app2d.text(ox, oy, size, string.format("\xef\xbf\xbd%06x ", ch), col)
			end
		end
	end
	return ox
end
