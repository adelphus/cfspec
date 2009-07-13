<cfimport taglib="/cfspec" prefix="">

<describe hint="ArgumentMatcher">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.ArgumentMatcher").init())>
    <cfset $matcher.setArguments("foo", 42, true)>
  </before>

  <it should="match when arguments are equal to those passed in">
    <cfset $matcher.isMatch("foo", 42, true).shouldBeTrue()>
  </it>

  <it should="match when arguments are not equal to those passed in">
    <cfset $matcher.isMatch("foo", 43, true).shouldBeFalse()>
  </it>

  <it should="flatten to a unique string for the arguments">
    <cfset $matcher.asString().shouldEqual("{1='foo',2=42,3=true}")>
  </it>

</describe>
