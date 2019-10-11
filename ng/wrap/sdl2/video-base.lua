ng.module(
	"ng.wrap.sdl2.video-base",
	"ng.wrap.sdl2.structs",
	"ng.wrap.sdl2.base"
)

-- This is *just* the basics.
-- Games don't need anything more than this and video-gl to work.

ng.sdl2Enums.flags("SDL_WINDOW_", {
	"FULLSCREEN", "OPENGL", "SHOWN", "HIDDEN", "BORDERLESS", "RESIZABLE",
	"MINIMIZED", "MAXIMIZED", "INPUT_GRABBED", "INPUT_FOCUS", "MOUSE_FOCUS",
	"FOREIGN", "", "ALLOW_HIGHDPI", "MOUSE_CAPTURE", "ALWAYS_ON_TOP", "SKIP_TASKBAR",
	"UTILITY", "TOOLTIP", "POPUP_MENU",
	"", "", "", "",
	"", "", "", "",
	"VULKAN"
})
ng.sdl2Enums.SDL_WINDOW_FULLSCREEN_DESKTOP = 0x1001

ng.sdl2Enums.SDL_WINDOWPOS_UNDEFINED = 0x1FFF0000
ng.sdl2Enums.SDL_WINDOWPOS_CENTERED = 0x2FFF0000
ng.sdl2Enums.SDL_WINDOWPOS_CENTRED = 0x2FFF0000

ffi.cdef[[
	typedef struct {} SDL_Window;
		
	SDL_Window * SDL_CreateWindow(const char *, int, int, int, int, uint32_t);
	void SDL_DestroyWindow(SDL_Window *);

	void SDL_SetWindowIcon(SDL_Window *, SDL_Surface *);
	void SDL_SetWindowTitle(SDL_Window *, const char *);
	void SDL_SetWindowGrab(SDL_Window *, int);
	void SDL_SetWindowFullscreen(SDL_Window *, uint32_t);

	uint32_t SDL_GetWindowID(SDL_Window *);
	SDL_Window * SDL_GetWindowFromID(uint32_t);

	SDL_Surface * SDL_GetWindowSurface(SDL_Window *);
	int SDL_UpdateWindowSurface(SDL_Window *);
]]

