<cfsetting enableCfoutputOnly="true">

<cfset specRunner = createObject("component", "cfspec.lib.SpecRunner").init()>
<cfset suiteDirectory = getDirectoryFromPath(getBaseTemplatePath())>

<cfset specRunner.runSpecSuite(suiteDirectory)>
<cfabort>