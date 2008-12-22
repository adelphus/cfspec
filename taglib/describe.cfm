<cfsetting enableCfoutputOnly="true">
<cfif thisTag.executionMode eq "start">
  <cfset caller.this._updateCurrentIteration(getBaseTagList())>
  <cfif caller.cfspec.trialRun>
    <cfset arrayAppend(caller.cfspec.hierarchy, caller.cfspec.currentIteration)>
    <cfexit method="exitTemplate">
  <cfelseif caller.cfspec.currentIteration eq caller.cfspec.targetIteration>
    <cfset caller.cfspec.headerText = attributes.hint>
    <cfif structKeyExists(attributes, "component")>
      <cfset caller.cfspec.headerText = attributes.component & " (#attributes.hint#)">
      <cfset "caller.$#listLast(attributes.component, '.')#" = caller.$(createObject("component", attributes.component).init())>
    </cfif>
  <cfelse>
    <cfexit method="exitTemplate">
  </cfif>
</cfif>