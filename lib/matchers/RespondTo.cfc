<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function setArguments() {
    if (arrayLen(arguments) != 1) throw("Application", "The RespondTo matcher expected 1 argument, got #arrayLen(arguments)#.");
    $methodName = arguments[1];
    if (not isSimpleValue($methodName)) throw("Application", "The METHODNAME parameter to the RespondTo matcher must be a simple value.");
  }

  function isMatch(actual) {
    if (not isObject(actual)) throw("cfspec.fail", "RespondTo expected an object, got #inspect(actual)#");
    return hasMethod(actual, $methodName);
  }

  function getFailureMessage() {
    return "expected to respond to #inspect($methodName)#, but the method was not found";
  }

  function getNegativeFailureMessage() {
    return "expected not to respond to #inspect($methodName)#, but the method was found";
  }

  function getDescription() {
    return "respond to #inspect($methodName)#";
  }

</cfscript></cfcomponent>