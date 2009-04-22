<cfimport taglib="/cfspec" prefix="">

<describe hint="Mock">

  <before>
    <cfset $mock = $(createObject("component", "cfspec.lib.Mock").__cfspecInit())>
  </before>

  <it should="throw an exception on an unspecified method call">
    <cfset $mock.undefinedMethod().shouldThrow()>
  </it>

  <it should="return a new stub on an unspecified method call">
    <cfset $mock.stubsMissingMethod()>
    <cfset $mock.undefinedMethod().shouldBeAnInstanceOf("cfspec.lib.Mock")>
  </it>

  <it should="return the specified value on an unspecified method call">
    <cfset $mock.stubsMissingMethod().returns("foo")>
    <cfset $mock.undefinedMethod().shouldEqual("foo")>
  </it>

  <it should="return the correct value for a method that was supplied on init">
    <cfset $mock = $(createObject("component", "cfspec.lib.Mock").__cfspecInit(getName="John Doe", getAge=21, isMale=true))>
    <cfset $mock.getName().shouldEqual("John Doe")>
    <cfset $mock.getAge().shouldEqual(21)>
    <cfset $mock.shouldBeMale()>
  </it>

  <it should="return the supplied value for a given method">
    <cfset $mock.stubs("foo").returns("bar")>
    <cfset $mock.foo().shouldEqual("bar")>
  </it>

  <it should="throw the supplied exception for a given method">
    <cfset $mock.stubs("foo").throws("NoFooAllowed")>
    <cfset $mock.foo().shouldThrow("NoFooAllowed")>
  </it>

  <it should="throw the supplied exception for a given method with a message">
    <cfset $mock.stubs("foo").throws("NoFooAllowed", "message")>
    <cfset $mock.foo().shouldThrow("NoFooAllowed", "message")>
  </it>

  <it should="throw the supplied exception for a given method with a message and details">
    <cfset $mock.stubs("foo").throws("NoFooAllowed", "message", "details")>
    <cfset $mock.foo().shouldThrow("NoFooAllowed", "message", "details")>
  </it>

  <describe hint="multiple return values or throws">

    <it should="return supplied values in succession if a given method is expected multiple times">
      <cfset $mock.stubs("next").returns("one")>
      <cfset $mock.stubs("next").returns("two")>
      <cfset $mock.stubs("next").returns("more")>
      <cfset $mock.next().shouldEqual("one")>
      <cfset $mock.next().shouldEqual("two")>
      <cfset $mock.next().shouldEqual("more")>
      <cfset $mock.next().shouldEqual("more")>
    </it>

    <it should="return supplied values in succession if multiple returns are chained">
      <cfset $mock.stubs("next").returns("one").returns("two").returns("more")>
      <cfset $mock.next().shouldEqual("one")>
      <cfset $mock.next().shouldEqual("two")>
      <cfset $mock.next().shouldEqual("more")>
      <cfset $mock.next().shouldEqual("more")>
    </it>

    <it should="return supplied values in succession if multiple return values are supplied">
      <cfset $mock.stubs("next").returns("one", "two", "more")>
      <cfset $mock.next().shouldEqual("one")>
      <cfset $mock.next().shouldEqual("two")>
      <cfset $mock.next().shouldEqual("more")>
      <cfset $mock.next().shouldEqual("more")>
    </it>

    <it should="throw supplied exceptions in succession if a given method is expected multiple times">
      <cfset $mock.stubs("next").throws("one")>
      <cfset $mock.stubs("next").throws("two")>
      <cfset $mock.stubs("next").throws("more")>
      <cfset $mock.next().shouldThrow("one")>
      <cfset $mock.next().shouldThrow("two")>
      <cfset $mock.next().shouldThrow("more")>
      <cfset $mock.next().shouldThrow("more")>
    </it>

    <it should="return supplied values in succession if multiple returns are chained">
      <cfset $mock.stubs("next").throws("one").throws("two").throws("more")>
      <cfset $mock.next().shouldThrow("one")>
      <cfset $mock.next().shouldThrow("two")>
      <cfset $mock.next().shouldThrow("more")>
      <cfset $mock.next().shouldThrow("more")>
    </it>

    <it should="return supplied values or throw supplied exceptions in succession if there are multiple expectations setup in different ways">
      <cfset $mock.stubs("next").returns("one").throws("boo").returns("two", "three")>
      <cfset $mock.stubs("next").throws("yah")>
      <cfset $mock.stubs("next").returns("four")>
      <cfset $mock.stubs("next").throws("done")>
      <cfset $mock.next().shouldEqual("one")>
      <cfset $mock.next().shouldThrow("boo")>
      <cfset $mock.next().shouldEqual("two")>
      <cfset $mock.next().shouldEqual("three")>
      <cfset $mock.next().shouldThrow("yah")>
      <cfset $mock.next().shouldEqual("four")>
      <cfset $mock.next().shouldThrow("done")>
      <cfset $mock.next().shouldThrow("done")>
    </it>

  </describe>

  <!---describe hint="partial stubbing">

    <before>
      <cfset widget = createObject("component", "cfspec.spec.assets.Widget")>
      <cfset mock = createObject("component", "cfspec.lib.Mock").__cfspecInit(widget)>
      <cfset $widget = $(widget)>
    </before>

    <it should="honor a call to the underlying object">
      <cfset $widget.getName().shouldEqual("Widget")>
    </it>

    <it should="throw on call to a non-existant method">
      <cfset $widget.getAge().shouldThrow()>
    </it>

    <it should="stub a new method onto the underlying object">
      <cfset mock.stubs("getAge").returns(21)>
      <cfset $widget.getAge().shouldEqual(21)>
    </it>

    <it should="stub over an existing method on the underlying object">
      <cfset mock.stubs("getName").returns("New Name")>
      <cfset $widget.getName().shouldEqual("New Name")>
    </it>

    <it should="stub new and existing methods on the underlying object">
      <cfset mock.stubs(getName="New Name", getAge=21)>
      <cfset $widget.getName().shouldEqual("New Name")>
      <cfset $widget.getAge().shouldEqual(21)>
    </it>

  </describe--->

</describe>
