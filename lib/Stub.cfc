<cfcomponent output="false"><cfscript>

  function init() {
  	$methods = structCopy(arguments);
    return this;
  }

  function onMissingMethod(missingMethodName, missingMethodArguments) {
  	if (structKeyExists($methods, missingMethodName)) return $methods[missingMethodName];
  	return createObject("component", "Stub").init();
  }

</cfscript></cfcomponent>