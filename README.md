# NGLPKG

There should be some more text here

## The Guide To Setting Up NGLPKG

1. Run `setup.sh` or `setup.cmd` depending on which is appropriate.

2. Copy the resulting `sdk` or `sdk.cmd` file to your target nglpkg project directory.

3. You can now use the NGLPKG tools - note though that the "sdk" wrapper assumes the NGLPKG SDK has not been moved.
Furthermore, some projects may need to run the SDK from within itself, so `sdk` / `sdk.cmd` should be left alone.

## The Tools

Effectively, sdk just runs a module with some given arguments.

It will attempt to require `nglpkg-settings` (which can't be an ng-style module) before `ng.boot`, allowing for some project-local configuration for all tools.

`ng.boot` is then required, and then the target module, but the target module is not checked to be in the ng style.

This is important for baking purposes, ensuring that no 'real' ng modules have been required yet.

### sdk ng.bake <modules...>

Bakes a module tree. Expects standard output to be willing to accept some binary in the resulting Lua code, so have a file ready.

## How To Make A Buildscript

You might be tempted to write a buildscript in your local shell language.

As it turns out, this was a terrible idea because it required maintaining two parallel scripts.

Instead, the `sdk` and `sdk.cmd` system allows a simple solution: `sdk build`.

Simply name a module `build`, and have it contain the buildscript for your program.

`PROJECT_DIR` and `NGLPKG_SDK` are globals that should simplify the task.

