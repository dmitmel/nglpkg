rem Assists in environment setup
echo set LUA_PATH=%%~dp0\?.lua;%~dp0\?.lua > sdk.cmd
echo set LUA_CPATH=%~dp0\reference\NT %PROCESSOR_ARCHITECTURE%\?.dll >> sdk.cmd
echo "%~dp0\reference\NT %PROCESSOR_ARCHITECTURE%\luajit" "%~dp0\sdk.lua" "%%~dp0 " "%~dp0 " %%* >> sdk.cmd

