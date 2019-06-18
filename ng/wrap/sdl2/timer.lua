ng.module(
	"ng.wrap.sdl2.timer",
	"ng.wrap.sdl2.base"
)

--- SDL_timer

ffi.cdef[[
	uint32_t SDL_GetTicks();
	uint64_t SDL_GetPerformanceCounter();
	uint64_t SDL_GetPerformanceFrequency();
	void SDL_Delay(uint32_t ms);
	typedef uint32_t (* SDL_TimerCallback) (uint32_t ms, void * userdata);
	int SDL_AddTimer(uint32_t ms, SDL_TimerCallback cb, void * userdata);
	int SDL_RemoveTimer(int timer);
]]

