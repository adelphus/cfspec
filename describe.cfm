<cfsetting enableCfoutputOnly="true">

<cfif not isDefined("caller.$cfspec")>
  <cfset specRunner = createObject("component", "cfspec.lib.SpecRunner")>
  <cfset specRunner.runSpecFile(getBaseTemplatePath())>
  <cfabort>
</cfif>

<cfif thisTag.executionMode eq "start">
  <cfset exitMethod = caller.this.describeStartTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
<cfelse>
  <cfset exitMethod = caller.this.describeEndTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
</cfif>