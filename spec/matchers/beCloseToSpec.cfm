<cfimport taglib="/cfspec" prefix="">

<describe hint="BeCloseTo (numeric)">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeCloseTo").init())>
    <cfset $matcher.setArguments(5, 0.5)>
  </before>

  <it should="match when actual == expected">
    <cfset $matcher.isMatch(5).shouldBeTrue()>
  </it>

  <it should="match when actual > (expected - delta)">
    <cfset $matcher.isMatch(4.51).shouldBeTrue()>
  </it>

  <it should="match when actual < (expected + delta)">
    <cfset $matcher.isMatch(5.49).shouldBeTrue()>
  </it>

  <it should="not match when actual == (expected - delta)">
    <cfset $matcher.isMatch(4.5).shouldBeFalse()>
  </it>

  <it should="not match when actual < (expected - delta)">
    <cfset $matcher.isMatch(4.49).shouldBeFalse()>
  </it>

  <it should="not match when actual == (expected + delta)">
    <cfset $matcher.isMatch(5.5).shouldBeFalse()>
  </it>

  <it should="not match when actual > (expected + delta)">
    <cfset $matcher.isMatch(5.51).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch(5.51)>
    <cfset $matcher.getFailureMessage().shouldEqual("expected 5 +/- (< 0.5), got 5.51")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(5)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected 5 +/- (>= 0.5), got 5")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be close to 5 (within +/- 0.5)")>
  </it>

  <describe hint="bad types">

    <it should="provide a useful failure message if actual is non-numeric">
      <cfset $matcher.isMatch(stub()).shouldThrow("cfspec.fail", "BeCloseTo expected a number, got")>
    </it>

  </describe>

</describe>

<describe hint="BeCloseTo (date)">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.BeCloseTo").init())>
    <cfset today = createDate(2001, 3, 15)>
    <cfset lastMonth = dateAdd("m", -1, today)>
    <cfset yesterday = dateAdd("d", -1, today)>
    <cfset anHourAgo = dateAdd("h", -1, today)>
    <cfset anHourFromNow = dateAdd("h", 1, today)>
    <cfset tomorrow = dateAdd("d", 1, today)>
    <cfset nextMonth = dateAdd("m", 1, today)>
    <cfset $matcher.setArguments(today, 1, "d")>
  </before>

  <it should="match when actual == expected">
    <cfset $matcher.isMatch(today).shouldBeTrue()>
  </it>

  <it should="match when actual > (expected - delta)">
    <cfset $matcher.isMatch(anHourAgo).shouldBeTrue()>
  </it>

  <it should="match when actual < (expected + delta)">
    <cfset $matcher.isMatch(anHourFromNow).shouldBeTrue()>
  </it>

  <it should="not match when actual == (expected - delta)">
    <cfset $matcher.isMatch(yesterday).shouldBeFalse()>
  </it>

  <it should="not match when actual < (expected - delta)">
    <cfset $matcher.isMatch(lastMonth).shouldBeFalse()>
  </it>

  <it should="not match when actual == (expected + delta)">
    <cfset $matcher.isMatch(tomorrow).shouldBeFalse()>
  </it>

  <it should="not match when actual > (expected + delta2001-03-15 12:00 AM)">
    <cfset $matcher.isMatch(nextMonth).shouldBeFalse()>
  </it>

  <it should="provide a useful failure message">
    <cfset $matcher.isMatch(nextMonth)>
    <cfset $matcher.getFailureMessage().shouldEqual("expected 2001-03-15 12:00 AM +/- (< 1d), got 2001-04-15 12:00 AM")>
  </it>

  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch(today)>
    <cfset $matcher.getNegativeFailureMessage().shouldEqual("expected 2001-03-15 12:00 AM +/- (>= 1d), got 2001-03-15 12:00 AM")>
  </it>

  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("be close to 2001-03-15 12:00 AM (within 1d)")>
  </it>

  <describe hint="bad types">

    <it should="provide a useful failure message if actual is not a date">
      <cfset $matcher.isMatch(stub()).shouldThrow("cfspec.fail", "BeCloseTo expected a date, got")>
    </it>

  </describe>

</describe>
