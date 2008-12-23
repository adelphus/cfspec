<cfcomponent extends="Matcher" output="false">

  <cffunction name="matchEqual">
    <cfargument name="expected" type="any" required="true">
    <cfset var key = "">
    <cfset var args = "">
    <cfif isStruct(expected) and listSort(ucase(structKeyList(obj)), "textnocase") eq listSort(ucase(structKeyList(expected)), "textnocase")>
      <cfloop collection="#obj#" item="key">
        <cfset args = [ expected[key] ]>
        <cfif not createObject("component", "cfspec.lib.Expectations").init(obj[key]).match("equal", args)>
          <cfreturn false>
        </cfif>
      </cfloop>
      <cfreturn true>
    </cfif>
    <cfreturn false>
  </cffunction>

  <cffunction name="matchEqualNoCase">
    <cfargument name="expected" type="any" required="true">
    <cfset var key = "">
    <cfset var args = "">
    <cfif isStruct(expected) and listSort(ucase(structKeyList(obj)), "textnocase") eq listSort(ucase(structKeyList(expected)), "textnocase")>
      <cfloop collection="#obj#" item="key">
        <cfset args = [ expected[key] ]>
        <cfif not createObject("component", "cfspec.lib.Expectations").init(obj[key]).match("equalNoCase", args)>
          <cfreturn false>
        </cfif>
      </cfloop>
      <cfreturn true>
    </cfif>
    <cfreturn false>
  </cffunction>

  <cffunction name="matchBeEmpty">
    <cfreturn structIsEmpty(obj)>
  </cffunction>

</cfcomponent>