--@> ng.doc.command({}, nil)
--@> DOC.target = "10-Examples-Simple"
--@: [[ng.lib.worker]] usage example. Proves it's really multi-threading.
--@: Also never ends.
ng.module(
	"ng.examples.worker",
	"ng.lib.worker",
	"ng.wrap.ffi"
)

local ptr = ffi.new("int[1]")

ng.newWorkerThread("ptr = ffi.cast(\"int*\", ptr) while true do ptr[0] = ptr[0] + 1 end", ptr)

while true do
	print("at " .. ptr[0])
end
