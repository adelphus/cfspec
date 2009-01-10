<cfset runner = createObject("component", "cfspec.lib.SpecRunner")>
<cfif not isDefined("runSpecs")>
  <cffunction name="runSpecs">
    <cfargument name="path">
    <cfset var files = "">
    <cfdirectory action="list" directory="#path#" name="files">
    <cfloop query="files">
      <cfif type eq "dir" and left(name, 1) neq ".">
        <cfset runSpecs("#path#/#name#")>
      <cfelseif type eq "file" and findNoCase("Spec.cfm", name)>
        <cfoutput>#runner.runSpec("#path#/#name#")#</cfoutput>
      </cfif>  
    </cfloop>
  </cffunction>
</cfif>
<cfset runSpecs(getDirectoryFromPath(getBaseTemplatePath()))>