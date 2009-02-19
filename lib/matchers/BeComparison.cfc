<!---
  BeComparison expects the given number to be related to the target accorging to the named
  comparison relationship.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="init">
    <cfargument name="comparison">
    <cfset _comparison = comparison>
    <cfreturn this>
  </cffunction>



  <cffunction name="setArguments">
    <cfset _matcherName = "Be#_comparison#">
    <cfset requireArgs(arguments, 1)>
    <cfset _expected = arguments[1]>
    <cfset verifyArg(isNumeric(_expected), "expected", "must be numeric")>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset _target = target>
    <cfif not isNumeric(_target)>
      <cfthrow type="cfspec.fail" message="Be#_comparison# expected a number, got #inspect(_target)#">
    </cfif>
    <cfswitch expression="#_comparison#">
      <cfcase value="LessThan">              <cfreturn _target lt _expected>  </cfcase>
      <cfcase value="LessThanOrEqualTo">     <cfreturn _target le _expected>  </cfcase>
      <cfcase value="GreaterThanOrEqualTo">  <cfreturn _target ge _expected>  </cfcase>
      <cfcase value="GreaterThan">           <cfreturn _target gt _expected>  </cfcase>
    </cfswitch>
    <cfthrow message="Internal Sytem Bug">
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected to be #_shorthand[_comparison]# #inspect(_expected)#, got #inspect(_target)#">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to be #_shorthand[_comparison]# #inspect(_expected)#, got #inspect(_target)#">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "be #_shorthand[_comparison]# #inspect(_expected)#">
  </cffunction>



  <cfset _shorthand = structNew()>
  <cfset _shorthand.lessThan             = "<"  >
  <cfset _shorthand.lessThanOrEqualTo    = "<=" >
  <cfset _shorthand.greaterThanOrEqualTo = ">=" >
  <cfset _shorthand.greaterThan          = ">"  >



</cfcomponent>
