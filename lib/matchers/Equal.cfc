<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(type, noCase, expected) {
    $type = type;
    $noCase = len(noCase);
    $expected = expected;
    return this;
  }

  function isMatch(actual) {
    $actual = actual;
    switch ($type) {
      case "Numeric": return isEqualNumeric($actual, $expected);
      case "Date":    return isEqualDate($actual, $expected);
      case "Boolean": return isEqualBoolean($actual, $expected);
      case "String":  return isEqualString($actual, $expected);
      case "Object":  return isEqualObject($actual, $expected);
      case "Struct":  return isEqualStruct($actual, $expected);
      case "Array":    return isEqualArray($actual, $expected);
      case "Query":    return isEqualQuery($actual, $expected);
      default:        return isEqual($actual, $expected);
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
    if (isSimpleValue(a) && isSimpleValue(b)) {
      if (isNumeric(a) && isNumeric(b)) return isEqualNumeric(a, b);
      if (isDate(a) && isDate(b))       return isEqualDate(a, b);
      if (listFindNoCase("true,false,yes,no", a) && listFindNoCase("true,false,yes,no", b)) return isEqualBoolean(a, b);
      return isEqualString(a, b);
    } else if (isObject(a) && isObject(b)) {
      return isEqualObject(a, b);
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