<cfcomponent extends="Matcher" output="false">

  <cffunction name="onMissingMethod" returntype="any" output="false">
    <cfargument name="missingMethodName" type="string" required="true">
    <cfargument name="missingMethodArguments" type="any" required="true">
    <cfset var value = "">
    <cfset var args = missingMethodArguments>
    <cfset var flatArgs = "">
    <cfset var i = "">
    <cfset var md = reFindNoCase("^matchBe(.+)$", missingMethodName, 1, true)>
    <cfif md.len[1]>
      <cfloop index="i" from="1" to="#arrayLen(args)#">
        <cfset flatArgs = listAppend(flatArgs, "args[#i#]")>
      </cfloop>      
      <cfreturn evaluate("obj.is#mid(missingMethodName, md.pos[2], md.len[2])#(#flatArgs#)")>
    </cfif>

    <cfthrow message="Missing method: #missingMethodName#">
  </cffunction>

  <cffunction name="matchBeAnInstanceOf">
    <cfargument name="expected" type="string" required="true">
    <cfreturn isInstanceOf(obj, expected)>
  </cffunction>

</cfcomponent>