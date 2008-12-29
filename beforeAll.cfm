<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfset caller.cfspec.current++>
  <cfif caller.cfspec.target neq caller.cfspec.current>
    <cfexit method="exitTag">
  </cfif>
  <cfset caller.cfspec.saveContext = true>
</cfif>