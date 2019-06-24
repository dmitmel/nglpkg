ng.module(
	"examples.http",
	"ng.lib.net.http-client",
	"ng.lib.util.polling-station"
)

do
	local on = true
	local allData = ""
	ng.httpClient({
		host = "20kdc.duckdns.org",
		path = "/neo/nglpkg-test-file",
		progress = function (str, pr)
			print(string.format("%02i%% %s", math.ceil(pr * 100), str))
		end,
		data = function (chunk)
			allData = allData .. chunk
		end,
		success = function (ab, hdr)
			print("-- SUCCESS --")
			print(ab)
			for k, v in pairs(hdr) do
				print("HEADER:", k, v)
			end
			print("DATA:")
			print(allData)
			on = false
		end,
		failure = function (...)
			print(...)
			on = false
		end,
	})
	while on do
		ng.poll()
	end
end
