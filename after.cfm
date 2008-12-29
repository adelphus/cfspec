<cfsetting enableCfoutputOnly="true">

<cfif thisTag.executionMode eq "start">
  <cfset caller.cfspec.current++>
  <cfif caller.cfspec.target eq 0>
    <cfset caller.cfspec.scope = listAppend(caller.cfspec.scope, caller.cfspec.current & ">")>
  </cfif>
  <cfif caller.cfspec.target lt caller.cfspec.current>
    <cfset i = listFind(caller.cfspec.scope, "#caller.cfspec.current#>")>
    <cfset level = 1>
    <cfloop condition="level gt 0 and i gt 0">
      <cfset i-->
      <cfset tmp = listGetAt(caller.cfspec.scope, i)>
      <cfif listFind("],>", right(tmp, 1))>
        <cfset level++>
      <cfelse>
        <cfset level-->
      </cfif>
    </cfloop>
    <cfif caller.cfspec.target le val(listGetAt(caller.cfspec.scope, i))>
      <cfexit method="exitTag">
    </cfif>
  <cfelse>
    <cfexit method="exitTag">
  </cfif>
</cfif>