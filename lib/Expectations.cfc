<cfcomponent output="false"><cfscript>

	$matchers = [
		"Equal(Number|Date|Boolean|String|Object|Struct|Array|Query)?(NoCase)?/Equal",
		"Be(.+)/Be"
	];

	function init(runner, target) {
		$runner = runner;
		$target = target;
		return this;
	}

	function onMissingMethod(missingMethodName, missingMethodArguments) {
		var regexp = "";
		var matchData = "";
		var matcher = "";
		var args = "";
		var flatArgs = "";
		var result = "";
		var i = "";
		var j = "";
		var k = "";

		for (i = 1; i <= arrayLen($matchers); i++) {
			regexp = $matchers[i];
			matchData = reFindNoCase("^should(Not)?#listFirst(regexp, '/')#$", missingMethodName, 1, true);
			if (matchData.len[1]) {
				k = 1;
				args = [];
				for (j = 3; j <= arrayLen(matchData.len); j++) {
					if (matchData.len[j]) arrayAppend(args, mid(missingMethodName, matchData.pos[j], matchData.len[j]));
					else arrayAppend(args, "");
					flatArgs = listAppend(flatArgs, "args[#k#]");
					k++;
				}
				for (j = 1; j <= arrayLen(missingMethodArguments); j++) {
					arrayAppend(args, missingMethodArguments[j]);
					flatArgs = listAppend(flatArgs, "args[#k#]");
					k++;
				}

				matcher = createObject("component", "cfspec.lib.matchers.#listLast(regexp, '/')#");
				evaluate("matcher.init(#flatArgs#)");

				if (matcher.isDelayed()) return matcher;

				negate = matchData.len[2];
				result = matcher.isMatch($target);

				if (result eqv negate) {
					if (negate) {
						return $runner.fail(matcher.getNegativeFailureMessage());
					} else {
						return $runner.fail(matcher.getFailureMessage());
					}
				}
				return true;
			}
		}

		if (isObject($target)) {
			result = evaluate("$target.#missingMethodName#(argumentCollection=arguments.missingMethodArguments)");
			return $runner.$(result);
		}

		$runner.fail("Missing Method: #missingMethodName#");
	}

</cfscript></cfcomponent>

<!---

  <cfset matchers = []>
  <cfdirectory action="list" directory="#expandPath('/cfspec/lib/matchers')#" filter="*.cfm" name="dir">
  <cfloop query="dir">
    <cfinclude template="matchers/#name#">
  </cfloop>

  <cffunction name="init" returntype="Expectations" output="false">
    <cfargument name="runner" type="any" required="true">
    <cfargument name="actual" type="any" required="true">
    <cfset variables.runner = arguments.runner>
    <cfset variables.actual = arguments.actual>
    <cfreturn this>
  </cffunction>

  <cffunction name="onMissingMethod" returntype="any" output="false">
    <cfargument name="missingMethodName" type="string" required="true">
    <cfargument name="missingMethodArguments" type="any" required="true">
    <cfset var matcher = "">
    <cfset var matchData = "">
    <cfset var flatArgs = "">
    <cfset var args = []>
    <cfset var i = "">
    <cfset var result = "">

    <cfloop array="#matchers#" index="matcher">
      <cfset matchData = reFindNoCase(listFirst(matcher, "/"), missingMethodName, 1, true)>
      <cfif matchData.len[1]>
        <cfloop index="i" from="2" to="#arrayLen(matchData.len)#">
          <cfset arrayAppend(args, mid(missingMethodName, matchData.pos[i], matchData.len[i]))>
          <cfset flatArgs = listAppend(flatArgs, "args[#(i-1)#]")>
        </cfloop>
        <cfset flatArgs = listAppend(flatArgs, "arguments.missingMethodArguments")>
        <cfset evaluate("#listRest(matcher, '/')#(#flatArgs#)")>
        <cfreturn true>
      </cfif>
    </cfloop>

    <cfif isObject(actual)>
      <cftry>
        <cfset result = evaluate("actual.#missingMethodName#(argumentCollection=arguments.missingMethodArguments)")>
        <cfreturn runner.$(result)>
        <cfcatch type="any">
          <cfset runner.setException(cfcatch)>
          <cfreturn createObject("component", "ExceptionExpectations").init(runner, cfcatch)>
        </cfcatch>
      </cftry>
    </cfif>

    <cfthrow message="Missing method: #missingMethodName#">
  </cffunction>

  <cffunction name="shouldNotThrow" output="false">
  </cffunction>

--->