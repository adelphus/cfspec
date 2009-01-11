<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfif caller.$cfspec.isTrial() or not caller.$cfspec.isAfterRunnable()>
    <cfexit method="exitTag">
  </cfif>
</cfif>