ng.module(
	"ng.wrap.sdl2.keyboard",
	"ng.wrap.sdl2.base"
)

--- SDL_keyboard
ffi.cdef[[
	typedef struct {
		int scancode, sym;
		uint16_t mod;
		uint32_t unused;
	} SDL_Keysym;
]]

