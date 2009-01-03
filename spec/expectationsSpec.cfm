<cfimport taglib="/cfspec" prefix="">

<describe hint="Expectations">

  <before>
    <cfset runner = createObject("component", "cfspec.spec.assets.SpecRunnerStub")>
    <cfset $expectations = $(createObject("component", "cfspec.lib.Expectations"))>
  </before>

  <describe hint="Be">
  
    <it should="expect shouldBeTrue to return true">
      <cfset $expectations.init(runner, true)>
      <cfset $expectations.shouldBeTrue()>
    </it>

    <it should="expect shouldBeFalse to return true">
      <cfset $expectations.init(runner, false)>
      <cfset $expectations.shouldBeFalse()>
    </it>

    <it should="expect shouldBeEmpty to return true">
      <cfset $expectations.init(runner, "")>
      <cfset $expectations.shouldBeEmpty()>
    </it>

    <it should="expect shouldBeAnInstanceOf to return true">
      <cfset $expectations.init(runner, createObject("component", "cfspec.spec.assets.Widget"))>
      <cfset $expectations.shouldBeAnInstanceOf("cfspec.spec.assets.Widget")>
    </it>

    <it should="expect shouldBeArbitraryPredicate to return true">
      <cfset $expectations.init(runner, createObject("component", "cfspec.spec.assets.HappyGuy"))>
      <cfset $expectations.shouldBeHappy()>
    </it>

  </describe>

  <describe hint="BeCloseTo">
  
    <it should="expect shouldBeCloseTo to return true">
      <cfset $expectations.init(runner, 4.51)>
      <cfset $expectations.shouldBeCloseTo(5, 0.5)>
    </it>

  </describe>
    
  <describe hint="BeComparison">
  
    <it should="expect shouldBeLessThan to return true">
      <cfset $expectations.init(runner, 5)>
      <cfset $expectations.shouldBeLessThan(6)>
    </it>

    <it should="expect shouldBeLessThanOrEqualTo to return true">
      <cfset $expectations.init(runner, 5)>
      <cfset $expectations.shouldBeLessThanOrEqualTo(6)>
    </it>

    <it should="expect shouldBeGreaterThanOrEqualTo to return true">
      <cfset $expectations.init(runner, 5)>
      <cfset $expectations.shouldBeGreaterThanOrEqualTo(4)>
    </it>

    <it should="expect shouldBeGreaterThan to return true">
      <cfset $expectations.init(runner, 5)>
      <cfset $expectations.shouldBeGreaterThan(4)>
    </it>

  </describe>
    
  <describe hint="Equal">
  
    <it should="expect shouldEqual to return true">
      <cfset $expectations.init(runner, "foo")>
      <cfset $expectations.shouldEqual("foo")>
    </it>

	  <it should="expect shouldEqualNoCase to return true">
	    <cfset $expectations.init(runner, "foo")>
	    <cfset $expectations.shouldEqualNoCase("FOO")>
	  </it>
	
	  <it should="expect shouldEqualNumeric to return true">
	    <cfset $expectations.init(runner, 123)>
	    <cfset $expectations.shouldEqualNumeric("123foo")>
	  </it>
	
	  <it should="expect shouldEqualDate to return true">
	    <cfset $expectations.init(runner, createDate(1999, 12, 31))>
	    <cfset $expectations.shouldEqualDate("December 31, 1999")>
	  </it>
	
	  <it should="expect shouldEqualBoolean to return true">
	    <cfset $expectations.init(runner, true)>
	    <cfset $expectations.shouldEqualBoolean(1)>
	  </it>
	
	  <it should="expect shouldEqualString to return true">
	    <cfset $expectations.init(runner, "foo")>
	    <cfset $expectations.shouldEqualString("foo")>
	  </it>
	
	  <it should="expect shouldEqualStringNoCase to return true">
	    <cfset $expectations.init(runner, "foo")>
	    <cfset $expectations.shouldEqualStringNoCase("FOO")>
	  </it>
	
	  <it should="expect shouldEqualObject to return true">
	    <cfset target = createObject("component", "cfspec.spec.assets.SupportsEquals").init("foo")>
	    <cfset $expectations.init(runner, target)>
	    <cfset target = createObject("component", "cfspec.spec.assets.SupportsEquals").init("foo")>
	    <cfset $expectations.shouldEqualObject(target)>
	  </it>
	
	  <it should="expect shouldEqualStruct to return true">
	    <cfset target = {foo=1,bar='a',baz=true}>
	    <cfset $expectations.init(runner, target)>
	    <cfset target = {foo=1,bar='a',baz=true}>
	    <cfset $expectations.shouldEqualStruct(target)>
	  </it>
	
	  <it should="expect shouldEqualStructNoCase to return true">
	    <cfset target = {foo=1,bar='a',baz=true}>
	    <cfset $expectations.init(runner, target)>
	    <cfset target = {foo=1,bar='A',baz=true}>
	    <cfset $expectations.shouldEqualStructNoCase(target)>
	  </it>
	
	  <it should="expect shouldEqualArray to return true">
	    <cfset target = [1,'a',true]>
	    <cfset $expectations.init(runner, target)>
	    <cfset target = [1,'a',true]>
	    <cfset $expectations.shouldEqualArray(target)>
	  </it>
	
	  <it should="expect shouldEqualArrayNoCase to return true">
	    <cfset target = [1,'a',true]>
	    <cfset $expectations.init(runner, target)>
	    <cfset target = [1,'A',true]>
	    <cfset $expectations.shouldEqualArrayNoCase(target)>
	  </it>
	
	  <it should="expect shouldEqualQuery to return true">
	    <cfset target = queryNew("")>
	    <cfset queryAddColumn(target, "foo", listToArray("a,b,c"))>
	    <cfset queryAddColumn(target, "bar", listToArray("d,e,f"))>
	    <cfset queryAddColumn(target, "baz", listToArray("g,h,i"))>
	    <cfset $expectations.init(runner, target)>
	    <cfset target = queryNew("")>
	    <cfset queryAddColumn(target, "foo", listToArray("a,b,c"))>
	    <cfset queryAddColumn(target, "bar", listToArray("d,e,f"))>
	    <cfset queryAddColumn(target, "baz", listToArray("g,h,i"))>
	    <cfset $expectations.shouldEqualQuery(target)>
	  </it>
	
	  <it should="expect shouldEqualQueryNoCase to return true">
	    <cfset target = queryNew("")>
	    <cfset queryAddColumn(target, "foo", listToArray("a,b,c"))>
	    <cfset queryAddColumn(target, "bar", listToArray("d,e,f"))>
	    <cfset queryAddColumn(target, "baz", listToArray("g,h,i"))>
	    <cfset $expectations.init(runner, target)>
	    <cfset target = queryNew("")>
	    <cfset queryAddColumn(target, "foo", listToArray("a,b,c"))>
	    <cfset queryAddColumn(target, "bar", listToArray("d,E,f"))>
	    <cfset queryAddColumn(target, "baz", listToArray("g,h,i"))>
	    <cfset $expectations.shouldEqualQueryNoCase(target)>
	  </it>
  
  </describe>

  <describe hint="Have">
  
    <it should="expect shouldHave(n) to return a delayed matcher, and true when items() is called on it">
      <cfset $expectations.init(runner, listToArray("a,b,c"))>
      <cfset $result = $expectations.shouldHave(3)>
      <cfset $result.shouldBeDelayed()>
      <cfset $result.items().shouldBeTrue()>
    </it>

    <it should="expect shouldHaveExactly(n) to return a delayed matcher, and true when items() is called on it">
      <cfset $expectations.init(runner, listToArray("a,b,c"))>
      <cfset $result = $expectations.shouldHaveExactly(3)>
      <cfset $result.shouldBeDelayed()>
      <cfset $result.items().shouldBeTrue()>
    </it>

    <it should="expect shouldHaveAtLeast(n) to return a delayed matcher, and true when items() is called on it">
      <cfset $expectations.init(runner, listToArray("a,b,c"))>
      <cfset $result = $expectations.shouldHaveAtLeast(3)>
      <cfset $result.shouldBeDelayed()>
      <cfset $result.items().shouldBeTrue()>
    </it>

    <it should="expect shouldHaveAtMost(n) to return a delayed matcher, and true when items() is called on it">
      <cfset $expectations.init(runner, listToArray("a,b,c"))>
      <cfset $result = $expectations.shouldHaveAtMost(3)>
      <cfset $result.shouldBeDelayed()>
      <cfset $result.items().shouldBeTrue()>
    </it>

  </describe>

  <describe hint="Match">
  
    <it should="expect shouldMatch to return true">
      <cfset $expectations.init(runner, "The quick brown fox...")>
      <cfset $expectations.shouldMatch("quick (\w+) fox")>
    </it>

    <it should="expect shouldMatchNoCase to return true">
      <cfset $expectations.init(runner, "The quick brown fox...")>
      <cfset $expectations.shouldMatchNoCase("QUICK (\w+) FOX")>
    </it>

  </describe>

</describe>