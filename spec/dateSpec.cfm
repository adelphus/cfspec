<cfimport taglib="/cfspec" prefix="">

<describe hint="Date">

  <describe hint="equality">
  
	  <it should="equal itself">
      <cfset dt = now()>
	    <cfset $(dt).shouldEqual(dt)>
	  </it>
	
	  <it should="not equal a different date">
      <cfset dt = now()>
	    <cfset $(dateAdd('d', 1, dt)).shouldNotEqual(dt)>
	  </it>

  </describe>

</describe>