<!---
  Match expects the target to be a simple value that matches the given regular expression.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="init">
    <cfargument name="noCase">
    <cfset _matcherName = "Match">
    <cfset _noCase = len(noCase) gt 0>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments">
    <cfset requireArgs(arguments, 1)>
    <cfset _regexp = arguments[1]>
    <cfset verifyArg(isSimpleValue(_regexp), "regExp", "must be a valid regular expression")>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset _target = target>
    <cfif not isSimpleValue(_target)>
      <cfthrow type="cfspec.fail" message="Match expected a simple value, got #inspect(_target)#">
    </cfif>
    <cfif _noCase>
      <cfreturn reFindNoCase(_regexp, _target) gt 0>
    <cfelse>
      <cfreturn reFind(_regexp, _target) gt 0>
    </cfif>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected to match #inspect(_regexp)#, got #inspect(_target)#">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to match #inspect(_regexp)#, got #inspect(_target)#">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "match #inspect(_regexp)#">
  </cffunction>



</cfcomponent>
