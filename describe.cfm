<cfsilent>

<cfif not isDefined("caller.__cfspecRunner")>
  <cfparam name="url.format" default="html">
  <cfparam name="url.output" default="">

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
  <cfset specRunner.runSpecFile(getBaseTemplatePath())>

  <cfif url.output eq "">
    <cfset writeOutput(report.getOutput())>
  <cfelse>
    <cffile action="write" file="#expandPath(url.output)#.#url.format#" output="#report.getOutput()#">
    <cfset writeOutput("Report saved to: #url.output#")>
  </cfif>

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

</cfsilent>
