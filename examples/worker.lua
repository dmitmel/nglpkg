ng.module(
	"examples.worker",
	"ng.lib.worker",
	"ng.wrap.ffi"
)

local ptr = ffi.new("int[1]")

ng.newWorkerThread("ptr = ffi.cast(\"int*\", ptr) while true do ptr[0] = ptr[0] + 1 end", ptr)

while true do
	print("at " .. ptr[0])
end
