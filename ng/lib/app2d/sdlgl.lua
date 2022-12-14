ng.module(
	"ng.lib.app2d.sdlgl",
	"ng.lib.app2d.base",
	"ng.wrap.sdl2.sdl",
	"ng.wrap.sdl2.video-base",
	"ng.wrap.sdl2.video-gl",
	"ng.wrap.gl",
	"ng.wrap.ffi",
	"ng.lib.util.cblists"
)

--@: This part manages a GL context for a app2d window. It should get refactored sometime.
--@: Apart from the ng.app2d.invertViewport, you use it just by having it referenced somewhere, FOR NOW
--@: API SUBJECT TO CHANGE

do

	local function updateSize()
		local w = ng.app2d.current
		local i2 = ffi.new("int[2]")
		ng.sdl2.SDL_GL_GetDrawableSize(w.window, i2, i2 + 1)
		w.width = i2[0]
		w.height = i2[1]
		w.gl.glViewport(0, 0, w.width, w.height)
	end
	function ng.app2d.invertViewport(xW, yW)
		xW, yW = math.floor(xW) + 0.5, math.floor(yW) - 0.5
		local w = ng.app2d.current
		-- Window coordinate transform is:
		-- xW = ((xD + 1) * (width / 2))
		-- yWI = ((yD + 1) * (height / 2))
		-- yW = height - (yWI + 1)
		local xD = (xW / (w.width / 2)) - 1
		local yWI = w.height - (yW + 1)
		local yD = (yWI / (w.height / 2)) - 1
		return xD, yD
	end
	table.insert(ng.app2d.ctxInitializers, function ()
		local w = ng.app2d.current
		ng.sdl2.SDL_GL_ResetAttributes()
		ng.sdl2.SDL_GL_SetAttribute(ng.sdl2Enums.SDL_GL_CONTEXT_MAJOR_VERSION, 2)
		ng.sdl2.SDL_GL_SetAttribute(ng.sdl2Enums.SDL_GL_CONTEXT_MINOR_VERSION, 1)
		w._glctx = ng.sdl2.SDL_GL_CreateContext(w.window)
		w.gl = ng.createGL(ng.sdl2.SDL_GL_GetProcAddress)
		updateSize()
	end)
	table.insert(ng.app2d.ctxEnterers, function ()
		local w = ng.app2d.current
		ng.sdl2.SDL_GL_MakeCurrent(w.window, w._glctx)
	end)
	table.insert(ng.app2d.ctxDestroyers, function ()
		local w = ng.app2d.current
		ng.sdl2.SDL_GL_DeleteContext(w._glctx)
	end)
	table.insert(ng.app2d.ctxFS, function ()
		local w = ng.app2d.current
		updateSize()
	end)
	table.insert(ng.app2d.ctxFE, function ()
		local w = ng.app2d.current
		w.gl.glFinish()
		ng.sdl2.SDL_GL_SwapWindow(w.window)
	end)
end
