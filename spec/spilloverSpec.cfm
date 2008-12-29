<cfimport taglib="/cfspec" prefix="">

<describe hint="Spillover">

  <beforeAll>
    <cfset foo = 100>
    <cfset cnt = 0>
  </beforeAll>  

  <before>
    <cfset bar = 100>
  </before>

  <it should="set baz = 1, and change foo & bar">
    <cfset baz = 1>
    <cfset $(foo).shouldEqual(100)>
    <cfset foo = foo + 5>
    <cfset $(bar).shouldEqual(100)>
    <cfset bar = bar + 5>
  </it>
  
  <it should="not find a variable called 'baz' (throws exception)">
    <cfset $(baz).shouldEqual(1)>
  </it>

  <it should="still have bar = 100">
    <cfset $(bar).shouldEqual(100)>
  </it>

  <it should="now have foo = 105">
    <cfset $(foo).shouldEqual(105)>
  </it>

  <it should="have cnt = 3">
    <cfset $(cnt).shouldEqual(3)>
  </it>

  <after>
    <cfset cnt = cnt + 1>
  </after>  

</describe>

<describe hint="after spillover">

  <it should="throw an exception when accessing foo">
    <cfset $(foo).shouldEqual(100)>
  </it>

  <it should="throw an exception when accessing bar">
    <cfset $(bar).shouldEqual(100)>
  </it>

  <it should="throw an exception when accessing baz">
    <cfset $(baz).shouldEqual(100)>
  </it>

  <it should="throw an exception when accessing cnt">
    <cfset $(cnt).shouldEqual(100)>
  </it>

</describe>