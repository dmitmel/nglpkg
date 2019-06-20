ng.module(
	"ng.lib.app2d.text",
	"ng.resource",
	"ng.lib.app2d.base",
	"ng.lib.app2d.font",
	"ng.lib.app2d.draw",
	"ng.lib.encoding.utf8"
)

do
	local function runText(ox, oy, size, str, draw)
		local function m(n)
			return (n - 1) * size / 32
		end
		local base = ox
		for ch in ng.encoding["UTF-8"]:iterate(str) do
			if ch == 10 then
				ox = base
				oy = oy + m(32)
			else
				local spc = ng.app2d.fontDrawChar(ch, function (xA, yA, xB, yB)
					draw(ox + m(xA), oy + m(yA), ox + m(xB), oy + m(yB))
				end)
				if spc then
					ox = ox + m(spc)
				else
					ox = runText(ox, oy, size, string.format("\xef\xbf\xbd%06x ", ch), draw)[1]
				end
			end
		end
		return {ox, oy}
	end
	-- need to reduce duplication here, ew...

	ng.app2d.text = function (ox, oy, size, str, col)
		return runText(ox, oy, size, str, function (aX, aY, bX, bY)
			ng.app2d.lineEx({aX, aY, bX, bY}, col)
		end)
	end

	ng.app2d.measureText = function (size, str)
		return runText(ox, oy, size, str, function (aX, aY, bX, bY) end)
	end
end
