ng.module(
	"ng.wrap.sdl2.stdinc"
	"ng.wrap.sdl2.base"
)

-- Ignore SDL_bool since it's equivalent to int...
-- Ignore fancy integer type redefinitions...
-- Ignore a lot of printfy stuff...

ffi.cdef[[
	void * SDL_malloc(size_t size);
	void * SDL_calloc(size_t nmemb, size_t size);
	void * SDL_realloc(void * mem, size_t size);
	void SDL_free(void * mem);
]]

-- Ignore memory overrides...
-- Ignore an entire clone of the C Standard Library...
-- Ignore SDL2's iconv (for now)...

