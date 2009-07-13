<cfimport taglib="/cfspec" prefix="">

<describe hint="ArgumentEvalMatcher">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.ArgumentEvalMatcher").init())>
    <cfset $matcher.setExpression("arguments[1] eq 'foo'")>
  </before>

  <it should="match when expression evaluates to true">
    <cfset $matcher.isMatch("foo", "bar").shouldBeTrue()>
  </it>

  <it should="match when expression evaluates to false">
    <cfset $matcher.isMatch("bar", "none").shouldBeFalse()>
  </it>

  <it should="flatten to a unique string for the expression">
    <cfset $matcher.asString().shouldEqual("EVAL:#chr(34)#arguments[1] eq 'foo'#chr(34)#")>
  </it>

</describe>
