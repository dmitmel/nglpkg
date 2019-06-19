ng.module(
	"ng.lib.util.polling-station"
)

-- [function] = true
ng.polls = {}

ng.poll = function ()
	for k, _ in pairs(ng.polls) do
		k()
	end
end

