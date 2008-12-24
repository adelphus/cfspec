<cfcomponent extends="SuperSample">

  <cffunction name="isFoo">
    <cfreturn true>
  </cffunction>

  <cffunction name="isBar">
    <cfreturn false>
  </cffunction>

  <cffunction name="isInRole">
    <cfargument name="role">
    <cfreturn role eq "user">
  </cffunction>

</cfcomponent>