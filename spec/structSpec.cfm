<cfimport taglib="/cfspec" prefix="">

<describe hint="Struct">

  <describe hint="equality">
  
	  <it should="equal a struct with identical elements">
      <cfset s1 = { foo="bar" }>
      <cfset s2 = { foo="bar" }>
	    <cfset $(s1).shouldEqual(s2)>
	  </it>
	
	  <it should="not equal a struct with elements that differ by case">
      <cfset s1 = { foo="BAR" }>
      <cfset s2 = { foo="bar" }>
	    <cfset $(s1).shouldNotEqual(s2)>
	  </it>
	
	  <it should="equal (no-case) a struct with elements that differ by case">
      <cfset s1 = { foo="BAR" }>
      <cfset s2 = { foo="bar" }>
	    <cfset $(s1).shouldEqualNoCase(s2)>
	  </it>
	
  </describe>

  <describe hint="emptiness">

	  <it should="be empty if it has length=0">
      <cfset s1 = {}>
	    <cfset $(s1).shouldBeEmpty()>    
	  </it>
	
	  <it should="not be empty if it has at least 1 element">
      <cfset s1 = { foo="bar" }>
	    <cfset $(s1).shouldNotBeEmpty()>    
	  </it>

  </describe>
  
</describe>