<cfsilent>

<cfparam name="url.format" default="html">
<cfswitch expression="#url.format#">
  <cfcase value="xml">
    <cfset report = createObject("component", "cfspec.lib.XmlReport").init()>
  </cfcase>
  <cfdefaultcase>
    <cfset report = createObject("component", "cfspec.lib.HtmlReport").init()>
  </cfdefaultcase>
</cfswitch>

<cfset request.singletons = createObject("component", "cfspec.lib.Singletons").init()>
<cfset specRunner = createObject("component", "cfspec.lib.SpecRunner").init()>
<cfset specStats = createObject("component", "cfspec.lib.SpecStats").init()>
<cfset specRunner.setReport(report)>
<cfset specRunner.setSpecStats(specStats)>
<cfset specRunner.runSpecSuite(getDirectoryFromPath(getBaseTemplatePath()))>
<cfset writeOutput(report.getOutput())>
<cfabort>

</cfsilent>
