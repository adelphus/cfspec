<cfcomponent extends="Matcher" output="false">

  <cffunction name="onMissingMethod" returntype="any" output="false">
    <cfargument name="missingMethodName" type="string" required="true">
    <cfargument name="missingMethodArguments" type="any" required="true">
    <cfset var value = "">

    <cfset var md = reFindNoCase("^matchBe(.+)$", missingMethodName, 1, true)>
    <cfif md.len[1]>
      <cfreturn evaluate("obj.is#mid(missingMethodName, md.pos[2], md.len[2])#()")>
    </cfif>

    <cfthrow message="Missing method: #missingMethodName#">
  </cffunction>

  <cffunction name="matchBeInstanceOf">
    <cfargument name="expected" type="string" required="true">
    <cfreturn isInstanceOf(obj, expected)>
  </cffunction>

</cfcomponent>