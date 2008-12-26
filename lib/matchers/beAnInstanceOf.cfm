<cffunction name="shouldBeAnInstanceOf" output="false">
  <cfargument name="expected">
  <cfif not isInstanceOf(actual, expected)>
    <cfset runner.fail("Expected to be an instance of #expected#.")>
  </cfif>
</cffunction>

<cffunction name="shouldNotBeAnInstanceOf" output="false">
  <cfargument name="expected">
  <cfif isInstanceOf(actual, expected)>
    <cfset runner.fail("Expected not to be an instance of #expected#.")>
  </cfif>
</cffunction>