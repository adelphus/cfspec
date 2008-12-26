<cffunction name="shouldEqualString" output="false">
  <cfargument name="expected">
  <cfif not _isEqualString(actual, expected)>
    <cfset runner.fail("expected '#expected#', got '#actual#' (case-sensitive)")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualString" output="false">
  <cfargument name="expected">
  <cfif _isEqualString(actual, expected)>
    <cfset runner.fail("expected '#expected#' not to equal '#actual#' (case-sensitive)")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualStringNoCase" output="false">
  <cfargument name="expected">
  <cfif not _isEqualStringNoCase(actual, expected)>
    <cfset runner.fail("expected '#expected#', got '#actual#' (case-insensitive)")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualStringNoCase" output="false">
  <cfargument name="expected">
  <cfif _isEqualStringNoCase(actual, expected)>
    <cfset runner.fail("expected '#expected#' not to equal '#actual#' (case-insensitive)")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualNumber" output="false">
  <cfargument name="expected">
  <cfif not _isEqualNumber(actual, expected)>
    <cfset runner.fail("expected #val(expected)#, got #val(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualNumber" output="false">
  <cfargument name="expected">
  <cfif _isEqualNumber(actual, expected)>
    <cfset runner.fail("expected #val(expected)# not to equal #val(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualBoolean" output="false">
  <cfargument name="expected">
  <cfif not _isEqualBoolean(actual, expected)>
    <cfset runner.fail("expected #yesNoFormat(expected)#, got #yesNoFormat(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualBoolean" output="false">
  <cfargument name="expected">
  <cfif _isEqualBoolean(actual, expected)>
    <cfset runner.fail("expected #yesNoFormat(expected)# not to equal #yesNoFormat(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualDate" output="false">
  <cfargument name="expected">
  <cfif not _isEqualDate(actual, expected)>
    <cfset runner.fail("expected #dateFormat(expected)# #timeFormat(expected)#, got #dateFormat(actual)# #timeFormat(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualDate" output="false">
  <cfargument name="expected">
  <cfif _isEqualDate(actual, expected)>
    <cfset runner.fail("expected #dateFormat(expected)# #timeFormat(expected)# not to equal #dateFormat(actual)# #timeFormat(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualObject" output="false">
  <cfargument name="expected">
  <cfif not _isEqualObject(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)#, got #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualObject" output="false">
  <cfargument name="expected">
  <cfif _isEqualObject(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)# not to equal #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualObjectNoCase" output="false">
  <cfargument name="expected">
  <cfif not _isEqualObjectNoCase(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)#, got #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualObjectNoCase" output="false">
  <cfargument name="expected">
  <cfif _isEqualObjectNoCase(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)# not to equal #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualStruct" output="false">
  <cfargument name="expected">
  <cfif not _isEqualStruct(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)#, got #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualStruct" output="false">
  <cfargument name="expected">
  <cfif _isEqualStruct(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)# not to equal #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualStructNoCase" output="false">
  <cfargument name="expected">
  <cfif not _isEqualStructNoCase(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)#, got #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualStructNoCase" output="false">
  <cfargument name="expected">
  <cfif _isEqualStructNoCase(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)# not to equal #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualArray" output="false">
  <cfargument name="expected">
  <cfif not _isEqualArray(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)#, got #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualArray" output="false">
  <cfargument name="expected">
  <cfif _isEqualArray(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)# not to equal #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualArrayNoCase" output="false">
  <cfargument name="expected">
  <cfif not _isEqualArrayNoCase(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)#, got #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualArrayNoCase" output="false">
  <cfargument name="expected">
  <cfif _isEqualArrayNoCase(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)# not to equal #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualQuery" output="false">
  <cfargument name="expected">
  <cfif not _isEqualQuery(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)#, got #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualQuery" output="false">
  <cfargument name="expected">
  <cfif _isEqualQuery(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)# not to equal #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualQueryNoCase" output="false">
  <cfargument name="expected">
  <cfif not _isEqualQueryNoCase(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)#, got #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualQueryNoCase" output="false">
  <cfargument name="expected">
  <cfif _isEqualQueryNoCase(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)# not to equal #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqual" output="false">
  <cfargument name="expected">
  <cfif not _isEqual(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)#, got #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqual" output="false">
  <cfargument name="expected">
  <cfif _isEqual(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)# not to equal #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldEqualNoCase" output="false">
  <cfargument name="expected">
  <cfif not _isEqualNoCase(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)#, got #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="shouldNotEqualNoCase" output="false">
  <cfargument name="expected">
  <cfif _isEqualNoCase(actual, expected)>
    <cfset runner.fail("expected #serializeJson(expected)# not to equal #serializeJson(actual)#")>
  </cfif>
</cffunction>

<cffunction name="_isEqualString" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn compare(actual, expected) eq 0>
</cffunction>

<cffunction name="_isEqualStringNoCase" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn compareNoCase(actual, expected) eq 0>
</cffunction>

<cffunction name="_isEqualNumber" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn val(actual) eq val(expected)>
</cffunction>

<cffunction name="_isEqualBoolean" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn actual eqv expected>
</cffunction>

<cffunction name="_isEqualDate" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn dateCompare(actual, expected) eq 0>
</cffunction>

<cffunction name="_isEqualObject" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn actual.isEqual(expected)>
</cffunction>

<cffunction name="_isEqualObjectNoCase" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfreturn actual.isEqualNoCase(expected)>
</cffunction>

<cffunction name="_isEqualStruct" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfset var key = "">
  <cfif listSort(structKeyList(actual), "textnocase") neq listSort(structKeyList(expected), "textnocase")>
    <cfreturn false>
  </cfif>
  <cfloop collection="#actual#" item="key">
    <cfif not _isEqual(actual[key], expected[key])>
      <cfreturn false>
    </cfif>
  </cfloop>
  <cfreturn true>
</cffunction>

<cffunction name="_isEqualStructNoCase" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfset var key = "">
  <cfif listSort(structKeyList(actual), "textnocase") neq listSort(structKeyList(expected), "textnocase")>
    <cfreturn false>
  </cfif>
  <cfloop collection="#actual#" item="key">
    <cfif not _isEqualNoCase(actual[key], expected[key])>
      <cfreturn false>
    </cfif>
  </cfloop>
  <cfreturn true>
</cffunction>

<cffunction name="_isEqualArray" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfset var i = "">
  <cfif arrayLen(actual) neq arrayLen(expected)>
    <cfreturn false>
  </cfif>
  <cfloop index="i" from="1" to="#arrayLen(actual)#">
    <cfif not _isEqual(actual[i], expected[i])>
      <cfreturn false>
    </cfif>
  </cfloop>
  <cfreturn true>
</cffunction>

<cffunction name="_isEqualArrayNoCase" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfset var i = "">
  <cfif arrayLen(actual) neq arrayLen(expected)>
    <cfreturn false>
  </cfif>
  <cfloop index="i" from="1" to="#arrayLen(actual)#">
    <cfif not _isEqualNoCase(actual[i], expected[i])>
      <cfreturn false>
    </cfif>
  </cfloop>
  <cfreturn true>
</cffunction>

<cffunction name="_isEqualQuery" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfset var key = "">
  <cfset var i = "">
  <cfif actual.recordCount neq expected.recordCount>
    <cfreturn false>
  </cfif>
  <cfif listSort(actual.columnList, "textnocase") neq listSort(expected.columnList, "textnocase")>
    <cfreturn false>
  </cfif>
  <cfloop index="i" from="1" to="#actual.recordCount#">
    <cfloop list="#actual.columnList#" index="key">
      <cfif not _isEqual(evaluate("actual.#key#[i]"), evaluate("expected.#key#[i]"))>
        <cfreturn false>
      </cfif>
    </cfloop>
  </cfloop>
  <cfreturn true>
</cffunction>

<cffunction name="_isEqualQueryNoCase" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfset var key = "">
  <cfset var i = "">
  <cfif actual.recordCount neq expected.recordCount>
    <cfreturn false>
  </cfif>
  <cfif listSort(actual.columnList, "textnocase") neq listSort(expected.columnList, "textnocase")>
    <cfreturn false>
  </cfif>
  <cfloop index="i" from="1" to="#actual.recordCount#">
    <cfloop list="#actual.columnList#" index="key">
      <cfif not _isEqualNoCase(evaluate("actual.#key#[i]"), evaluate("expected.#key#[i]"))>
        <cfreturn false>
      </cfif>
    </cfloop>
  </cfloop>
  <cfreturn true>
</cffunction>

<cffunction name="_isEqual" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfif isSimpleValue(expected) and isSimpleValue(actual)>
    <cfif isDate(actual) and isDate(expected)>
      <cfreturn _isEqualDate(actual, expected)>
    <cfelseif isNumeric(actual) and isNumeric(expected)>
      <cfreturn _isEqualNumber(actual, expected)>
    <cfelseif listFindNoCase("true,false,yes,no", actual) and listFindNoCase("true,false,yes,no", expected)>
      <cfreturn _isEqualBoolean(actual, expected)>
    <cfelse>
      <cfreturn _isEqualString(actual, expected)>
    </cfif>
  <cfelseif isObject(expected) and isObject(actual)>
    <cfreturn _isEqualObject(actual, expected)>
  <cfelseif isStruct(expected) and isStruct(actual)>
    <cfreturn _isEqualStruct(actual, expected)>
  <cfelseif isArray(expected) and isArray(actual)>
    <cfreturn _isEqualArray(actual, expected)>
  <cfelseif isQuery(expected) and isQuery(actual)>
    <cfreturn _isEqualQuery(actual, expected)>
  <cfelse>
    <cfreturn false>
  </cfif>
</cffunction>

<cffunction name="_isEqualNoCase" access="private" output="false">
  <cfargument name="actual">
  <cfargument name="expected">
  <cfif isSimpleValue(expected) and isSimpleValue(actual)>
    <cfif isDate(actual) and isDate(expected)>
      <cfreturn _isEqualDate(actual, expected)>
    <cfelseif isNumeric(actual) and isNumeric(expected)>
      <cfreturn _isEqualNumber(actual, expected)>
    <cfelseif listFindNoCase("true,false,yes,no", actual) and listFindNoCase("true,false,yes,no", expected)>
      <cfreturn _isEqualBoolean(actual, expected)>
    <cfelse>
      <cfreturn _isEqualStringNoCase(actual, expected)>
    </cfif>
  <cfelseif isObject(expected) and isObject(actual)>
    <cfreturn _isEqualObjectNoCase(actual, expected)>
  <cfelseif isStruct(expected) and isStruct(actual)>
    <cfreturn _isEqualStructNoCase(actual, expected)>
  <cfelseif isArray(expected) and isArray(actual)>
    <cfreturn _isEqualArrayNoCase(actual, expected)>
  <cfelseif isQuery(expected) and isQuery(actual)>
    <cfreturn _isEqualQueryNoCase(actual, expected)>
  <cfelse>
    <cfreturn false>
  </cfif>
</cffunction>