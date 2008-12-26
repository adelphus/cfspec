<cffunction name="shouldBeTrue" output="false">
  <cfif not actual>
    <cfset runner.fail("expected #yesNoFormat(true)#, got #yesNoFormat(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotBeFalse" output="false">
  <cfif not actual>
    <cfset runner.fail("expected #yesNoFormat(true)#, got #yesNoFormat(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldBeFalse" output="false">
  <cfif actual>
    <cfset runner.fail("expected #yesNoFormat(false)#, got #yesNoFormat(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotBeTrue" output="false">
  <cfif actual>
    <cfset runner.fail("expected #yesNoFormat(false)#, got #yesNoFormat(actual)#")>
  </cfif>
</cffunction>