<cfsilent>

<cfset request.singletons = createObject("component", "cfspec.lib.Singletons").init()>
<cfset featureRunner = createObject("component", "cfspec.lib.FeatureRunner").init()>
<cfset htmlReport = createObject("component", "cfspec.lib.HtmlReport").init()>
<cfset specStats = createObject("component", "cfspec.lib.SpecStats").init()>
<cfset featureRunner.setReport(htmlReport)>
<cfset featureRunner.setSpecStats(specStats)>
<cfset featureRunner.runFeatureSuite(getDirectoryFromPath(getBaseTemplatePath()))>
<cfset writeOutput(htmlReport.getOutput())>
<cfabort>

</cfsilent>
