<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfif caller.$cfspec.isTrial() or not caller.$cfspec.isBeforeRunnable()>
    <cfexit method="exitTag">
  </cfif>
</cfif>