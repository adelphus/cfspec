<!---
  EvalContext is used to evaluate expressions within a specific binding context. To the extent
  possible, it is a clean environment where no other variables or methods can interfere.
--->
<cfcomponent output="false"><cfscript>

  function __cfspecEval(__cfspecEvalBindings, __cfspecEvalExpression) {
    var __cfspecEvalResult = "";
    
    structAppend(variables, arguments.__cfspecEvalBindings);
    __cfspecEvalResult = evaluate(arguments.__cfspecEvalExpression);
    structAppend(__cfspecEvalBindings, variables);
    
    return iif(isDefined("__cfspecEvalResult"), "__cfspecEvalResult", "false");
  }

</cfscript></cfcomponent>