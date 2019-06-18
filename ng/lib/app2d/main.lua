ng.module(
	"ng.lib.app2d.main",
	"ng.lib.app2d.base",
	"ng.wrap.sdl2.events",
	"ng.wrap.sdl2.sdl",
	"ng.wrap.sdl2.timer",
	"ng.wrap.ffi"
)

-- This is the main loop for app2d.
-- The application class is a function that returns a table of form:
-- {
--  function :frame () -- Called on every frame.
-- }

function ng.app2d.main(appClass, frameTime)
	ng.sdl2.SDL_Init(ng.sdl2Enums.SDL_INIT_TIMER + ng.sdl2Enums.SDL_INIT_VIDEO + ng.sdl2Enums.SDL_INIT_EVENTS)
	ng.app2d.running = true

	ng.app2d.instance = appClass()

	local event = ffi.new("SDL_Event")
	while ng.app2d.running do
		while ng.sdl2.SDL_PollEvent(event) ~= 0 do
			ng.app2d.instance:event(event)
		end
		ng.app2d.instance:frame()
		-- Yes, I know I should have proper counterweighting.
		ng.sdl2.SDL_Delay(frameTime)
	end
	ng.sdl2.SDL_Quit()
end
