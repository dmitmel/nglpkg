--@: Allows the creation of worker threads through ancient magic.
--@: Use at your peril.
ng.module(
	"ng.lib.worker",
	"ng.wrap.ffi",
	"ng.wrap.sdl2.thread",
	"ng.wrap.luajit"
)

--@: ng.Worker(): Creates a new "worker" state. Note that this is NOT GC'd automatically!
--@:  It also does not have libs opened automatically, nor is it "launched" as a thread yet, so you can set things up as you want.
function ng.Worker()
	local worker = {
		state = ffi.C.luaL_newstate()
	}
	--@: worker:close(): Deletes the worker.
	function worker:close()
		ffi.C.lua_close(self.state)
	end
	--@: worker:openlibs(): Runs luaL_openlibs on the state. Necessary to use operations that need Worker-side FFI access (but not eval)
	function worker:openlibs()
		ffi.C.luaL_openlibs(self.state)
	end

	local function extractS(state, i)
		local temp = ffi.new("size_t[1]")
		local ptr = ffi.C.lua_tolstring(state, i, temp)
		if ptr then
			return ffi.string(ptr, temp[0])
		end
	end

	--@: worker:eval(code, ...): Runs some code in the worker, sending values if they are strings/numbers/nil. Returns the results if they are strings/numbers.
	function worker:eval(code, ...)
		local args = {...}
		ffi.C.lua_settop(self.state, 0)
		if ffi.C.luaL_loadstring(self.state, code) ~= 0 then
			local err = extractS(self.state, -1)
			ffi.C.lua_settop(self.state, 0)
			error("Worker eval parse error: " .. err)
		end
		-- Ok, function's on the stack, time for the args
		local argcount = 0
		for _, v in ipairs(args) do
			if v == nil then
				ffi.C.lua_pushnil(self.state)
			elseif type(v) == "string" then
				ffi.C.lua_pushlstring(self.state, v, #v)
			elseif type(v) == "number" then
				ffi.C.lua_pushnumber(self.state, v)
			else
				ffi.C.lua_settop(self.state, 0)
				error("Invalid data argument of type " .. type(v))
			end
			argcount = argcount + 1
		end
		-- Make the call
		if ffi.C.lua_pcall(self.state, argcount, -1, 0) ~= 0 then
			local err = extractS(self.state, -1)
			ffi.C.lua_settop(self.state, 0)
			error("Worker eval run error: " .. err)
		end
		local retvalsCount = ffi.C.lua_gettop(self.state)
		local retvals = {}
		-- Need to deliberately use the table.insert optimization abuse here to make this work 100% of the time
		for i = 1, retvalsCount do
			local val = nil
			if not ffi.C.lua_isnumber(self.state, i) then
				val = extractS(self.state, i)
			else
				val = ffi.C.lua_tonumber(self.state, i)
			end
			table.insert(retvals, val)
		end
		ffi.C.lua_settop(self.state, 0)
		return unpack(retvals)
	end

	--@: worker:extractValue(fntype, fnname): Extracts a C value (such as a closure). This is used in "shunting" workers into different threads via C closures.
	function worker:extractValue(fntype, fnname)
		local address = self:eval("local ffi = require(\"ffi\") local cbt = ffi.new(\"void*[1]\") cbt[0] = ffi.cast(\"" .. fntype .. "\", " .. fnname .. ") return ffi.string(cbt, ffi.sizeof(cbt))")
		if not address then error("There was an unexpected issue with the extractor and nothing was extracted") end
		return ffi.cast(fntype, ffi.cast("void**", address)[0])
	end
	--@: worker:injectValue(fntype, fnname, val): Injects a C value.
	function worker:injectValue(fntype, fnname, val)
		-- Create an injection assistant
		local array = ffi.new(fntype .. "[1]")
		array[0] = val
		-- Turn the value into a string
		local ptr = ffi.string(array, ffi.sizeof(fntype))
		-- Convert the value back worker-side
		self:eval("local ffi = require(\"ffi\") " .. fnname .. " = ffi.cast(\"" .. fntype .. "*\", ...)[0]", ptr)
	end

	--@: Threads
	--@: worker:launch(fnname, ptr, [name]): Launches a new thread using function reference fnname (passed pointer ptr, returns exit code number) with thread name in name.
	--@:  After this, do not use any functions on the worker apart from :wait() which waits for the thread to halt.
	function worker:launch(fnname, ptr, name)
		name = name or "NGWorker"
		local threadFn = self:extractValue("int (*)(void*)", fnname)
		-- So that returned the worker callback...
		state.thread = ng.sdl2.SDL_CreateThread(threadFn, name, ptr)
		if not state.thread then
			error("Failed to create thread.")
		end
	end
	--@: worker:wait(live): Waits for the thread to halt. If it doesn't, you're screwed. If live is not true, the worker is automatically closed. Returns the returned number from the thread.
	function worker:wait(live)
		local retVal = ffi.new("int[1]")
		ng.sdl2.SDL_WaitThread(self.thread, retVal)
		if not live then
			ffi.C.lua_close(self.state)
		end
		return retVal[0]
	end
	return worker
end
--@: ng.newWorkerThread(code, ptr, [name]): Shorthand to launch a worker thread with libs opened and given code (with parameter as "ptr")
function ng.newWorkerThread(code, ptr, name)
	local worker = ng.Worker()
	worker:openlibs()
	return worker:launch("function (ptr) " .. code .. " end", ptr, name)
end
