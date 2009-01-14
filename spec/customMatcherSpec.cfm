<cfimport taglib="/cfspec" prefix="">

<describe hint="Custom Matcher">

  <beforeAll>
    <cfset $cfspec.registerMatcher("Say", "cfspec.spec.assets.SimonSaysMatcher")>
  </beforeAll>

  <before>
    <cfset $simon = $(createObject("component", "cfspec.spec.assets.Simon").init("Hello World!"))>
  </before>

  <it should="do what simon says">
    <cfset $simon.shouldSay("Hello World!")>
  </it>

  <it should="not do what simon doesn't say">
    <cfset $simon.shouldNotSay("Goodbye!")>
  </it>

</describe>
