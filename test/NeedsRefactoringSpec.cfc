<cfcomponent extends="cfspec.Spec"><cffunction name="spec"><cfimport taglib="/cfspec/taglib" prefix="">

  <describe hint="Basic Spec Functions">
  	<it should="meet a string expectation">
      <cfset $("dog").shouldEqual("dog")>
    </it>

  	<it should="fail a string expectation">
      <cfset $("dog").shouldEqual("cat")>
    </it>

  	<it should="meet a numeric expectation">
      <cfset $(1 + 1).shouldEqual(2)>
    </it>

  	<it should="fail a numeric expectation">
      <cfset $(1 + 1).shouldEqual(3)>
    </it>

  	<it should="meet a boolean expectation">
      <cfset $(true).shouldEqual("yes")>
    </it>

  	<it should="fail a boolean expectation">
      <cfset $(true).shouldEqual(0)>
    </it>

  	<it should="meet a date expectation">
  	  <cfset ts = now()>
      <cfset $(ts).shouldEqual(ts)>
    </it>

  	<it should="fail a date expectation">
  	  <cfset ts = now()>
      <cfset $(dateAdd("d", 1, ts)).shouldEqual(ts)>
    </it>

  	<it should="meet an array expectation">
  	  <cfset a1 = [1, "b", true]>
  	  <cfset a2 = [1, "b", true]>
      <cfset $(a1).shouldEqual(a2)>
    </it>

  	<it should="fail an array expectation">
  	  <cfset a1 = [1, "b", true]>
  	  <cfset a2 = [1, "B", true]>
      <cfset $(a1).shouldEqual(a2)>
    </it>

  	<it should="meet a struct expectation">
  	  <cfset st1 = { foo = "bar" }>
  	  <cfset st2 = { foo = "bar" }>
      <cfset $(st1).shouldEqual(st2)>
    </it>

  	<it should="fail a struct expectation">
  	  <cfset st1 = { foo = "bar" }>
  	  <cfset st2 = { foo = "baz" }>
      <cfset $(st1).shouldEqual(st2)>
    </it>
    <describe hint="String empty?">

    	<it should="be empty">
        <cfset $("   ").shouldBeEmpty()>
      </it>

  	  <it should="not be empty">
        <cfset $("foo").shouldNotBeEmpty()>
      </it>

  	  <it should="fail because it's empty and should not be">
        <cfset $("   ").shouldNotBeEmpty()>
      </it>

  	  <it should="fail because it's not empty and should be">
        <cfset $("foo").shouldBeEmpty()>
      </it>

    </describe>

    <describe hint="Array empty?">

    	<it should="be empty">
    	  <cfset a = []>
        <cfset $(a).shouldBeEmpty()>
      </it>

  	  <it should="not be empty">
  	    <cfset a = [1, 2]>
        <cfset $(a).shouldNotBeEmpty()>
      </it>

  	  <it should="fail because it's empty and should not be">
  	    <cfset a = []>
        <cfset $(a).shouldNotBeEmpty()>
      </it>

  	  <it should="fail because it's not empty and should be">
  	    <cfset a = [1, 2]>
        <cfset $(a).shouldBeEmpty()>
      </it>

    </describe>

    <describe hint="Struct empty?">

    	<it should="be empty">
    	  <cfset s = {}>
        <cfset $(s).shouldBeEmpty()>
      </it>

  	  <it should="not be empty">
  	    <cfset s = { foo = "bar" }>
        <cfset $(s).shouldNotBeEmpty()>
      </it>

  	  <it should="fail because it's empty and should not be">
    	  <cfset s = {}>
        <cfset $(s).shouldNotBeEmpty()>
      </it>

  	  <it should="fail because it's not empty and should be">
  	    <cfset s = { foo = "bar" }>
        <cfset $(s).shouldBeEmpty()>
      </it>

    </describe>

  </describe>

</cffunction></cfcomponent>