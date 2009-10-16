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
<cfset featureRunner = createObject("component", "cfspec.lib.FeatureRunner").init()>
<cfset specStats = createObject("component", "cfspec.lib.SpecStats").init()>
<cfset featureRunner.setReport(report)>
<cfset featureRunner.setSpecStats(specStats)>
<cfset featureRunner.loadStepDefinitions(getDirectoryFromPath(getBaseTemplatePath()) & "stepDefinitions")>
<cfset featureRunner.runFeatureSuite(getDirectoryFromPath(getBaseTemplatePath()))>
<cfset writeOutput(report.getOutput())>
<cfabort>

</cfsilent>
