<cfimport taglib="/cfspec" prefix="">

<describe hint="MockExpectations">

  <before>
    <cfset $expectations = $(createObject("component", "cfspec.lib.MockExpectations").init())>
  </before>

  <it should="create a new argument matcher using arguments supplied to 'with'">
    <cfset $expectations.with("foo", 42, true)>
    <cfset $expectations.shouldBeActive("foo", 42, true)>
    <cfset $expectations.shouldNotBeActive("foo", 43, true)>
  </it>

  <it should="create a new argument matcher using the expression supplied to 'withEval'">
    <cfset $expectations.withEval("arrayLen(arguments) eq 3")>
    <cfset $expectations.shouldBeActive("foo", "bar", "baz")>
    <cfset $expectations.shouldNotBeActive("foo", "bar")>
  </it>

  <it should="render the argument matcher as a string">
    <cfset $expectations.with("foo", 42, true)>
    <cfset $expectations.asString().shouldEqual("(missing method)({1='foo',2=42,3=true})")>
  </it>

  <it should="be equal to other expectations with the same argument matcher">
    <cfset $expectations.with("foo", 42, true)>
    <cfset otherExpectations = createObject("component", "cfspec.lib.MockExpectations").init()>
    <cfset otherExpectations.with("foo", 42, true)>
    <cfset $expectations.shouldEqual(otherExpectations)>
  </it>

</describe>
