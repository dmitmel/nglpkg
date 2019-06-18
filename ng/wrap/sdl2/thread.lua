ng.module(
	"ng.wrap.sdl2.thread",
	"ng.wrap.sdl2.base"
)

-- Lots of stuff missing here. Partially intentional.
ffi.cdef[[
	typedef int (*SDL_ThreadFunction)(void *);
	void * SDL_CreateThread(SDL_ThreadFunction, const char *, void *);
	void SDL_WaitThread(void *, int *);
]]

-- Atomics. As a separate string for importing by Workers
ng.sdl2Atomics = [[
	void SDL_MemoryBarrierReleaseFunction();
	void SDL_MemoryBarrierAcquireFunction();
	int SDL_AtomicTryLock(int *);
	void SDL_AtomicLock(int *);
	void SDL_AtomicUnlock(int *);

	int SDL_AtomicCAS(int *, int, int);
	int SDL_AtomicSet(int *, int);
	int SDL_AtomicGet(int *);
	int SDL_AtomicAdd(int *, int);

	int SDL_AtomicCASPtr(void **, void *, void *);
	void * SDL_AtomicSetPtr(void **, void *);
	void * SDL_AtomicGetPtr(void **);
]]
ffi.cdef(ng.sdl2Atomics)
