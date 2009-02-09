<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfif not caller.this.itStartTag(attributes)>
    <cfexit method="exitTag">
  </cfif>
<cfelse>
  <cfset caller.this.itEndTag(attributes)>
</cfif>