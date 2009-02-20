<!---
  EvalContext is used to evaluate expressions within a specific binding context. To the extent
  possible, it is a clean environment where no other variables or methods can interfere.
--->
<cfcomponent output="false">



  <cffunction name="__cfspecEval">
    <cfargument name="__cfspecEvalBindings">
    <cfargument name="__cfspecEvalExpression">
    <cfset var __cfspecEvalResult = "">

    <cfset structAppend(variables, __cfspecEvalBindings)>
    <cfset __cfspecEvalResult = evaluate(__cfspecEvalExpression)>
    <cfset structAppend(__cfspecEvalBindings, variables)>

    <cfreturn iif(isDefined("__cfspecEvalResult"), "__cfspecEvalResult", "false")>
  </cffunction>



</cfcomponent>
