--@> ng.doc.internal()
return function(modules)
	if ng.bakeModules == modules then
		return "ng.atexit.compiled"
	else
		return "ng.atexit.runtime"
	end
end
