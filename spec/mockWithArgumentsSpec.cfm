<cfimport taglib="/cfspec" prefix="">

<describe hint="Mock (stubbing with arguments)">

  <before>
    <cfset $mock = $(createObject("component", "cfspec.lib.Mock").__cfspecInit("myStub"))>
  </before>

  <it should="return different values for different arguments">
    <cfset $mock.stubs("foo").with(true).returns("bar")>
    <cfset $mock.stubs("foo").with(false).returns("baz")>
    <cfset $mock.foo(false).shouldEqual("baz")>
    <cfset $mock.foo(true).shouldEqual("bar")>
  </it>

  <it should="throw an exception if arguments do not match">
    <cfset $mock.stubs("foo").with(true).returns("bar")>
    <cfset $mock.foo(false).shouldThrow()>
  </it>

  <it should="throw an exception if too many arguments">
    <cfset $mock.stubs("foo").with().returns("bar")>
    <cfset $mock.foo(true).shouldThrow()>
  </it>

  <it should="throw an exception if too few arguments">
    <cfset $mock.stubs("foo").with(true).returns("bar")>
    <cfset $mock.foo().shouldThrow()>
  </it>

  <it should="meet multiple expectations when called with more specific arguments">
    <cfset $mock.expects("foo").returns("bar")>
    <cfset $mock.expects("foo").with(true).returns("baz")>
    <cfset $mock.foo(true).shouldEqual("baz")>
    <cfset $mock.__cfspecGetFailureMessages().shouldBeEmpty()>
  </it>

  <it should="recognize an eval-based argument matcher">
    <cfset $mock.stubs("foo").withEval("arrayLen(arguments) mod 2 eq 0").returns("even")>
    <cfset $mock.stubs("foo").withEval("arrayLen(arguments) mod 2 eq 1").returns("odd")>
    <cfset $mock.foo().shouldEqual("even")>
    <cfset $mock.foo(0).shouldEqual("odd")>
    <cfset $mock.foo(0, 0).shouldEqual("even")>
    <cfset $mock.foo(0, 0, 0).shouldEqual("odd")>
  </it>

</describe>
