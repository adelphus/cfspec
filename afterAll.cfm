<cfsilent>

<cfif thisTag.executionMode eq "start">
  <cfset exitMethod = caller.__cfspecRunner.afterAllStartTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
<cfelse>
  <cfset exitMethod = caller.__cfspecRunner.afterAllEndTag(attributes)>
  <cfif exitMethod neq "">
    <cfexit method="#exitMethod#">
  </cfif>
</cfif>

</cfsilent>