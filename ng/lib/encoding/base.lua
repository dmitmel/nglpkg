ng.module(
	"ng.lib.encoding.base"
)
ng.encoding = {}
function ng.Encoding(nextChar, makeChar)
	local enc = {}
	--- Gets the first character and remaining string given an input string.
	-- @return charInt
	-- @return remainingString
	function enc:nextChar(str) return nextChar(str) end
	--- Writes out the string that represents a given Unicode character.
	-- Returns nil for invalid Unicode characters (unrepresentable)
	-- @return str
	function enc:makeChar(unicode) return makeChar(unicode) end
	--- Transforms a string into a list of Unicode codepoints.
	-- @return characters
	function enc:stringToTable(data)
		local chrs = {}
		while #data > 0 do
			local chr
			chr, data = self:nextChar(data)
			table.insert(chrs, chr)
		end
		return chrs
	end
	function enc:tableToString(tbl)
		local data = ""
		for _, v in ipairs(tbl) do
			data = data .. self:makeChar(v)
		end
		return data
	end
	function enc:iterate(data)
		return function ()
			if data == "" then
				return
			end
			local chr
			chr, data = self:nextChar(data)
			return chr
		end
	end
	return enc
end
