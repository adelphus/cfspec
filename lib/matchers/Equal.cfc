<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(type, noCase) {
    $type = type;
    $noCase = len(noCase);
    return this;
  }
  
  function setArguments() {
    if (arrayLen(arguments) != 1) throw("Application", "The Equal#$type# matcher expected 1 argument, got #arrayLen(arguments)#.");
    $expected = arguments[1];
  }

  function isMatch(actual) {
    var result = "";
    $actual = actual;
    switch ($type) {

      case "Numeric":
        if (not isNumeric($expected)) throw("Application", "The EXPECTED parameter to the Equal#$type# matcher must be a number.");
        if (not isNumeric($actual)) throw("cfspec.fail", "Equal#$type# expected a number, got #inspect($actual)#");
        return isEqualNumeric($actual, $expected);

      case "Date":
        if (not isDate($expected)) throw("Application", "The EXPECTED parameter to the Equal#$type# matcher must be a date.");
        if (not isDate($actual)) throw("cfspec.fail", "Equal#$type# expected a date, got #inspect($actual)#");
        return isEqualDate($actual, $expected);

      case "Boolean":
        if (not isBoolean($expected)) throw("Application", "The EXPECTED parameter to the Equal#$type# matcher must be a boolean.");
        if (not isBoolean($actual)) throw("cfspec.fail", "Equal#$type# expected a boolean, got #inspect($actual)#");
        return isEqualBoolean($actual, $expected);

      case "String":
        if (not isSimpleValue($expected)) throw("Application", "The EXPECTED parameter to the Equal#$type# matcher must be a string.");
        if (not isSimpleValue($actual)) throw("cfspec.fail", "Equal#$type# expected a string, got #inspect($actual)#");
        return isEqualString($actual, $expected);

      case "Object":
        if (not isObject($expected)) throw("Application", "The EXPECTED parameter to the Equal#$type# matcher must be an object.");
        if (not isObject($actual)) throw("cfspec.fail", "Equal#$type# expected an object, got #inspect($actual)#");
        try {
          result = isEqualObject($actual, $expected);
        } catch (Application e) {
          if (e.message != "The method isEqualTo was not found.") rethrow(e);
          throw("cfspec.fail", "Equal#$type# expected actual.isEqualTo(expected) to return a boolean, but the method was not found.");
        }
        if (not isBoolean(result)) throw("cfspec.fail", "Equal#$type# expected actual.isEqualTo(expected) to return a boolean, got #inspect(result)#");
        return result;

      case "Struct":
        if (not isStruct($expected)) throw("Application", "The EXPECTED parameter to the Equal#$type# matcher must be a struct.");
        if (not isStruct($actual)) throw("cfspec.fail", "Equal#$type# expected a struct, got #inspect($actual)#");
        return isEqualStruct($actual, $expected);

      case "Array":
        if (not isArray($expected)) throw("Application", "The EXPECTED parameter to the Equal#$type# matcher must be an array.");
        if (not isArray($actual)) throw("cfspec.fail", "Equal#$type# expected an array, got #inspect($actual)#");
        return isEqualArray($actual, $expected);

      case "Query":
        if (not isQuery($expected)) throw("Application", "The EXPECTED parameter to the Equal#$type# matcher must be a query.");
        if (not isQuery($actual)) throw("cfspec.fail", "Equal#$type# expected a query, got #inspect($actual)#");
        return isEqualQuery($actual, $expected);

      default:
        return isEqual($actual, $expected);
    }
  }

  function getFailureMessage() {
    return "expected #inspect($expected)#, got #inspect($actual)#";
  }

  function getNegativeFailureMessage() {
    return "expected not to equal #inspect($expected)#, got #inspect($actual)#";
  }

  function getDescription() {
    return "equal #inspect($expected)#";
  }

  function isEqualNumeric(a, b) { return val(a) == val(b); }
  function isEqualDate(a, b)    { return dateCompare(a, b) == 0; }
  function isEqualBoolean(a, b) { return a eqv b; }
  function isEqualString(a, b)  { return iif($noCase, 'compareNoCase(a, b)', 'compare(a, b)') == 0; }

  function isEqualObject(a, b)   {
    return a.isEqualTo(b);
  }

  function isEqualStruct(a, b)   {
    var keys = "";
    var i = "";
    if (structCount(a) != structCount(b)) return false;
    keys = listSort(structKeyList(a), "textnocase");
    if (keys != listSort(structKeyList(b), "textnocase")) return false;
    keys = listToArray(keys);
    for (i = 1; i <= arrayLen(keys); i++) {
      if (!isEqual(a[keys[i]], b[keys[i]])) return false;
    }
    return true;
  }

  function isEqualArray(a, b)   {
    var i = "";
    if (arrayLen(a) != arrayLen(b)) return false;
    for (i = 1; i <= arrayLen(a); i++) {
      if (!isEqual(a[i], b[i])) return false;
    }
    return true;
  }

  function isEqualQuery(a, b)   {
    var keys = "";
    var i = "";
    var j = "";
    if (a.recordCount != b.recordCount) return false;
    keys = listSort(a.columnList, "textnocase");
    if (keys != listSort(b.columnList, "textnocase")) return false;
    keys = listToArray(keys);
    for (i = 1; i <= a.recordCount; i++) {
      for (j = 1; j <= arrayLen(keys); j++) {
        if (!isEqual(a[keys[i]][j], b[keys[i]][j])) return false;
      }
    }
    return true;
  }

  function isEqual(a, b) {
    var result = "";
    if (isSimpleValue(a) && isSimpleValue(b)) {
      if (isNumeric(a) && isNumeric(b)) return isEqualNumeric(a, b);
      if (isDate(a) && isDate(b))       return isEqualDate(a, b);
      if (listFindNoCase("true,false,yes,no", a) && listFindNoCase("true,false,yes,no", b)) return isEqualBoolean(a, b);
      return isEqualString(a, b);
    } else if (isObject(a) && isObject(b)) {
      try {
        result = isEqualObject(a, b);
      } catch (Application e) {
        if (e.message != "The method isEqualTo was not found.") rethrow(e);
        throw("cfspec.fail", "Equal#$type# expected actual.isEqualTo(expected) to return a boolean, but the method was not found.");
      }
      if (not isBoolean(result)) throw("cfspec.fail", "Equal#$type# expected actual.isEqualTo(expected) to return a boolean, got #inspect(result)#");
      return result;
    } else if (isStruct(a) && isStruct(b)) {
      return isEqualStruct(a, b);
    } else if (isArray(a) && isArray(b)) {
      return isEqualArray(a, b);
    } else if (isQuery(a) && isQuery(b)) {
      return isEqualQuery(a, b);
    }
    return false;
  }

</cfscript></cfcomponent>