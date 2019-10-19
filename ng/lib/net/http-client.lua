--@: It's an HTTP client!
--@: So you can download things.
--@: Doesn't support HTTPS. Maybe another time.
--@: API arguably non-final.
ng.module(
	"ng.lib.net.http-client",
	"ng.wrap.luasocket-core",
	"ng.lib.util.polling-station"
)

-- NOTE: I've read the RFC on stuff I was uncertain on, but I haven't done a full search.
-- So there might be unsupported stuff here.

-- Options:
-- host (required)
-- path (required)
-- port (defaults to 80)
-- method (defaults to GET)
-- noaddhost (optional)
-- headers (
--  defaults to {}
--  but will automatically have stuff added even if provided
--  specifically, "Host", and if relevant "Content-Length"
-- )
-- content (defaults to not sending any)
-- progress (optional, function (info, progress))
--  NOTE: progress("Done", 1) may not be sent
-- data (required, function (data))
--  note: this delivers a *chunk* of data, not necessarily the whole thing!
-- success (required, function (primary, headers, body))
-- failure (required, function (details))
ng.httpClient = function (options)
	-- Add defaults
	options.port = options.port or 80
	options.method = options.method or "GET"
	options.headers = options.headers or {}
	options.progress = options.progress or function (info, progress) end
	-- Add headers
	if not options.noaddhost then
		options.headers["Host"] = options.headers["Host"] or options.host
	end
	if options.content then
		options.headers["Content-Length"] = #options.content
	end
	-- Compile request
	local request
	do
		local lines = {
			options.method .. " " .. options.path .. " HTTP/1.1"
		}
		for k, v in pairs(options.headers) do
			-- RFC 2616, 4.2 Message Headers, Paragraph 1
			-- & RFC 822, 3.1.1 LONG HEADER FIELDS
			-- NOTE: If I am interpreting these correctly, \r & \n isn't allowed.
			-- Usage of it is thus banned.
			table.insert(lines, k .. ": " .. v)
		end
		request = table.concat(lines, "\r\n") .. "\r\n\r\n"
		if options.content then
			request = request .. options.content
		end
	end
	-- Begin
	local coro
	local function poll()
		local aok, err = coroutine.resume(coro)
		if not aok then
			options.failure(err)
		end
		if coroutine.status(coro) == "dead" then
			ng.polls[poll] = nil
		end
	end
	coro = coroutine.create(function ()
		options.progress("Looking up...", 0)
		-- DNS Lookup
		local ai, err = socket.dns.getaddrinfo(options.host)
		if not ai then error(err) end
		-- Connecting
		local tcp
		for _, v in ipairs(ai) do
			-- This bit isn't really as async as I'd like.
			-- There's a yield, which both splits lookup from connecting,
			--  and the different connection attempts from each other.
			options.progress("Attempting connection to " .. options.host .. " via " .. v.addr .. " (" .. v.family .. ")", 0)
			coroutine.yield()
			tcp, err = socket.connect(v.addr, options.port, nil, nil, v.family)
			if tcp then break end
		end
		if not tcp then error(err) end
		-- Successfully connected.
		-- Switch to almost non-blocking, but allow juuust a bit of slack for efficiency & safety.
		tcp:settimeout(0)
		local olen = #request
		while #request > 0 do
			options.progress("Sending request (" .. (olen - #request) .. " / " .. olen .. " bytes)", 0)
			coroutine.yield()
			local bytes, bytes2
			bytes, err, bytes2 = tcp:send(request)
			if not bytes and err ~= "timeout" then
				-- Error
				tcp:close()
				error(err)
			elseif not bytes then
				-- Timeout
				bytes = bytes2
			end
			-- Get rid of all sent bytes
			request = request:sub(bytes + 1)
		end
		-- Receive response headers
		local function lws(ch)
			-- RFC 2616, 2.2 Basic Rules
			return ch == " " or ch == "\t"
		end
		-- Implements field-content trimming as described in RFC 2616, 4.2 Message Headers,
		--  Paragraph 2
		local function trim(str)
			return str:gsub("^[ \t]*", ""):gsub("[ \t]*$", "")
		end
		-- Response line buffer
		local responsePrimary = nil
		local responseHeaders = {}
		-- Local state for response header reception
		local response = ""
		local responseLastKey = nil
		options.progress("Receiving response", 0)
		while true do
			local block, block2
			block, err, block2 = tcp:receive(0x10000)
			if err then
				response = response .. block2
			else
				response = response .. block
			end
			local targ = response:find("\r\n")
			if targ then
				local line = response:sub(1, targ - 1)
				response = response:sub(targ + 2)
				if not responsePrimary then
					-- RFC 2616, 4.1 Message Types (Paragraph 3)
					--  describes this "ignore leading empty lines" part.
					if line ~= "" then
						responsePrimary = line
					end
				elseif line == "" then
					-- Body
					break
				elseif responseLastKey and lws(line:sub(1, 1)) then
					-- RFC 2616, 4.2 Message Headers (Paragraph 1) again...
					-- The whitespace is included to prevent value merging.
					responseHeaders[responseLastKey] = responseHeaders[responseLastKey] .. line
				else
					-- RFC 2616, 4.2 Message Headers (Paragraph 1)
					targ = line:find(":")
					if targ then
						-- This key trimming *may* or *may not* be compliant.
						-- Consider this to be following the 'generous in what you accept' rule.
						local key = trim(line:sub(1, targ - 1)):lower()
						local value = trim(line:sub(targ + 1))
						-- Paragraph 4 states some very specific behavior regarding if multiple headers with the same name are present.
						-- Transform accordingly.
						if responseHeaders[key] then
							responseHeaders[key] = responseHeaders[key] .. "," .. value
						else
							responseHeaders[key] = value
						end
						responseLastKey = key
					end
				end
			end
			if err and err ~= "timeout" then
				tcp:close()
				error(err)
			elseif err == "timeout" then
				coroutine.yield()
			end
		end
		-- Receive response body
		-- Initial part from previous stage
		local lastResponseDone = nil
		local responseDone = #response
		options.data(response)
		response = nil
		local responseLength = tonumber(responseHeaders["content-length"])
		while true do
			local block, block2
			block, err, block2 = tcp:receive(0x10000)
			if err then
				block = block2
			end
			if block ~= "" then
				options.data(block)
				responseDone = responseDone + #block
			end
			-- Update progress / check for quit
			if lastResponseDone ~= responseDone then
				lastResponseDone = responseDone
				if not responseLength then
					-- Assuming 128MB, this will just quietly use up time
					local fakeProgress = 1 - (1 / (1 + (responseDone / 0x8000000)))
					options.progress("Receiving file (" .. responseDone .. " bytes)", fakeProgress)
				else
					if responseDone >= responseLength then
						break
					end
					-- Check-for-end condition implies responseLength != 0
					options.progress("Receiving file (" .. responseDone .. " / " .. responseLength .. " bytes)", responseDone / responseLength)
				end
			end
			-- If an error occurred, determine exit strategy.
			-- It's possible an old server might not have sent a Content-Length.
			if err and err ~= "timeout" then
				if not responseLength then
					-- This is technically valid IIRC
					break
				end
				-- Note that the 'full response' condition was checked in the previous condition
				tcp:close()
				error(err)
			elseif err == "timeout" then
				coroutine.yield()
			end
		end
		tcp:close()
		options.success(responsePrimary, responseHeaders)
	end)
	ng.polls[poll] = true
end
