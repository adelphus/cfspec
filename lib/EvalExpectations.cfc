<cfcomponent extends="Expectations" output="false"><cfscript>

  $matchers = [
    "Change(NoCase)?/Change"
  ];
  
  function eval(expression) {
    var ec = createObject("component", "EvalContext");
    return ec.__cfspecEval($runner.cfSpecBindings(), expression);
  }

</cfscript></cfcomponent>