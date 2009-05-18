<cfsilent>

<cfset request.singletons = createObject("component", "cfspec.lib.Singletons").init()>
<cfset specRunner = createObject("component", "cfspec.lib.SpecRunner").init()>
<cfset suiteDirectory = getDirectoryFromPath(getBaseTemplatePath())>

<cfset specRunner.runSpecSuite(suiteDirectory)>
<cfabort>

</cfsilent>