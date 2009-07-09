<!---
  Mock object.  Method name space should be kept clean.
--->
<cfcomponent output="false">



  <cfset _stubbedMethods = structNew()>
  <cfset _stubsMissingMethod = false>



  <cffunction name="__cfspecInit">
    <cfset var method = "">
    <cfloop collection="#arguments#" item="method">
      <cfset stubs(method).returns(arguments[method])>
    </cfloop>
    <cfreturn this>
  </cffunction>



  <cffunction name="stubs">
    <cfargument name="method">
    <cfif not structKeyExists(_stubbedMethods, method)>
      <cfset _stubbedMethods[method] = createObject("component", "cfspec.lib.MockExpectations").init()>
    </cfif>
    <cfreturn _stubbedMethods[method]>
  </cffunction>



  <cffunction name="stubsMissingMethod">
    <cfset _stubsMissingMethod = createObject("component", "cfspec.lib.MockExpectations").init()>
    <cfreturn _stubsMissingMethod>
  </cffunction>



  <cffunction name="onMissingMethod">
    <cfargument name="missingMethodName">
    <cfargument name="missingMethodArguments">
    <cfif structKeyExists(_stubbedMethods, missingMethodName)>
      <cfreturn _stubbedMethods[missingMethodName].getReturn()>
    </cfif>
    <cfif isObject(_stubsMissingMethod)>
      <cfreturn _stubsMissingMethod.getReturn()>
    </cfif>
    <cfif isDefined("_obj.__cfspecOriginalOnMissingMethod")>
      <cfreturn _obj.__cfspecOriginalOnMissingMethod(missingMethodName, missingMethodArguments)>
    </cfif>
    <cfthrow message="The method #missingMethodName# was not found.">
  </cffunction>



</cfcomponent>
