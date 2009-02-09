<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfif not caller.this.afterStartTag(attributes)>
    <cfexit method="exitTag">
  </cfif>
<cfelse>
  <cfset caller.this.afterEndTag(attributes)>
</cfif>