<cfimport taglib="/cfspec" prefix="">

<describe hint="ArgumentMatcher">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.ArgumentMatcher").init())>
  </before>

  <describe hint="expecting no arguments">

    <before>
      <cfset $matcher.setArguments()>
    </before>

    <it should="match with no arguments">
      <cfset $matcher.shouldBeMatch()>
    </it>

    <it should="not match with 1 argument">
      <cfset $matcher.shouldNotBeMatch("foo")>
    </it>

  </describe>

</describe>
