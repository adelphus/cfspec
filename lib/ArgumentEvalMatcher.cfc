<!---
  ArgumentMatcher is responsible for checking arguments signatures passed
  into a stub or mock.  This default implementation matches anything.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfreturn this>
  </cffunction>



  <cffunction name="setExpression" output="false">
    <cfargument name="expression">
    <cfset _expression = expression>
  </cffunction>



  <cffunction name="isMatch" output="false">
    <cfreturn not not evaluate(_expression)>
  </cffunction>



  <cffunction name="asString" output="false">
    <cfreturn "EVAL:#serializeJson(_expression)#">
  </cffunction>



</cfcomponent>
