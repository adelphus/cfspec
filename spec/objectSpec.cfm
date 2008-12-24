<cfimport taglib="/cfspec" prefix="">

<describe hint="Object">

  <describe hint="typing">
  
	  <it should="be an instance of its class">
      <cfset o = createObject("component", "cfspec.spec.assets.Sample")>
	    <cfset $(o).shouldBeAnInstanceOf("cfspec.spec.assets.Sample")>    
	  </it>

	  <it should="be an instance of its parent class">
      <cfset o = createObject("component", "cfspec.spec.assets.Sample")>
	    <cfset $(o).shouldBeAnInstanceOf("cfspec.spec.assets.SuperSample")>    
	  </it>
  
	  <it should="not be an instance of a different class">
      <cfset o = createObject("component", "cfspec.spec.assets.Sample")>
	    <cfset $(o).shouldNotBeAnInstanceOf("OtherClass")>    
	  </it>

  </describe>

  <describe hint="custom predicate">

	  <it should="be foo">
      <cfset o = createObject("component", "cfspec.spec.assets.Sample")>
	    <cfset $(o).shouldBeFoo()>    
	  </it>

	  <it should="not be bar">
      <cfset o = createObject("component", "cfspec.spec.assets.Sample")>
	    <cfset $(o).shouldNotBeBar()>    
	  </it>

	  <it should="be in role=user">
      <cfset o = createObject("component", "cfspec.spec.assets.Sample")>
	    <cfset $(o).shouldBeInRole("user")>    
	  </it>

	  <it should="not be in role=admin">
      <cfset o = createObject("component", "cfspec.spec.assets.Sample")>
	    <cfset $(o).shouldNotBeInRole("admin")>    
	  </it>

  </describe>
  
</describe>