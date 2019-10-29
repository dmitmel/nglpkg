--@: This module acts as a central station for things that require polling to be placed.
--@: ng.polls: Table with functions as keys. These functions are called when ng.poll is called.
--@: ng.poll(): Polls the things that require polling.
--@: ng.defer(fn, ...): Runs a function with given arguments the next time polling occurs.
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

ng.defer = function (fn, ...)
	local n = {...}
	local temp = function ()
		ng.polls[temp] = nil
		fn(unpack(n))
	end
	ng.polls[temp] = true
end
