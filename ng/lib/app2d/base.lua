ng.module(
	"ng.lib.app2d.base",
	"ng.lib.util.cblists"
)

ng.app2d = {ctxInitializers = {}, ctxEnterers = {}, ctxFS = {}, ctxFE = {}, ctxLeavers = {}, ctxDestroyers = {}, windows = {}}
-- ng.app2d.current contains the current 'window handle'

function ng.app2d.setCurrent(window)
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
	ng.app2d.setCurrent(window)
	ng.runForwards(ng.app2d.ctxFS)
	cb()
	ng.runBackwards(ng.app2d.ctxFE)
end

-- Implicitly sets current to the new window.
function ng.app2d.Window(title, width, height, resizable)
	ng.app2d.setCurrent(nil)
	local window = {}
	ng.app2d.windows[window] = true
	ng.app2d.current = window
	ng.runForwards(ng.app2d.ctxInitializers, title, width, height, resizable)
	return window
end

function ng.app2d.destroyCurrentWindow()
	ng.runBackwards(ng.app2d.ctxDestroyers)
	ng.app2d.windows[ng.app2d.current] = nil
	ng.app2d.current = nil
end
