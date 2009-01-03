<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfset caller.cfspec.current++>
  <cfif caller.cfspec.target neq caller.cfspec.current>
    <cfexit method="exitTag">
  </cfif>

  <cfset caller.cfspec.hint = attributes.should>

<cfelse>
  <cfif isSimpleValue(caller.cfspec.exception)>
    <cfoutput><p class="pass">should #attributes.should#</p></cfoutput>  
  </cfif>

</cfif>