--@: This module provides decompression for the algorithm used by [[ng.appsize.bdivide]].
--@: ng.decompressBDivide(data): Returns the decompressed output for the input data.
ng.module(
	"ng.lib.decompress.bdivide"
)
-- This *specific* bit of code is a hotspot for size purposes.
-- Under any compressed configuration it ends up in the binary raw.
-- Bytes here count 1:1.
-- So it gets to play fast and loose with the style rules,
--  in favour of human optimization.
ng.decompressBDivide=function(c,s,a,b)s=""while#c>0
do
	b=c:byte()if b<128 then
		s=s..c:sub(1,1)c=c:sub(2)else
		-- Normally I wouldn't do this, but desperate times 'n' all that.
		-- (c:byte(2) * 256) + c:byte(3)
		a=c:byte(2)*256+c:byte(3)s=s..s:sub(a,a+b-128)c=c:sub(4)end
	end
	return s
end

