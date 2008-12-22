<cfdirectory action="list" directory="#expandPath('.')#" name="dir" filter="*Spec.cfc">

<cfloop query="dir">
  <cfset cfcName = left(name, len(name) - 4)>
  <cfoutput>
    <h1>#cfcName#</h1>
    #createObject("component", cfcName).run()#
  </cfoutput>
</cfloop>