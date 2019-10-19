--@: This module adds two functions that are semi-commonly written for event handlers and the like.
--@:
ng.module(
	"ng.lib.util.cblists"
)
--@: ng.runForwards(list, ...)
--@:  Runs each element of list with the given arguments. Returns nothing.
--@:
function ng.runForwards(list, ...)
	for _, v in ipairs(list) do
		v(...)
	end
end
--@: ng.runBackwards(list, ...)
--@:  Runs each element of list in reverse with the given arguments. Returns nothing.
--@:
function ng.runBackwards(list, ...)
	for i = 0, #list - 1 do
		list[#list - i](...)
	end
end
