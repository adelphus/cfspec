<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init() {
    $type = "Any";
    if (arrayLen(arguments) >= 1) {
      $type = arguments[1];
      if (not isSimpleValue($type)) throw("Application", "The TYPE parameter to the Throw matcher must be a simple value.");
    }
    if (arrayLen(arguments) >= 2) {
      $message = arguments[2];
      if (not isSimpleValue($message)) throw("Application", "The MESSAGE parameter to the Throw matcher must be a simple value.");
    }
    if (arrayLen(arguments) >= 3) {
      $detail = arguments[3];
      if (not isSimpleValue($detail)) throw("Application", "The DETAIL parameter to the Throw matcher must be a simple value.");
    }
    if (arrayLen(arguments) >= 4) throw("Application", "The Throw matcher expected at most 3 arguments, got #arrayLen(arguments)#.");
    return this;
  }

  function isMatch(actual) {
    $actual = "";
    try {
      $actual = $context.getExpectedException();
    } catch (Any e) {
      return false;
    }
    if (isSimpleValue($actual)) return false;
    
    if ((isDefined("$type") and !isMatchType($actual.type, $type)) or
        (isDefined("$message") and !findNoCase($message, $actual.message) and !reFindNoCase($message, $actual.message)) or
        (isDefined("$detail") and !findNoCase($detail, $actual.detail) and !reFindNoCase($detail, $actual.detail))) {

      if ($negateExpectations) $context.setExpectedException($actual);          
      return false;      
    }

    return true;
  }
  
  function isMatchType(actual, expected) {
    var pos = "";
    if (expected == "Any") return true;
    pos = findNoCase(expected, actual);
    if (pos == 1 and (len(expected) == len(actual) or mid(actual, len(expected) + 1, 1) == ".")) return true;
    return false;
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
    if (params != "") description = description & " (#params#)";
    return description;
  }
  
  function inspectException(e) {
    var description = "";
    var params = "";
    if (isDefined("e.type")) description = e.type;
    if (isDefined("e.message")) params = listAppend(params, "message=" & inspect(e.message));
    if (isDefined("e.detail")) params = listAppend(params, "detail=" & inspect(e.detail));
    if (params != "") description = description & " (#params#)";
    return description;
  }

</cfscript></cfcomponent>