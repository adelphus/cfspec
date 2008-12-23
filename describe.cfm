<cfif thisTag.executionMode eq "start" and not isDefined("caller.cfspec.target")>
  <cfset specRunner = createObject("component", "cfspec.lib.SpecRunner").init(getBaseTemplatePath())>
  <cfoutput>#specRunner.run()#</cfoutput>
  <cfexit method="exitTag">

<cfelseif thisTag.executionMode eq "start">
  <cfset caller.cfspec.current += 1>
  <cfif caller.cfspec.current neq caller.cfspec.target>
    <cfexit method="exitTemplate">
  </cfif>

  <cfoutput>
    <h2>#attributes.hint#</h2>
    <div>
  </cfoutput>

<cfelseif thisTag.executionMode eq "end">
  <cfset caller.cfspec.current += 1>
  <cfif caller.cfspec.current neq caller.cfspec.target>
    <cfexit method="exitTemplate">
  </cfif>
  <cfoutput>
    </div>
  </cfoutput>

</cfif>