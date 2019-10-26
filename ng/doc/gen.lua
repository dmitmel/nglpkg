--@> DOC.target = "25-Tools"
--@> ng.doc.command({"project"})

ng.module(
	"ng.doc.gen",
	"ng.wrap.fs",
	"ng.resource"
)
ng.resource(
	"ng.doc.basefile",
	".fodg"
)

if #ng.args ~= 1 then
	--@> DOC.runPrefixes["print%("] = {"ng.doc.docPrint(", ""}
	print("I am the document generator!")
	print("Pass the directory name to generate a document for, and I'll output doc.fodg here.")
	print("I run arbitrary code from the files when it's prefixed with --@>")
	print("I output stuff as straight text when it's prefixed with --@:")
	print("This allows changing the markup to suit different situations in the document.")
	--@> DOC.runPrefixes["print%("] = nil
end

--@:
--@: The documentation generator defines two globals to aid in this...
--@:
--@> ng.doc.section("ng.doc: Across the whole file global")
--@> DOC.functions = "ng.doc."
ng.doc = {
--@: ng.doc.skeletons: Table mapping PROJECT names to the respective skeletons
	skeletons = {
	},
	docPrint = function (text)
		--@:  Writes into DOC.entry.TEXT
		local span = "T3"
		if DOC.entry[1] == "MODULE_INTERNAL" or DOC.entry[1] == "FUNCTION" then
			span = "T4"
		end
		for i = 1, #text do
			DOC.entry.TEXT = DOC.entry.TEXT .. "&#" .. string.byte(text, i) .. ";"
		end
		DOC.entry.TEXT = DOC.entry.TEXT .. "</text:span></text:p>\n<text:p text:style-name=\"P9\"><text:span text:style-name=\"" .. span .. "\">"
	end,
	section = function (name)
		--@:  Adds an additional page to the module for a section.
		DOC.entry = {"FUNCTION", ["MODULE"] = DOC.module.MODULE, ["TEXT"] = "", ["PROPERTY"] = name}
		table.insert(DOC.skeleton, DOC.entry)
	end,
	internal = function ()
		--@:  Marks the module as internal (makes it invisible)
		DOC.module[1] = "MODULE_INTERNAL"
		DOC.target = nil
	end,
	mixin = function ()
		--@:  Marks the module as a baking mixin
		DOC.module[1] = "MODULE_INTERNAL"
		DOC.target = "25-Baking-Mixins"
	end,
	command = function (parts, range)
		--@:  Marks the module as a command.
		--@:  parts: Table containing a list of names like: {"from", "to"}
		--@:  range: Optional string, indicates variable amount of arguments
		DOC.module[1] = "RUNNABLE"
		ng.doc.docPrint("Usage:")
		local built = " sdk " .. DOC.module.MODULE .. " "
		for k, v in ipairs(parts) do
			if k ~= 1 then
				built = built .. " "
			end
			built = built .. "<" .. v .. ">"
		end
		if range then
			built = built .. "<" .. range .. "...>"
		end
		ng.doc.docPrint(built)
		ng.doc.docPrint("")
	end,
	lineHandlerDefault = function (line)
		--@:  The default line handler (uses the various DOC entries)
		for pattern, result in pairs(DOC.runPrefixes) do
			local s, e = line:find("^[\t ]*" .. pattern)
			if s then
				(result[3] or function (n)
					loadstring(n)()
				end)(result[1] .. line:sub(e + 1) .. result[2])
				return
			end
		end
		if DOC.functions then
			local wsa, wsb = line:find("^[\t ]*")
			line = line:sub(wsb + 1)
			local match1a, match1b = line:find("^[^ ]*[ ]*=[ ]*function ")
			local match2a, match2b = line:find("^function ")
			if match1a then
				-- This bit gets kinda complicated
				ng.doc.docPrint("")
				ng.doc.docPrint(DOC.functions .. line:match("^[^ ]*") .. line:sub(match1b + 1))
			elseif match2a then
				ng.doc.docPrint("")
				ng.doc.docPrint(line:sub(match2b + 1))
			end
		end
		if DOC.echo then
			ng.doc.docPrint(line)
		end
	end
}
--@> DOC.functions = nil

