<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfset caller.cfspec.current += 1>
  <cfif caller.cfspec.current neq caller.cfspec.target>
    <cfexit method="exitTag">
  </cfif>

  <cfset caller.cfspec.hint = attributes.should>
  <cfoutput><p class="pass">should #attributes.should#</p></cfoutput>

<cfelseif thisTag.executionMode eq "end">

</cfif>