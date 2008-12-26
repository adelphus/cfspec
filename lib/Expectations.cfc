<cfcomponent output="false">

  <cfset matchers = []>
  <cfdirectory action="list" directory="#expandPath('/cfspec/lib/matchers')#" filter="*.cfm" name="dir">
  <cfloop query="dir">
    <cfinclude template="matchers/#name#">
  </cfloop>

  <cffunction name="init" returntype="Expectations" output="false">
    <cfargument name="runner" type="any" required="true">
    <cfargument name="actual" type="any" required="true">
    <cfset variables.runner = arguments.runner>
    <cfset variables.actual = arguments.actual>
    <cfreturn this>
  </cffunction>

  <cffunction name="onMissingMethod" returntype="any" output="false">
    <cfargument name="missingMethodName" type="string" required="true">
    <cfargument name="missingMethodArguments" type="any" required="true">
    <cfset var matcher = "">
    <cfset var matchData = "">
    <cfset var flatArgs = "">
    <cfset var args = []>
    <cfset var i = "">
    <cfset var result = "">

    <cfloop array="#matchers#" index="matcher">
      <cfset matchData = reFindNoCase(listFirst(matcher, "/"), missingMethodName, 1, true)>
      <cfif matchData.len[1]>
        <cfloop index="i" from="2" to="#arrayLen(matchData.len)#">
          <cfset arrayAppend(args, mid(missingMethodName, matchData.pos[i], matchData.len[i]))>
          <cfset flatArgs = listAppend(flatArgs, "args[#(i-1)#]")>
        </cfloop>
        <cfset flatArgs = listAppend(flatArgs, "arguments.missingMethodArguments")>
        <cfset evaluate("#listRest(matcher, '/')#(#flatArgs#)")>
        <cfreturn true>
      </cfif>
    </cfloop>

    <cfif isObject(actual)>
      <cftry>
        <cfset result = evaluate("actual.#missingMethodName#(argumentCollection=arguments.missingMethodArguments)")>
        <cfreturn runner.$(result)>
        <cfcatch type="any">
          <cfset runner.setException(cfcatch)>
          <cfreturn createObject("component", "ExceptionExpectations").init(runner, cfcatch)>
        </cfcatch>
      </cftry>
    </cfif>

    <cfthrow message="Missing method: #missingMethodName#">
  </cffunction>
  
  <cffunction name="shouldNotThrow" output="false">
  </cffunction>
  
</cfcomponent>