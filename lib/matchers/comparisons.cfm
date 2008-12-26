<cffunction name="shouldBeLessThan" output="false">
  <cfargument name="expected">
  <cfif not _isLessThan(actual, expected)>
    <cfset runner.fail("expected #val(actual)# < #val(expected)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotBeLessThan" output="false">
  <cfargument name="expected">
  <cfif _isLessThan(actual, expected)>
    <cfset runner.fail("expected #val(actual)# >= #val(expected)#")>
  </cfif>
</cffunction>

<cffunction name="shouldBeLessThanOrEqualTo" output="false">
  <cfargument name="expected">
  <cfif not _isLessThanOrEqualTo(actual, expected)>
    <cfset runner.fail("expected #val(actual)# <= #val(expected)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotBeLessThanOrEqualTo" output="false">
  <cfargument name="expected">
  <cfif _isLessThanOrEqualTo(actual, expected)>
    <cfset runner.fail("expected #val(actual)# > #val(expected)#")>
  </cfif>
</cffunction>

<cffunction name="shouldBeGreaterThanOrEqualTo" output="false">
  <cfargument name="expected">
  <cfif not _isGreaterThanOrEqualTo(actual, expected)>
    <cfset runner.fail("expected #val(actual)# >= #val(expected)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotBeGreaterThanOrEqualTo" output="false">
  <cfargument name="expected">
  <cfif _isGreaterThanOrEqualTo(actual, expected)>
    <cfset runner.fail("expected #val(actual)# < #val(expected)#")>
  </cfif>
</cffunction>

<cffunction name="shouldBeGreaterThan" output="false">
  <cfargument name="expected">
  <cfif not _isGreaterThan(actual, expected)>
    <cfset runner.fail("expected #val(actual)# > #val(expected)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotBeGreaterThan" output="false">
  <cfargument name="expected">
  <cfif _isGreaterThan(actual, expected)>
    <cfset runner.fail("expected #val(actual)# <= #val(expected)#")>
  </cfif>
</cffunction>

<cffunction name="_isLessThan" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn val(actual) lt val(expected)>
</cffunction>

<cffunction name="_isLessThanOrEqualTo" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn val(actual) le val(expected)>
</cffunction>

<cffunction name="_isGreaterThanOrEqualTo" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn val(actual) ge val(expected)>
</cffunction>

<cffunction name="_isGreaterThan" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn val(actual) gt val(expected)>
</cffunction>