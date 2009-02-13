<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(noCase) {
    $noCase = len(noCase);
    return this;
  }
  
  function setArguments() {
    if (arrayLen(arguments) != 1) throw("Application", "The Match matcher expected 1 argument, got #arrayLen(arguments)#.");
    $expected = arguments[1];
    if (not isSimpleValue($expected)) throw("Application", "The EXPECTED parameter to the Match matcher must be a simple value.");
  }

  function isMatch(actual) {
    $actual = actual;
    if (not isSimpleValue($actual)) throw("cfspec.fail", "Match expected a simple value, got #inspect($actual)#");
    if ($noCase) {
      return reFindNoCase($expected, $actual) > 0;
    } else {
      return reFind($expected, $actual) > 0;
    }
  }

  function getFailureMessage() {
    return "expected to match #inspect($expected)#, got #inspect($actual)#";
  }

  function getNegativeFailureMessage() {
    return "expected not to match #inspect($expected)#, got #inspect($actual)#";
  }

  function getDescription() {
    return "match #inspect($expected)#";
  }

</cfscript></cfcomponent>