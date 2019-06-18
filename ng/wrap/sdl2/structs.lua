ng.module(
	"ng.wrap.sdl2.structs",
	"ng.wrap.sdl2.base"
)

--- SDL core structs (SDL_rwops, SDL_rect, SDL_pixels, SDL_surface) (heavily abridged)

-- This has a surprisingly extensive rectangle library, but it's part-inlined.
-- The interesting parts aren't, though!
ffi.cdef[[
	typedef struct {
		int x, y;
	} SDL_Point;
	typedef struct {
		int x, y, w, h;
	} SDL_Rect;
	int SDL_HasIntersection(const SDL_Rect * a, const SDL_Rect * b);
	int SDL_IntersectRect(const SDL_Rect * a, const SDL_Rect * b, SDL_Rect * o);
	void SDL_UnionRect(const SDL_Rect * a, const SDL_Rect * b, SDL_Rect * o);
	int SDL_IntersectRectAndLine(const SDL_Rect * r, int * xa, int * ya, int * xb, int * yb);
]]

ng.sdl2Enums.enums("SDL_RWOPS_", {
	"UNKNOWN", "WINFILE", "STDFILE", "JNIFILE", "MEMORY", "MEMORY_RO"
})
ng.sdl2Enums.enums("RW_SEEK_", {
	"SET", "CUR", "END"
})

ffi.cdef[[
	typedef struct {
		int64_t ( * size) (void * self);
		int64_t ( * seek) (void * self, int64_t offset, int whence);
		size_t ( * read) (void * self, void * ptr, size_t size, size_t maxnum);
		size_t ( * write) (void * self, void * ptr, size_t size, size_t maxnum);
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
	SDL_RWops * SDL_RWFromFile(const char * file, const char * mode);
	SDL_RWops * SDL_RWFromMem(void * mem, int size);
	SDL_RWops * SDL_RWFromConstMem(const void * mem, int size);
	SDL_RWops * SDL_AllocRW(SDL_RWops * file);
	void SDL_FreeRW(SDL_RWops * file);
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

	SDL_Surface * SDL_CreateRGBSurface(uint32_t flags, int w, int h, int depth, uint32_t rm, uint32_t gm, uint32_t bm, uint32_t am);
	SDL_Surface * SDL_CreateRGBSurfaceFrom(void * pixels, int w, int h, int depth, int pitch, uint32_t rmask, uint32_t gmask, uint32_t bmask, uint32_t amask);
	int SDL_LockSurface(SDL_Surface * surface);
	void SDL_UnlockSurface(SDL_Surface * surface);
	int SDL_FillRect(SDL_Surface * dst, const SDL_Rect * tgt, uint32_t col);
	int SDL_UpperBlit(SDL_Surface * src, const SDL_Rect * srcr, SDL_Surface * dst, SDL_Rect * dstr);
	int SDL_UpperBlitScaled(SDL_Surface * src, const SDL_Rect * srcr, SDL_Surface * dst, SDL_Rect * dstr);
	int SDL_SetSurfaceBlendMode(SDL_Surface * surface, int mode);
	void SDL_FreeSurface(SDL_Surface * surface);
	SDL_Surface * SDL_LoadBMP_RW(SDL_RWops * src, int freesrc);
]]
ng.sdl2Enums.SDL_BLENDMODE_NONE = 0
ng.sdl2Enums.SDL_BLENDMODE_BLEND = 1
ng.sdl2Enums.SDL_BLENDMODE_ADD = 2
ng.sdl2Enums.SDL_BLENDMODE_MOD = 4

