<cfsetting enableCfoutputOnly="true">
<cfif thisTag.executionMode eq "start">
  <cfset caller.this._updateCurrentIteration(getBaseTagList())>
  <cfif caller.cfspec.trialRun>
    <cfset arrayAppend(caller.cfspec.hierarchy, caller.cfspec.currentIteration)>
    <cfexit method="exitTag">
  <cfelseif caller.cfspec.currentIteration eq caller.cfspec.targetIteration>
    <cfset caller.cfspec.bodyText = attributes.should>
  <cfelse>
    <cfexit method="exitTag">
  </cfif>
</cfif>