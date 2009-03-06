<!---
  SpecStats keeps tracks of how many tests have passed, failed or pended, and how long it took.
--->
<cfcomponent output="false">



  <cffunction name="init">
    <cfset _startTime = getTickCount()>
    <cfset _exampleCount = 0>
    <cfset _passCount = 0>
    <cfset _pendCount = 0>
    <cfreturn this>
  </cffunction>



  <cffunction name="incrementExampleCount">
    <cfset _exampleCount = _exampleCount + 1>
  </cffunction>



  <cffunction name="incrementPassCount">
    <cfset _passCount = _passCount + 1>
  </cffunction>



  <cffunction name="incrementPendCount">
    <cfset _pendCount = _pendCount + 1>
  </cffunction>



  <cffunction name="getStatus">
    <cfset var failCount = _exampleCount - _passCount - _pendCount>
    <cfset var status = "pass">
    <cfif failCount>
      <cfset status = "fail">
    <cfelseif _pendCount>
      <cfset status = "pend">
    </cfif>
    <cfreturn status>
  </cffunction>



  <cffunction name="getCounterSummary">
    <cfset var failCount = _exampleCount - _passCount - _pendCount>
    <cfset var summary = "#_exampleCount# example">
    <cfif _exampleCount neq 1>
      <cfset summary = summary & "s">
    </cfif>
    <cfset summary = summary & ", #failCount# failure">
    <cfif failCount neq 1>
      <cfset summary = summary & "s">
    </cfif>
    <cfset summary = summary & ", #_pendCount# pending">
    <cfreturn summary>
  </cffunction>



  <cffunction name="getTimerSummary">
    <cfreturn ((getTickCount() - _startTime) / 1000) & " seconds">
  </cffunction>



</cfcomponent>
