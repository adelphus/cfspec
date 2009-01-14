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
    $before = $expectations.eval($changee);
    $expectations.eval(actual);
    $after = $expectations.eval($changee);
    return !eqMatcher.init("", iif($noCase, de("NoCase"), de("")), $before).isMatch($after);
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

  function isChained() {
    return not $negateExpectations;
  }

  function by(delta) {
    var difference = getDifferenceAndScreenParams("", delta);
    if (difference != delta) $runner.fail("expected to change #inspect($changee)# by #inspect(delta)#, got #inspect(difference)#");    
    return this;
  }

  function byAtLeast(delta) {
    var difference = getDifferenceAndScreenParams("AtLeast", delta);
    if (difference < delta) $runner.fail("expected to change #inspect($changee)# by at least #inspect(delta)#, got #inspect(difference)#");    
    return this;
  }

  function byAtMost(delta) {
    var difference = getDifferenceAndScreenParams("AtMost", delta);
    if (difference > delta) $runner.fail("expected to change #inspect($changee)# by at most #inspect(delta)#, got #inspect(difference)#");
    return this;
  }
  
  function from(before) {
    var eqMatcher = createObject("component", "cfspec.lib.matchers.Equal");
    var pass = eqMatcher.init("", iif($noCase, de("NoCase"), de("")), before).isMatch($before);
    if (!pass) $runner.fail("expected to change #inspect($changee)# from #inspect(before)#, was #inspect($before)#");
    return this;
  }

  function to(after) {
    var eqMatcher = createObject("component", "cfspec.lib.matchers.Equal");
    var pass = eqMatcher.init("", iif($noCase, de("NoCase"), de("")), after).isMatch($after);
    if (!pass) $runner.fail("expected to change #inspect($changee)# to #inspect(after)#, got #inspect($after)#");
    return this;
  }

  function getDifferenceAndScreenParams(relativity, delta) {
    if (not isNumeric(delta)) throw("Application", "The DELTA parameter to the Change().by#relativity#(delta) matcher must be a number.");
    if (not isNumeric($before)) throw("Application", "The BEFORE value of the Change().by#relativity#(delta) matcher must be a number.");
    if (not isNumeric($after)) throw("Application", "The AFTER value of the Change().by#relativity#(delta) matcher must be a number.");
    return $after - $before;
  }

</cfscript></cfcomponent>