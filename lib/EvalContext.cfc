<cfcomponent output="false"><cfscript>

  function __cfspecEval(__cfspecEvalBindings, __cfspecEvalExpression) {
    var __cfspecEvalResult = "";
    structAppend(variables, __cfspecEvalBindings);
    __cfspecEvalResult = evaluate(__cfspecEvalExpression);
    structAppend(__cfspecEvalBindings, variables);
    if (!isDefined("__cfspecEvalResult")) return false;
    return __cfspecEvalResult;
  }

</cfscript></cfcomponent>