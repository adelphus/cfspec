<!---
  PartialMock object.  Used to inject methods into an underlying object.
--->
<cfcomponent extends="Mock" output="false">



  <cffunction name="init" output="false">
    <cfargument name="obj">
    <cfset var name = listLast(getMetaData(obj).name, ".")>
    <cfset _obj = obj>
    <cfset obj.__cfspecPartialMock = this>
    <cfset obj.__cfspecGetFailureMessages = __cfspecGetPartialMockFailureMessages>
    <cfif isDefined("obj.onMissingMethod")>
      <cfset obj.__cfspecOriginalOnMissingMethod = obj.onMissingMethod>
    </cfif>
    <cfset obj.onMissingMethod = __cfspecOnMissingMethod>
    <cfreturn __cfspecInit(name)>
  </cffunction>



  <cffunction name="stubs" output="false">
    <cfargument name="method">
    <cfset var expectations = super.stubs(method)>
    <cfset structDelete(_obj, method)>
    <cfset _obj.__cfspecObliterateMethod = __cfspecObliterateMethod>
    <cfset _obj.__cfspecObliterateMethod(method)>
    <cfreturn expectations>
  </cffunction>



  <cffunction name="expects" output="false">
    <cfargument name="method">
    <cfset var expectations = super.expects(method)>
    <cfset structDelete(_obj, method)>
    <cfset _obj.__cfspecObliterateMethod = __cfspecObliterateMethod>
    <cfreturn expectations>
  </cffunction>



  <cffunction name="__cfspecObliterateMethod" output="false">
    <cfargument name="method">
    <cfset variables[method] = this.__cfspecPartialMock.__cfspecObliteratedMethod>
  </cffunction>



  <cffunction name="__cfspecObliteratedMethod" output="false">
    <cfthrow message="Partial mocks can only override methods that are called externally or with an explicit 'this' scope.">
  </cffunction>



  <cffunction name="__cfspecGetPartialMockFailureMessages">
    <cfreturn this.__cfspecPartialMock.__cfspecGetFailureMessages()>
  </cffunction>



  <cffunction name="__cfspecOnMissingMethod" output="false">
    <cfargument name="missingMethodName">
    <cfargument name="missingMethodArguments">
    <cfreturn this.__cfspecPartialMock.onMissingMethod(missingMethodName, missingMethodArguments)>
  </cffunction>



</cfcomponent>
