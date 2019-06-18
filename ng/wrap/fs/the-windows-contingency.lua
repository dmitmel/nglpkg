ng.module(
	"ng.wrap.fs.the-windows-contingency",
	"ng.lib.encoding.utf16",
	"ng.lib.encoding.utf8",
	"ng.wrap.ffi"
)

-- Oh dear goodness.

if ffi.os == "Windows" then
	local function xtend(a)
		local b, c = ""
		while a ~= "" do
			c, a = ng.encoding["UTF-8"]:nextChar(a)
			b = b .. ng.encoding["UTF-16LE"]:makeChar(c)
		end
		return b .. "\x00\x00"
	end
	ffi.cdef[[
		void * _wfopen(uint16_t * fileName, uint16_t * mode);
		typedef void * (*fopenimpl)(const char * file, const char * mode);
		void * __stdcall GetModuleHandleA(const char * victim);
		int __stdcall VirtualProtect(void * lpAddr, size_t dwSize, uint32_t newProtect, uint32_t * oldProtect);
		int __stdcall SetConsoleCP(unsigned int id);
		int __stdcall SetConsoleOutputCP(unsigned int id);
	]]
	ffi.C.SetConsoleCP(65001)
	ffi.C.SetConsoleOutputCP(65001)
	-- Ok, so firstly let's see how to fix fopen.
	-- Step 1: Let's play SPOT THE VICTIM.
	-- There it is!
	local foa = ffi.cast("intptr_t", ffi.C.GetModuleHandleA("lua51"))
	if ffi.arch == "x86" then
		-- 66f80000
		-- 66fe72f8
		foa = foa + 0x672F8
	elseif ffi.arch == "x64" then
		-- 66d80000
		-- 66def64c
		foa = foa + 0x6F64C
	else
		foa = nil
	end
	if foa and jit.version == "LuaJIT 2.1.0-beta2" then
		foa = ffi.cast("fopenimpl *", foa)
		ffi.C.VirtualProtect(foa, ffi.sizeof("fopenimpl"), 0x40, nil)
		-- Implicit conversion locks resources, but it'd be worse if we *didn't*!
		foa[0] = function (a, b)
			local ax, bx = xtend(ffi.string(a)), xtend(ffi.string(b))
			return ffi.C._wfopen(ffi.cast("void *", ax), ffi.cast("void *", bx))
		end
	else
		io.stderr:write("Unable to correct for Windows not supporting UTF-8 in standard C functions.\n")
	end
end

