<cfsetting enableCfoutputOnly="true">

<cfif not isDefined("caller.cfspec.target")>
  <cfset specRunner = createObject("component", "cfspec.lib.SpecRunner").init(getBaseTemplatePath())>
  <cfoutput>#specRunner.run()#</cfoutput>
  <cfabort>
</cfif>

<cfset caller.cfspec.current++>
<cfif caller.cfspec.target eq 0>
  <cfif thisTag.executionMode eq "start">
    <cfset caller.cfspec.scope = listAppend(caller.cfspec.scope, caller.cfspec.current & "[")>
  <cfelseif thisTag.executionMode eq "end">
    <cfset caller.cfspec.scope = listAppend(caller.cfspec.scope, caller.cfspec.current & "]")>
  </cfif>
</cfif>
<cfif caller.cfspec.target neq caller.cfspec.current>
  <cfexit method="exitTemplate">
</cfif>

<cfif thisTag.executionMode eq "start">
  <cfset arrayPrepend(caller.cfspec.context, structNew())>
  <cfoutput>
    <h2>#attributes.hint#</h2>
    <div>
  </cfoutput>

<cfelseif thisTag.executionMode eq "end">
  <cfset arrayDeleteAt(caller.cfspec.context, 1)>
  <cfoutput>
    </div>
  </cfoutput>

</cfif>