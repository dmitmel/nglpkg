--@> ng.doc.command({}, nil)
--@> DOC.target = "10-Examples-Simple"
ng.module(
	"ng.examples.shell"
)

dump = function (a, indent)
	indent = indent or ""
	if a == nil then
		print(indent .. "nil")
	elseif type(a) == "table" then
		print(indent .. "{")
		for k, v in pairs(a) do
			print(indent .. tostring(k) .. " =")
			dump(v, indent .. " ")
		end
		print(indent .. "}")
	elseif type(a) == "string" then
		print(indent .. "\"" .. a .. "\"")
	else
		print(indent .. tostring(a))
	end
end
while true do
	print("READY.")
	local text = io.read()
	local rf, dt = loadstring(text)
	if not rf then
		print(dt)
	else
		rf, dt = pcall(rf)
		if not rf then
			print(dt)
		else
			dump(dt)
		end
	end
end

