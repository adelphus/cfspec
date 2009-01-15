<cfimport taglib="/cfspec" prefix="">

<describe hint="HaveTag">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.HaveTag").init("h1"))>
    <cfset $matcher.setExpectations(stub(), false, this, $cfspec)>
  </before>

  <it should="match when target has the expected tag">
    <cfset $matcher.isMatch("<h1>The Page Title</h1><p>Para1<p>Para2<p>Para3").shouldBeTrue()>
  </it>

  <it should="not match when target does not have the expected tag">
    <cfset $matcher.isMatch("<h2>The Page Title</h2><p>Para1<p>Para2<p>Para3").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("<h2>The Page Title</h2><p>Para1<p>Para2<p>Para3").shouldBeFalse()>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to have tag 'h1', but the tag was not found")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch("<h1>The Page Title</h1><p>Para1<p>Para2<p>Para3").shouldBeTrue()>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to have tag 'h1', but the tag was found")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("have tag 'h1'")>
  </it>

</describe>