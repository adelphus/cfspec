<cffunction name="runSpecs">
  <cfargument name="path">
  <cfset var files = "">
  <cfdirectory action="list" directory="#expandPath(path)#" name="files">
  <cfloop query="files">
    <cfif type eq "dir" and left(name, 1) neq ".">
      <cfset runSpecs("#path#/#name#")>
    <cfelseif type eq "file" and findNoCase("Spec.cfm", name)>
      <cfinclude template="#path#/#name#">
    </cfif>  
  </cfloop>
</cffunction>

<cfset runSpecs('.')>