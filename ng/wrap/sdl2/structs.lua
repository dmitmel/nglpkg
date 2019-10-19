ng.module(
	"ng.wrap.sdl2.structs",
	"ng.wrap.sdl2.base"
)

--@: SDL core structs (SDL_rwops, SDL_rect, SDL_pixels, SDL_surface) (heavily abridged)

-- This has a surprisingly extensive rectangle library, but it's part-inlined.
-- The interesting parts aren't, though!
ffi.cdef[[
	typedef struct {
		int x, y;
	} SDL_Point;
	typedef struct {
		int x, y, w, h;
	} SDL_Rect;
	int SDL_HasIntersection(const SDL_Rect *, const SDL_Rect *);
	int SDL_IntersectRect(const SDL_Rect *, const SDL_Rect *, SDL_Rect *);
	void SDL_UnionRect(const SDL_Rect *, const SDL_Rect *, SDL_Rect *);
	int SDL_IntersectRectAndLine(const SDL_Rect *, int *, int *, int *, int *);
]]

ng.sdl2Enums.enums("SDL_RWOPS_", {
	"UNKNOWN", "WINFILE", "STDFILE", "JNIFILE", "MEMORY", "MEMORY_RO"
})
ng.sdl2Enums.enums("RW_SEEK_", {
	"SET", "CUR", "END"
})

ffi.cdef[[
	typedef struct {
		int64_t (*size) (void *);
		int64_t (*seek) (void *, int64_t, int);
		size_t (*read) (void *, void *, size_t, size_t);
		size_t (*write) (void *, void *, size_t, size_t);
		int ( * close) (void * self);
		uint32_t type;
		union {
			struct {
				uint8_t * base, * here, * stop;
			} mem;
			struct {
				void * data1;
				void * data2;
			} unknown;
		};
	} SDL_RWops;
	SDL_RWops * SDL_RWFromFile(const char *, const char *);
	SDL_RWops * SDL_RWFromMem(void *, int);
	SDL_RWops * SDL_RWFromConstMem(const void *, int);
	SDL_RWops * SDL_AllocRW(SDL_RWops *);
	void SDL_FreeRW(SDL_RWops *);
]]

ffi.cdef[[
	typedef struct {
		uint8_t r, g, b, a;
	} SDL_Color;
	typedef SDL_Color SDL_Colour;

	typedef struct {
		uint32_t flags;
		void * format;
		int w, h, pitch;
		void * pixels;
		void * userdata;
		int locked;
		void * lock_data;
		SDL_Rect clip_rect;
		void * private_please_ignore_me;
		int refcount;
	} SDL_Surface;

	SDL_Surface * SDL_CreateRGBSurface(uint32_t, int, int, int, uint32_t, uint32_t, uint32_t, uint32_t);
	SDL_Surface * SDL_CreateRGBSurfaceFrom(void *, int, int, int, int, uint32_t, uint32_t, uint32_t, uint32_t);
	int SDL_LockSurface(SDL_Surface *);
	void SDL_UnlockSurface(SDL_Surface *);
	int SDL_FillRect(SDL_Surface *, const SDL_Rect *, uint32_t);
	int SDL_UpperBlit(SDL_Surface *, const SDL_Rect *, SDL_Surface *, SDL_Rect *);
	int SDL_UpperBlitScaled(SDL_Surface *, const SDL_Rect *, SDL_Surface *, SDL_Rect *);
	int SDL_SetSurfaceBlendMode(SDL_Surface *, int);
	void SDL_FreeSurface(SDL_Surface *);
	SDL_Surface * SDL_LoadBMP_RW(SDL_RWops *, int);
]]
ng.sdl2Enums.SDL_BLENDMODE_NONE = 0
ng.sdl2Enums.SDL_BLENDMODE_BLEND = 1
ng.sdl2Enums.SDL_BLENDMODE_ADD = 2
ng.sdl2Enums.SDL_BLENDMODE_MOD = 4

