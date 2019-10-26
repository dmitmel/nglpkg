class Haxe {
	public static function main() {
		// Gets turned into a valid baking directive through magical horrors. Don't ask.
		nglpkg.Module.require("ng.wrap.zlib");

		Sys.println("hello world");
		var test = "😂";
		Sys.println(test + " has a length of " + test.length);
	}
}
