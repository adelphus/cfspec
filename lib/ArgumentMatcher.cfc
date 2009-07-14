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
    <cfargument name="args">
    <cfset _args = structCopy(args)>
    <cfset equalMatcher.setArguments(_args)>
  </cffunction>



  <cffunction name="isMatch" output="false">
    <cfargument name="args">
    <cfreturn equalMatcher.isMatch(structCopy(args))>
  </cffunction>



  <cffunction name="asString" output="false">
    <cfreturn equalMatcher.inspect(_args)>
  </cffunction>



</cfcomponent>
