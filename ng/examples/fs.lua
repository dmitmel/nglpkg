--@> ng.doc.command({}, nil)
--@> DOC.target = "10-Examples-Simple"
ng.module(
	"ng.examples.fs",
	"ng.wrap.fs"
)

print("hi...")
local nt = io.open("👻", "wb")
nt:write("UTF-16 is annoying")
nt:close()
nt = io.open("👻", "rb")
print(nt:read())
nt:close()
local function hexdump(s)
	local ws = ""
	for i = 1, #s do
		ws = ws .. string.format("%02x", s:byte(i))
	end
	return ws
end
for _, v in ipairs(ng.fs.list(".")) do
	print(#v .. ":" .. hexdump(v) .. ":" .. v)
end

print("Info on . and ghost:")
print(ng.fs.info("."))
print(ng.fs.info("👻"))
print("Press enter to continue...")
io.read()
ng.fs.unlink("👻")
ng.fs.mkdir("👻🚫")
print("Ghostbuster present. Press enter to continue...")
io.read()
ng.fs.rmdir("👻🚫")

