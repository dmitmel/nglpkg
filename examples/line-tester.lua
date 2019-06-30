ng.module(
	"examples.line-tester",
	"ng.lib.app2d.main",
	"ng.lib.app2d.draw"
)

-- Used to confirm that the transforms are working correctly.

ng.app2d.main(function ()
	local app = {
		mX = 0,
		mY = 0,
		pX = 0,
		pY = 0
	}

	app.mainWin = ng.app2d.Window("Line Tester", 400, 300, true)

	function app:event(event)
		if ng.app2d.isQuit(event) then
			ng.app2d.running = false
		elseif event.type == ng.sdl2Enums.SDL_MOUSEBUTTONDOWN then
			if event.button.button == 1 then
				self.mX, self.mY = event.motion.x, event.motion.y
			else
				self.pX, self.pY = event.motion.x, event.motion.y
			end
		end
	end
	function app:frame()
		ng.app2d.windowFrame(self.mainWin, function ()
			self.mainWin.gl.glClear(self.mainWin.gl.GL_COLOUR_BUFFER_BIT)
			-- Colours make it look off, even though it isn't, due to sub-pixel effects.
			-- To be honest, just about any marking method does this.
			local low = {0.1, 0.1, 0.1, 1}
			local high = {1, 1, 1, 1}
			local quad = {0.1, 1, 0.1, 0.5}
			ng.app2d.lineEx({self.mX, 0, self.mX, self.mainWin.height - 1}, low)
			ng.app2d.lineEx({0, self.mY, self.mainWin.width - 1, self.mY}, low)
			ng.app2d.lineEx({self.pX, 0, self.pX, self.mainWin.height - 1}, low)
			ng.app2d.lineEx({0, self.pY, self.mainWin.width - 1, self.pY}, low)
			ng.app2d.lineEx({self.mX, self.mY, self.pX, self.pY}, high)
			ng.app2d.texRect(self.mainWin.pixel, {self.mX, self.mY, (self.pX - self.mX) + 1, (self.pY - self.mY) + 1}, {0, 0, 1, 1}, quad)
			--ng.app2d.point(self.mX, self.mY, {1, 0, 1, 1})
			--ng.app2d.point(self.pX, self.pY, {1, 0, 1, 1})
		end)
	end

	return app
end, 15)
