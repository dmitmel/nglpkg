ng.module(
	"ng.wrap.sdl2.thread",
	"ng.wrap.sdl2.base"
)

--- SDL_thread (STATE: Lots of stuff missing from this wrapper. Partially intentional.)

ng.sdl2Threads = [[
	typedef int (*SDL_ThreadFunction)(void *);
	void * SDL_CreateThread(SDL_ThreadFunction, const char *, void *);
	void SDL_WaitThread(void *, int *);
	void SDL_DetachThread(void *);
]]
ffi.cdef(ng.sdl2Threads)

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

-- Mutexes. As a separate string for importing by Workers
ng.sdl2Mutexes = [[
	void * SDL_CreateMutex();
	void SDL_DestroyMutex(void *);
	int SDL_LockMutex(void *);
	int SDL_UnlockMutex(void *);
]]
ffi.cdef(ng.sdl2Mutexes)

