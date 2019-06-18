ng.module(
	"ng.wrap.zlib",
	"ng.wrap.ffi"
)

ng.zlib = ffi.load("z")
-- Just includes the more complicated ones, let's not get over-excited
ng.zlibEnums = {
	Z_NO_FLUSH = 0,
	Z_PARTIAL_FLUSH = 1,
	Z_SYNC_FLUSH = 2,
	Z_FULL_FLUSH = 3,
	Z_FINISH = 4,
	Z_BLOCK = 5,
	Z_TREES = 6,

	Z_FILTERED = 1,
	Z_HUFFMAN_ONLY = 2,
	Z_RLE = 3,
	Z_FIXED = 4,
	Z_DEFAULT_STRATEGY = 0,

	Z_OK = 0,
	Z_STREAM_END = 1,
	Z_NEED_DICT = 2,
	Z_ERRNO = -1,
	Z_STREAM_ERROR = -2,
	Z_DATA_ERROR = -3,
	Z_MEM_ERROR = -4,
	Z_BUF_ERROR = -5,
	Z_VERSION_ERROR = -6
}

-- Lots of non-essential stuff here is stripped out, because this is one big library
ffi.cdef[[
	typedef struct {
		const uint8_t * inputStream;
		unsigned int inputStreamAvailable;
		unsigned long inputStreamCounter;

		const uint8_t * outputStream;
		unsigned int outputStreamAvailable;
		unsigned long outputStreamCounter;

		const char * msg;
		void * internalState;

		void * zalloc;
		void * zfree;
		void * zopaque;

		int dataType;

		unsigned long adler;
		unsigned long reserved;
	} z_stream;

	int deflateInit2_(z_stream *, int, int, int, int, int, const char *, int);
	unsigned long deflateBound(z_stream *, unsigned long);
	int deflate(z_stream *, int);
	int deflateEnd(z_stream *);

	int inflateInit2_(z_stream *, int, const char *, int);
	int inflate(z_stream *, int);
	int inflateEnd(z_stream *);
]]

ng.zlibVersion = "1.2.11"
ng.zlibStreamSize = ffi.sizeof("z_stream")

