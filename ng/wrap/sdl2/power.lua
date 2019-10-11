ng.module(
	"ng.wrap.sdl2.power",
	"ng.wrap.sdl2.base"
)

ng.sdl2Enums.enums("SDL_POWERSTATE_", {
	"UNKNOWN", "ON_BATTERY", "NO_BATTERY", "CHARGING", "CHARGED"
})

ffi.cdef[[
	int SDL_GetPowerInfo(int *, int *);
]]

