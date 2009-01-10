<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init(relativity) {
    $relativity = relativity;
    if (arrayLen(arguments) != 2) throw("Application", "The Have#$relativity# matcher expected 1 argument, got #arrayLen(arguments)-1#.");
    $expected = arguments[2];
    if (not isNumeric($expected)) throw("Application", "The EXPECTED parameter to the Have#$relativity# matcher must be numeric.");
    return this;
  }

  function isMatch(collectionOwner) {
    var pluralCollectionName = "";
    var collection = "";

    if (isObject(collectionOwner)) {
      try {
        collection = evaluate("collectionOwner.get#$collectionName#()");
      } catch(Application e) {
        if (!reFindNoCase("the method get#$collectionName# was not found", e.message)) rethrow(e);
        try {
          pluralCollectionName = $context.getInflector().pluralize($collectionName);
          if (pluralCollectionName != $collectionName) {
            collection = evaluate("collectionOwner.get#pluralCollectionName#()");
          } else {
            collection = collectionOwner;
          }
        } catch(Application e) {
          if (!reFindNoCase("the method get#pluralCollectionName# was not found", e.message)) rethrow(e);
          collection = collectionOwner;
        }
      }
    } else {
      collection = collectionOwner;
    }

    if (isSimpleValue(collection)) {
      $given = len(collection);

    } else if (isObject(collection)) {
      try {
        $given = collection.size();
      } catch (Application e) {
        if (e.message != "The method size was not found.") rethrow(e);
        throw("cfspec.fail", "Have#$relativity# expected actual.size() to return a number, but the method was not found.");
      }
      if (not isNumeric($given)) throw("cfspec.fail", "Have#$relativity# expected actual.size() to return a number, got #inspect($given)#");

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
    if (isDefined("$expectations"))  $expectations.resumeDelayedMatcher(this, $negateExpectations);
    return this;
  }

  function isDelayed() {
    return not isDefined("$collectionName");
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