<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(predicate) {
    var i = "";
    $predicate = predicate;
    $args = [];
    $flatArgs = "";
    for (i = 2; i <= arrayLen(arguments); i++) {
      arrayAppend($args, arguments[i]);
      $flatArgs = listAppend($flatArgs, "$args[#i-1#]");
    }
    return this;
  }

  function isMatch(actual) {
    $actual = actual;
    switch ($predicate) {

    case "True":
      if (arrayLen($args) != 0) throw("Application", "The BeTrue matcher expected 0 arguments, got #arrayLen($args)#.");
      if (not isBoolean($actual)) throw("cfspec.fail", "BeTrue expected a boolean, got #inspect($actual)#");
      return $actual eq true;

    case "False":
      if (arrayLen($args) != 0) throw("Application", "The BeFalse matcher expected 0 arguments, got #arrayLen($args)#.");
      if (not isBoolean($actual)) throw("cfspec.fail", "BeFalse expected a boolean, got #inspect($actual)#");
      return $actual eq false;

    case "SimpleValue":
      if (arrayLen($args) != 0) throw("Application", "The BeSimpleValue matcher expected 0 arguments, got #arrayLen($args)#.");
      return isSimpleValue($actual);

    case "Numeric":
      if (arrayLen($args) != 0) throw("Application", "The BeNumeric matcher expected 0 arguments, got #arrayLen($args)#.");
      return isNumeric($actual);

    case "Date":
      if (arrayLen($args) != 0) throw("Application", "The BeDate matcher expected 0 arguments, got #arrayLen($args)#.");
      return isDate($actual);

    case "Boolean":
      if (arrayLen($args) != 0) throw("Application", "The BeBoolean matcher expected 0 arguments, got #arrayLen($args)#.");
      return isBoolean($actual);

    case "Object":
      if (arrayLen($args) != 0) throw("Application", "The BeObject matcher expected 0 arguments, got #arrayLen($args)#.");
      return isObject($actual);

    case "Struct":
      if (arrayLen($args) != 0) throw("Application", "The BeStruct matcher expected 0 arguments, got #arrayLen($args)#.");
      return isStruct($actual);

    case "Array":
      if (arrayLen($args) != 0) throw("Application", "The BeArray matcher expected 0 arguments, got #arrayLen($args)#.");
      return isArray($actual);

    case "Query":
      if (arrayLen($args) != 0) throw("Application", "The BeQuery matcher expected 0 arguments, got #arrayLen($args)#.");
      return isQuery($actual);

    case "UUID":
      if (arrayLen($args) != 0) throw("Application", "The BeUUID matcher expected 0 arguments, got #arrayLen($args)#.");
      return isValid('uuid',$actual);

    case "Empty":
      if (arrayLen($args) != 0) throw("Application", "The BeEmpty matcher expected 0 arguments, got #arrayLen($args)#.");
      if (isSimpleValue($actual)) return trim($actual) == "";
      if (isQuery($actual)) return $actual.recordCount == 0;
      try {
        $actual = actual.isEmpty();
      } catch (Application e) {
        if (e.message != "The method isEmpty was not found.") rethrow(e);
        throw("cfspec.fail", "BeEmpty expected actual.isEmpty() to return a boolean, but the method was not found.");
      }
      if (not isBoolean($actual)) throw("cfspec.fail", "BeEmpty expected actual.isEmpty() to return a boolean, got #inspect($actual)#");
      return $actual;

    case "Defined":
      if (arrayLen($args) != 0) throw("Application", "The BeDefined matcher expected 0 arguments, got #arrayLen($args)#.");
      $actual = structKeyExists($runner.cfspecBindings(), actual);
      return $actual;

    case "AnInstanceOf":
      if (arrayLen($args) != 1) throw("Application", "The BeEmpty matcher expected 1 argument, got #arrayLen($args)#.");
      if (not isSimpleValue($args[1])) throw("Application", "The CLASSNAME parameter to the BeEmpty matcher must be a string.");
      try {
        $actual = getMetaData($actual).name;
      } catch (Any e) {
        $actual = "???";
      }
      return isInstanceOf(actual, $args[1]);

    default:
      try {
        $actual = evaluate("$actual.is#$predicate#(#$flatArgs#)");
      } catch (Application e) {
        if (e.message != "The method is#$predicate# was not found.") rethrow(e);
        throw("cfspec.fail", "Be#$predicate# expected actual.#predicateMethod()# to return a boolean, but the method was not found.");
      }
      if (not isBoolean($actual)) throw("cfspec.fail", "Be#$predicate# expected actual.#predicateMethod()# to return a boolean, got #inspect($actual)#");
      return $actual;
    }
  }

  function getFailureMessage() {
    return "expected #predicateExpectation(false)#, got #inspect($actual)#";
  }

  function getNegativeFailureMessage() {
    return "expected #predicateExpectation(true)#, got #inspect($actual)#";
  }

  function getDescription() {
    return reReplace(predicateExpectation(false), "^to\s+", "");
  }

  function predicateExpectation(negative) {
    switch ($predicate) {
      case "True":         return iif(negative, de('not '), de('')) & "to be true";
      case "False":        return iif(negative, de('not '), de('')) & "to be false";
      case "SimpleValue":  return iif(negative, de('not '), de('')) & "to be a simple value";
      case "Numeric":      return iif(negative, de('not '), de('')) & "to be numeric";
      case "Date":         return iif(negative, de('not '), de('')) & "to be a date";
      case "Boolean":      return iif(negative, de('not '), de('')) & "to be a boolean";
      case "Object":       return iif(negative, de('not '), de('')) & "to be an object";
      case "Struct":       return iif(negative, de('not '), de('')) & "to be a struct";
      case "Array":        return iif(negative, de('not '), de('')) & "to be an array";
      case "Query":        return iif(negative, de('not '), de('')) & "to be a query";
      case "UUID":         return iif(negative, de('not '), de('')) & "to be a valid uuid";
      case "Empty":        return iif(negative, de('not '), de('')) & "to be empty";
      case "Defined":      return iif(negative, de('not '), de('')) & "to be defined";
      case "AnInstanceOf": return iif(negative, de('not '), de('')) & "to be an instance of #inspect($args[1])#";
      default:
        return "#predicateMethod()# to be " & iif(negative, de('false'), de('true'));
    }
  }

  function predicateMethod() {
    return "is#$predicate#(#reReplace(inspect($args), '^\[(.*)\]$', '\1')#)";
  }

</cfscript></cfcomponent>