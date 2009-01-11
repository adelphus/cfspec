<cfimport taglib="/cfspec" prefix="">

<describe hint="Match">
  
  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Match").init("", "^t\s\(\d{3}\)\s\d{3}-\d{4}$"))>
  </before>

  <it should="match when target matches actual">
    <cfset $matcher.isMatch("t (555) 123-4567").shouldBeTrue()>
  </it>

  <it should="not match when target does not match actual">
    <cfset $matcher.isMatch("T (555) 123-4567").shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("T (555) 123-4567")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to match '^t\\s\\(\\d{3}\\)\\s\\d{3}-\\d{4}$', got 'T (555) 123-4567'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch("t (555) 123-4567")>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to match '^t\\s\\(\\d{3}\\)\\s\\d{3}-\\d{4}$', got 't (555) 123-4567'")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("match '^t\\s\\(\\d{3}\\)\\s\\d{3}-\\d{4}$'")>
  </it>  

  <describe hint="NoCase">
  
    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Match").init("NoCase", "^t\s\(\d{3}\)\s\d{3}-\d{4}$"))>
    </before>

    <it should="match when target matches actual (case-insensitive)">
      <cfset $matcher.isMatch("T (555) 123-4567").shouldBeTrue()>
    </it>

  </describe>  

  <describe hint="bad types">
    
    <it should="provide a useful failure message if actual is not a simple type">
      <cfset $matcher.isMatch(stub()).shouldThrow("cfspec.fail", "Match expected a simple value, got")>
    </it>

  </describe>

</describe>