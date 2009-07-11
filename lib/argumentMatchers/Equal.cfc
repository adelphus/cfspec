<!---
  ArgumentMatcher is responsible for checking arguments signatures passed
  into a stub or mock.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfset _matcher = createObject("component", "cfspec.lib.matchers.Equal").init("", "")>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments" output="false">
    <cfset _matcher.setArguments(arguments)>
  </cffunction>



  <cffunction name="isMatch" output="false">
    <cfreturn _matcher.isMatch(arguments)>
  </cffunction>



</cfcomponent>
