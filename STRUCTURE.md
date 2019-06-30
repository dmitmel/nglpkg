Firstly: any module with "-bake" at the end is required at bake-time after
 baking the module without "-bake" at the end.

This is used to extend the baker, for example by providing compression.

Secondly: Modules with "-selector" at the end mean the module in question does not exist,
 but is replaced at build-time with a virtual module which depends on a module selected by the selector.

Selector modules are not actually modules, but just functions receiving an available module table as an argument and outputting the resulting module.

The purpose behind this is to reduce redundant code - for example, removing Lua DEFLATE decompression when zlib is already used by the application.

# (the root)

There's `sdk.lua` here, which is the SDK 'do many, many things' entrypoint.

There's also `setup.sh` (Unix-likes) and `setup.cmd` (Windows).

# examples

SDK examples.

# haxe

Used for writing NGLPKG applications in Haxe.

On the one hand, it may be harder to get the development environment between computers with more dependencies.

It may be an idea to write your build script in Lua and expect it to be run with `$NGLPKG_SDK/env` - this can ease porting in some aspects (and utterly ruin it in others).

On the other hand, this can be worth it for the architecture of bigger programs where *not* performing some form of static typing would cause the program to collapse.

# ng

All SDK packages.

"ng.boot" starts the module system, and isn't really a module.

"ng.boot-bake" is really a module, but which starts a bake by requiring it.

These two provide the minimum necessary components for nglpkg's "SDK".

## ng.appsize

Application size reducers. To use these, chain them before the application module on the baking command line.

Note that different combinations suit different use-cases.

`ng.appsize.bdivide` uses an extremely small and simple to implement compression algorithm,
 but which is several times less efficient than DEFLATE byte-for-byte, and does not support bytes >= 0x80.

This compression algorithm is primarily meant to bootstrap ng.appsize.deflate.

`ng.appsize.deflate` meanwhile uses a Lua decompressor for DEFLATE itself, but DEFLATE takes a relatively large amount of code to implement.

Using `ng.appsize.bdivide` solely to bootstrap `ng.appsize.deflate` offsets the implementation cost of DEFLATE.

A test program with both was 3993 bytes of Lua at last check.

Alone, `ng.appsize.bdivide` lead to the program being 1291 bytes at last check.

Alone, `ng.appsize.deflate` lead to the program being 6906 bytes at last check.

So it is clear that for extremely small programs, DEFLATE's implementation cost outweighs the benefits.

For larger programs, however, the better compression ratio versus BDIVIDE will cause the (constant) cost of ~2700 bytes to be outweighed by the (increasing) cost of BDIVIDE's worse compression ratio.

Furthermore, some programs may already need a DEFLATE implementation, and in this case using `ng.appsize.deflate` reduces size.

The DEFLATE implementation used for application decompression is loaded as a normal module, and remains available for use.

## ng.lib

Various libraries.

## ng.lib.util

This is where individual little pieces that aren't really categorizable should go.

## ng.lib.fs

Internal stuff for the module `ng.lib.fs`.

## ng.lib.encoding

Encodings. `ng.lib.encoding.all` contains them all.

## ng.wrap

Wrappers.
