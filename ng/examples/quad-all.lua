--@> ng.doc.command({}, nil)
--@> DOC.target = "15-Examples-Complex"
-- This uses the module system to compose the other quad changes
ng.module(
	"ng.examples.quad-all",
	"ng.examples.quad-text",
	"ng.examples.quad-multi",
	"ng.examples.quad-mouse"
)
