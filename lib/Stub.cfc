<!---
  Stub object.  Method name space should be kept clean.
--->
<cfcomponent output="false">



  <cfset __cfspecMethods = structNew()>



  <cffunction name="__cfspecInit">
    <cfset __cfspecMethods = structCopy(arguments)>
    <cfreturn this>
  </cffunction>



  <cffunction name="onMissingMethod">
    <cfargument name="missingMethodName">
    <cfargument name="missingMethodArguments">
    <cfif structKeyExists(__cfspecMethods, missingMethodName)>
      <cfreturn __cfspecMethods[missingMethodName]>
    </cfif>
    <cfif not structKeyExists(__cfspecMethods, "stubMissingMethod") or __cfspecMethods.stubMissingMethod>
      <cfreturn createObject("component", "Stub")>
    <cfelse>
      <cfthrow message="The method #missingMethodName# was not found.">
    </cfif>
  </cffunction>



</cfcomponent>
