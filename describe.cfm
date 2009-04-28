<cfsetting enableCfoutputOnly="true">

<cfif not isDefined("caller.__cfspecRunner")>
  <cfset request.singletons = createObject("component", "cfspec.lib.Singletons").init()>
  <cfset specRunner = createObject("component", "cfspec.lib.SpecRunner").init()>
  <cfset specRunner.runSpecFile(getBaseTemplatePath())>
  <cfabort>
</cfif>

<cfif thisTag.executionMode eq "start">
  <cfset exitMethod = caller.__cfspecRunner.describeStartTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
<cfelse>
  <cfset exitMethod = caller.__cfspecRunner.describeEndTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
</cfif>
