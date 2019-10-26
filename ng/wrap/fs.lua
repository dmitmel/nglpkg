ng.module(
	"ng.wrap.fs",
	"ng.lib.encoding.utf16",
	"ng.wrap.fs.the-windows-contingency",
	"ng.wrap.ffi"
)

ng.fs = {}

--@: ng.fs = {}

pcall(require, "ng-fs-override")

--@: dirname(n) -> string (dir), string (name), root (boolean)
function ng.fs.dirname(n)
	-- 'root' case
	if n:sub(2) == ":" or n:sub(2) == ":/" or n:sub(2) == ":\\" or n == "/" then return n, n, true end
	--@: This tries to be more or less equivalent to the Unix "dirname"/"basename" pair, which eliminates trailing "/"
	--@: However, unlike that, this supports backslash as separator.
	n = n:reverse()
	local whereA, whereB = n:find(".[\\/]+")
	local base
	if whereB then
		base = n:sub(1, whereA):reverse()
		n = n:sub(whereB + 1)
	else
		return ".", n:reverse()
	end
	return n:reverse(), base
end

--@:
--@: list(n) -> ({name...}) | (nil, error)
--@: mkdir(n) -> true/false
--@: rmdir(n) -> true/false
--@: unlink(n) -> true/false
--@: info(n) -> "directory"/"file"/nil

if (not ng.fs.list) and ffi.os == "Windows" then
	local function xtend(a)
		local b, c = ""
		while a ~= "" do
			c, a = ng.encoding["UTF-8"]:nextChar(a)
			b = b .. ng.encoding["UTF-16LE"]:makeChar(c)
		end
		return b .. "\x00\x00"
	end
	ffi.cdef[[
		typedef struct {
			uint32_t low, high;
		} FILETIME;
		typedef struct {
			uint32_t attrs;
			FILETIME creation, lastAccess, lastWrite;
			uint32_t sizeHigh, sizeLow, rv0, rv1;
			uint16_t fileName[0x104];
			uint16_t altName[14];
			uint32_t fileType, creatorTime;
			uint16_t finderFlags;
		} WIN32_FIND_DATA;
		void * __stdcall FindFirstFileW(uint16_t *, WIN32_FIND_DATA *);
		int __stdcall FindNextFileW(void *, WIN32_FIND_DATA *);
		int __stdcall FindClose(void *);
		uint32_t GetLastError();

		int __stdcall CreateDirectoryW(uint16_t *, void *);
		int __stdcall RemoveDirectoryW(uint16_t *);
		int __stdcall DeleteFileW(uint16_t *);

		int __stdcall GetFileAttributesW(uint16_t *);
	]]
	ng.fs.list = function (n)
		if n:find("[?*]") then
			-- Prevent accidental screwups
			return nil, "invalid characters"
		end
		local ax = xtend(n .. "\\*")
		local ns = ffi.new("WIN32_FIND_DATA")
		local hnd = ffi.C.FindFirstFileW(ffi.cast("void *", ax), ns)
		local lst = {}
		if hnd == nil then
			if ffi.C.GetLastError() == 0x80070002 then
				return lst
			end
			return nil, "system error"
		end
		while true do
			local ws = ""
			local ws2 = ffi.string(ns.fileName, 0x208)
			local idx = 0
			while true do
				local ch
				ch, ws2 = ng.encoding["UTF-16LE"]:nextChar(ws2)
				if ch == 0 then break end
				ws = ws .. ng.encoding["UTF-8"]:makeChar(ch)
			end
			if ws ~= ".." and ws ~= "." then
				table.insert(lst, ws)
			end
			if ffi.C.FindNextFileW(hnd, ns) == 0 then
				break
			end
		end
		ffi.C.FindClose(hnd)
		return lst
	end
	ng.fs.mkdir = function (n)
		n = xtend(n)
		return ffi.C.CreateDirectoryW(ffi.cast("void *", n), nil) ~= 0
	end
	ng.fs.rmdir = function (n)
		n = xtend(n)
		return ffi.C.RemoveDirectoryW(ffi.cast("void *", n)) ~= 0
	end
	ng.fs.unlink = function (n)
		n = xtend(n)
		return ffi.C.DeleteFileW(ffi.cast("void *", n)) ~= 0
	end
	ng.fs.info = function (n)
		n = xtend(n)
		local v = ffi.C.GetFileAttributesW(ffi.cast("void *", n))
		if v == -1 then
			return nil
		end
		if (math.floor(v / 0x10) % 2) == 1 then
			return "directory"
		end
		return "file"
	end
