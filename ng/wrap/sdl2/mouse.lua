ng.module(
	"ng.wrap.sdl2.mouse",
	"ng.wrap.sdl2.base"
)

-- SDL_mouse (State: Occasional function, not at all a complete definition)

ffi.cdef[[
	int SDL_SetRelativeMouseMode(int enabled);
]]

