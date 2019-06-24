rem NGLPKG bootstrap script - this & PROGRAM are CC0
set LUA_PATH="%LUA_PATH%;%~dp0\?.lua"
set LUA_CPATH="%LUA_CPATH%;%~dp0\reference\NT %PROCESSOR_ARCHITECTURE%\?.dll"
"%~dp0\NT %PROCESSOR_ARCHITECTURE%\luajit" "%~dp0\binary" %*

