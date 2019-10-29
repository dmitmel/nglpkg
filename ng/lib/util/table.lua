--@: This is a number of extensions to the table library.
--@:
ng.module(
	"ng.lib.util.table"
)
--@: table.shuffle(tbl): Randomly swaps 2 elements in the table #tbl * 16 times.
--@:  May swap an element with itself (has no effect).
--@:
table.shuffle = function (tbl)
	for i = 1, #tbl * 16 do
		local swap1 = math.random(#tbl)
		local swap2 = math.random(#tbl)
		tbl[swap1], tbl[swap2] = tbl[swap2], tbl[swap1]
	end
end

--@: table.copy(tbl): Creates a shallow copy of the given table.
--@:  Keys and values that point to other tables remain pointing to those other tables.
--@:
table.copy = function (tbl)
	local ntbl = {}
	for k, v in pairs(tbl) do
		ntbl[k] = v
	end
	return ntbl
end

--@: table.indexOf(tbl, v): Gets the index of a table value (or nil if not found).
--@:  Not limited to numerical tables.
table.indexOf = function (tbl, v)
	for tk, tv in pairs(tbl) do
		if tv == v then
			return tk
		end
	end
end
