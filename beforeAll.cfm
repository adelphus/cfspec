<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfif not caller.this.beforeAllStartTag(attributes)>
    <cfexit method="exitTag">
  </cfif>
<cfelse>
  <cfset caller.this.beforeAllEndTag(attributes, variables)>
</cfif>