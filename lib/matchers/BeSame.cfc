<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init() {
    if (arrayLen(arguments) != 1) throw("Application", "The BeSame matcher expected 1 argument, got #arrayLen(arguments)#.");
    $expected = arguments[1];
    return this;
  }

  function isMatch(actual) {
    var system = createObject("java", "java.lang.System");
    return system.identityHashCode(actual) == system.identityHashCode($expected);
  }

  function getFailureMessage() {
    return "expected to be the same, got different (native arrays are always different)";
  }

  function getNegativeFailureMessage() {
    return "expected not to be different, got the same (equivalent simple values are usually the same)";
  }

  function getDescription() {
    return "be the same";
  }

</cfscript></cfcomponent>