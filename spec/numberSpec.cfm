<cfimport taglib="/cfspec" prefix="">

<describe hint="Number">

  <describe hint="equality">
  
	  <it should="equal an identical number">
	    <cfset $(-42).shouldEqual(-42)>
	    <cfset $(-1.5).shouldEqual(-1.5)>
	    <cfset $(0).shouldEqual(0)>
	    <cfset $(3.1415).shouldEqual(3.1415)>
	    <cfset $(100).shouldEqual(100)>
	  </it>
	
	  <it should="not equal a different number">
	    <cfset $(2).shouldNotEqual(3)>
	  </it>

  </describe>

  <describe hint="comparisons">
  
	  <it should="be less than or equal to a larger number">
	    <cfset $(10).shouldBeLessThanOrEqualTo(11)>
	  </it>

	  <it should="be less than or equal to an equal number">
	    <cfset $(10).shouldBeLessThanOrEqualTo(10)>
	  </it>

	  <it should="not be less than or equal to a smaller number">
	    <cfset $(10).shouldNotBeLessThanOrEqualTo(9)>
	  </it>
  
	  <it should="be less than a larger number">
	    <cfset $(10).shouldBeLessThan(11)>
	  </it>

	  <it should="not be less than an equal number">
	    <cfset $(10).shouldNotBeLessThan(10)>
	  </it>

	  <it should="not be less than a smaller number">
	    <cfset $(10).shouldNotBeLessThan(9)>
	  </it>

	  <it should="not be greater than a larger number">
	    <cfset $(10).shouldNotBeGreaterThan(11)>
	  </it>

	  <it should="not be greater than an equal number">
	    <cfset $(10).shouldNotBeGreaterThan(10)>
	  </it>

	  <it should="be greater than a smaller number">
	    <cfset $(10).shouldBeGreaterThan(9)>
	  </it>

	  <it should="not be greater than or equal to a larger number">
	    <cfset $(10).shouldNotBeGreaterThanOrEqualTo(11)>
	  </it>

	  <it should="be greater than or equal to an equal number">
	    <cfset $(10).shouldBeGreaterThanOrEqualTo(10)>
	  </it>

	  <it should="be greater than or equal to a smaller number">
	    <cfset $(10).shouldBeGreaterThanOrEqualTo(9)>
	  </it>
  
  </describe>

  <describe hint="proximity">

	  <it should="be close to a number within the specified delta">
	    <cfset $(10).shouldBeCloseTo(9.9, 0.2)>
	    <cfset $(10).shouldBeCloseTo(10.9, 1)>
	  </it>
  
	  <it should="not be close to a number outside of the specified delta">
	    <cfset $(10).shouldNotBeCloseTo(9.9, 0.05)>
	    <cfset $(10).shouldNotBeCloseTo(11.1, 1)>
	  </it>
  
  </describe>

</describe>