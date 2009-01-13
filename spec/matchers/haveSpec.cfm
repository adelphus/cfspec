<cfimport taglib="/cfspec" prefix="">

<describe hint="HaveExactly(n).items()">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Have").init("Exactly", 3).items())>
    <cfset $matcher.setExpectations($(0), false, this, $cfspec)>
  </before>

  <it should="match when target is a string with n characters">
    <cfset target = "abc">
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with n items">
    <cfset target = stub(getItems="abc")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with size == n">
    <cfset target = stub(size=3, stubMissingMethod=false)>
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
    <cfset target = stub(getItems="abcd")>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with size > n">
    <cfset target = stub(size=4, stubMissingMethod=false)>
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
    <cfset target = stub(getItems="ab")>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with size < n">
    <cfset target = stub(size=2, stubMissingMethod=false)>
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

  <describe hint="bad types">

    <it should="provide a useful failure message if actual.size() returns a non-numeric">
      <cfset $matcher.isMatch(stub()).shouldThrow("cfspec.fail", "HaveExactly expected actual.size() to return a number, got")>
    </it>

    <it should="provide a useful failure message if actual doesn't implement size">
      <cfset $matcher.isMatch(stub(stubMissingMethod=false)).shouldThrow("cfspec.fail", "HaveExactly expected actual.size() to return a number, but the method was not found.")>
    </it>

  </describe>

</describe>

<describe hint="HaveAtLeast(n).items()">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Have").init("AtLeast", 3).items())>
    <cfset $matcher.setExpectations($(0), false, this, $cfspec)>
  </before>

  <it should="match when target is a string with n characters">
    <cfset target = "abc">
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with n items">
    <cfset target = stub(getItems="abc")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with size == n">
    <cfset target = stub(size=3, stubMissingMethod=false)>
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
    <cfset target = stub(getItems="abcd")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with size > n">
    <cfset target = stub(size=4, stubMissingMethod=false)>
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
    <cfset target = stub(getItems="ab")>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with size < n">
    <cfset target = stub(size=2, stubMissingMethod=false)>
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
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Have").init("AtMost", 3).items())>
    <cfset $matcher.setExpectations($(0), false, this, $cfspec)>
  </before>

  <it should="match when target is a string with n characters">
    <cfset target = "abc">
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with n items">
    <cfset target = stub(getItems="abc")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with size == n">
    <cfset target = stub(size=3, stubMissingMethod=false)>
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
    <cfset target = stub(getItems="abcd")>
    <cfset $matcher.isMatch(target).shouldBeFalse()>
  </it>

  <it should="not match when target is an object with size > n">
    <cfset target = stub(size=4, stubMissingMethod=false)>
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
    <cfset target = stub(getItems="ab")>
    <cfset $matcher.isMatch(target).shouldBeTrue()>
  </it>

  <it should="match when target is an object with size < n">
    <cfset target = stub(size=2, stubMissingMethod=false)>
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

<describe hint="HaveExactly(n).item() -- should pluralize to getItems()">

  <it should="match when target is an object with n items">
    <cfset target = stub(getItems="a", stubMissingMethod=false)>
    <cfset $(target).shouldHave(1).item()>
  </it>

</describe>