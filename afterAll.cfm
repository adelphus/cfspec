<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfif not caller.this.afterAllStartTag(attributes)>
    <cfexit method="exitTag">
  </cfif>
<cfelse>
  <cfset caller.this.afterAllEndTag(attributes)>
</cfif>