do
	-- Parse templates
	local templates = {}
	local wTemplate = "BEGIN"
	for v in ng.resources["ng.doc.basefile"]:gmatch("[^\n]+") do
		local base = "   <draw:page draw:name=\"$$SLIDE_"
		if v:sub(1, #base) == base then
			local templateName = v:sub(#base + 1)
			-- Additional () strips the second return value
			local point = templateName:find("%$%$")
			local rest = templateName:sub(point)
			templateName = templateName:sub(1, point - 1)
			wTemplate = templateName
			-- print(wTemplate)
			v = base:sub(1, -7) .. "PAGE_NUMBER" .. rest
		end
		templates[wTemplate] = (templates[wTemplate] or "") .. v .. "\n"
		if v:find("</draw:page>") then
			wTemplate = "END"
		end
	end
	local project = ng.args[1]
	if ng.args[1] == "ng" then
		project = "NGLPKG"
	end
	-- Construct the skeleton
	local function processModule(fn)
		DOC = {
			--@> ng.doc.section("DOC: Per-document global")
			--@: DOC.skeleton: The skeleton for the current module, with DOC.module at the start. Gets imported later into the target.
			skeleton = {
			},
			--@: DOC.target: The target skeleton this is imported into.
			target = "50-Main",
			--@: DOC.runPrefixes: A table mapping Lua patterns (that get prefixed with "^[\t ]*") to tables of the form {prefix, suffix, function}
			--@:  The function (or a dostring equivalent if not provided) is passed the text without the real prefix, and with the prefix/suffix provided
			runPrefixes = {
				["--@>"] = {"", ""},
				["--@: ?"] = {"", "", ng.doc.docPrint}
			},
			--@: DOC.lineHandler: The function that incoming lines of text are run through. This is responsible for checking runPrefixes & echo.
			lineHandler = ng.doc.lineHandlerDefault,
			--@: DOC.module: The skeleton entry for the current module.
			--@:  Skeleton entries have index 1 (like a list) as the 'type', but other keys are attributes to find/replace in the source drawing.
			module = {"MODULE",
				["PROJECT"] = project,
				["MODULE"] = fn:sub(1, -5):gsub("/", "."),
				["TEXT"] = ""
			},
			--@: DOC.echo: Copy/paste incoming source code (use for cdefs)
			echo = false,
			--@: DOC.functions: Try to automatically grab function definitions.
			--@:  Has to be a string as it'll be used as a prefix when encountering the 'abc = function' pattern.
			functions = nil
		}
		--@: DOC.entry: The skeleton entry to print into
		DOC.entry = DOC.module
		table.insert(DOC.skeleton, DOC.module)
		local f = io.open(fn, "rb")
		for line in (f:read("*a") .. "\n"):gmatch("[^\n]*\n") do
			local lineP = line:sub(1, -2)
			if lineP:sub(-1) == "\r" then
				lineP = lineP:sub(1, -2)
			end
			DOC.lineHandler(lineP)
		end
		f:close()
		if DOC.target then
			if not ng.doc.skeletons[DOC.target] then
				ng.doc.skeletons[DOC.target] = {}
			end
			local target = ng.doc.skeletons[DOC.target]
			for _, v in ipairs(DOC.skeleton) do
				table.insert(target, v)
			end
		end
	end
	local function scanForModules(fn)
		if fn:sub(-4) == ".lua" then
			processModule(fn)
		end
		local lst = ng.fs.list(fn)
		if lst then
			table.sort(lst)
			for _, v in ipairs(lst) do
				scanForModules(fn .. "/" .. v)
			end
		end
	end
	scanForModules(ng.args[1])
	local skeleton = {{"BEGIN"}}
	if ng.args[1] == "ng" then
		table.insert(skeleton, {"TITLE"})
	end
	local skeletons = {}
	for k, _ in pairs(ng.doc.skeletons) do
		table.insert(skeletons, k)
	end
	table.sort(skeletons)
	for _, v in ipairs(skeletons) do
		for _, entry in ipairs(ng.doc.skeletons[v]) do
			table.insert(skeleton, entry)
		end
	end
	table.insert(skeleton, {"END"})
	-- Actually write the output
	local f = io.open("doc.fodg", "wb")
	for k, v in ipairs(skeleton) do
		v["PAGE_NUMBER"] = tostring(k - 2)
		local text = templates[v[1]]
		if not text then error("Template missing: " .. v[1]) end
		for k2, v2 in pairs(v) do
			if k2 ~= 1 then
				-- Templating...
				text = text:gsub("%$%$" .. k2 .. "%$%$", v2)
			end
		end
		f:write(text)
	end
	f:close()
	print("Done!")
end
