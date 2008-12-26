<cffunction name="shouldBeCloseTo" output="false">
  <cfargument name="expected">
  <cfargument name="delta">  
  <cfif not _isCloseTo(actual, expected, delta)>
    <cfset runner.fail("expected #expected# +/- (< #delta#), got #actual#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotBeCloseTo" output="false">
  <cfargument name="expected">
  <cfargument name="delta">  
  <cfif _isCloseTo(actual, expected, delta)>
    <cfset runner.fail("expected #expected# +/- (>= #delta#), got #actual#")>
  </cfif>
</cffunction>

<cffunction name="_isCloseTo" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfargument name="delta">
  <cfreturn abs(actual - expected) lt delta>
</cffunction>