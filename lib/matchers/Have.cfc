<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(relativity) {
    $relativity = relativity;
    return this;
  }

  function setArguments() {
    if (arrayLen(arguments) != 1) throw("Application", "The Have#$relativity# matcher expected 1 argument, got #arrayLen(arguments)#.");
    $expected = arguments[1];
    if (not isNumeric($expected)) throw("Application", "The EXPECTED parameter to the Have#$relativity# matcher must be numeric.");
  }

  function isMatch(collectionOwner) {
    var pluralCollectionName = "";
    var collection = "";

    if (isObject(collectionOwner)) {
      if (hasMethod(collectionOwner, "get#$collectionName#")) {
        collection = evaluate("collectionOwner.get#$collectionName#()");
      } else {
        pluralCollectionName = $runner.getInflector().pluralize($collectionName);
        if (pluralCollectionName != $collectionName and hasMethod(collectionOwner, "get#pluralCollectionName#")) {
          collection = evaluate("collectionOwner.get#pluralCollectionName#()");
        } else if (hasMethod(collectionOwner, "length") || hasMethod(collectionOwner, "size")) {
          collection = collectionOwner;
        } else {
          try {
            collection = evaluate("collectionOwner.get#$collectionName#()");
          } catch (Application e) {
            if (e.message != "The method get#$collectionName# was not found.") rethrow(e);
            collection = collectionOwner;
          }
        }
      }
    } else {
      collection = collectionOwner;
    }

    if (isSimpleValue(collection)) {
      $given = len(collection);

    } else if (isObject(collection)) {
      if (hasMethod(collection, "length")) {
        $given = collection.length();
      } else if (hasMethod(collection, "size")) {
        $given = collection.size();
      } else {
        throw("cfspec.fail", "Have#$relativity# expected actual.size() or actual.length() to return a number, but the method was not found.");
      }
      if (not isNumeric($given)) throw("cfspec.fail", "Have#$relativity# expected actual.size() or actual.length() to return a number, got #inspect($given)#");

    } else if (isStruct(collection)) {
      $given = structCount(collection);

    } else if (isArray(collection)) {
      $given = arrayLen(collection);

    } else if (isQuery(collection)) {
      $given = collection.recordCount;

    }

    switch ($relativity) {
      case "AtLeast":  return $given >= $expected;
      case "AtMost":  return $given <= $expected;
      default:        return $given == $expected;
    }
  }

  function getFailureMessage() {
    return "expected #relativeExpectation()# #$collectionName#, got #inspect($given)#";
  }

  function getDescription() {
    return "have #relativeExpectation()# #$collectionName#";
  }

  function onMissingMethod(missingMethodName, missingMethodArguments) {
    $collectionName = missingMethodName;
    if (isDefined("$expectations")) $expectations.__cfspecEvalMatcher(this);
    return this;
  }

  function isDelayed() {
    var delayed = not isDefined("$collectionName");
    $runner.flagDelayedMatcher(delayed);
    return delayed;
  }

  function relativeExpectation() {
    var n = inspect($expected);
    switch ($relativity) {
      case "AtLeast":  return "at least #n#";
      case "AtMost":  return "at most #n#";
      default:        return n;
    }
  }

</cfscript></cfcomponent>