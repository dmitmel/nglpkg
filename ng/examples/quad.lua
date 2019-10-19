--@> ng.doc.command({}, nil)
--@> DOC.target = "15-Examples-Complex"
ng.module(
	"ng.examples.quad",
	"ng.atexit",
	"ng.lib.app2d.main",
	"ng.lib.app2d.draw"
)
ng.atexit(
	"ng.app2d.main(QuadAppClassWrapper, 15)"
)

-- A relatively simple example demonstrating ng.lib.app2d's drawing functionality.

function QuadAppClass()
	local app = {}
	function app:drawWindow(w)
		w.gl.glClear(w.gl.GL_COLOUR_BUFFER_BIT)
		ng.app2d.texRect(w.pixel, {w.greenX, w.greenY, 32, 32}, {0, 0, 1, 1}, {0.25, 0.25, 0.25, 1})
	end
	function app:createWindow()
		local w = ng.app2d.Window("Quads Test", 400, 300, true)
		w.greenX = 1
		w.greenY = 1
		return w
	end
	-- used by wrapper...
	function app:start()
		self.mainWin = self:createWindow()
	end
	-- draw2d interface...
	function app:event(event)
		if ng.app2d.isQuit(event) then
			ng.app2d.running = false
		end
	end
	function app:frame()
		ng.app2d.windowFrame(self.mainWin, function ()
			self:drawWindow(self.mainWin)
		end)
	end
	return app
end

-- Used so later examples can extend the example properly.
function QuadAppClassWrapper()
	local app = QuadAppClass()
	app:start()
	return app
end
