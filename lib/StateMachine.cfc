<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfset _state = "">
    <cfreturn this>
  </cffunction>



  <cffunction name="startsAs" output="false">
    <cfargument name="state">
    <cfset _state = state>
  </cffunction>



  <cffunction name="is" output="false">
    <cfargument name="state">
    <cfreturn compare(state, _state) eq 0>
  </cffunction>



  <cffunction name="becomes" output="false">
    <cfargument name="state">
    <cfreturn createObject("component", "cfspec.lib.StateMachineTransition").init(this, state)>
  </cffunction>



</cfcomponent>
