<cfimport taglib="/cfspec" prefix="">

<describe hint="BeComparison">
  
  <describe hint="less than">
  
    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("LessThan", 5))>
    </before>

    <it should="match when target < actual">
      <cfset $matcher.isMatch(4).shouldBeTrue()>
    </it>

    <it should="not match when target == actual">
      <cfset $matcher.isMatch(5).shouldBeFalse()>
    </it>

    <it should="not match when target > actual">
      <cfset $matcher.isMatch(6).shouldBeFalse()>
    </it>

    <it should="provide a useful failure message">
    	<cfset $matcher.isMatch(6)>
      <cfset $matcher.getFailureMessage().shouldEqual("expected to be < 5, got 6")>
    </it>

    <it should="describe itself">
    	<cfset $matcher.getDescription().shouldEqual("be < 5")>
    </it>

  </describe>  

  <describe hint="less than or equal to">
  
    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("LessThanOrEqualTo", 5))>
    </before>

    <it should="match when target < actual">
      <cfset $matcher.isMatch(4).shouldBeTrue()>
    </it>

    <it should="match when target == actual">
      <cfset $matcher.isMatch(5).shouldBeTrue()>
    </it>

    <it should="not match when target > actual">
      <cfset $matcher.isMatch(6).shouldBeFalse()>
    </it>

    <it should="provide a useful failure message">
    	<cfset $matcher.isMatch(6)>
      <cfset $matcher.getFailureMessage().shouldEqual("expected to be <= 5, got 6")>
    </it>

    <it should="describe itself">
    	<cfset $matcher.getDescription().shouldEqual("be <= 5")>
    </it>

  </describe>  

  <describe hint="greater than or equal to">
  
    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("GreaterThanOrEqualTo", 5))>
    </before>

    <it should="not match when target < actual">
      <cfset $matcher.isMatch(4).shouldBeFalse()>
    </it>

    <it should="match when target == actual">
      <cfset $matcher.isMatch(5).shouldBeTrue()>
    </it>

    <it should="match when target > actual">
      <cfset $matcher.isMatch(6).shouldBeTrue()>
    </it>

    <it should="provide a useful failure message">
    	<cfset $matcher.isMatch(4)>
      <cfset $matcher.getFailureMessage().shouldEqual("expected to be >= 5, got 4")>
    </it>

    <it should="describe itself">
    	<cfset $matcher.getDescription().shouldEqual("be >= 5")>
    </it>

  </describe>  

  <describe hint="greater than">
  
    <before>
      <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeComparison").init("GreaterThan", 5))>
    </before>

    <it should="not match when target < actual">
      <cfset $matcher.isMatch(4).shouldBeFalse()>
    </it>

    <it should="not match when target == actual">
      <cfset $matcher.isMatch(5).shouldBeFalse()>
    </it>

    <it should="match when target > actual">
      <cfset $matcher.isMatch(6).shouldBeTrue()>
    </it>

    <it should="provide a useful failure message">
    	<cfset $matcher.isMatch(4)>
      <cfset $matcher.getFailureMessage().shouldEqual("expected to be > 5, got 4")>
    </it>

    <it should="describe itself">
    	<cfset $matcher.getDescription().shouldEqual("be > 5")>
    </it>

  </describe>  

</describe>