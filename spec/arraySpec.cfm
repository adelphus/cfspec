<cfimport taglib="/cfspec" prefix="">

<describe hint="Array">

  <describe hint="equality">
  
	  <it should="equal an array with identical elements">
      <cfset a1 = [1, 2, 3]>
      <cfset a2 = [1, 2, 3]>
	    <cfset $(a1).shouldEqual(a2)>
	  </it>
	
	  <it should="not equal an array with elements that differ by case">
      <cfset a1 = [1, "x", 3]>
      <cfset a2 = [1, "X", 3]>
	    <cfset $(a1).shouldNotEqual(a2)>
	  </it>
	
	  <it should="equal (no-case) an array with elements that differ by case">
      <cfset a1 = [1, "x", 3]>
      <cfset a2 = [1, "X", 3]>
	    <cfset $(a1).shouldEqualNoCase(a2)>
	  </it>
	
  </describe>

  <describe hint="emptiness">

	  <it should="be empty if it has length=0">
      <cfset a1 = []>
	    <cfset $(a1).shouldBeEmpty()>    
	  </it>
	
	  <it should="not be empty if it has at least 1 element">
      <cfset a1 = [1, 2, 3]>
	    <cfset $(a1).shouldNotBeEmpty()>    
	  </it>

  </describe>
  
</describe>