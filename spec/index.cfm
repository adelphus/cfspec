<cfdirectory action="list" directory="#expandPath('.')#" filter="*Spec.cfm" name="specs">
<cfloop query="specs"><cfinclude template="#name#"></cfloop>