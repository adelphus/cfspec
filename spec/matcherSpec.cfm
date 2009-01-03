<cfimport taglib="/cfspec" prefix="">

<describe hint="Matcher (base object)">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.Matcher"))>
  </before>

  <it should="not be delayed">
    <cfset $matcher.shouldNotBeDelayed()>
  </it>

  <describe hint="inspect">
    
    <it should="represent an integer directly with no decimal point">
      <cfset $matcher.inspect(42.0).shouldEqual("42")>
      <cfset $matcher.inspect(0).shouldEqual("0")>
      <cfset $matcher.inspect(-5).shouldEqual("-5")>
    </it>

    <it should="represent a float directly">
      <cfset $matcher.inspect(42.1).shouldEqual("42.1")>
      <cfset $matcher.inspect(0.05).shouldEqual("0.05")>
      <cfset $matcher.inspect(-5.13).shouldEqual("-5.13")>
    </it>

    <it should="represent a date in YYYY-MM-DD HH:MM TT format">
      <cfset $matcher.inspect(createDate(2009, 1, 3)).shouldEqual("2009-01-03 12:00 AM")>
    </it>

    <it should="represent a boolean as true or false">
      <cfset $matcher.inspect(true).shouldEqual("true")>
      <cfset $matcher.inspect(false).shouldEqual("false")>
      <cfset $matcher.inspect("Yes").shouldEqual("true")>
      <cfset $matcher.inspect("No").shouldEqual("false")>
    </it>

    <it should="represent a string in single quotes with backslash escaping">
      <cfset $matcher.inspect("foo").shouldEqual("'foo'")>
      <cfset $matcher.inspect("foo\bar'baz").shouldEqual("'foo\\bar\'baz'")>
    </it>

    <it should="represent an object by calling inspect()">
      <cfset target = createObject("component", "cfspec.spec.assets.SupportsEquals").init("foo")>
      <cfset $matcher.inspect(target).shouldEqual("&lt;SupportsEquals:ACBD18DB4CC2F85CEDEF654FCCC4A4D8&gt;")>
    </it>

    <it should="represent a struct as {key1=value1,key2=value2} with keys in textnocase order">
      <cfset target = {}>
      <cfset $matcher.inspect(target).shouldEqual("{}")>
      <cfset target = {foo=1, bar='a', baz=true}>
      <cfset $matcher.inspect(target).shouldEqual("{BAR='a',BAZ=true,FOO=1}")>
    </it>

    <it should="represent an array as [value1,value2]">
      <cfset target = []>
      <cfset $matcher.inspect(target).shouldEqual("[]")>
      <cfset target = [1, 'a', true]>
      <cfset $matcher.inspect(target).shouldEqual("[1,'a',true]")>
    </it>

    <it should="represent a query as {COLUMNS=['col1','col2'],DATA=[[value11,value12],[value21,value22]]} with columns in textnocase order">
      <cfset target = queryNew("")>
      <cfset $matcher.inspect(target).shouldEqual("{COLUMNS=[],DATA=[]}")>
      <cfset queryAddColumn(target, "foo", listToArray('a,b,c'))>
      <cfset queryAddColumn(target, "bar", listToArray('d,e,f'))>
      <cfset queryAddColumn(target, "baz", listToArray('g,h,i'))>
      <cfset $matcher.inspect(target).shouldEqual("{COLUMNS=['BAR','BAZ','FOO'],DATA=[['d','g','a'],['e','h','b'],['f','i','c']]}")>
    </it>

  </describe>

  <describe hint="throw">

    <it should="be able to throw an exception">
      <cfset $matcher.throw().shouldThrow("Application")>
    </it>

    <it should="be able to throw an exception with type specified">
      <cfset $matcher.throw("SpecialException").shouldThrow("SpecialException")>
    </it>

    <it should="be able to throw an exception with type specified and a message">
      <cfset $matcher.throw("SpecialException", "It didn't work!").shouldThrow("SpecialException", "It didn't work!")>
    </it>

    <it should="be able to rethrow an exception">
      <cftry>
        <cfthrow message="Rethrown Exception">
        <cfcatch>
          <cfset $matcher.rethrow(cfcatch).shouldThrow("Application", "Rethrown Exception")>
        </cfcatch>
      </cftry>
    </it>

  </describe>

</describe>