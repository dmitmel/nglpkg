--@: This module is another one of those 'one-function' modules.
--@: It's worth it, though.
--@:
--@: ng.finder(name, ext):
--@:  Finds a file in a way that's similar to Lua's module-finding functionality.
--@:  Returns all possible places it could be as a list of strings.
ng.module(
	"ng.lib.util.finder"
)

function ng.finder(name, ext)
	local places = {}
	for v in package.path:gmatch("[^;]+") do
		local fn = v:gsub("%.lua", ""):gsub("%?", name:gsub("%.", "/")) .. ext
		table.insert(places, fn)
	end
	return places
end
