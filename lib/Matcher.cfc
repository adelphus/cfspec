<cfcomponent extends="Base" output="false">

  <cffunction name="requireArgs">
    <cfargument name="args">
    <cfargument name="count">
    <cfargument name="relation" default="">
    <cfset var argCount = arrayLen(args)>
    <cfset var op = "eq">
    <cfif relation eq "at least"><cfset op = "ge"></cfif>
    <cfif relation eq "at most"> <cfset op = "le"></cfif>

    <cfif not evaluate("argCount #op# count")>
      <cfthrow message="The #_matcherName# matcher expected #trim(relation & ' ' & count)# argument(s), got #argCount#.">
    </cfif>
  </cffunction>

  <cffunction name="verifyArg">
    <cfargument name="verified">
    <cfargument name="argName">
    <cfargument name="message">
    <cfif not verified>
      <cfthrow message="The #uCase(argName)# parameter to the #_matcherName# matcher #message#.">
    </cfif>
  </cffunction>


<cfscript>

  function init() {
  	return this;
  }

  function isDelayed() {
    if (isDefined("$runner")) $runner.flagDelayedMatcher(false);
    return false;
  }
  
  function isChained() {
    return false;
  }

  function setRunner(runner) {
    $runner = runner;
    _runner = runner;
  }

  function setExpectations(expectations) {
    $expectations = expectations;
    _expectations = expectations;
  }

  function setArguments() {}
  
  function inspect(value) {
    var keys = "";
    var data = "";
    var row = "";
    var s = "";
    var i = "";
    var j = "";

    if (isSimpleValue(value)) {
      if (isNumeric(value)) return value;
      if (isDate(value)) return dateFormat(value, "yyyy-mm-dd") & " " & timeFormat(value, "hh:mm tt");
      if (listFindNoCase("true,false,yes,no", value)) return iif(value, 'true', 'false');
      return "'#replace(replace(value, '\', '\\', 'all'), "'", "\'", 'all')#'";

    } else if (isObject(value)) {
      try {
        value = value.inspect();
        if (isSimpleValue(value)) return value;
      } catch (Any e) {}
      return "&lt;#getMetaData(value).name#:???&gt;";

    } else if (isStruct(value)) {
      keys = listToArray(listSort(structKeyList(value), "textnocase"));
      for (i = 1; i <= arrayLen(keys); i++) {
        s = listAppend(s, "#keys[i]#=#inspect(value[keys[i]])#");
      }
      return "{#s#}";

    } else if (isArray(value)) {
      for (i = 1; i <= arrayLen(value); i++) {
        s = listAppend(s, inspect(value[i]));
      }
      return "[#s#]";

    } else if (isQuery(value)) {
      keys = listToArray(listSort(value.columnList, "textnocase"));
      for (i = 1; i <= arrayLen(keys); i++) {
        s = listAppend(s, "#inspect(keys[i])#");
      }
      for (i = 1; i <= value.recordCount; i++) {
        row = "";
        for (j = 1; j <= arrayLen(keys); j++) {
          row = listAppend(row, inspect(value[keys[j]][i]));
        }
        data = listAppend(data, "[#row#]");
      }
      return "{COLUMNS=[#s#],DATA=[#data#]}";

    }
    return serializeJson(value);
  }

</cfscript></cfcomponent>
