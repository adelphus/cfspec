<!---
  EvalExpectations acts like Expectations but it wraps an expression which is evaluated within
  the matcher. This allows the matcher to evaluate it one or more times in order to determine
  if the expectation is met.
--->
<cfcomponent extends="Expectations" output="false">



  <cffunction name="eval">
    <cfargument name="expression">
    <cfset var context = createObject("component", "EvalContext")>
    <cfreturn context.__cfspecEval(_runner.getBindings(), expression)>
  </cffunction>



</cfcomponent>
