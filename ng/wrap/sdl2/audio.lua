ng.module(
	"ng.wrap.sdl2.audio",
	"ng.wrap.sdl2.base"
)

-- SDL_audio

-- This gets 'interesting'.
ng.sdl2Enums.SDL_AUDIO_MASK_BITSIZE = 0xFF
ng.sdl2Enums.SDL_AUDIO_MASK_DATATYPE = 0x100
ng.sdl2Enums.SDL_AUDIO_MASK_ENDIAN = 0x1000
ng.sdl2Enums.SDL_AUDIO_MASK_SIGNED = 0x8000

ng.sdl2Enums.AUDIO_U8 = 0x0008
ng.sdl2Enums.AUDIO_S8 = 0x8008
ng.sdl2Enums.AUDIO_U16LSB = 0x0010
ng.sdl2Enums.AUDIO_S16LSB = 0x8010
ng.sdl2Enums.AUDIO_U16MSB = 0x1010
ng.sdl2Enums.AUDIO_S16MSB = 0x9010
ng.sdl2Enums.AUDIO_S32LSB = 0x8020
ng.sdl2Enums.AUDIO_S32MSB = 0x9020
ng.sdl2Enums.AUDIO_F32LSB = 0x8120
ng.sdl2Enums.AUDIO_F32MSB = 0x9120

-- Interesting note here - SDL2 defines U16/S16 as defaulting to LSB byte order,
--  with the 'SYS' constants being system.
-- I'll just skip the useless ones.
if ffi.abi("le") then
	ng.sdl2Enums.AUDIO_U16SYS = ng.sdl2Enums.AUDIO_U16LSB
	ng.sdl2Enums.AUDIO_S16SYS = ng.sdl2Enums.AUDIO_S16LSB
	ng.sdl2Enums.AUDIO_S32SYS = ng.sdl2Enums.AUDIO_S32LSB
	ng.sdl2Enums.AUDIO_F32SYS = ng.sdl2Enums.AUDIO_F32LSB
else
	ng.sdl2Enums.AUDIO_U16SYS = ng.sdl2Enums.AUDIO_U16MSB
	ng.sdl2Enums.AUDIO_S16SYS = ng.sdl2Enums.AUDIO_S16MSB
	ng.sdl2Enums.AUDIO_S32SYS = ng.sdl2Enums.AUDIO_S32MSB
	ng.sdl2Enums.AUDIO_F32SYS = ng.sdl2Enums.AUDIO_F32MSB
end

ng.sdl2Enums.flags("SDL_AUDIO_ALLOW_", {"FREQUENCY_CHANGE", "FORMAT_CHANGE", "CHANNELS_CHANGE"})
ng.sdl2Enums.SDL_AUDIO_ALLOW_ANY_CHANGE = 0x07

ffi.cdef[[
	typedef void (* SDL_AudioCallback) (void *, uint8_t *, int);
	typedef struct {
		int rate;
		uint16_t format;
		uint8_t channels;
		uint8_t cSilence;
		uint16_t cBufferFrames;
		uint16_t cPadding;
		uint32_t cBufferBytes;
		SDL_AudioCallback callback;
		void * userdata;
	} SDL_AudioSpec;
	int SDL_OpenAudio(SDL_AudioSpec *, SDL_AudioSpec *);
	int SDL_QueueAudio(uint32_t, void *, uint32_t);
	uint32_t SDL_GetQueuedAudioSize(uint32_t);
	void SDL_PauseAudio(int);
	void SDL_CloseAudio();
]]

