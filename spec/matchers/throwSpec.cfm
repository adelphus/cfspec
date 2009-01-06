<cfimport taglib="/cfspec" prefix="">

<describe hint="Throw">

  <before>
    <cfset $matcher = $(createObject("component", "cfspec.lib.matchers.Throw").init())>    
    <cfset $target = $(createObject("component", "cfspec.spec.assets.Widget"))>
  </before>

  <it should="match when target throws an exception">
    <cfset $target.nonExistantMethod().shouldThrow()>
  </it>

  <it should="not match when target does not throw an exception">
    <cfset $target.getName().shouldNotThrow()>
  </it>
  
  <it should="provide a useful failure message">
    <cfset $matcher.isMatch($target.getName())>
    <cfset $matcher.getFailureMessage().shouldEqual("expected to throw Any, got no exception")>
  </it>
  
  <it should="provide a useful negative failure message">
    <cfset $matcher.isMatch($target.getName())>
    <cfset $matcher.getNegativeFailureMessage().shouldMatch("expected not to throw Any, got no exception")>
  </it>
  
  <it should="describe itself">
    <cfset $matcher.getDescription().shouldEqual("throw Any")>
  </it>  
  
</describe>