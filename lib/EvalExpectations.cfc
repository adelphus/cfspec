<cfcomponent extends="Expectations" output="false">
  
  <cffunction name="eval">
    <cfargument name="expression">
    <cfset var context = createObject("component", "EvalContext")>
    <cfreturn context.__cfspecEval(_runner.cfSpecBindings(), expression)>
  </cffunction>

</cfcomponent>