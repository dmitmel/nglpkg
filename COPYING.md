Most of the files in the 'reference' directory are taken from various 
 open-source projects and builds of them. Their licenses are described
 in the COPYRIGHT files in that directory.

Those binaries and license files are provided, but I'm not a lawyer, and it's not valid legal advice.

Do your own research, okay?

(And if I've screwed up, please tell me!)

nglpkg code in `ng.wrap` refers to functions found in libraries.

These parts are simply wrappers and should not contain library code.

Regardless, licensing information is provided just in case.

The baking system in particular relies on the system's ZLIB - ZLIB not being supplied here - to compress code.

(ZLIB is not used in the resulting program for decompression unless the resulting program already uses ZLIB.)

Other files are under the following license:

    nglpkg - program packaging for the mad
    Written starting in 2019.
    To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.
    You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

Said copy of the CC0 is in `reference/CC0.txt`.

The method used for Huffman table creation is taken from that described in RFC1951.
This is due to the format incompatibility that would result otherwise, and should not affect copyright, but this notice exists as a fallback.

