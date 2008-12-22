<cfcomponent>

  <cffunction name="init" returntype="Expectations">
    <cfargument name="obj" type="any" required="true">
    <cfset variables.obj = arguments.obj>
    <cfif isSimpleValue(obj)>
      <cfset variables.matcher = createObject("component", "cfspec.matchers.SimpleMatcher").init(obj)>
    <cfelseif isObject(obj)>
      <cfset variables.matcher = createObject("component", "cfspec.matchers.ObjectMatcher").init(obj)>
    <cfelseif isArray(obj)>
      <cfset variables.matcher = createObject("component", "cfspec.matchers.ArrayMatcher").init(obj)>
    <cfelseif isStruct(obj)>
      <cfset variables.matcher = createObject("component", "cfspec.matchers.StructMatcher").init(obj)>
    </cfif>
    <cfreturn this>
  </cffunction>

  <cffunction name="onMissingMethod" returntype="any" output="false">
    <cfargument name="missingMethodName" type="string" required="true">
    <cfargument name="missingMethodArguments" type="any" required="true">
    <cfset var value = "">
    <cfset var md = reFindNoCase("^should(not)?(.+)$", missingMethodName, 1, true)>
    <cfif not md.len[1]>
      <cfif isObject(obj)>
        <cfreturn _passItOn(missingMethodName, missingMethodArguments)>
      </cfif>
      <cfthrow message="Missing method: #missingMethodName#">
    </cfif>

    <cfset value = match(mid(missingMethodName, md.pos[3], md.len[3]), missingMethodArguments)>
    <cfif md.len[2] eq 3><cfset value = not value></cfif>
    <cfif not value>
      <cfthrow type="cfspec" message="DID NOT MEET EXPECTATION">
    </cfif>
  </cffunction>

  <cffunction name="_passItOn">
    <cfargument name="name" type="string" required="true">
    <cfargument name="args" type="any" required="true">
    <cfset var result = evaluate("obj.#name#(argumentCollection=args)")>
    <cfif isDefined("result")>
      <cfset result = createObject("component", "Expectations").init(result)>
    </cfif>
    <cfreturn result>
  </cffunction>

  <cffunction name="match" returntype="boolean" output="false">
    <cfargument name="expectation" type="any" required="true">
    <cfargument name="args" type="any" required="true">
    <cfreturn evaluate("variables.matcher.match#expectation#(argumentCollection=args)")>
  </cffunction>

</cfcomponent>