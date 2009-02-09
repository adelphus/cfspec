<cfsetting enableCfoutputOnly="true">

<cfset specRunner = createObject("component", "cfspec.lib.SpecRunner")>
<cfset suiteDirectory = getDirectoryFromPath(getBaseTemplatePath())>

<cfset specRunner.runSpecSuite(suiteDirectory)>