package nglpkg;
class Module {
	public static inline function require(x: String) {
		untyped __lua__("--IMPORT");
		untyped __lua__(x);
	}
}
