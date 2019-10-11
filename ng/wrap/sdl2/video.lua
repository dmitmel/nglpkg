ng.module(
	"ng.wrap.sdl2.video",
	"ng.wrap.sdl2.video-base",
	"ng.wrap.sdl2.video-gl",
	"ng.wrap.sdl2.base"
)

--- SDL_video (STATE: Probably complete per 2.0.10+dfsg1-1ubuntu1 )

ffi.cdef[[
	typedef struct {
		uint32_t format;
		int w, h, refresh_rate;
		void * driverdata;
	} SDL_DisplayMode;
]]

ng.sdl2Enums.enums("SDL_ORIENTATION_", {
	"UNKNOWN", "LANDSCAPE", "LANDSCAPE_FLIPPED", "PORTRAIT", "PORTRAIT_FLIPPED"
})

-- The following are in events (and thus not here):
-- SDL_WINDOWEVENT_*
-- SDL_DISPLAYEVENT_*
-- The following are in video-base (and thus not here):
-- The SDL_Window type
-- SDL_WINDOWPOS_*
-- SDL_WINDOW_*
-- SDL_CreateWindow
-- SDL_SetWindowIcon
-- SDL_SetWindowTitle
-- SDL_GetWindowID
-- SDL_GetWindowFromID
-- SDL_SetWindowGrab
-- SDL_SetWindowFullscreen
-- SDL_GetWindowSurface
-- SDL_UpdateWindowSurface
-- SDL_DestroyWindow
-- The entire "GL" side of the API is in video-gl

ng.sdl2Enums.enums("SDL_HITTEST_", {
	"NORMAL", "DRAGGABLE",
	"RESIZE_TOPLEFT", "RESIZE_TOP", "RESIZE_TOPRIGHT",
	"RESIZE_RIGHT", "RESIZE_BOTTOMRIGHT", "RESIZE_BOTTOM",
	"RESIZE_BOTTOMLEFT", "RESIZE_LEFT"
})

ffi.cdef[[
	int SDL_GetNumVideoDrivers();
	const char * SDL_GetVideoDriver(int);
	int SDL_VideoInit(const char *);
	void SDL_VideoQuit();
	const char * SDL_GetCurrentVideoDriver();
	int SDL_GetNumVideoDisplays();
	const char * SDL_GetDisplayName(int);
	int SDL_GetDisplayBounds(int, SDL_Rect *);
	int SDL_GetDisplayUsableBounds(int, SDL_Rect *);
	int SDL_GetDisplayDPI(int, float *, float *, float *);
	int SDL_GetDisplayOrientation(int);
	int SDL_GetNumDisplayModes(int);
	int SDL_GetDisplayMode(int, int, SDL_DisplayMode *);
	int SDL_GetDesktopDisplayMode(int, SDL_DisplayMode *);
	int SDL_GetCurrentDisplayMode(int, SDL_DisplayMode *);
	int SDL_GetClosestDisplayMode(int, const SDL_DisplayMode *, SDL_DisplayMode *);
	int SDL_GetWindowDisplayIndex(SDL_Window *);
	int SDL_SetWindowDisplayMode(SDL_Window *, const SDL_DisplayMode *);
	int SDL_GetWindowDisplayMode(SDL_Window *, SDL_DisplayMode *);
	uint32_t SDL_GetWindowPixelFormat(SDL_Window *);
	SDL_Window * SDL_CreateWindowFrom(const void *);
	uint32_t SDL_GetWindowFlags(SDL_Window *);
	const char * SDL_GetWindowTitle(SDL_Window *);
	void * SDL_SetWindowData(SDL_Window *, const char *, void *);
	void * SDL_GetWindowData(SDL_Window *, const char *);
	void SDL_SetWindowPosition(SDL_Window *, int, int);
	void SDL_GetWindowPosition(SDL_Window *, int *, int *);
	void SDL_SetWindowSize(SDL_Window *, int, int);
	void SDL_GetWindowSize(SDL_Window *, int, int);
	int SDL_GetWindowBordersSize(SDL_Window *, int *, int *, int *, int *);
	void SDL_SetWindowMinimumSize(SDL_Window *, int, int);
	void SDL_GetWindowMinimumSize(SDL_Window *, int *, int *);
	void SDL_SetWindowMaximumSize(SDL_Window *, int, int);
	void SDL_GetWindowMaximumSize(SDL_Window *, int *, int *);
	void SDL_SetWindowBordered(SDL_Window *, int);
	void SDL_SetWindowResizable(SDL_Window *, int);
	void SDL_ShowWindow(SDL_Window *);
	void SDL_HideWindow(SDL_Window *);
	void SDL_RaiseWindow(SDL_Window *);
	void SDL_MaximizeWindow(SDL_Window *);
	void SDL_MinimizeWindow(SDL_Window *);
	void SDL_RestoreWindow(SDL_Window *);
	int SDL_UpdateWindowSurfaceRects(SDL_Window *, const SDL_Rect *, int);
	int SDL_GetWindowGrab(SDL_Window *);
	SDL_Window * SDL_GetGrabbedWindow();
	int SDL_SetWindowBrightness(SDL_Window *, float);
	float SDL_GetWindowBrightness(SDL_Window *);
	int SDL_SetWindowOpacity(SDL_Window *, float);
	int SDL_GetWindowOpacity(SDL_Window *, float *);
	int SDL_SetWindowModalFor(SDL_Window *, SDL_Window *);
	int SDL_SetWindowInputFocus(SDL_Window *);
	int SDL_SetWindowGammaRamp(SDL_Window *, const uint16_t *, const uint16_t *, const uint16_t *);
	int SDL_GetWindowGammaRamp(SDL_Window *, uint16_t *, uint16_t *, uint16_t *);
	int SDL_SetWindowHitTest(SDL_Window *, int (*)(SDL_Window *, const SDL_Point *, void *), void *);
	void SDL_IsScreenSaverEnabled();
	void SDL_EnableScreenSaver();
	void SDL_DisableScreenSaver();
]]

