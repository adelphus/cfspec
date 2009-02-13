<cfimport taglib="/cfspec" prefix="">

<describe hint="Stub">

  <before>
    <cfset $stub = $(createObject("component", "cfspec.lib.Stub").__cfspecInit(getName="John Doe", getAge=21, isMale=true))>
  </before>

  <it should="return a new stub when an arbitrary method is called">
    <cfset $stub.anyOldMethod().shouldBeAnInstanceOf("cfspec.lib.Stub")>
  </it>
  
  <it should="return the correct value for a method that was supplied on init">
    <cfset $stub.getName().shouldEqual("John Doe")>
    <cfset $stub.getAge().shouldEqual(21)>
    <cfset $stub.shouldBeMale()>
  </it>
  
  <describe hint="stubMissingMethod=false">

    <it should="throw an exception on an unspecified method call">
      <cfset $stub = $(createObject("component", "cfspec.lib.Stub").__cfspecInit(getName="John Doe", stubMissingMethod=false))>
      <cfset $stub.anyOldMethod().shouldThrow()>
    </it>
    
  </describe>
  
</describe>