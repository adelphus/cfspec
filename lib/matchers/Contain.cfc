<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(noCase, expected) {
    $noCase = len(noCase);
    $expected = expected;
    return this;
  }

  function isMatch(actual) {
    $actual = actual;
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