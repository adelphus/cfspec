<cfsilent>

<cfif thisTag.executionMode eq "start">
  <cfset exitMethod = caller.__cfspecRunner.stepTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
</cfif>

</cfsilent>
