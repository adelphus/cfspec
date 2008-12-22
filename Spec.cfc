<cfcomponent output="false">

  <cffunction name="run" returntype="void" access="remote">
    <cfset _establishHierarchy()>
    <cfset _runSpecs()>
  </cffunction>

  <cffunction name="_establishHierarchy" returntype="void" output="false">
    <cfset cfspec.hierarchy = []>
    <cfset cfspec.trialRun = true>
    <cfset cfspec.currentIteration = "0">
    <cfset spec()>
  </cffunction>

  <cffunction name="_runSpecs" returntype="void">
    <cfset cfspec.trialRun = false>
    <cfset cfspec.outputLevel = 1>

    <cfoutput><style><cfinclude template="includes/style.css"></style></cfoutput>

    <cfloop array="#cfspec.hierarchy#" index="cfspec.targetIteration">
      <cfset cfspec.currentIteration = "0">
      <cftry>
        <cfset cfspec.isFail = false>
        <cfset cfspec.headerText = "">
        <cfset cfspec.bodyText = "">
        <cfset spec()>
        <cfcatch type="cfspec">
          <cfset cfspec.isFail = true>
          <cfset cfspec.bodyText = cfspec.bodyText & ": " & cfcatch.message>
        </cfcatch>
      </cftry>

      <cfloop condition="cfspec.outputLevel lt listLen(cfspec.targetIteration)">
        <cfset cfspec.outputLevel = cfspec.outputLevel + 1>
        <cfoutput><div></cfoutput>
      </cfloop>

      <cfloop condition="cfspec.outputLevel gt listLen(cfspec.targetIteration)">
        <cfset cfspec.outputLevel = cfspec.outputLevel - 1>
        <cfoutput></div></cfoutput>
      </cfloop>

      <cfif len(cfspec.headerText)>
        <cfoutput><h2>#cfspec.headerText#</h2></cfoutput>
      </cfif>

      <cfif len(cfspec.bodyText)>
        <cfoutput><p#iif(cfspec.isFail, de(' class="fail"'), de(''))#>#cfspec.bodyText#</p></cfoutput>
      </cfif>

    </cfloop>
  </cffunction>

  <cffunction name="_updateCurrentIteration" returntype="void" output="false">
    <cfargument name="tagList" type="string" required="true">
    <cfset var iteration = cfspec.currentIteration>
    <cfset var tagName = "">
    <cfset var nesting = 0>

    <cfloop list="#arguments.tagList#" index="tagName">
      <cfif listFind("CFDESCRIBE,CFIT", tagName)>
        <cfset nesting = nesting + 1>
      </cfif>
    </cfloop>

    <cfloop condition="listLen(cfspec.currentIteration) gt nesting">
      <cfset cfspec.currentIteration = listDeleteAt(cfspec.currentIteration, listLen(cfspec.currentIteration))>
    </cfloop>
    <cfif listLen(cfspec.currentIteration) ge nesting>
      <cfset cfspec.currentIteration = listSetAt(cfspec.currentIteration, nesting, listGetAt(cfspec.currentIteration, nesting) + 1)>
    <cfelse>
      <cfset cfspec.currentIteration = listAppend(cfspec.currentIteration, "1")>
    </cfif>
  </cffunction>

  <cffunction name="$" returntype="Expectations">
    <cfargument name="obj" type="any" required="true">
    <cfreturn createObject("component", "Expectations").init(arguments.obj)>
  </cffunction>

  <cffunction name="fail" returntype="void" output="false">
    <cfargument name="message" type="string" default="FAIL">
    <cfthrow type="cfspec" message="#arguments.message#">
  </cffunction>

</cfcomponent>