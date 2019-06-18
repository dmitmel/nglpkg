ng.module(
	"ng.lib.compress.bdivide"
)

ng.compressBDivide = function (code)
	local alldata = ""
	local window = ""
	local a = code
	while #a > 0 do
		local b = a:byte(1)
		if b >= 128 then
			error("BDIVIDE compressed data cannot contain bytes >= 128.")
		end
		local dat = string.char(b)
		local datr = 1
		for l = 4, 128 do
			local chunk = a:sub(1, l)
			if #chunk ~= l then break end
			local ad = window:find(chunk, 1, true)
			if not ad then break end
			dat = string.char(l + 127, math.floor(ad / 256), ad % 256)
			datr = l
		end
		alldata = alldata .. dat
		window = window .. a:sub(1, datr)
		a = a:sub(datr + 1)
	end
	assert(window == code)
	return alldata
end

