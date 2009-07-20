<cfcomponent extends="Widget" output="false">



  <cffunction name="getSpecial" output="false">
    <cfreturn "Special">
  </cffunction>



  <cffunction name="proxyGetName" output="false">
    <cfreturn getName()>
  </cffunction>



  <cffunction name="proxyGetSpecial" output="false">
    <cfreturn getSpecial()>
  </cffunction>



</cfcomponent>
