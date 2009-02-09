<cfcomponent extends="Expectations" output="false"><cfscript>

  $matchers = [
    "Change(NoCase)?/Change",
    "Throw/Throw"
  ];
  
  function eval(expression) {
    var ec = createObject("component", "EvalContext");
    return ec.__cfspecEval($runner.cfSpecBindings(), expression);
  }

</cfscript></cfcomponent>