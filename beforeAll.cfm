<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfif caller.$cfspec.isTrial() or not caller.$cfspec.isBeforeAllRunnable()>
    <cfexit method="exitTag">
  </cfif>
<cfelse>
  <cfset caller.$cfspec.updateContext(variables)>
  <cfset caller.$cfspec.setContext(caller)>
</cfif>