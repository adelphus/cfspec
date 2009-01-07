<cfimport taglib="/cfspec" prefix="">

<describe hint="Contain">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Contain").init("", "in"))>
  </before>

  <it should="match when actual contains expected">
    <cfset $matcher.isMatch("splinter").shouldBeTrue()>    
  </it>

  <it should="not match when actual does not contain expected">
    <cfset $matcher.isMatch("Interest").shouldBeFalse()>    
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch("Interest")>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to contain 'in', got 'Interest'")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch("splinter")>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected not to contain 'in', got 'splinter'")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("contain 'in'")>
  </it>

  <describe hint="NoCase">
  
    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Contain").init("NoCase", "in"))>
    </before>

    <it should="match when target matches actual (case-insensitive)">
      <cfset $matcher.isMatch("Interest").shouldBeTrue()>
    </it>

  </describe>

  <describe hint="bad types">
    
    <it should="provide a useful failure message if actual is not a simple type">
      <cfset $matcher.isMatch(stub()).shouldThrow("cfspec.fail", "Contain expected a simple value, got")>
    </it>

  </describe>

</describe>