<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

	function init(predicate) {
		$predicate = predicate;
		return this;
	}

	function isMatch(actual) {
		$actual = actual;
		switch ($predicate) {

		case "True":
			return $actual eq true;

		case "False":
			return $actual eq false;

		default:
			return false;

		}
	}

	function getFailureMessage() {
		return "expected to be #inspect($predicate)#, got #inspect($actual)#";
	}

	function getDescription() {
		return "be #$predicate#";
	}

</cfscript></cfcomponent>