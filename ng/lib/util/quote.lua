ng.module(
	"ng.lib.util.quote"
)

function ng.quoteString(s)
	-- [[ followed by a single direct newline will ignore that newline,
	--  so get that out of the way
	-- Found this out the hard way
	local q = "([[\n" ..
	s:gsub("[%[%]\x0D\x7F]", function (n)
		return "\x7F" .. string.char(n:byte() - 1)
	end) ..
	"]]):gsub(\"\x7F.\",function(n)return string.char(n:byte(2)+1)end)"
	-- local dump3 = io.open("dump3", "wb")
	-- dump3:write(q)
	local res = assert(loadstring("return " .. q))()
	if res ~= s then
		--local dump1 = io.open("dump1", "wb")
		--dump1:write(res)
		--local dump2 = io.open("dump2", "wb")
		--dump2:write(s)
		error("Failure to quote string")
	end
	return q
end


