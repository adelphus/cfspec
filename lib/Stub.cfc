<cfcomponent output="false"><cfscript>

  __cfspecMethods = structNew();

  function __cfspecInit() {
    __cfspecMethods = structCopy(arguments);
    return this;
  }

  function onMissingMethod(missingMethodName, missingMethodArguments) {
    if (structKeyExists(__cfspecMethods, missingMethodName)) return __cfspecMethods[missingMethodName];
    if (not structKeyExists(__cfspecMethods, "stubMissingMethod") or __cfspecMethods.stubMissingMethod) {
      return createObject("component", "Stub");
    } else {
      createObject("component", "cfspec.lib.Base").throw("Application", "The method #missingMethodName# was not found.");
    }
  }

</cfscript></cfcomponent>