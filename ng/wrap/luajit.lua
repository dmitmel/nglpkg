ng.module(
	"ng.wrap.luajit"
)


ffi.cdef[[
	void * luaL_newstate();
	void luaL_openlibs(void *);
	int luaL_loadstring(void *, const char *);
	int lua_pcall(void *, int, int, int);
	const char * lua_tolstring(void *, int, size_t *);
	void lua_close(void *);
]]
