--@> ng.doc.command({}, nil)
--@> DOC.target = "10-Examples-Simple"
--@: [[ng.lib.worker]] usage example. Proves it's really multi-threading.
--@: Also never ends.
ng.module(
	"ng.examples.worker",
	"ng.lib.worker",
	"ng.wrap.ffi",
	"ng.wrap.sdl2.thread"
)

local ptr = ffi.new("int[2]")

-- Note the use of atomics. The loop will be infinite otherwise.
local worker = ng.newWorkerThread("local sdl2 = ffi.load(\"SDL2\") ffi.cdef[[" .. ng.sdl2Atomics .. "]] ptr = ffi.cast(\"int*\", ptr) while sdl2.SDL_AtomicGet(ptr + 1) == 0 do ptr[0] = ptr[0] + 1 end return 0", ptr)

-- It is expected that the process will be interrupted during the loop. Allowing this to turn into an error will crash things.
pcall(function ()
	while true do
		print("at " .. ptr[0])
	end
end)

ng.sdl2.SDL_AtomicSet(ptr + 1, 1)

worker:wait()
