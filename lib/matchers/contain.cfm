<cffunction name="shouldContain" output="false">
  <cfargument name="expected">
  <cfif not find(expected, actual)>
    <cfset runner.fail("expected '#actual#' to contain '#expected#' (case-sensitive)")>
  </cfif>
</cffunction>

<cffunction name="shouldNotContain" output="false">
  <cfargument name="expected">
  <cfif find(expected, actual)>
    <cfset runner.fail("expected '#actual#' not to contain '#expected#' (case-sensitive)")>
  </cfif>
</cffunction>

<cffunction name="shouldContainNoCase" output="false">
  <cfargument name="expected">
  <cfif not findNoCase(expected, actual)>
    <cfset runner.fail("expected '#actual#' to contain '#expected#' (case-insensitive)")>
  </cfif>
</cffunction>

<cffunction name="shouldNotContainNoCase" output="false">
  <cfargument name="expected">
  <cfif findNoCase(expected, actual)>
    <cfset runner.fail("expected '#actual#' not to contain '#expected#' (case-insensitive)")>
  </cfif>
</cffunction>