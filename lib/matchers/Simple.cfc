<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(name) {
  	$name = name;
  	$args = arguments;
    return this;
  }

  function isMatch(target) {
    var ec = createObject("component", "cfspec.lib.EvalContext");
    var result = "";
    variables.target = target;
    if (arrayLen($args) gt 1) variables.expected = $args[2];
    result = ec.__cfspecEval(variables, $context.getSimpleMatcher($name));
    if (isDefined("result")) return result;
    return false;
  }

  function getFailureMessage() {
    return "expected to #$name#, failed";
  }

  function getNegativeFailureMessage() {
    return "expected not to #$name#, failed";
  }

  function getDescription() {
    return $name;
  }

</cfscript></cfcomponent>