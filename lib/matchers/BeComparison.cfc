<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

	function init(comparison, expected) {
		$comparison = comparison;
		$expected = expected;
		return this;
	}

	function isMatch(actual) {
		$actual = actual;
		switch ($comparison) {
			case "LessThan":             return $actual < $expected;
			case "LessThanOrEqualTo":    return $actual <= $expected;
			case "GreaterThanOrEqualTo": return $actual >= $expected;
			case "GreaterThan":          return $actual > $expected;
			default:				             return false;
		}
	}

	function getFailureMessage() {
		return "expected to be #comparisonOperator()# #inspect($expected)#, got #inspect($actual)#";
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