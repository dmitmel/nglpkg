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
