<cfimport taglib="/cfspec" prefix="">

<describe hint="Be True">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("True"))>
  </before>

  <it should="match when actual is true">
    <cfset $matcher.isMatch(true).shouldBeTrue()>
  </it>

  <it should="not match when actual is false">
    <cfset $matcher.isMatch(false).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
  	<cfset $matcher.isMatch(false)>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be true, got false")>
  </it>

  <it should="describe itself">
  	<cfset $matcher.getDescription().shouldEqual("be true")>
  </it>

</describe>

<describe hint="Be False">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("False"))>
  </before>

  <it should="match when actual is false">
    <cfset $matcher.isMatch(false).shouldBeTrue()>
  </it>

  <it should="not match when actual is true">
    <cfset $matcher.isMatch(true).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
  	<cfset $matcher.isMatch(true)>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be false, got true")>
  </it>

  <it should="describe itself">
  	<cfset $matcher.getDescription().shouldEqual("be false")>
  </it>

</describe>

<describe hint="Be Empty">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Empty"))>
  </before>

  <it should="match when target is a string of whitespace characters">
    <cfset $matcher.isMatch("#chr(9)#  #chr(10)##chr(13)#").shouldBeTrue()>
  </it>

  <it should="not match when target is a string with non-whitespace characters">
    <cfset $matcher.isMatch("  x  ").shouldBeFalse()>
  </it>
  
  <it should="match when actual is an object with isEmpty() == true">
    <cfset target = createObject("component", "cfspec.spec.assets.IsEmpty")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when actual is an object with isEmpty() == false">
    <cfset target = createObject("component", "cfspec.spec.assets.IsFull")>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>
  
  <it should="match when actual is a struct with no keys">
    <cfset target = {}>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when actual is a struct with 1+ keys">
    <cfset target = {foo=1}>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="match when actual is an array with no elements">
    <cfset target = []>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when actual is an array with 1+ elements">
    <cfset target = [1]>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="match when actual is a query with no records">
    <cfset target = queryNew("foo")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when actual is a query with 1+ records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("1"))>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
  	<cfset $matcher.isMatch("abc")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be empty, got 'abc'")>
  </it>

  <it should="provide a useful negative failure message">
  	<cfset $matcher.isMatch("   ")>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be empty, got '   '")>
  </it>

  <it should="describe itself">
  	<cfset $matcher.getDescription().shouldEqual("be empty")>
  </it>

</describe>

<describe hint="Be AnInstanceOf">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("AnInstanceOf", "cfspec.spec.assets.Widget"))>
  </before>
  
  <it should="match if target is an instance of the expected class">
    <cfset target = createObject("component", "cfspec.spec.assets.Widget")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match if target is an instance of a decendant class">
    <cfset target = createObject("component", "cfspec.spec.assets.SpecialWidget")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match if target is not an instance of the expected class">
    <cfset target = createObject("component", "cfspec.spec.assets.HappyGuy")>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset target = createObject("component", "cfspec.spec.assets.HappyGuy")>
  	<cfset $matcher.isMatch(target)>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to be an instance of 'cfspec.spec.assets.Widget', got 'cfspec.spec.assets.HappyGuy'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset target = createObject("component", "cfspec.spec.assets.Widget")>
  	<cfset $matcher.isMatch(target)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to be an instance of 'cfspec.spec.assets.Widget', got 'cfspec.spec.assets.Widget'")>
  </it>

  <it should="describe itself">
  	<cfset $matcher.getDescription().shouldEqual("be an instance of 'cfspec.spec.assets.Widget'")>
  </it>

</describe>

<describe hint="Be ArbitraryPredicate">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("Happy"))>
  </before>

  <it should="match when actual.isHappy() returns true">
    <cfset target = createObject("component", "cfspec.spec.assets.HappyGuy")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when actual.isHappy() returns false">
    <cfset target = createObject("component", "cfspec.spec.assets.SadGuy")>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset target = createObject("component", "cfspec.spec.assets.SadGuy")>
  	<cfset $matcher.isMatch(target)>
    <cfset $matcher.getFailureMessage().shouldEqual("expected isHappy() to be true, got false")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset target = createObject("component", "cfspec.spec.assets.HappyGuy")>
  	<cfset $matcher.isMatch(target)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected isHappy() to be false, got true")>
  </it>

  <it should="describe itself">
  	<cfset $matcher.getDescription().shouldEqual("isHappy() to be true")>
  </it>

  <describe hint="with arguments">

    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Be").init("InMood", "happy", 42))>
    </before>

    <it should="match when actual.isInMood('happy', 42) returns true">
      <cfset target = createObject("component", "cfspec.spec.assets.HappyGuy")>
      <cfset $matcher.isMatch(target).shouldBeTrue()>
    </it>

    <it should="not match when actual.isInMood('happy', 42) returns false">
      <cfset target = createObject("component", "cfspec.spec.assets.SadGuy")>
      <cfset $matcher.isMatch(target).shouldBeFalse()>
    </it>

    <it should="provide a useful failure message">
      <cfset target = createObject("component", "cfspec.spec.assets.SadGuy")>
  	  <cfset $matcher.isMatch(target)>
      <cfset $matcher.getFailureMessage().shouldEqual("expected isInMood('happy',42) to be true, got false")>
    </it>

    <it should="provide a useful negative failure message">
      <cfset target = createObject("component", "cfspec.spec.assets.HappyGuy")>
  	  <cfset $matcher.isMatch(target)>
      <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected isInMood('happy',42) to be false, got true")>
    </it>

    <it should="describe itself">
    	<cfset $matcher.getDescription().shouldEqual("isInMood('happy',42) to be true")>
    </it>

  </describe>

</describe>