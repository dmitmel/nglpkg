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
