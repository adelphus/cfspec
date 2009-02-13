<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function setArguments() {
    if (arrayLen(arguments) != 2) throw("Application", "The BeCloseTo matcher expected 2 arguments, got #arrayLen(arguments)#.");
    $expected = arguments[1];
    if (not isNumeric($expected)) throw("Application", "The EXPECTED parameter to the BeCloseTo matcher must be numeric.");
    $delta = arguments[2];
    if (not isNumeric($delta)) throw("Application", "The DELTA parameter to the BeCloseTo matcher must be numeric.");
  }

  function isMatch(actual) {
    $actual = actual;
    if (not isNumeric($actual)) throw("cfspec.fail", "BeCloseTo expected a number, got #inspect($actual)#");
    return abs($actual - $expected) < $delta;
  }

  function getFailureMessage() {
    return "expected #inspect($expected)# +/- (< #inspect($delta)#), got #inspect($actual)#";
  }

  function getNegativeFailureMessage() {
    return "expected #inspect($expected)# +/- (>= #inspect($delta)#), got #inspect($actual)#";
  }

  function getDescription() {
    return "be close to #inspect($expected)# (within +/- #inspect($delta)#)";
  }

</cfscript></cfcomponent>