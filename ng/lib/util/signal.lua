--@: Implements a more 'styled' event mechanism on cblists
--@:
ng.module(
	"ng.lib.util.signal",
	"ng.lib.util.cblists",
	"ng.lib.util.table"
)
--@: ng.Signal(backwards): Creates a Signal object.
--@:  signal:connect(fn): Connects a signal handler. Returns a SignalConnection.
--@:  signal:fire(...): Fires the signal, passing the arguments to the handlers.
--@:
--@: SignalConnection:
--@:  connection.connected: True if the connection is connected. False otherwise.
--@:  connection:disconnect(): Disconnects the connection.
ng.Signal = function (backwards)
	local signal = {}
	signal._connected = {}
	function signal:connect(fn)
		local connection = {}
		connection._signal = self
		connection._fn = fn
		connection.connected = true
		table.insert(self._connected, connection)
		function connection:disconnect()
			if self.connected then
				table.remove(self._signal._connected, table.indexOf(self._signal._connected, self._fn))
				self.connected = false
			end
		end
		return connection
	end
	-- Try to make it look like a tail-call for TCO
	if self.backwards then
		function signal:fire(...)
			return ng.runBackwards(self._connected, ...)
		end
	else
		function signal:fire(...)
			return ng.runForwards(self._connected, ...)
		end
	end
	return signal
end

