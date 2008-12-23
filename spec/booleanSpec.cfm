<cfimport taglib="/cfspec" prefix="">

<describe hint="Boolean">

  <describe hint="equality">
  
	  <it should="equal itself">
	    <cfset $(true).shouldEqual(true)>
	    <cfset $(false).shouldEqual(false)>
	  </it>
	
	  <it should="not equal its opposite">
	    <cfset $(true).shouldNotEqual(false)>
	    <cfset $(false).shouldNotEqual(true)>
	  </it>

  </describe>

  <describe hint="predicates">
  
	  <it should="be true and not false">
	    <cfset $(true).shouldBeTrue()>
	    <cfset $(true).shouldNotBeFalse()>
	  </it>

	  <it should="be false and not true">
	    <cfset $(false).shouldBeFalse()>
	    <cfset $(false).shouldNotBeTrue()>
	  </it>

  </describe>

</describe>