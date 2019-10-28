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
	void lua_close(void *);

	void luaL_openlibs(void *);

	int lua_gettop(void *);
	void lua_settop(void *, int);

	void lua_pushnil(void *);
	void lua_pushnumber(void *, double);
	void lua_pushlstring(void *, const char *, size_t);

	void lua_isnumber(void *, int);
	double lua_tonumber(void *, int);
	const char * lua_tolstring(void *, int, size_t *);

	int luaL_loadstring(void *, const char *);
	int lua_pcall(void *, int, int, int);
]]
-- LUA_MULTRET = -1
--@> DOC.echo = false

