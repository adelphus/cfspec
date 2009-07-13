<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfargument name="stateMachine">
    <cfargument name="state">
    <cfset _stateMachine = stateMachine>
    <cfset _state = state>
    <cfreturn this>
  </cffunction>



  <cffunction name="run" output="false">
    <cfset _stateMachine.startsAs(_state)>
  </cffunction>



</cfcomponent>
