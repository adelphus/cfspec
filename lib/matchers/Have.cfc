<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

	function init(expected, relativity) {
		$expected = expected;
		$relativity = relativity;
		return this;
	}

	function isMatch(collectionOwner) {
		var collection = "";

		if (isObject(collectionOwner)) {
			try {
				collection = evaluate("collectionOwner.get#$collectionName#()");
			} catch(Application e) {
				if (!reFindNoCase("the method get#$collectionName# was not found", e.message)) rethrow(e);
				collection = collectionOwner;
			}
		} else {
			collection = collectionOwner;
		}

		if (isSimpleValue(collection)) {
			$given = len(collection);

		} else if (isObject(collection)) {
			$given = collection.size();

		} else if (isStruct(collection)) {
			$given = structCount(collection);

		} else if (isArray(collection)) {
			$given = arrayLen(collection);

		} else if (isQuery(collection)) {
			$given = collection.recordCount;

		}

		switch ($relativity) {
			case "AtLeast":	return $given >= $expected;
			case "AtMost":	return $given <= $expected;
			default:				return $given == $expected;
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
		return this;
	}

	function isDelayed() {
		return not isDefined("$collectionName");
	}

	function relativeExpectation() {
		var n = inspect($expected);
		switch ($relativity) {
			case "AtLeast":	return "at least #n#";
			case "AtMost":	return "at most #n#";
			default:				return n;
		}
	}

</cfscript></cfcomponent>