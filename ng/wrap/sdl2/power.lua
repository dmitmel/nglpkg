ng.module(
	"ng.wrap.sdl2.power",
	"ng.wrap.sdl2.base"
)

--- SDL_power (STATE: Probably complete per 2.0.10+dfsg1-1ubuntu1 )

ng.sdl2Enums.enums("SDL_POWERSTATE_", {
	"UNKNOWN", "ON_BATTERY", "NO_BATTERY", "CHARGING", "CHARGED"
})

ffi.cdef[[
	int SDL_GetPowerInfo(int *, int *);
]]

