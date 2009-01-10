<cfsetting enableCfoutputOnly="true">

<cfif not isDefined("caller.$cfspec")>
  <cfset createObject("component", "cfspec.lib.SpecRunner").runSpec(getBaseTemplatePath())>
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
    <cfset caller.$cfspec.appendOutput("<h2>#attributes.hint#</h2><div>")>
  </cfif>

  <cfexit method="exitTemplate">
<cfelse>
  <cfset caller.$cfspec.popCurrent()>
  
  <cfif caller.$cfspec.isTrial() or not caller.$cfspec.isDescribeEndRunnable()>
    <cfexit method="exitTag">
  </cfif>  

  <cfset caller.$cfspec.popContext()>
  <cfset caller.$cfspec.appendOutput("</div>")>
</cfif>