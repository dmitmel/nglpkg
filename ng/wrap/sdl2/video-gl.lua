ng.module(
	"ng.wrap.sdl2.video-gl",
	"ng.wrap.sdl2.video-base",
	"ng.wrap.sdl2.base"
)

--- SDL_video (GL) (STATE: Probably complete per 2.0.10+dfsg1-1ubuntu1 )

ffi.cdef[[
	typedef void* SDL_GLContext;

	int SDL_GL_LoadLibrary(const char *);
	void * SDL_GL_GetProcAddress(const char *);
	void SDL_GL_UnloadLibrary();
	int SDL_GL_ExtensionSupported(const char *);
	void SDL_GL_ResetAttributes();
	int SDL_GL_SetAttribute(int, int);
	int SDL_GL_GetAttribute(int, int *);
	SDL_GLContext SDL_GL_CreateContext(SDL_Window *);
	int SDL_GL_MakeCurrent(SDL_Window *, SDL_GLContext);
	SDL_Window * SDL_GL_GetCurrentWindow();
	SDL_GLContext SDL_GL_GetCurrentContext();
	void SDL_GL_GetDrawableSize(SDL_Window *, int *, int *);
	int SDL_GL_SetSwapInterval(int);
	int SDL_GL_GetSwapInterval();
	void SDL_GL_SwapWindow(SDL_Window *);
	void SDL_GL_DeleteContext(SDL_GLContext);
]]

-- GL attributes
ng.sdl2Enums.enums("SDL_GL_", {
	"RED_SIZE", "GREEN_SIZE", "BLUE_SIZE", "ALPHA_SIZE", "BUFFER_SIZE", "DOUBLEBUFFER", "DEPTH_SIZE",
	"STENCIL_SIZE", "ACCUM_RED_SIZE", "ACCUM_GREEN_SIZE", "ACCUM_BLUE_SIZE", "ACCUM_ALPHA_SIZE",
	"STEREO", "MULTISAMPLEBUFFERS", "MULTISAMPLESAMPLES", "ACCELERATED_VISUAL", "RETAINED_BACKING",
	"CONTEXT_MAJOR_VERSION", "CONTEXT_MINOR_VERSION", "CONTEXT_EGL", "CONTEXT_FLAGS",
	"CONTEXT_PROFILE_MASK", "SHARE_WITH_CURRENT_CONTEXT", "FRAMEBUFFER_SRGB_CAPABLE",
	"CONTEXT_RELEASE_BEHAVIOR", "CONTEXT_RESET_NOTIFICATION", "CONTEXT_NO_ERROR"
})
-- Values for some GL attributes
ng.sdl2Enums.flags("SDL_GL_CONTEXT_PROFILE_", {"CORE", "COMPATIBILITY", "ES"})
ng.sdl2Enums.flags("SDL_GL_CONTEXT_", {"DEBUG_FLAG", "FORWARD_COMPATIBLE_FLAG", "ROBUST_ACCESS_FLAG", "RESET_ISOLATION_FLAG"})
ng.sdl2Enums.flags("SDL_GL_CONTEXT_RELEASE_BEHAVIOR_", {"NONE", "FLUSH"})
ng.sdl2Enums.flags("SDL_GL_CONTEXT_RESET_", {"NO_NOTIFICATION", "LOSE_CONTEXT"})

