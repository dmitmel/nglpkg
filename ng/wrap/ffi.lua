ng.module(
	"ng.wrap.ffi"
)

--@: This module just exists to make sure that if the FFI is being used, this line exists.
--@: It performs size reduction by making "local ffi =" unnecessary.
--@:
--@> DOC.echo = true
ffi = require("ffi")

