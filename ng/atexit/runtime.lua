--@> DOC.module.MODULE = "ng.atexit"
--@: Provides the ng.atexit baking directive / function.
--@: 
--@: This baking directive is useful when a "program" (that actually has a main function) can have modules added to it.
--@: Example:
--@: 
--@: ng.atexit(
--@:  "runMyCode()"
--@: )
--@: 
--@: This essentially puts "runMyCode()" at the end of the last module.
--@: Given multiple atexit directives, they are added in order.

ng.module(
	"ng.atexit.runtime"
)

ng.atexit = function (code)
	local f, e = loadstring(code)
	if not f then
		error(e)
	end
	local oz = ng.Z
	ng.Z = function ()
		oz()
		f()
	end
end
