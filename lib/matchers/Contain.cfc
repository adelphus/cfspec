<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(noCase) {
    $noCase = len(noCase);
    if (arrayLen(arguments) != 2) throw("Application", "The Contain matcher expected 1 argument, got #arrayLen(arguments)-1#.");
    $expected = arguments[2];
    if (not isSimpleValue($expected)) throw("Application", "The EXPECTED parameter to the Contain matcher must be a simple value.");
    return this;
  }

  function isMatch(actual) {
    $actual = actual;
  	if (not isSimpleValue($actual)) throw("cfspec.fail", "Contain expected a simple value, got #inspect($actual)#");
    if ($noCase) {
      return reFindNoCase($expected, actual) > 0;
    } else {
      return reFind($expected, actual) > 0;
    }
  }

  function getFailureMessage() {
    return "expected to contain #inspect($expected)#, got #inspect($actual)#";
  }

  function getNegativeFailureMessage() {
    return "expected not to contain #inspect($expected)#, got #inspect($actual)#";
  }

  function getDescription() {
    return "contain #inspect($expected)#";
  }

</cfscript></cfcomponent>