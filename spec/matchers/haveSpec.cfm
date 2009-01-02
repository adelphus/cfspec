<cfimport taglib="/cfspec" prefix="">

<describe hint="HaveExactly(n).items()">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Have").init(3, "exactly").items())>
  </before>

  <it should="match when target is a string with n characters">
    <cfset target = "abc">
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with n items">
    <cfset target = createObject("component", "cfspec.spec.assets.HasItems").init(3)>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with size == n">
    <cfset target = createObject("component", "cfspec.spec.assets.HasSize").init(3)>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a struct with n keys">
    <cfset target = {a="foo", b="bar", c="baz"}>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an array with n elements">
    <cfset target = ["a", "b", "c"]>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a query with n records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("a,b,c"))>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when target is a string with > n characters">
    <cfset target = "abcd">
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with > n items">
    <cfset target = createObject("component", "cfspec.spec.assets.HasItems").init(4)>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with size > n">
    <cfset target = createObject("component", "cfspec.spec.assets.HasSize").init(4)>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is a struct with > n keys">
    <cfset target = {a="foo", b="bar", c="baz", d="bat"}>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an array with > n elements">
    <cfset target = ["a", "b", "c", "d"]>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is a query with > n records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("a,b,c,d"))>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is a string with < n characters">
    <cfset target = "ab">
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with < n items">
    <cfset target = createObject("component", "cfspec.spec.assets.HasItems").init(2)>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with size < n">
    <cfset target = createObject("component", "cfspec.spec.assets.HasSize").init(2)>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is a struct with < n keys">
    <cfset target = {a="foo", b="bar"}>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an array with < n elements">
    <cfset target = ["a", "b"]>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is a query with < n records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("a,b"))>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
  	<cfset $matcher.isMatch("abcde")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected 3 items, got 5")>
  </it>

  <it should="describe itself">
  	<cfset $matcher.getDescription().shouldEqual("have 3 items")>
  </it>

</describe>

<describe hint="HaveAtLeast(n).items()">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Have").init(3, "atLeast").items())>
  </before>

  <it should="match when target is a string with n characters">
    <cfset target = "abc">
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with n items">
    <cfset target = createObject("component", "cfspec.spec.assets.HasItems").init(3)>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with size == n">
    <cfset target = createObject("component", "cfspec.spec.assets.HasSize").init(3)>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a struct with n keys">
    <cfset target = {a="foo", b="bar", c="baz"}>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an array with n elements">
    <cfset target = ["a", "b", "c"]>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a query with n records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("a,b,c"))>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a string with > n characters">
    <cfset target = "abcd">
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with > n items">
    <cfset target = createObject("component", "cfspec.spec.assets.HasItems").init(4)>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with size > n">
    <cfset target = createObject("component", "cfspec.spec.assets.HasSize").init(4)>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a struct with > n keys">
    <cfset target = {a="foo", b="bar", c="baz", d="bat"}>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an array with > n elements">
    <cfset target = ["a", "b", "c", "d"]>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a query with > n records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("a,b,c,d"))>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when target is a string with < n characters">
    <cfset target = "ab">
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with < n items">
    <cfset target = createObject("component", "cfspec.spec.assets.HasItems").init(2)>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with size < n">
    <cfset target = createObject("component", "cfspec.spec.assets.HasSize").init(2)>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is a struct with < n keys">
    <cfset target = {a="foo", b="bar"}>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an array with < n elements">
    <cfset target = ["a", "b"]>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is a query with < n records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("a,b"))>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
  	<cfset $matcher.isMatch("ab")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected at least 3 items, got 2")>
  </it>

  <it should="describe itself">
  	<cfset $matcher.getDescription().shouldEqual("have at least 3 items")>
  </it>

</describe>

<describe hint="HaveAtMost(n).items()">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Have").init(3, "atMost").items())>
  </before>

  <it should="match when target is a string with n characters">
    <cfset target = "abc">
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with n items">
    <cfset target = createObject("component", "cfspec.spec.assets.HasItems").init(3)>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with size == n">
    <cfset target = createObject("component", "cfspec.spec.assets.HasSize").init(3)>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a struct with n keys">
    <cfset target = {a="foo", b="bar", c="baz"}>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an array with n elements">
    <cfset target = ["a", "b", "c"]>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a query with n records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("a,b,c"))>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="not match when target is a string with > n characters">
    <cfset target = "abcd">
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with > n items">
    <cfset target = createObject("component", "cfspec.spec.assets.HasItems").init(4)>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with size > n">
    <cfset target = createObject("component", "cfspec.spec.assets.HasSize").init(4)>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is a struct with > n keys">
    <cfset target = {a="foo", b="bar", c="baz", d="bat"}>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an array with > n elements">
    <cfset target = ["a", "b", "c", "d"]>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is a query with > n records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("a,b,c,d"))>
  	<cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="match when target is a string with < n characters">
    <cfset target = "ab">
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with < n items">
    <cfset target = createObject("component", "cfspec.spec.assets.HasItems").init(2)>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with size < n">
    <cfset target = createObject("component", "cfspec.spec.assets.HasSize").init(2)>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a struct with < n keys">
    <cfset target = {a="foo", b="bar"}>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an array with < n elements">
    <cfset target = ["a", "b"]>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is a query with < n records">
    <cfset target = queryNew("")>
    <cfset queryAddColumn(target, "foo", listToArray("a,b"))>
  	<cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="provide a useful failure message">
  	<cfset $matcher.isMatch("abcde")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected at most 3 items, got 5")>
  </it>

  <it should="describe itself">
  	<cfset $matcher.getDescription().shouldEqual("have at most 3 items")>
  </it>

</describe>