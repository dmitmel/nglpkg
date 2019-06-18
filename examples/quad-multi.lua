ng.module(
	"examples.quad-multi",
	"examples.quad"
)

-- Extends quad to add multiple windows.

-- Extends the previous example, quad, to add text.

do
	local oldQAC = QuadAppClass
	function QuadAppClass()
		local app = oldQAC()
		function app:start()
			self.mainWins = {
				self:createWindow(),
				self:createWindow()
			}
		end
		function app:frame()
			for _, v in ipairs(self.mainWins) do
				ng.app2d.windowFrame(v, function ()
					self:drawWindow(v)
				end)
			end
		end
		return app
	end
end
