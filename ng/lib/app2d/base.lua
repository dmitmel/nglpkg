--@: The basic 'app2d' framework base.
--@: Even if everything else changes, this'll probably stay the same.
--@:
ng.module(
	"ng.lib.app2d.base",
	"ng.wrap.sdl2.sdl",
	"ng.wrap.sdl2.video-base",
	"ng.lib.util.cblists"
)
--@: Firstly, let's go over the ng.app2d table:
--@> DOC.echo = true
ng.app2d = {
	-- Functions run when creating a window.
	ctxInitializers = {},
	-- Due to the nature of the OpenGL API, the current OpenGL context is an application-wide global.
	-- Each window has it's own OpenGL context. As such, the current app2d window is also an application-wide global.
	-- These functions are run when entering a window's context.
	-- NOTE: The model of a "current window" is probably going to stay API-level, but if it'll look like this...
	ctxEnterers = {},
	-- NOTE: The idea of frame start/end being part of the app2d base is subject to change.
	-- I think it'd be better to have this in higher abstraction layers so when app2d.draw is nuked from orbit there's less casualties.
	-- If you're already not using app2d.draw, don't use this either.
	-- These functions are run to begin a frame in a window.
	ctxFS = {},
	-- These functions are run in reverse to end a frame in a window.
	ctxFE = {},
	-- These functions are run in reverse when leaving a window's context.
	ctxLeavers = {},
	-- These functions are run in reverse to destroy a window.
	ctxDestroyers = {},
	-- This maps window tables to true (that is, ng.app2d.windows[window] = true)
	windows = {},
	-- This maps SDL2 window IDs to their respective windows.
	windowById = {}
	-- ng.app2d.current is the current window
}
--@> DOC.echo = false
--@: As for functions...
--@> ng.doc.section("base functions")
--@> DOC.functions = "ng.app2d."
function ng.app2d.setCurrent(window)
	--@: Properly sets the current window.
	--@:
	if ng.app2d.current ~= window then
		if ng.app2d.current then
			ng.runBackwards(ng.app2d.ctxLeavers)
		end
		ng.app2d.current = window
		if ng.app2d.current then
			ng.runForwards(ng.app2d.ctxEnterers)
		end
	end
end

function ng.app2d.windowFrame(window, cb)
	--@: Starts a frame in the current window's context, runs cb(), then ends it.
	--@: THIS PART OF THE API SUBJECT TO CHANGE
	--@:
	ng.app2d.setCurrent(window)
	ng.runForwards(ng.app2d.ctxFS)
	cb()
	ng.runBackwards(ng.app2d.ctxFE)
end

function ng.app2d.Window(title, width, height, resizable)
	--@: Creates a window.
	--@: Implicitly sets current to the new window.
	--@:
	local flags = ng.sdl2Enums.SDL_WINDOW_OPENGL
	if resizable then
		flags = flags + ng.sdl2Enums.SDL_WINDOW_RESIZABLE
	end
	return ng.app2d.windowFromSDL2(ng.sdl2.SDL_CreateWindow(title, ng.sdl2Enums.SDL_WINDOWPOS_CENTRED, ng.sdl2Enums.SDL_WINDOWPOS_CENTRED, width, height, flags))
end

function ng.app2d.windowFromSDL2(sdlw)
	--@: Turns an SDL2 window into an app2d window (so you can initialize the window however you like)
	--@:
	ng.app2d.setCurrent(nil)
	local w = {}
	w.window = sdlw
	ng.app2d.windows[w] = true
	ng.app2d.current = w
	ng.app2d.windowById[ng.sdl2.SDL_GetWindowID(sdlw)] = w
	ng.runForwards(ng.app2d.ctxInitializers)
	return w
end

function ng.app2d.destroyCurrentWindow()
	--@: Destroys the current window.
	--@:
	ng.runBackwards(ng.app2d.ctxDestroyers)
	ng.app2d.windowById[ng.sdl2.SDL_GetWindowID(ng.app2d.current.window)] = nil
	ng.sdl2.SDL_DestroyWindow(ng.app2d.current.window)
	ng.app2d.windows[ng.app2d.current] = nil
	ng.app2d.current = nil
end
