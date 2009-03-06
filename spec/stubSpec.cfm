<cfimport taglib="/cfspec" prefix="">

<describe hint="Stub">

  <before>
    <cfset $stub = $(createObject("component", "cfspec.lib.Stub").__cfspecInit())>
  </before>

  <it should="throw an exception on an unspecified method call">
    <cfset $stub.undefinedMethod().shouldThrow()>
  </it>

  <it should="return a new stub on an unspecified method call">
    <cfset $stub.stubsMissingMethod()>
    <cfset $stub.undefinedMethod().shouldBeAnInstanceOf("cfspec.lib.Stub")>
  </it>

  <it should="return the specified value on an unspecified method call">
    <cfset $stub.stubsMissingMethod().returns("foo")>
    <cfset $stub.undefinedMethod().shouldEqual("foo")>
  </it>

  <it should="return the correct value for a method that was supplied on init">
    <cfset $stub = $(createObject("component", "cfspec.lib.Stub").__cfspecInit(getName="John Doe", getAge=21, isMale=true))>
    <cfset $stub.getName().shouldEqual("John Doe")>
    <cfset $stub.getAge().shouldEqual(21)>
    <cfset $stub.shouldBeMale()>
  </it>

  <it should="return the supplied value for a given method">
    <cfset $stub.stubs("foo").returns("bar")>
    <cfset $stub.foo().shouldEqual("bar")>
  </it>

  <it should="throw the supplied exception for a given method">
    <cfset $stub.stubs("foo").throws("NoFooAllowed")>
    <cfset $stub.foo().shouldThrow("NoFooAllowed")>
  </it>

  <it should="throw the supplied exception for a given method with a message">
    <cfset $stub.stubs("foo").throws("NoFooAllowed", "message")>
    <cfset $stub.foo().shouldThrow("NoFooAllowed", "message")>
  </it>

  <it should="throw the supplied exception for a given method with a message and details">
    <cfset $stub.stubs("foo").throws("NoFooAllowed", "message", "details")>
    <cfset $stub.foo().shouldThrow("NoFooAllowed", "message", "details")>
  </it>

  <describe hint="multiple return values or throws">

    <it should="return supplied values in succession if a given method is expected multiple times">
      <cfset $stub.stubs("next").returns("one")>
      <cfset $stub.stubs("next").returns("two")>
      <cfset $stub.stubs("next").returns("more")>
      <cfset $stub.next().shouldEqual("one")>
      <cfset $stub.next().shouldEqual("two")>
      <cfset $stub.next().shouldEqual("more")>
      <cfset $stub.next().shouldEqual("more")>
    </it>

    <it should="return supplied values in succession if multiple returns are chained">
      <cfset $stub.stubs("next").returns("one").returns("two").returns("more")>
      <cfset $stub.next().shouldEqual("one")>
      <cfset $stub.next().shouldEqual("two")>
      <cfset $stub.next().shouldEqual("more")>
      <cfset $stub.next().shouldEqual("more")>
    </it>

    <it should="return supplied values in succession if multiple return values are supplied">
      <cfset $stub.stubs("next").returns("one", "two", "more")>
      <cfset $stub.next().shouldEqual("one")>
      <cfset $stub.next().shouldEqual("two")>
      <cfset $stub.next().shouldEqual("more")>
      <cfset $stub.next().shouldEqual("more")>
    </it>

    <it should="throw supplied exceptions in succession if a given method is expected multiple times">
      <cfset $stub.stubs("next").throws("one")>
      <cfset $stub.stubs("next").throws("two")>
      <cfset $stub.stubs("next").throws("more")>
      <cfset $stub.next().shouldThrow("one")>
      <cfset $stub.next().shouldThrow("two")>
      <cfset $stub.next().shouldThrow("more")>
      <cfset $stub.next().shouldThrow("more")>
    </it>

    <it should="return supplied values in succession if multiple returns are chained">
      <cfset $stub.stubs("next").throws("one").throws("two").throws("more")>
      <cfset $stub.next().shouldThrow("one")>
      <cfset $stub.next().shouldThrow("two")>
      <cfset $stub.next().shouldThrow("more")>
      <cfset $stub.next().shouldThrow("more")>
    </it>

    <it should="return supplied values or throw supplied exceptions in succession if there are multiple expectations setup in different ways">
      <cfset $stub.stubs("next").returns("one").throws("boo").returns("two", "three")>
      <cfset $stub.stubs("next").throws("yah")>
      <cfset $stub.stubs("next").returns("four")>
      <cfset $stub.stubs("next").throws("done")>
      <cfset $stub.next().shouldEqual("one")>
      <cfset $stub.next().shouldThrow("boo")>
      <cfset $stub.next().shouldEqual("two")>
      <cfset $stub.next().shouldEqual("three")>
      <cfset $stub.next().shouldThrow("yah")>
      <cfset $stub.next().shouldEqual("four")>
      <cfset $stub.next().shouldThrow("done")>
      <cfset $stub.next().shouldThrow("done")>
    </it>

  </describe>

  <!---describe hint="partial stubbing">

    <before>
      <cfset widget = createObject("component", "cfspec.spec.assets.Widget")>
      <cfset stub = createObject("component", "cfspec.lib.Stub").__cfspecInit(widget)>
      <cfset $widget = $(widget)>
    </before>

    <it should="honor a call to the underlying object">
      <cfset $widget.getName().shouldEqual("Widget")>
    </it>

    <it should="throw on call to a non-existant method">
      <cfset $widget.getAge().shouldThrow()>
    </it>

    <it should="stub a new method onto the underlying object">
      <cfset stub.stubs("getAge").returns(21)>
      <cfset $widget.getAge().shouldEqual(21)>
    </it>

    <it should="stub over an existing method on the underlying object">
      <cfset stub.stubs("getName").returns("New Name")>
      <cfset $widget.getName().shouldEqual("New Name")>
    </it>

    <it should="stub new and existing methods on the underlying object">
      <cfset stub.stubs(getName="New Name", getAge=21)>
      <cfset $widget.getName().shouldEqual("New Name")>
      <cfset $widget.getAge().shouldEqual(21)>
    </it>

  </describe--->

</describe>
