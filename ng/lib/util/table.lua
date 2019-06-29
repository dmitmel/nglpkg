ng.module(
	"ng.lib.util.table"
)

table.shuffle = function (tbl)
	for i = 1, #tbl * 16 do
		local swap1 = math.random(#tbl)
		local swap2 = math.random(#tbl)
		tbl[swap1], tbl[swap2] = tbl[swap2], tbl[swap1]
	end
end

-- Shallow
table.copy = function (tbl)
	local ntbl = {}
	for k, v in pairs(tbl) do
		ntbl[k] = v
	end
	return ntbl
end
