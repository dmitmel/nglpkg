rem NGLPKG bootstrap script - this & PROGRAM are CC0
set LUA_CPATH="%~dp0\NT %PROCESSOR_ARCHITECTURE%\?.dll"
"%~dp0\NT %PROCESSOR_ARCHITECTURE%\luajit" "%~dp0\binary" %*
