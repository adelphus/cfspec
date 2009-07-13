<!---
  MockExpectations is responsible for handling the setup and evaluation
  of the expectations that are put onto a mock object.
--->
<cfcomponent output="false">

  <cffunction name="vars">
  <cfreturn variables>
  </cffunction>

  <cffunction name="init" output="false">
    <cfargument name="parent" default="">
    <cfargument name="name" default="(missing method)">
    <cfargument name="isExpected" default="false">
    <cfset _parent = parent>
    <cfset _name = name>
    <cfset _callCount = 0>
    <cfset _returns = arrayNew(1)>
    <cfif isExpected>
      <cfset once()>
    <cfelse>
      <cfset times(0, -1)>
    </cfif>
    <cfreturn this>
  </cffunction>



  <cffunction name="with" output="false">
    <cfset _argumentMatcher = createObject("component", "cfspec.lib.ArgumentMatcher").init()>
    <cfset _argumentMatcher.setArguments(argumentCollection=arguments)>
    <cfreturn this>
  </cffunction>



  <cffunction name="withEval" output="false">
    <cfargument name="expression">
    <cfset _argumentMatcher = createObject("component", "cfspec.lib.ArgumentEvalMatcher").init()>
    <cfset _argumentMatcher.setExpression(expression)>
    <cfreturn this>
  </cffunction>



  <cffunction name="isMatch" output="false">
    <cfif isDefined("_argumentMatcher")>
      <cfreturn _argumentMatcher.isMatch(argumentCollection=arguments)>
    </cfif>
    <cfreturn true>
  </cffunction>



  <cffunction name="asString" output="false">
    <cfif isDefined("_argumentMatcher")>
      <cfreturn _argumentMatcher.asString()>
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="isEqualTo" output="false">
    <cfargument name="expectations">
    <cfreturn compare(asString(), expectations.asString()) eq 0>
  </cffunction>



  <cffunction name="returns" output="false">
    <cfset var i = "">
    <cfset var entry = "">
    <cfset var intern = this>
    <cfif isObject(_parent)>
      <cfset intern = _parent.__cfspecInternExpectations(_name, this)>
    </cfif>
    <cfreturn intern.__cfspecReturns(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="__cfspecReturns" output="false">
    <cfset var entry = "">
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(arguments)#">
      <cfset entry = createObject("component", "MockReturnValue").init(arguments[i])>
      <cfset arrayAppend(_returns, entry)>
    </cfloop>
    <cfreturn this>
  </cffunction>



  <cffunction name="throws" output="false">
    <cfargument name="type">
    <cfargument name="message" default="">
    <cfargument name="detail" default="">
    <cfset var intern = this>
    <cfif isObject(_parent)>
      <cfset intern = _parent.__cfspecInternExpectations(_name, this)>
    </cfif>
    <cfreturn intern.__cfspecThrows(type, message, detail)>
  </cffunction>



  <cffunction name="__cfspecThrows" output="false">
    <cfargument name="type">
    <cfargument name="message" default="">
    <cfargument name="detail" default="">
    <cfset var entry = createObject("component", "MockReturnException").init(type, message, detail)>
    <cfset arrayAppend(_returns, entry)>
    <cfreturn this>
  </cffunction>



  <cffunction name="times" output="false">
    <cfargument name="minCount">
    <cfargument name="maxCount" default="#minCount#">
    <cfset _minCount = minCount>
    <cfset _maxCount = maxCount>
    <cfreturn this>
  </cffunction>



  <cffunction name="never" output="false">
    <cfreturn times(0)>
  </cffunction>



  <cffunction name="once" output="false">
    <cfreturn times(1)>
  </cffunction>



  <cffunction name="twice" output="false">
    <cfreturn times(2)>
  </cffunction>



  <cffunction name="atLeast" output="false">
    <cfargument name="minCount">
    <cfreturn times(minCount, -1)>
  </cffunction>



  <cffunction name="atLeastOnce" output="false">
    <cfreturn times(1, -1)>
  </cffunction>



  <cffunction name="atMost" output="false">
    <cfargument name="maxCount">
    <cfreturn times(0, maxCount)>
  </cffunction>



  <cffunction name="atMostOnce" output="false">
    <cfreturn times(0, 1)>
  </cffunction>



  <cffunction name="inSequence" output="false">
    <cfreturn this>
  </cffunction>



  <cffunction name="incrementCallCount" output="false">
    <cfset _callCount = _callCount + 1>
  </cffunction>



  <cffunction name="getReturn" output="false">
    <cfset var entry = "">
    <cfif not arrayIsEmpty(_returns)>
      <cfset entry = _returns[1]>
      <cfif arrayLen(_returns) gt 1>
        <cfset arrayDeleteAt(_returns, 1)>
      </cfif>
      <cfreturn entry.eval()>
    </cfif>
    <cfreturn createObject("component", "cfspec.lib.Mock").__cfspecInit()>
  </cffunction>



  <cffunction name="getFailureMessage" output="false">
    <cfset var message = "">
    <cfif (_callCount lt _minCount) or (_maxCount ge 0 and _callCount gt _maxCount)>
      <cfset message = 'expected "#_name#" to be invoked #expectedText()#, but it was #actualText()#.'>
    </cfif>
    <cfreturn message>
  </cffunction>



  <!--- PRIVATE --->



  <cffunction name="expectedText" access="private" output="false">
    <cfset var expected = "">
    <cfif _minCount eq _maxCount>
      <cfif _minCount eq 0>
        <cfset expected = "never">
      <cfelseif _minCount eq 1>
        <cfset expected = "once">
      <cfelseif _minCount eq 2>
        <cfset expected = "twice">
      <cfelse>
        <cfset expected = "#_minCount# times">
      </cfif>
    <cfelseif _minCount lt _maxCount>
      <cfif _maxCount eq 1>
        <cfset expected = "at most once">
      <cfelseif _minCount eq 0>
        <cfset expected = "at most #_maxCount# times">
      <cfelse>
        <cfset expected = "#_minCount# to #_maxCount# times">
      </cfif>
    <cfelse>
      <cfif _minCount eq 0>
        <cfset expected = "any number of times">
      <cfelseif _minCount eq 1>
        <cfset expected = "at least once">
      <cfelse>
        <cfset expected = "at least #_minCount# times">
      </cfif>
    </cfif>
    <cfreturn expected>
  </cffunction>



  <cffunction name="actualText" access="private" output="false">
    <cfset var actual = "">
    <cfif _callCount eq 0>
      <cfset actual = "never invoked">
    <cfelseif _callCount eq 1>
      <cfset actual = "invoked once">
    <cfelseif _callCount eq 2>
      <cfset actual = "invoked twice">
    <cfelse>
      <cfset actual = "invoked #_callCount# times">
    </cfif>
    <cfreturn actual>
  </cffunction>



</cfcomponent>
