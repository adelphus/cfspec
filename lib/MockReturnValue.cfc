<!---
  This holds a return value that a mock will supply in its execution chain.
--->
<cfcomponent>



  <cffunction name="init">
    <cfargument name="value">
    <cfset _value = value>
    <cfreturn this>
  </cffunction>



  <cffunction name="eval">
    <cfreturn _value>
  </cffunction>



</cfcomponent>
