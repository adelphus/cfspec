<cfimport taglib="/cfspec" prefix="">

<describe hint="Object">

  <describe hint="custom predicate">

	  <it should="be foo">
      <cfset o = createObject("component", "cfspec.spec.assets.Sample")>
	    <cfset $(o).shouldBeFoo()>    
	  </it>

	  <it should="not be bar">
      <cfset o = createObject("component", "cfspec.spec.assets.Sample")>
	    <cfset $(o).shouldNotBeBar()>    
	  </it>

  </describe>
  
</describe>