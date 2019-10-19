ng.module(
	"ng.wrap.sdl2.base",
	"ng.wrap.ffi"
)
--@: This module holds the `ffi.load` for all the other SDL2-related modules,
--@:  and defines the sdl2Enums table that enums are put into.
--@> DOC.echo = true

ng.sdl2 = ffi.load("SDL2")
ng.sdl2Enums = {}
ng.sdl2Enums.flags = function (pf, st)
	local power = 1
	for k, v in ipairs(st) do
		if v ~= "" then
			ng.sdl2Enums[pf .. v] = power
		end
		power = power * 2
	end
end
ng.sdl2Enums.enums = function (pf, st)
	for k, v in ipairs(st) do
		if v ~= "" then
			ng.sdl2Enums[pf .. v] = k - 1
		end
	end
end
