<!---
  BeCloseTo expected numeric arguments to fall within a given delta of the target.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="setArguments">
    <cfset requireArgs(arguments, 2)>
    <cfset _expected = arguments[1]>
    <cfset _delta = arguments[2]>
    <cfset verifyArg(isNumeric(_expected), "expected", "must be numeric")>
    <cfset verifyArg(isNumeric(_delta), "delta", "must be numeric")>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset _target = target>
    <cfif not isNumeric(_target)>
      <cfthrow type="cfspec.fail" message="BeCloseTo expected a number, got #inspect(_target)#">
    </cfif>
    <cfreturn abs(_target - _expected) lt _delta>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected #inspect(_expected)# +/- (< #inspect(_delta)#), got #inspect(_target)#">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected #inspect(_expected)# +/- (>= #inspect(_delta)#), got #inspect(_target)#">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "be close to #inspect(_expected)# (within +/- #inspect(_delta)#)">
  </cffunction>



</cfcomponent>
