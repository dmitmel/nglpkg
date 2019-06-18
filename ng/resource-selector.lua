return function(modules)
	if ng.bakeModules == modules then
		return "ng.resource.compiled"
	else
		return "ng.resource.runtime"
	end
end
