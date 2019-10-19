--@> ng.doc.command({}, nil)
--@> DOC.target = "15-Examples-Complex"
ng.module(
	"ng.examples.quad-text",
	"ng.examples.quad",
	"ng.lib.app2d.text"
)

-- Extends the previous example, quad, to add text.

do
	local oldQAC = QuadAppClass
	function QuadAppClass()
		local app = oldQAC()
		local oldDW = app.drawWindow
		function app:drawWindow(w)
			oldDW(self, w)
			ng.app2d.text(0, 0, 32, "£111", {1, 1, 1, 1})
			ng.app2d.text(32, w.height / 2, 16, "Hello @ " .. os.time() .. " from " .. tostring(w) .. "\n" .. [[
£111 
	boop!
the quick brown fox jumped over the lazy dog
THE QUICK BROWN FOX JUMPED OVER THE LAZY DOG
GOD YZAL EHT REVO DEPMUJ XOF NWORB KCIUQ EHT
god yzal eht revo depmuj xof nworb kciuq eht]], {1, 1, 1, 1})
		end
		return app
	end
end
