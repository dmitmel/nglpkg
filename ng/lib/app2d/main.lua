--@: This provides the main loop used by app2d.
--@: Hence, it's also necessary to run an app2d application.
--@> DOC.functions = "ng.app2d."
ng.module(
	"ng.lib.app2d.main",
	"ng.lib.app2d.base",
	"ng.wrap.sdl2.events",
	"ng.wrap.sdl2.sdl",
	"ng.wrap.sdl2.timer",
	"ng.wrap.ffi",
	"ng.lib.util.polling-station"
)

function ng.app2d.isQuit(event)
	--@: Determines if an SDL_Event is, in fact, a quit event.
	return (event.type == ng.sdl2Enums.SDL_QUIT) or ((event.type == ng.sdl2Enums.SDL_WINDOWEVENT) and (event.window.event == ng.sdl2Enums.SDL_WINDOWEVENT_CLOSE))
end

function ng.app2d.main(appClass, frameTime)
	--@: This is the main loop for app2d.
	--@: The application class is a function that returns a table of form:
	--@: {
	--@:  function :event (event) -- Called on events.
	--@:  function :frame () -- Called on every frame.
	--@: }
	ng.sdl2.SDL_Init(ng.sdl2Enums.SDL_INIT_TIMER + ng.sdl2Enums.SDL_INIT_VIDEO + ng.sdl2Enums.SDL_INIT_EVENTS)
	ng.app2d.running = true

	ng.app2d.instance = appClass()
	ng.sdl2.SDL_EventState(ng.sdl2Enums.SDL_DROPFILE, 1)

	local function sdlPoller()
		local event = ffi.new("SDL_Event")
		while ng.sdl2.SDL_PollEvent(event) ~= 0 do
			ng.app2d.instance:event(event)
			if event.type == ng.sdl2Enums.SDL_DROPFILE then
				ng.sdl2.SDL_free(event.drop.file)
			end
		end
	end
	ng.polls[sdlPoller] = true

	while ng.app2d.running do
		ng.poll()
		ng.app2d.instance:frame()
		-- Yes, I know I should have proper counterweighting. There's no time though
		ng.sdl2.SDL_Delay(frameTime)
	end
	ng.polls[sdlPoller] = nil
	ng.sdl2.SDL_Quit()
end
