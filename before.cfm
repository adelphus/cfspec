<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfif not caller.this.beforeStartTag(attributes)>
    <cfexit method="exitTag">
  </cfif>
<cfelse>
  <cfset caller.this.beforeEndTag(attributes)>
</cfif>