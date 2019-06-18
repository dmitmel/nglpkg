ng.module(
	"ng.wrap.sdl2.events",
	"ng.wrap.sdl2.keyboard",
	"ng.wrap.sdl2.base"
)

ng.sdl2Enums.enums("SDL_", {"RELEASED", "PRESSED"})

-- Moved from video.lua
ng.sdl2Enums.enums("SDL_WINDOWEVENT_", {
	"NONE", "SHOWN", "HIDDEN", "EXPOSED", "MOVED", "RESIZED", "SIZE_CHANGED", "MINIMIZED", "MAXIMIZED",
	"RESTORED", "ENTER", "LEAVE", "FOCUS_GAINED", "FOCUS_LOST", "CLOSE", "TAKE_FOCUS", "HIT_TEST"
})

-- NOTE: This is not a complete listing! Several OS-specific events are missing.
-- Where the blanks are, --<SNIP>-- will be put.

-- --<SNIP>-- SDL_FIRSTEVENT

ng.sdl2Enums.SDL_QUIT = 0x100
-- --<SNIP>-- SDL_APP_...
ng.sdl2Enums.SDL_DISPLAYEVENT = 0x150
ng.sdl2Enums.SDL_WINDOWEVENT = 0x200
ng.sdl2Enums.SDL_SYSWMEVENT = 0x201

ng.sdl2Enums.SDL_KEYDOWN = 0x300
ng.sdl2Enums.SDL_KEYUP = 0x301
ng.sdl2Enums.SDL_TEXTEDITING = 0x302
ng.sdl2Enums.SDL_TEXTINPUT = 0x303
ng.sdl2Enums.SDL_KEYMAPCHANGED = 0x304

ng.sdl2Enums.SDL_MOUSEMOTION = 0x400
ng.sdl2Enums.SDL_MOUSEBUTTONDOWN = 0x401
ng.sdl2Enums.SDL_MOUSEBUTTONUP = 0x402
ng.sdl2Enums.SDL_MOUSEWHEEL = 0x403

-- --<SNIP>-- SDL_JOY... / SDL_CONTROLLER...

ng.sdl2Enums.SDL_FINGERDOWN = 0x700
ng.sdl2Enums.SDL_FINGERUP = 0x701
ng.sdl2Enums.SDL_FINGERMOTION = 0x702

-- --<SNIP>-- gesture stuff

ng.sdl2Enums.SDL_CLIPBOARDUPDATE = 0x900

ng.sdl2Enums.SDL_DROPFILE = 0x1000
ng.sdl2Enums.SDL_DROPTEXT = 0x1001
ng.sdl2Enums.SDL_DROPBEGIN = 0x1002
ng.sdl2Enums.SDL_DROPCOMPLETE = 0x1003

-- --<SNIP>-- audio device stuff, abstract sensor stuff, SDL_RENDER_DEVICE_RESET (wtf)

ng.sdl2Enums.SDL_USEREVENT = 0x8000

ffi.cdef[[
	typedef struct {
		uint32_t type, timestamp;
	} SDL_CommonEvent;
	typedef struct {
		uint32_t type, timestamp, display;
		uint8_t event, padding1, padding2, padding3;
		int32_t data1;
	} SDL_DisplayEvent;
	typedef struct {
		uint32_t type, timestamp, windowID;
		uint8_t event, padding1, padding2, padding3;
		int32_t data1, data2;
	} SDL_WindowEvent;
	typedef struct {
		uint32_t type, timestamp, windowID;
		uint8_t state, repeat, padding2, padding3;
		SDL_Keysym keysym;
	} SDL_KeyboardEvent;
	typedef struct {
		uint32_t type, timestamp, windowID;
		char text[32];
		int32_t start, length;
	} SDL_TextEditingEvent;
	typedef struct {
		uint32_t type, timestamp, windowID;
		char text[32];
	} SDL_TextInputEvent;
	typedef struct {
		uint32_t type, timestamp, windowID;
		uint32_t which, state;
		int32_t x, y, xrel, yrel;
	} SDL_MouseMotionEvent;
	typedef struct {
		uint32_t type, timestamp, windowID;
		uint32_t which;
		uint8_t button, state, clicks, padding1;
		int32_t x, y;
	} SDL_MouseButtonEvent;
	typedef struct {
		uint32_t type, timestamp, windowID;
		uint32_t which;
		int32_t x, y;
		uint32_t direction;
	} SDL_MouseWheelEvent;
]]
-- --<SNIP>-- joy*, controller*, audiodeviceevent
ffi.cdef[[
	typedef struct {
		uint32_t type, timestamp;
		int64_t touchId, fingerId;
		float x, y;
		float dx, dy;
		float pressure;
	} SDL_TouchFingerEvent;
]]
-- --<SNIP>-- complex gesture stuff
ffi.cdef[[
	typedef struct {
		uint32_t type, timestamp;
		// You must free this with SDL_free if not NULL.
		char * file;
		uint32_t windowID;
	} SDL_DropEvent;
]]
-- --<SNIP>-- sensor stuff
ffi.cdef[[
	typedef SDL_CommonEvent SDL_QuitEvent;
]]
-- --<SNIP>-- user, syswm
ffi.cdef[[
	typedef union {
		uint32_t type;
		SDL_CommonEvent common;
		SDL_WindowEvent window;
		SDL_KeyboardEvent key;
		SDL_TextEditingEvent edit;
		SDL_TextInputEvent text;
		SDL_MouseMotionEvent motion;
		SDL_MouseButtonEvent button;
		SDL_MouseWheelEvent wheel;
		SDL_QuitEvent quit;
		SDL_TouchFingerEvent tfinger;
		SDL_DropEvent drop;
		uint8_t padding[56];
	} SDL_Event;
	int SDL_PollEvent(SDL_Event * event);
	int SDL_WaitEvent(SDL_Event * event);
	int SDL_WaitEventTimeout(SDL_Event * event, int timeout);
	void SDL_StartTextInput();
	void SDL_StopTextInput();
]]

