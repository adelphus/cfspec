<!---
  ArgumentMatcher is responsible for checking arguments signatures passed
  into a stub or mock.  This default implementation matches anything.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfset equalMatcher = createObject("component", "cfspec.lib.matchers.Equal").init("", "")>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments" output="false">
    <cfset _args = structCopy(arguments)>
    <cfset equalMatcher.setArguments(_args)>
  </cffunction>



  <cffunction name="isMatch" output="false">
    <cfreturn equalMatcher.isMatch(structCopy(arguments))>
  </cffunction>



  <cffunction name="asString" output="false">
    <cfreturn equalMatcher.inspect(_args)>
  </cffunction>



</cfcomponent>
