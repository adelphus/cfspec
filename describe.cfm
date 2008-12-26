<cfsetting enableCfoutputOnly="true">

<cfif not isDefined("caller.cfspec.target")>
  <cfset specRunner = createObject("component", "cfspec.lib.SpecRunner").init(getBaseTemplatePath())>
  <cfoutput>#specRunner.run()#</cfoutput>
  <cfabort>
</cfif>

<cfset caller.cfspec.current++>
<cfif caller.cfspec.target neq caller.cfspec.current>
  <cfexit method="exitTemplate">
</cfif>

<cfif thisTag.executionMode eq "start">
  <cfoutput>
    <h2>#attributes.hint#</h2>
    <div>
  </cfoutput>

<cfelseif thisTag.executionMode eq "end">
  <cfoutput>
    </div>
  </cfoutput>

</cfif>