ng.module(
	"ng.resource.runtime",
	"ng.lib.util.finder"
)

ng.resources = {}
ng.resource = function (name, ext)
	if not ng.resources[name] then
		for _, fn in ipairs(ng.finder(name, ext)) do
			local f = io.open(fn, "rb")
			if f then
				local data = f:read("*a")
				f:close()
				ng.resources[name] = data
				return
			end
		end
		error("Unable to find resource " .. name)
	end
end
