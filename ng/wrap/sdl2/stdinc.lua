ng.module(
	"ng.wrap.sdl2.stdinc",
	"ng.wrap.sdl2.base"
)

-- Ignore SDL_bool since it's equivalent to int...
-- Ignore fancy integer type redefinitions...
-- Ignore a lot of printfy stuff...

ffi.cdef[[
	void * SDL_malloc(size_t);
	void * SDL_calloc(size_t, size_t);
	void * SDL_realloc(void *, size_t);
	void SDL_free(void *);
]]

-- Ignore memory overrides...
-- Ignore an entire clone of the C Standard Library...
-- Keep this bit, though
ffi.cdef[[
	char * SDL_getenv(const char *);
	int SDL_setenv(const char *, const char *, int);
]]

ffi.cdef[[
	typedef struct {} * SDL_iconv_t;
	SDL_iconv_t SDL_iconv_open(const char *, const char *);
	int SDL_iconv_close(SDL_iconv_t);
	size_t SDL_iconv(SDL_iconv_t, const char **, size_t *, char **, size_t *)
	char * SDL_iconv_string(const char *, const char *, const char *, size_t);
]]