elseif (not ng.fs.list) then
	-- The assumption on all of these is that you're using UTF-8.
	-- This is the standard nowadays.
	-- Use different structures for the BSDs. This is untested code,
	--  but I tried.
	-- My hope here is that the BSD lineage won't deliberately break binary compat.,
	--  thus by definition they have to all share the same basic system calls. 
	-- A particular note is that the BSDs, Darwin, and Linux, all share the same
	--  first 7 fields of stat. device, inode, mode, links, uid, gid, rdev.
	local config = {
		cdef = {
			opendir = "void * opendir(const char *)",
			readdir = "kacol_dirent * readdir(void *)",
			closedir = "int closedir(void *)",
			mkdir = "int mkdir(const char *, int)",
			rmdir = "int rmdir(const char *)",
			unlink = "int unlink(const char *)",
			stat = "int stat(const char *, kacol_stat *)"
		},
		get_opendir = function () return ffi.C.opendir end,
		get_readdir = function () return ffi.C.readdir end,
		get_closedir = function () return ffi.C.closedir end,
		get_mkdir = function () return ffi.C.mkdir end,
		get_rmdir = function () return ffi.C.rmdir end,
		get_unlink = function () return ffi.C.unlink end,
		get_stat = function () return ffi.C.stat end,
		stat_size = 0x400,
		stat_st_mode_size = 2,
		dirmod = 0x10,
		dirdiv = 0x1000,
		dirval = 4
	}
	local padsa, padsb, padda

	if ffi.os == "Linux" and (ffi.arch == "x86" or ffi.arch == "x64") then
		-- glibc's fault - there's no other way to access this.
		config.cdef.stat = "int __xstat(int, const char *, kacol_stat *)"
		local statxv
		if ffi.arch == "x86" then
			config.stat_st_mode_ofs = 0x10
			config.dirent_d_name_ofs = 11
			statxv = 3
		else
			config.stat_st_mode_ofs = 0x18
			config.dirent_d_name_ofs = 19
			statxv = 0
		end
		config.get_stat = function ()
			local stat = ffi.C.__xstat
			return function (n, ws)
				return stat(statxv, n, ws)
			end
		end
	elseif ffi.os == "OSX" and ffi.arch == "x64" then
		-- Thanks to Fridtjof for providing the information.
		-- Additional notes: stat_st_mode_size = 2, dirent_d_name_size = 1024
		config.stat_st_mode_ofs = 4
		config.dirent_d_name_ofs = 21
		config.cdef.opendir = config.cdef.opendir .. " __asm__(\"opendir$INODE64\")"
		config.cdef.readdir = config.cdef.readdir .. " __asm__(\"readdir$INODE64\")"
		config.cdef.stat = config.cdef.stat .. " __asm__(\"stat$INODE64\")"
	else
		-- No way to continue!
		error("Unable to recognize system type. Provide replacement FS module as ng-fs-override")
	end
	-- Config modification ends here!
	local cdefs = ""
	for _, v in pairs(config.cdef) do
		cdefs = cdefs .. v .. ";"
	end

	local statpad2 = config.stat_size - (config.stat_st_mode_ofs + config.stat_st_mode_size)
	ffi.cdef(
		"typedef struct { uint8_t BLAH1[" .. config.stat_st_mode_ofs .. "]; uint" .. (config.stat_st_mode_size * 8) .. "_t mode; uint8_t BLAH2[" .. statpad2 .. "]; } kacol_stat;" ..
		"typedef struct { uint8_t BLAH[" .. config.dirent_d_name_ofs .. "]; char name[0];} kacol_dirent;" ..
	cdefs)

	local opendir, readdir, closedir, mkdir, rmdir, unlink, stat =
		config.get_opendir(), config.get_readdir(), config.get_closedir(), config.get_mkdir(), config.get_rmdir(), config.get_unlink(), config.get_stat()
	local dirdiv, dirmod, dirval = config.dirdiv, config.dirmod, config.dirval

	ng.fs.list = function (dir)
		local dc = opendir(dir)
		if dc == nil then
			return nil, "system error"
		end
		local ents = {}
		while true do
			local tmp = readdir(dc)
			-- FFI quirk: can't just "if not tmp then"
			if tmp == nil then break end
			local name = ffi.string(tmp.name)
			if name ~= ".." and name ~= "." then
				table.insert(ents, ffi.string(name))
			end
		end
		closedir(dc)
		return ents
	end
	ng.fs.mkdir = function (n)
		return mkdir(n, 0x1FF) == 0
	end
	ng.fs.rmdir = function (n)
		return rmdir(n) == 0
	end
	ng.fs.unlink = function (n)
		return unlink(n) == 0
	end
	ng.fs.info = function (n)
		local ws = ffi.new("kacol_stat")
		if stat(n, ws) == 0 then
			if (math.floor(ws.mode / dirdiv) % dirmod) == dirval then
				return "directory"
			else
				return "file"
			end
		end
		return nil
	end
end
