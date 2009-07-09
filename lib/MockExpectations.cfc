<!---
  MockExpectations is responsible for handling the setup and evaluation
  of the expectations that are put onto a mock object.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfargument name="name" default="(missing method)">
    <cfargument name="minCount" default="0">
    <cfargument name="maxCount" default="-1">
    <cfset _name = name>
    <cfset _callCount = 0>
    <cfset _returns = arrayNew(1)>
    <cfset times(minCount, maxCount)>
    <cfreturn this>
  </cffunction>



  <cffunction name="returns" output="false">
    <cfset var i = "">
    <cfset var entry = "">
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
    <cfset var entry = createObject("component", "MockReturnException").init(type, message, detail)>
    <cfset arrayAppend(_returns, entry)>
    <cfreturn this>
  </cffunction>



  <cffunction name="times" output="false">
    <cfargument name="minCount">
    <cfargument name="maxCount" default="#minCount#">
    <cfset _minCount = minCount>
    <cfset _maxCount = maxCount>
    <cfif minCount eq 0 and maxCount eq 0>
      <cfset _expected = "never">
    <cfelseif minCount eq 1 and maxCount eq 1>
      <cfset _expected = "once">
    <cfelseif minCount eq 2 and maxCount eq 2>
      <cfset _expected = "twice">
    <cfelseif minCount eq 1 and maxCount eq -1>
      <cfset _expected = "at least once">
    <cfelseif minCount gt 1 and maxCount eq -1>
      <cfset _expected = "at least #minCount# times">
    <cfelseif minCount eq 0 and maxCount eq 1>
      <cfset _expected = "at most once">
    <cfelseif minCount eq 0 and maxCount gt 1>
      <cfset _expected = "at most #maxCount# times">
    <cfelseif minCount gt 0 and maxCount eq minCount>
      <cfset _expected = "#minCount# times">
    <cfelse>
      <cfset _expected = "#minCount# to #maxCount# times">
    </cfif>
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



  <cffunction name="getReturn" output="false">
    <cfset var entry = "">
    <cfset _callCount = _callCount + 1>
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
    <cfset var actual = "">
    <cfif (_callCount lt _minCount) or (_maxCount ge 0 and _callCount gt _maxCount)>
      <cfif _callCount eq 0>
        <cfset actual = "never invoked">
      <cfelseif _callCount eq 1>
        <cfset actual = "invoked once">
      <cfelseif _callCount eq 2>
        <cfset actual = "invoked twice">
      <cfelse>
        <cfset actual = "invoked #_callCount# times">
      </cfif>
      <cfset message = 'expected "#_name#" to be invoked #_expected#, but it was #actual#.'>
    </cfif>
    <cfreturn message>
  </cffunction>



</cfcomponent>
