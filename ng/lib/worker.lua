ng.module(
	"ng.lib.worker",
	"ng.wrap.ffi",
	"ng.wrap.sdl2.thread",
	"ng.wrap.luajit"
)

function ng.newWorkerThread(code, ptr)
	-- awful, awful, no-good magic
	code = "ffi = require(\"ffi\") ffi.cdef[[ typedef int (*SDL_ThreadFunction)(void *); ]] threadFn = ffi.cast(\"SDL_ThreadFunction\", function (ptr) " .. code .. " end) local cbt = ffi.new(\"SDL_ThreadFunction[1]\") cbt[0] = threadFn return ffi.string(cbt, ffi.sizeof(cbt))"
	local addrLen = ffi.sizeof("SDL_ThreadFunction[1]")
	local state = ffi.C.luaL_newstate()
	ffi.C.luaL_openlibs(state)
	if ffi.C.luaL_loadstring(state, code) ~= 0 then
		local _, res = loadstring(code)
		error("unable to load code, probably: " .. tostring(res))
	end
	if ffi.C.lua_pcall(state, 0, 1, 0) ~= 0 then
		error("error during worker initializer")
	end
	local receiver = ffi.string(ffi.C.lua_tolstring(state, 0, nil), addrLen)
	local threadFn = ffi.cast("SDL_ThreadFunction*", receiver)[0]
	-- So that returned the worker callback...
	local thread = ng.sdl2.SDL_CreateThread(threadFn, "NGWorker", ptr)
	if not thread then
		error("whoops! the thread isn't valid")
	end
	local obj = {state = state, thread = thread}
	function obj:wait()
		local retVal = ffi.new("int[1]")
		ng.sdl2.SDL_WaitThread(self.thread, retVal)
		ffi.C.lua_close(self.state)
		return retVal
	end
	return obj
end
