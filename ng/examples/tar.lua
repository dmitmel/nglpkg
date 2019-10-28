--@> ng.doc.command({}, "parameters")
--@> DOC.target = "10-Examples-Fun"
--@: The parameters here are complicated and subject to change.
ng.module(
	"ng.examples.tar",
	"ng.lib.util.tarhdr",
	"ng.wrap.fs"
)
if ng.args[1] == "index" then
	local f = io.open(ng.args[2], "rb")
	while true do
		local block = f:read(512)
		if not block then break end
		local info = ng.tarhdr.getInfo(block)
		if info.type == "" or info.type == "0" or info.type == "7" then
			-- -rwxr-xr-x user/user       480 2019-10-28 01:16 sdk
			local perms = "srwxrwxrwx"
			local permsBase = 0x200
			for i = 1, #perms do
				if bit.band(permsBase, info.access) ~= 0 then
					io.write(perms:sub(i, i))
				else
					io.write("-")
				end
				permsBase = permsBase / 2
			end
			print(" " .. (info.user or info.uid) .. "/" .. (info.group or info.gid) .. "       " .. info.size .. "                  " .. info.path)
		end
		f:read(info.sectors * 512)
	end
	f:close()
elseif ng.args[1] == "add" then
	local f = io.open(ng.args[2], "rb")
	local data = f:read("*a")
	local sector = ng.tarhdr.makeSector({
		path = ng.args[2],
		size = #data
	})
	assert(#sector == 512)
	io.write(sector)
	io.write(data)
	local part = #data % 512
	if part ~= 0 then
		io.write(("\x00"):rep(512 - part))
	end
	f:close()
else
	print("NGLPKG TAR-like Thing")
	print("tar index <file>")
	print(" shows all files in the given TAR file")
	print("tar add <file>")
	print(" writes TAR file containing the given file to standard output")
end
