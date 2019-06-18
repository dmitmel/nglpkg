ng.module(
	"examples.quad-mouse",
	"examples.quad"
)

-- Extends quad to add mouse support.

do
	local oldQAC = QuadAppClass
	function QuadAppClass()
		local app = oldQAC()
		local oldEv = app.event
		function app:event(ev)
			oldEv(self, ev)
			if ev.type == ng.sdl2Enums.SDL_MOUSEMOTION then
				local w = ng.app2d.windowById[ev.motion.windowID]
				w.greenX = ev.motion.x
				w.greenY = ev.motion.y
			end
		end
		return app
	end
end
