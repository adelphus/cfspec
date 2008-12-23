<cfcomponent extends="Matcher" output="false">

  <cffunction name="matchEqual">
    <cfargument name="expected" type="any" required="true">
    <cfset var i = "">
    <cfset var args = "">
    <cfif isArray(expected) and arrayLen(obj) eq arrayLen(expected)>
      <cfloop index="i" from="1" to="#arrayLen(obj)#">
        <cfset args = { expected = expected[i] }>
        <cfif not createObject("component", "cfspec.Expectations").init(obj[i]).match("equal", args)>
          <cfreturn false>
        </cfif>
      </cfloop>
      <cfreturn true>
    </cfif>
    <cfreturn false>
  </cffunction>

  <cffunction name="matchEqualNoCase">
    <cfargument name="expected" type="any" required="true">
    <cfset var i = "">
    <cfset var args = "">
    <cfif isArray(expected) and arrayLen(obj) eq arrayLen(expected)>
      <cfloop index="i" from="1" to="#arrayLen(obj)#">
        <cfset args = { expected = expected[i] }>
        <cfif not createObject("component", "cfspec.Expectations").init(obj[i]).match("equalNoCase", args)>
          <cfreturn false>
        </cfif>
      </cfloop>
      <cfreturn true>
    </cfif>
    <cfreturn false>
  </cffunction>

  <cffunction name="matchBeEmpty">
    <cfreturn arrayLen(obj) eq 0>
  </cffunction>

</cfcomponent>