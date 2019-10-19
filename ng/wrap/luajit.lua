--@: This module provides some cdefs for LuaJIT itself.
--@: This can be useful to make other Lua states.
--@:
ng.module(
	"ng.wrap.luajit"
)

--@: As it's just cdefs, you should check the relevant Lua 5.1 API documentation for more information.
--@:
--@> DOC.echo = true
ffi.cdef[[
	void * luaL_newstate();
	void luaL_openlibs(void *);
	int luaL_loadstring(void *, const char *);
	int lua_pcall(void *, int, int, int);
	const char * lua_tolstring(void *, int, size_t *);
	void lua_close(void *);
]]
--@> DOC.echo = false

