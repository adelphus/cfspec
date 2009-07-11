<!---
  ArgumentMatcher is responsible for checking arguments signatures passed
  into a stub or mock.  This default implementation matches anything.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments" output="false">
    <cfset _args = arguments>
  </cffunction>



  <cffunction name="isMatch" output="false">
    <cfset var match = compare(asString(), serializeJson(arguments)) eq 0>
    <cfif false>
      <cfthrow message="#asString()#" detail="#serializeJson(arguments)#">
    </cfif>
    <cfreturn match>
  </cffunction>



  <cffunction name="asString" output="false">
    <cfreturn serializeJson(_args)>
  </cffunction>



</cfcomponent>
