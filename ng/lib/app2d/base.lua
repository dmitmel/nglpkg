--@: The basic 'app2d' framework base.
--@: Even if everything else changes, this'll probably stay the same.
--@:
ng.module(
	"ng.lib.app2d.base",
	"ng.lib.util.cblists"
)
--@: Firstly, let's go over the ng.app2d table:
--@> DOC.echo = true
ng.app2d = {
	-- Functions run to create a window. The App2D window object starts off as a new, empty table.
	-- These functions are then run to actually make that window "real".
	ctxInitializers = {},
	-- Due to the nature of the OpenGL API, the current OpenGL context is an application-wide global.
	-- Each window has it's own OpenGL context. As such, the current app2d window is also an application-wide global.
	-- These functions are run when entering a window's context.
	ctxEnterers = {},
	-- These functions are run to begin a frame in a window.
	ctxFS = {},
	-- These functions are run in reverse to end a frame in a window.
	ctxFE = {},
	-- These functions are run in reverse when leaving a window's context.
	ctxLeavers = {},
	-- These functions are run in reverse to destroy a window.
	ctxDestroyers = {},
	-- This maps window tables to true (that is, ng.app2d.windows[window] = true)
	windows = {}
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
	--@:
	ng.app2d.setCurrent(window)
	ng.runForwards(ng.app2d.ctxFS)
	cb()
	ng.runBackwards(ng.app2d.ctxFE)
end

function ng.app2d.Window(title, width, height, resizable)
	--@: Implicitly sets current to the new window.
	--@:
	ng.app2d.setCurrent(nil)
	local window = {}
	ng.app2d.windows[window] = true
	ng.app2d.current = window
	ng.runForwards(ng.app2d.ctxInitializers, title, width, height, resizable)
	return window
end

function ng.app2d.destroyCurrentWindow()
	--@: Destroys the current window.
	--@:
	ng.runBackwards(ng.app2d.ctxDestroyers)
	ng.app2d.windows[ng.app2d.current] = nil
	ng.app2d.current = nil
end
