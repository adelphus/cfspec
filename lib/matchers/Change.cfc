<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(noCase) {
    var i = "";
    $noCase = len(noCase);
    if (arrayLen(arguments) != 2) throw("Application", "The Change matcher expected 1 argument, got #arrayLen(arguments)-1#.");
    $changee = arguments[2];
    return this;
  }

  function isMatch(actual) {
    var eqMatcher = createObject("component", "cfspec.lib.matchers.Equal");
    var before = $expectations.eval($changee);
    var after = "";
    $expectations.eval(actual);
    after = $expectations.eval($changee);
    return !eqMatcher.init("", iif($noCase, de("NoCase"), de("")), before).isMatch(after);
  }

  function getFailureMessage() {
    return "expected to change #inspect($changee)#, got unchanged";
  }

  function getNegativeFailureMessage() {
    return "expected not to change #inspect($changee)#, got changed";
  }

  function getDescription() {
    return "change #inspect($changee)#";
  }

</cfscript></cfcomponent>