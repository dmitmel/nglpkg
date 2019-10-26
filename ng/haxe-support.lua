--@: Reimplements libraries or parts of libraries Haxe expects.
ng.module(
	"ng.haxe-support",
	"ng.lib.encoding.utf8"
)
do
	-- The implementation of all this doesn't look very null-safety-observant
	-- (see: codes, byte)
	package.loaded["lua-utf8"] = {
		len = function (s)
			return #(ng.encoding["UTF-8"]:stringToTable(s))
		end,
		char = function (...)
			return ng.encoding["UTF-8"]:tableToString({...})
		end,
		-- sub
		-- charCodeAt
		-- find
		-- byte
		-- gsub
		-- gmatch
		-- match
		upper = string.upper,
		lower = string.lower,
		-- codes
	}
end

