<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(noCase) {
    $noCase = len(noCase);
    return this;
  }

  function setArguments() {
    var i = "";
    if (arrayLen(arguments) < 1) throw("Application", "The Contain matcher expected at least 1 argument, got #arrayLen(arguments)#.");
    $expected = [];
    for (i = 1; i <= arrayLen(arguments); i++) {
      arrayAppend($expected, arguments[i]);
    }
  }

  function isMatch(actual) {
    var eqMatcher = createObject("component", "cfspec.lib.matchers.Equal").init("", iif($noCase, de("NoCase"), de("")));
    var result = "";
    var row = "";
    var key = "";
    var i = "";
    var j = "";
    $actual = actual;

    if (isSimpleValue($actual)) {
      if ($noCase) {
        for (i = 1; i <= arrayLen($expected); i++) {
          if (not isSimpleValue($expected[i])) throw("Application", "The EXPECTED parameters to the Contain matcher must be simple values.");
          if (not reFindNoCase($expected[i], actual)) return false;
        }
      } else {
        for (i = 1; i <= arrayLen($expected); i++) {
          if (not isSimpleValue($expected[i])) throw("Application", "The EXPECTED parameters to the Contain matcher must be simple values.");
          if (not reFind($expected[i], actual)) return false;
        }
      }
      return true;

    } else if (isObject($actual)) {
       for (i = 1; i <= arrayLen($expected); i++) {
         try {
           result = $actual.hasElement($expected[i]);
         } catch (Application e) {
          if (e.message != "The method hasElement was not found.") rethrow(e);
           try {
             result = $actual.contains($expected[i]);
           } catch (Application e) {
            if (e.message != "The method contains was not found.") rethrow(e);
            throw("cfspec.fail", "Contain expected actual.hasElement(expected) or actual.contains(expected) to return a boolean, but neither method was not found.");
          }
        }
        if (not isBoolean(result)) throw("cfspec.fail", "Contain expected actual.hasElement(expected) or actual.contains(expected) to return a boolean, got #inspect(result)#");
        if (!result) return false;
      }
      return true;

    } else if (isStruct($actual)) {
       for (i = 1; i <= arrayLen($expected); i++) {
         if (isSimpleValue($expected[i])) {
           if (!structKeyExists($actual, $expected[i])) return false;
         } else if (isStruct($expected[i])) {
           for (key in $expected[i]) {
             if (!structKeyExists($actual, key)) return false;
             eqMatcher.setArguments($actual[key]);
             if (!eqMatcher.isMatch($expected[i][key])) return false;
           }
         } else {
          throw("Application", "The EXPECTED parameters to the Contain matcher must be simple values or structs.");
         }
       }
       return true;

    } else if (isArray($actual)) {
       for (i = 1; i <= arrayLen($expected); i++) {
        result = false;
         for (j = 1; j <= arrayLen($actual); j++) {
           eqMatcher.setArguments($actual[j]);
           if (eqMatcher.isMatch($expected[i])) {
             result = true;
             break;
           }
         }
         if (!result) return false;
       }
       return true;

    } else if (isQuery($actual)) {
       for (i = 1; i <= arrayLen($expected); i++) {
         if (isSimpleValue($expected[i])) {
           if (!listFindNoCase($actual.columnList, $expected[i])) return false;
         } else if (isStruct($expected[i])) {
           for (key in $expected[i]) {
             if (!listFindNoCase($actual.columnList, key)) return false;
           }
           result = false;
           for (j = 1; j <= $actual.recordCount; j++) {
             row = true;
             for (key in $expected[i]) {
               eqMatcher.setArguments($actual[key][j]);
               if (!eqMatcher.isMatch($expected[i][key])) {
                 row = false;
                 break;
               }
             }
             if (row) {
               result = true;
               break;
             }
           }
           if (!result) return false;

         } else {
          throw("Application", "The EXPECTED parameters to the Contain matcher must be simple values or structs.");
         }
       }
       return true;

    }
    return false;
  }

  function getFailureMessage() {
    return "expected to contain #prettyPrint($expected)#, got #inspect($actual)#";
  }

  function getNegativeFailureMessage() {
    return "expected not to contain #prettyPrint($expected)#, got #inspect($actual)#";
  }

  function getDescription() {
    return "contain #prettyPrint($expected)#";
  }

  function prettyPrint(e) {
    var s = inspect(e[1]);
    var l = arrayLen(e);
    var i = "";
    for (i = 2; i < l; i++) {
      s = s & ", " & inspect(e[i]);
    }
    if (l > 1) {
      s = s & " and " & inspect(e[l]);
    }
    return s;
  }

</cfscript></cfcomponent>