<cfcomponent extends="cfspec.Spec"><cffunction name="spec"><cfimport taglib="/cfspec/taglib" prefix="">

  <describe hint="Base Spec Functions">

    <it should="pass">
    </it>

  	<it should="fail">
      <cfset fail()>
    </it>

  	<it should="fail with a message">
      <cfset fail("This is the message.")>
    </it>

  </describe>

</cffunction></cfcomponent>