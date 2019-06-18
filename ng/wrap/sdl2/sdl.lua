ng.module(
	"ng.wrap.sdl2.sdl",
	"ng.wrap.sdl2.base"
)

--- SDL

ng.sdl2Enums.flags("SDL_INIT_", {
	"TIMER", "", "", "",
	"AUDIO", "VIDEO", "", "",
	"", "JOYSTICK", "", "",
	"HAPTIC", "GAMECONTROLLER", "EVENTS", "SENSORS"
})
-- noparachute is for compat only & ignored, so ignore it!
ng.sdl2Enums.SDL_INIT_EVERYTHING = 0xF231

ffi.cdef[[
	int SDL_Init(uint32_t);
	void SDL_Quit();
	// These are noted to be ref-counted, while SDL_Quit performs a global nuke.
	int SDL_InitSubSystem(uint32_t);
	void SDL_QuitSubSystem(uint32_t);
	uint32_t SDL_WasInit(uint32_t);
	void SDL_Quit();
]]

