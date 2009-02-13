<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(comparison) {
    $comparison = comparison;
    return this;
  }
  
  function setArguments() {
    if (arrayLen(arguments) != 1) throw("Application", "The Be#$comparison# matcher expected 1 argument, got #arrayLen(arguments)#.");
    $expected = arguments[1];
    if (not isNumeric($expected)) throw("Application", "The EXPECTED parameter to the Be#$comparison# matcher must be numeric.");
  }

  function isMatch(actual) {
    $actual = actual;
    if (not isNumeric($actual)) throw("cfspec.fail", "Be#$comparison# expected a number, got #inspect($actual)#");
    switch ($comparison) {
      case "LessThan":             return $actual < $expected;
      case "LessThanOrEqualTo":    return $actual <= $expected;
      case "GreaterThanOrEqualTo": return $actual >= $expected;
      case "GreaterThan":          return $actual > $expected;
      default:                     return false;
    }
  }

  function getFailureMessage() {
    return "expected to be #comparisonOperator()# #inspect($expected)#, got #inspect($actual)#";
  }

  function getNegativeFailureMessage() {
    return "expected not to be #comparisonOperator()# #inspect($expected)#, got #inspect($actual)#";
  }

  function getDescription() {
    return "be #comparisonOperator()# #inspect($expected)#";
  }

  function comparisonOperator() {
    switch ($comparison) {
      case "LessThan":             return "<";
      case "LessThanOrEqualTo":    return "<=";
      case "GreaterThanOrEqualTo": return ">=";
      case "GreaterThan":          return ">";
    }
  }

</cfscript></cfcomponent>