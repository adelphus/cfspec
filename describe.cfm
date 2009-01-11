<cfsetting enableCfoutputOnly="true">

<cfif not isDefined("caller.$cfspec")>
  <cfset createObject("component", "cfspec.lib.SpecRunner").runSpecFile(getBaseTemplatePath())>
  <cfabort>
</cfif>

<cfif thisTag.executionMode eq "start">
  <cfset caller.$cfspec.pushCurrent()>
  
  <cfif caller.$cfspec.isTrial()>
    <cfexit method="exitTemplate">
  </cfif>

  <cfif not caller.$cfspec.isDescribeInsideRunnable()>
    <cfset caller.$cfspec.popCurrent()>
    <cfexit method="exitTag">
  </cfif>

  <cfif caller.$cfspec.isDescribeStartRunnable()>
    <cfset caller.$cfspec.pushContext()>    
    <cfset caller.$cfspec.appendOutput("<h2 id='desc_#caller.$cfspec.getSuiteNumber()#_#replace(caller.$cfspec.getCurrent(), ',', '_', 'all')#'>#attributes.hint#</h2><div>")>
  </cfif>

  <cfexit method="exitTemplate">
<cfelse>
  <cfset caller.$cfspec.popCurrent()>
  
  <cfif caller.$cfspec.isTrial() or not caller.$cfspec.isDescribeEndRunnable()>
    <cfexit method="exitTag">
  </cfif>  

  <cfif caller.$cfspec.getContextStatus() eq "fail">
    <cfset css = "background:##CC0000">
  <cfelseif caller.$cfspec.getContextStatus() eq "pend">
    <cfset css = "background:##FFFF00;color:black">
  <cfelse>
    <cfset css = "background:##00CC00">
  </cfif>

  <cfset caller.$cfspec.popContext()>
  <cfset caller.$cfspec.appendOutput("<style>##desc_#caller.$cfspec.getSuiteNumber()#_#replace(caller.$cfspec.getCurrent(), ',', '_', 'all')#_0{#css#}</style></div>")>
</cfif>