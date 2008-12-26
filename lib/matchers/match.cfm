<cffunction name="shouldMatch" output="false">
  <cfargument name="expected">
  <cfif not reFind(expected, actual)>
    <cfset runner.fail("expected '#actual#' to match /#expected#/ (case-sensitive)")>
  </cfif>
</cffunction>

<cffunction name="shouldNotMatch" output="false">
  <cfargument name="expected">
  <cfif reFind(expected, actual)>
    <cfset runner.fail("expected '#actual#' not to match /#expected#/ (case-sensitive)")>
  </cfif>
</cffunction>

<cffunction name="shouldMatchNoCase" output="false">
  <cfargument name="expected">
  <cfif not reFindNoCase(expected, actual)>
    <cfset runner.fail("expected '#actual#' to match /#expected#/ (case-insensitive)")>
  </cfif>
</cffunction>

<cffunction name="shouldNotMatchNoCase" output="false">
  <cfargument name="expected">
  <cfif reFindNoCase(expected, actual)>
    <cfset runner.fail("expected '#actual#' not to match /#expected#/ (case-insensitive)")>
  </cfif>
</cffunction>