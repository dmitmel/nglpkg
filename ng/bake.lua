--@> DOC.target = "01-A-Bake"
--@> ng.doc.command({}, "modules")
--@: This program 'bakes' a program using the source code available in the current environment.
--@: It writes the result to standard output. (Windows users, please see [[ng.bake-file]].)
--@:
--@: The program to bake consists of the 'modules' list provided.
--@: It is sufficient to only write the module name of the program itself.
--@: However, if you want the resulting Lua script to be compressed, then you can add modules before your program's module to do that.
--@: Alternatively, if you have modules that 'register themselves' with the program, the baking list can add these into the baked program without an explicit dependency.
--@:
--@: Modules are put into the resulting program in dependency order if not explicitly specified, or, if explicitly specified, whichever comes first: dependency order or the explicit specification.
--@: Baking certain modules can alter the way the program is compressed, or define baking directives, such as ng.module.
--@: 
--@: A baking directive must always be used with a very specific format, at the start of a file.
--@: For example, ng.module usages look like this:
--@: ng.module(
--@:  "happiness"
--@:  "refuge.lightbulb"
--@: )
--@:
--@: In this case, it defines the module as being called "happiness", and requiring "refuge.lightbulb".
--@: Baking directives are always valid Lua.
--@: If this is being run 'live' (not baked), the relevant Lua function is called.
--@: 
require("ng.boot-bake")

ng.bakeBegin(io.write)
for _, v in ipairs(ng.args) do
	ng.bakeModule(v)
end
ng.bakeEnd()

