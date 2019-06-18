ng.module(
	"ng.wrap.sdl2.video",
	"ng.wrap.sdl2.video-base",
	"ng.wrap.sdl2.video-gl",
	"ng.wrap.sdl2.base"
)

--- SDL_video

ffi.cdef[[
	typedef struct {
		uint32_t format;
		int w, h, refresh_rate;
		void * driverdata;
	} SDL_DisplayMode;
]]

ng.sdl2Enums.enums("SDL_HITTEST_", {
	"NORMAL", "DRAGGABLE",
	"RESIZE_TOPLEFT", "RESIZE_TOP", "RESIZE_TOPRIGHT",
	"RESIZE_RIGHT", "RESIZE_BOTTOMRIGHT", "RESIZE_BOTTOM",
	"RESIZE_BOTTOMLEFT", "RESIZE_LEFT"
})

ffi.cdef[[
	int SDL_GetDisplayDPI(int displayIndex, float * ddpi, float * hdpi, float * vdpi);
	int SDL_GetWindowDisplayIndex(SDL_Window * window);
]]

-- There's a lot of functions here that one *could* add here but I won't.
-- The following are in events (and thus not here):
-- SDL_WINDOWEVENT_*
-- The following are in video-base (and thus not here):
-- SDL_WINDOWPOS_*
-- SDL_WINDOW_*
-- SDL_CreateWindow
-- SDL_SetWindowIcon
-- SDL_SetWindowTitle
-- SDL_GetWindowID
-- SDL_GetWindowFromID
-- SDL_GetWindowSurface
-- SDL_UpdateWindowSurface
-- SDL_SetWindowGrab
-- SDL_SetWindowFullscreen
-- SDL_DestroyWindow
-- The entire "GL" side of the API is in video-gl
ffi.cdef[[
	SDL_Window * SDL_CreateWindowFrom(const void *);
	uint32_t SDL_GetWindowFlags(SDL_Window * window);
	const char * SDL_GetWindowTitle(SDL_Window * window);
	void SDL_SetWindowPosition(SDL_Window * window, int x, int y);
	void SDL_GetWindowPosition(SDL_Window * window, int * x, int * y);
	void SDL_SetWindowSize(SDL_Window * window, int w, int h);
	void SDL_GetWindowSize(SDL_Window * window, int * w, int * h);
	int SDL_GetWindowBordersSize(SDL_Window * window, int * top, int * left, int * bottom, int * right);
	void SDL_SetWindowMinimumSize(SDL_Window * window, int mw, int mh);
	void SDL_SetWindowMaximumSize(SDL_Window * window, int mw, int mh);
	void SDL_SetWindowBordered(SDL_Window * window, int bordered);
	void SDL_SetWindowResizable(SDL_Window * window, int resiz);
	void SDL_ShowWindow(SDL_Window * window);
	void SDL_HideWindow(SDL_Window * window);
	void SDL_RaiseWindow(SDL_Window * window);
	void SDL_MaximizeWindow(SDL_Window * window);
	void SDL_MinimizeWindow(SDL_Window * window);
	void SDL_RestoreWindow(SDL_Window * window);
	int SDL_UpdateWindowSurfaceRects(SDL_Window *, const SDL_Rect *, int);
	int SDL_GetWindowGrab(SDL_Window *);
	SDL_Window * SDL_GetGrabbedWindow();
]]
ffi.cdef[[
	int SDL_SetWindowGammaRamp(SDL_Window *, const uint16_t *, const uint16_t *, const uint16_t *);
	int SDL_GetWindowGammaRamp(SDL_Window *, uint16_t *, uint16_t *, uint16_t *);
	int SDL_SetWindowHitTest(SDL_Window *, int (*)(SDL_Window *, const SDL_Point *, void *), void *);
	void SDL_IsScreenSaverEnabled();
	void SDL_EnableScreenSaver();
	void SDL_DisableScreenSaver();
]]

