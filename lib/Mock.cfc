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
    <cfset var matcher = createObject("component", "cfspec.lib.MockExpectations").init(this, method)>
    <cfif not structKeyExists(_stubbedMethods, method)>
      <cfset _stubbedMethods[method] = arrayNew(1)>
    </cfif>
    <cfset arrayPrepend(_stubbedMethods[method], matcher)>
    <cfreturn matcher>
  </cffunction>



  <cffunction name="expects" output="false">
    <cfargument name="method">
    <cfset var matcher = createObject("component", "cfspec.lib.MockExpectations").init(this, method, true)>
    <cfif not structKeyExists(_stubbedMethods, method)>
      <cfset _stubbedMethods[method] = arrayNew(1)>
    </cfif>
    <cfset arrayPrepend(_stubbedMethods[method], matcher)>
    <cfreturn matcher>
  </cffunction>



  <cffunction name="stubsMissingMethod" output="false">
    <cfset _stubsMissingMethod = createObject("component", "cfspec.lib.MockExpectations").init()>
    <cfreturn _stubsMissingMethod>
  </cffunction>



  <cffunction name="onMissingMethod">
    <cfargument name="missingMethodName">
    <cfargument name="missingMethodArguments">
    <cfset var matchers = "">
    <cfset var result = "">
    <cfset var isDone = false>
    <cfset var i = "">
    <cfif structKeyExists(_stubbedMethods, missingMethodName)>
      <cfset matchers = _stubbedMethods[missingMethodName]>
      <cfloop index="i" from="1" to="#arrayLen(matchers)#">
        <cfif matchers[i].isMatch(argumentCollection=missingMethodArguments)>
          <cfset matchers[i].incrementCallCount()>
          <cfif not isDone>
            <cfset result = matchers[i].getReturn()>
            <cfset isDone = true>
          </cfif>
        </cfif>
      </cfloop>
      <cfif isDone>
        <cfreturn result>
      </cfif>
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
    <cfset var matchers = "">
    <cfset var messages = arrayNew(1)>
    <cfset var message = "">
    <cfset var method = "">
    <cfloop collection="#_stubbedMethods#" item="method">
      <cfset matchers = _stubbedMethods[method]>
      <cfloop index="i" from="1" to="#arrayLen(matchers)#">
        <cfset message = matchers[i].getFailureMessage()>
        <cfif message neq "">
          <cfset arrayAppend(messages, "#_name#: #message#")>
        </cfif>
      </cfloop>
    </cfloop>
    <cfreturn messages>
  </cffunction>



  <cffunction name="__cfspecInternExpectations" output="false">
    <cfargument name="method">
    <cfargument name="expectations">
    <cfset var matchers = "">
    <cfset var previous = "">
    <cfset var garbage = "">
    <cfset var i = "">
    <cfif not structKeyExists(_stubbedMethods, method)>
      <cfreturn expectations>
    </cfif>
    <cfset matchers = _stubbedMethods[method]>
    <cfloop index="i" from="1" to="#arrayLen(matchers)#">
      <cfif matchers[i].isEqualTo(expectations)>
        <cfset expectations = matchers[i]>
        <cfset garbage = listPrepend(garbage, previous)>
        <cfset previous = i>
      </cfif>
    </cfloop>
    <cfif garbage neq "">
      <cfloop list="#garbage#" index="i">
        <cfset arrayDeleteAt(_stubbedMethods[method], i)>
      </cfloop>
    </cfif>
    <cfreturn expectations>
  </cffunction>



</cfcomponent>
