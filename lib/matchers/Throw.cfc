<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

	function init() {
		$type = "Any";
		if (arrayLen(arguments) >= 1) $type = arguments[1];
		if (arrayLen(arguments) >= 2) $message = arguments[2];
		if (arrayLen(arguments) >= 3) $detail = arguments[3];
		return this;
	}

	function isMatch(actual) {
		$actual = "";
    try {
  		$actual = $expectations.getExpectedException();
    } catch (Any e) {
    	return false;
    }
		return !isSimpleValue($actual);
	}

	function getFailureMessage() {
		var actual = "no exception";
		if (!isSimpleValue($actual)) actual = inspectException($actual);
		return "expected to #getDescription()#, got #actual#";
	}
	
	function getNegativeFailureMessage() {
		var actual = "no exception";
		if (!isSimpleValue($actual)) actual = inspectException($actual);
		return "expected not to #getDescription()#, got #actual#";
	}

	function getDescription() {
		var description = "throw #$type#";
		var params = "";
		if (isDefined("$message")) params = listAppend(params, "message=" & inspect($message));
		if (isDefined("$detail")) params = listAppend(params, "detail=" & inspect($detail));
    if (params != "") description &= " (#params#)";
		return description;
	}
	
	function inspectException(e) {
		var description = "";
		var params = "";
		if (isDefined("e.type")) description = e.type;
		if (isDefined("e.message")) params = listAppend(params, "message=" & inspect(e.message));
		if (isDefined("e.detail")) params = listAppend(params, "detail=" & inspect(e.detail));
    if (params != "") description &= " (#params#)";
		return description;
	}

</cfscript></cfcomponent>