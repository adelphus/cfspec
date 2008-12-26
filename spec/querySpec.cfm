<cfimport taglib="/cfspec" prefix="">

<describe hint="Query">

  <describe hint="equality">
  
	  <it should="equal a query with identical elements">
      <cfset q1 = queryNew("")>
      <cfset queryAddColumn(q1, "foo", listToArray("1,2,3"))>
      <cfset queryAddColumn(q1, "bar", listToArray("a,b,c"))>
      <cfset q2 = queryNew("")>
      <cfset queryAddColumn(q2, "foo", listToArray("1,2,3"))>
      <cfset queryAddColumn(q2, "bar", listToArray("a,b,c"))>
	    <cfset $(q1).shouldEqual(q2)>
	  </it>
	
	  <it should="not equal a struct with elements that differ by case">
      <cfset q1 = queryNew("")>
      <cfset queryAddColumn(q1, "foo", listToArray("1,2,3"))>
      <cfset queryAddColumn(q1, "bar", listToArray("a,b,c"))>
      <cfset q2 = queryNew("")>
      <cfset queryAddColumn(q2, "foo", listToArray("1,2,3"))>
      <cfset queryAddColumn(q2, "bar", listToArray("a,B,c"))>
	    <cfset $(q1).shouldNotEqual(q2)>
	  </it>
	
	  <it should="equal (no-case) a struct with elements that differ by case">
      <cfset q1 = queryNew("")>
      <cfset queryAddColumn(q1, "foo", listToArray("1,2,3"))>
      <cfset queryAddColumn(q1, "bar", listToArray("a,b,c"))>
      <cfset q2 = queryNew("")>
      <cfset queryAddColumn(q2, "foo", listToArray("1,2,3"))>
      <cfset queryAddColumn(q2, "bar", listToArray("a,B,c"))>
	    <cfset $(q1).shouldEqualNoCase(q2)>
	  </it>
	
  </describe>

  <describe hint="emptiness">

	  <it should="be empty if it has recordCount=0">
      <cfset q1 = queryNew("foo,bar")>
	    <cfset $(q1).shouldBeEmpty()>    
	  </it>
	
	  <it should="not be empty if it has at least 1 record">
      <cfset q1 = queryNew("")>
      <cfset queryAddColumn(q1, "foo", listToArray("1,2,3"))>
      <cfset queryAddColumn(q1, "bar", listToArray("a,b,c"))>
	    <cfset $(q1).shouldNotBeEmpty()>
	  </it>

  </describe>
  
</describe>