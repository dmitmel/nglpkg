ng.module(
	"ng.lib.util.cblists"
)
function ng.runForwards(list, ...)
	for _, v in ipairs(list) do
		v(...)
	end
end
function ng.runBackwards(list, ...)
	for i = 0, #list - 1 do
		list[#list - i](...)
	end
end
