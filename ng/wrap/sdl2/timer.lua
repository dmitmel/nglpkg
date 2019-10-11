ng.module(
	"ng.wrap.sdl2.timer",
	"ng.wrap.sdl2.base"
)

--- SDL_timer (STATE: Probably complete per 2.0.10+dfsg1-1ubuntu1 )

ffi.cdef[[
	uint32_t SDL_GetTicks();
	uint64_t SDL_GetPerformanceCounter();
	uint64_t SDL_GetPerformanceFrequency();
	void SDL_Delay(uint32_t);
	typedef uint32_t (* SDL_TimerCallback) (uint32_t, void *);
	int SDL_AddTimer(uint32_t, SDL_TimerCallback, void *);
	int SDL_RemoveTimer(int);
]]

