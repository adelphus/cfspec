<cfimport taglib="/cfspec" prefix="">

<describe hint="String">

  <describe hint="equality">
  
	  <it should="equal an identical string">
	    <cfset $("SampleValue").shouldEqual("SampleValue")>
	  </it>
	
	  <it should="not equal a string with different case">
	    <cfset $("sampleValue").shouldNotEqual("SampleValue")>
	  </it>
	
	  <it should="not equal a string with different whitespace">
	    <cfset $("SampleValue ").shouldNotEqual("SampleValue")>
	  </it>
	
	  <it should="equal (no-case) an identical string">
	    <cfset $("SampleValue").shouldEqualNoCase("SampleValue")>
	  </it>
	
	  <it should="equal (no-case) a string with different case">
	    <cfset $("sampleValue").shouldEqualNoCase("SampleValue")>
	  </it>
	
	  <it should="not equal (no-case) a string with different whitespace">
	    <cfset $("SampleValue ").shouldNotEqualNoCase("SampleValue")>
	  </it>

  </describe>

  <describe hint="emptiness">

	  <it should="be empty if it has length=0">
	    <cfset $("").shouldBeEmpty()>    
	  </it>
	
	  <it should="be empty if it has only whitespace characters">
	    <cfset $(" #chr(10)##chr(13)##chr(9)# ").shouldBeEmpty()>    
	  </it>
	
	  <it should="not be empty if it contains non-whitespace characters">
	    <cfset $("   c ").shouldNotBeEmpty()>    
	  </it>

  </describe>

  <describe hint="containment">

	  <it should="contain a substring">
	    <cfset $("Metropolis").shouldContain("tropo")>
	  </it>
	
	  <it should="not contain a non-substring">
	    <cfset $("Metropolis").shouldNotContain("Tropo")>
	  </it>
	  
	  <it should="contain a substring (no-case)">
	    <cfset $("Metropolis").shouldContainNoCase("Tropo")>
	  </it>
	
	  <it should="not contain a non-substring (no-case)">
	    <cfset $("Metropolis").shouldNotContainNoCase("xxx")>
	  </it>
  
  </describe>

  <describe hint="matching">

	  <it should="match a regexp that describes it">
	    <cfset $("Metropolis").shouldMatch("(.)p\1")>
	  </it>

	  <it should="not match a regexp that doesn't describe it">
	    <cfset $("Metropolis").shouldNotMatch("(.)P\1")>
	  </it>

	  <it should="match a regexp that describes it (no-case)">
	    <cfset $("Metropolis").shouldMatchNoCase("(.)P\1")>
	  </it>

	  <it should="not match a regexp that doesn't describe it (no-case)">
	    <cfset $("Metropolis").shouldNotMatchNoCase("(.)\1")>
	  </it>
  
  </describe>
  
</describe>