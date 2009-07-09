<!---
  Mock object.  Method name space should be kept clean.
--->
<cfcomponent output="false">



  <cfset _stubbedMethods = structNew()>
  <cfset _stubsMissingMethod = false>



  <cffunction name="__cfspecInit" output="false">
    <cfargument name="__cfspecMockName" default="(unknown)">
    <cfargument name="__cfspecMockType" default="stub">
    <cfset var method = "">
    <cfset _name = __cfspecMockName>
    <cfloop collection="#arguments#" item="method">
      <cfif len(method) lt 8 or left(method, 8) neq "__cfspec">
        <cfif __cfspecMockType eq "stub">
          <cfset stubs(method).returns(arguments[method])>
        <cfelse>
          <cfset expects(method).returns(arguments[method])>
        </cfif>
      </cfif>
    </cfloop>
    <cfreturn this>
  </cffunction>



  <cffunction name="stubs" output="false">
    <cfargument name="method">
    <cfif not structKeyExists(_stubbedMethods, method)>
      <cfset _stubbedMethods[method] =
                 createObject("component", "cfspec.lib.MockExpectations").init(method)>
    </cfif>
    <cfreturn _stubbedMethods[method]>
  </cffunction>



  <cffunction name="expects" output="false">
    <cfargument name="method">
    <cfif not structKeyExists(_stubbedMethods, method)>
      <cfset _stubbedMethods[method] =
                 createObject("component", "cfspec.lib.MockExpectations").init(method, 1, 1)>
    </cfif>
    <cfreturn _stubbedMethods[method]>
  </cffunction>



  <cffunction name="stubsMissingMethod" output="false">
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



  <cffunction name="__cfspecGetFailureMessages" output="false">
    <cfset var messages = arrayNew(1)>
    <cfset var message = "">
    <cfset var method = "">
    <cfloop collection="#_stubbedMethods#" item="method">
      <cfset message = _stubbedMethods[method].getFailureMessage()>
      <cfif message neq "">
        <cfset arrayAppend(messages, "#_name#: #message#")>
      </cfif>
    </cfloop>

    <cfreturn messages>
  </cffunction>



</cfcomponent>
