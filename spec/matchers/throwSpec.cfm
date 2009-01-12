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
  
  <describe hint="with various arguments (some intentional failures)">
    
    <it should="FAIL because no exception was thrown">
      <cfset $target.getName().shouldThrow()>
    </it>

    <it should="FAIL because no exception was thrown">
      <cfset $target.getName().shouldThrow("RecordNotSaved")>
    </it>

    <it should="PASS because an exception was thrown">
      <cfset $target.nonExistantMethod().shouldThrow()>
    </it>

    <it should="FAIL because the wrong type of exception was thrown">
      <cfset $target.nonExistantMethod().shouldThrow("RecordNotSaved")>
    </it>

    <it should="FAIL because the exception message doesn't match">
      <cfset $target.nonExistantMethod().shouldThrow("Application", "zzzzz")>
    </it>

    <it should="FAIL because the exception detail doesn't match">
      <cfset $target.nonExistantMethod().shouldThrow("Application", "nonExistantMethod", "zzzzz")>
    </it>

    <it should="PASS because the exception matches the type">
      <cfset $target.nonExistantMethod().shouldThrow("Application")>
    </it>

    <it should="PASS because the exception matches the type and message">
      <cfset $target.nonExistantMethod().shouldThrow("Application", "nonExistantMethod")>
    </it>

    <it should="PASS because the exception matches the type, message, and details">
      <cfset $target.nonExistantMethod().shouldThrow("Application", "nonExistantMethod", "Ensure that the method is defined")>
    </it>

    <it should="PASS because no exception was thrown">
      <cfset $target.getName().shouldNotThrow()>
    </it>

    <it should="PASS because no exception was thrown">
      <cfset $target.getName().shouldNotThrow("RecordNotSaved")>
    </it>

    <it should="FAIL because an exception was thrown">
      <cfset $target.nonExistantMethod().shouldNotThrow()>
    </it>

    <it should="RETHROW because the wrong type of exception was thrown">
      <cfset $target.nonExistantMethod().shouldNotThrow("RecordNotSaved")>
    </it>

    <it should="PASS because the wrong type of exception was thrown, but is then caught">
      <cfset $target.nonExistantMethod().shouldNotThrow("RecordNotSaved").shouldThrow()>
    </it>

    <it should="RETHROW because the exception message doesn't match">
      <cfset $target.nonExistantMethod().shouldNotThrow("Application", "zzzzz")>
    </it>

    <it should="PASS because the exception message doesn't match, but is then caught">
      <cfset $target.nonExistantMethod().shouldNotThrow("Application", "zzzzz").shouldThrow()>
    </it>

    <it should="RETHROW because the exception detail doesn't match">
      <cfset $target.nonExistantMethod().shouldNotThrow("Application", "nonExistantMethod", "zzzzz")>
    </it>

    <it should="PASS because the exception detail doesn't match, but is then caught">
      <cfset $target.nonExistantMethod().shouldNotThrow("Application", "nonExistantMethod", "zzzzz").shouldThrow()>
    </it>

    <it should="FAIL because the exception matches the type">
      <cfset $target.nonExistantMethod().shouldNotThrow("Application")>
    </it>

    <it should="FAIL because the exception matches the type and message">
      <cfset $target.nonExistantMethod().shouldNotThrow("Application", "nonExistantMethod")>
    </it>

    <it should="FAIL because the exception matches the type, message, and details">
      <cfset $target.nonExistantMethod().shouldNotThrow("Application", "nonExistantMethod", "Ensure that the method is defined")>
    </it>
    
  </describe>

</describe>