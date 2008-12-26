<cfset arrayAppend(matchers, "^shouldBe(.+)$/_shouldBeXxx")>
<cfset arrayAppend(matchers, "^shouldNotBe(.+)$/_shouldNotBeXxx")>

<cffunction name="_shouldBeXxx" access="private" output="false">
  <cfargument name="expected">
  <cfargument name="args">
  <cfset var flatArgs = "">
  <cfset var i = "">
  <cfloop index="i" from="1" to="#arrayLen(args)#">
    <cfset flatArgs = listAppend(flatArgs, "args[#i#]")>
  </cfloop>
  <cfif not evaluate("actual.is#expected#(#flatArgs#)")>
    <cfset runner.fail("Expected to be #expected#.")>
  </cfif>
</cffunction>

<cffunction name="_shouldNotBeXxx" access="private" output="false">
  <cfargument name="expected">
  <cfargument name="args">
  <cfset var flatArgs = "">
  <cfset var i = "">
  <cfloop index="i" from="1" to="#arrayLen(args)#">
    <cfset flatArgs = listAppend(flatArgs, "args[#i#]")>
  </cfloop>
  <cfif evaluate("actual.is#expected#(#flatArgs#)")>
    <cfset runner.fail("Expected not to be #expected#.")>
  </cfif>
</cffunction>