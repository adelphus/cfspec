<cffunction name="shouldBeEmpty" output="false">
  <cfif not _isEmpty(actual)>
    <cfset runner.fail("Expected to be empty, got '#serializeJson(actual)#'.")>
  </cfif>
</cffunction>

<cffunction name="shouldNotBeEmpty" output="false">
  <cfif _isEmpty(actual)>
    <cfset runner.fail("Expected not to be empty, got '#serializeJson(actual)#'.")>
  </cfif>
</cffunction>

<cffunction name="_isEmpty" access="private" output="false">
  <cfargument name="actual">
  <cfif isSimpleValue(actual) and trim(actual) eq "">
    <cfreturn true>
  <cfelseif isObject(actual)>
    <cfreturn actual.isEmpty()>
  <cfelseif isStruct(actual) and structIsEmpty(actual)>
    <cfreturn true>
  <cfelseif isArray(actual) and arrayIsEmpty(actual)>
    <cfreturn true>
  <cfelseif isQuery(actual) and actual.recordCount eq 0>
    <cfreturn true>
  <cfelse>
    <cfreturn false>
  </cfif>  
</cffunction>