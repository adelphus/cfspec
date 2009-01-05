<cfcomponent output="false"><cfscript>

  function init() {
  	$methods = structCopy(arguments);
    return this;
  }

  function onMissingMethod(missingMethodName, missingMethodArguments) {
  	if (structKeyExists($methods, missingMethodName)) return $methods[missingMethodName];
  	if (not structKeyExists($methods, "stubMissingMethod") or $methods.stubMissingMethod) {
    	return createObject("component", "Stub").init();
  	} else {
    	createObject("component", "cfspec.lib.Matcher").throw("Application", "The method #missingMethodName# was not found.");
  	}
  }

</cfscript></cfcomponent>