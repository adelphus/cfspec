<!---
  SpecContext is used to run spec blocks within the correct binding context. To the extent
  possible, it is a clean environment where no other variables or methods can interfere.
--->
<cfcomponent output="false">

  <cffunction name="__cfspecRun">
    <cfargument name="__cfspecRunner">
    <cfargument name="cfspec">
    <cfargument name="__cfspecRunBindings">
    <cfargument name="__cfspecRunTemplate">
    <cfset variables.$cfspec = arguments.cfspec>
    <cfset variables.__cfspecRunner = arguments.__cfspecRunner>
    <cfset structAppend(variables, arguments.__cfspecRunBindings)>
    <cfinclude template="#arguments.__cfspecRunTemplate#">
    <cfset structAppend(arguments.__cfspecRunBindings, variables)>
<cfif isDefined("foo")>    <cfdump var="#arguments.__cfspecRunBindings#"></cfif>
  </cffunction>

<cfscript>

  function $(object) {
    return createObject("component", "Expectations").init(__cfspecRunner, $cfspec, object);
  }

  function $eval(expression) {
    return createObject("component", "EvalExpectations").init(__cfspecRunner, $cfspec, expression);
  }
  
  function stub() {
    return createObject("component", "Stub").init(argumentCollection=arguments);
  }

  function mock() {
    return createObject("component", "Mock").init(argumentCollection=arguments);
  }
  
  function fail() {
    __cfspecRunner.fail(argumentCollection=arguments);
  }
  
  function pend() {
    __cfspecRunner.pend(argumentCollection=arguments);
  }
  
  function cfspecBindings() {
    return variables;
  }
  
</cfscript></cfcomponent>