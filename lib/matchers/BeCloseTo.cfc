<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

	function init(expected, delta) {
		$expected = expected;
		$delta = delta;
		return this;
	}

	function isMatch(actual) {
		$actual = actual;
		return abs($actual - $expected) < $delta;
	}

	function getFailureMessage() {
		return "expected #inspect($expected)# +/- (< #inspect($delta)#), got #inspect($actual)#";
	}

	function getDescription() {
		return "be close to #inspect($expected)# (within +/- #inspect($delta)#)";
	}

</cfscript></cfcomponent>