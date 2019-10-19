--@: Defines a framework for text encodings.
--@:
--@: ng.Encoding(nextChar, makeChar):
--@:  From two functions:
--@:   nextChar(bytes): Returns an integer Unicode codepoint & the remainder of the bytes
--@:   makeChar(codepoint): Returns the string for a given codepoint, or nil if invalid
--@:  Creates an Encoding object.
--@:
--@: ng.encoding is a table that maps encoding names to their Encoding objects.
--@:
ng.module(
	"ng.lib.encoding.base"
)
ng.encoding = {}
function ng.Encoding(nextChar, makeChar)
	local enc = {}
	--@: The Encoding Object API:
	--@:
	--@: enc:nextChar(bytes) -> codepoint, remainingBytes
	--@:  Gets the first codepoint and remaining bytes given input bytes.
	--@:
	function enc:nextChar(str) return nextChar(str) end
	--@: enc:makeChar(codepoint) -> bytes
	--@:  Writes out the string that represents a given Unicode character.
	--@:  Returns nil for invalid Unicode characters (unrepresentable)
	--@:
	function enc:makeChar(unicode) return makeChar(unicode) end
	--@: enc:stringToTable(bytes) -> list of codepoints
	--@:  Transforms a string into a list of Unicode codepoints.
	--@:
	function enc:stringToTable(data)
		local chrs = {}
		while #data > 0 do
			local chr
			chr, data = self:nextChar(data)
			table.insert(chrs, chr)
		end
		return chrs
	end
	--@: enc:tableToString(tbl) -> bytes
	--@:  Encodes the given list of codepoints into a string.
	--@:
	function enc:tableToString(tbl)
		local data = ""
		for _, v in ipairs(tbl) do
			data = data .. self:makeChar(v)
		end
		return data
	end
	--@: enc:iterate(bytes) -> iterator
	--@:  Iterates over the codepoints in a string.
	--@:
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
