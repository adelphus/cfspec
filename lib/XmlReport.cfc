<!---
  XmlReport is an XML version of the SpecRunner's output report.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfset reset()>
    <cfreturn this>
  </cffunction>



  <cffunction name="reset" output="false">
    <cfset _block = arrayNew(1)>
    <cfset _examples = "">
    <cfset _timer = getTickCount()>
    <cfset _exampleCount = 0>
    <cfset _errorCount = 0>
    <cfset _failureCount = 0>
  </cffunction>



  <cffunction name="setSpecStats" output="false">
    <cfargument name="specStats">
    <cfset _specStats = specStats>
  </cffunction>



  <cffunction name="setSpecFile">
    <cfargument name="specFile">
    <cfset _specFile = reReplaceNoCase(specFile, "\.cfm$", "")>
  </cffunction>



  <cffunction name="getOutput" output="false">
    <cfset var xml = "">
    <cfset xml = '<?xml version="1.0" encoding="UTF-8" ?>' &
                 '<testsuite errors="#_errorCount#" ' &
                            'failures="#_failureCount#" ' &
                            'hostname="#cgi.server_name#" ' &
                            'name="#_specFile#" ' &
                            'tests="#_exampleCount#" ' &
                            'time="#_specStats.getTimer()#" ' &
                            'timestamp="#this.getTimestamp()#">' &
                   '<properties></properties>' &
                   _examples &
                   '<system-out><![CDATA[]]></system-out>' &
                   '<system-err><![CDATA[]]></system-err>' &
                 '</testsuite>'>
    <cfreturn xml>
  </cffunction>



  <cffunction name="enterBlock" output="false">
    <cfargument name="hint">
    <cfset arrayAppend(_block, hint)>
  </cffunction>



  <cffunction name="addExample" output="false">
    <cfargument name="status">
    <cfargument name="expectation">
    <cfargument name="exception" default="#structNew()#">
    <cfset var s = '<testcase classname="#_specFile#" name="#arrayToList(_block, ' ')#: it #xmlFormat(expectation)##iif(status eq "pend", de(" (PENDING)"), de(""))#" time="#this.getTimer()#"'>
    <cfparam name="exception.message" default="">
    <cfif status eq "fail">
      <cfset _failureCount = _failureCount + 1>
      <cfset s = s & '><failure>' & xmlFormat(exception.message) & '</failure></testcase>'>
    <cfelseif status eq "error">
      <cfset _errorCount = _errorCount + 1>
      <cfset s = s & '><error>' & formatException(exception) & '</error></testcase>'>
    <cfelse>
      <cfset s = s & ' />'>
    </cfif>
    <cfset _examples = _examples & s>
    <cfset _exampleCount = _exampleCount + 1>
  </cffunction>



  <cffunction name="exitBlock" output="false">
    <cfset arrayDeleteAt(_block, arrayLen(_block))>
  </cffunction>



  <cffunction name="getTimestamp" output="false">
    <cfset var t = now()>
    <cfreturn dateFormat(t, "yyyy-mm-dd") & "T" & timeFormat(t, "HH:mm:ss")>
  </cffunction>



  <cffunction name="getTimer" output="false">
    <cfset var timer = _timer>
    <cfset _timer = getTickCount()>
    <cfreturn (_timer - timer) / 1000>
  </cffunction>



  <!--- PRIVATE --->



  <cffunction name="getSpecStatsSummary" access="private" output="false">
    <cfset var title = '<span>cfSpec Results</span>'>
    <cfset var summary = '<div class="summary">#_specStats.getCounterSummary()#</div>'>
    <cfset var timer = '<strong>#_specStats.getTimerSummary()#</strong>'>
    <cfset timer = '<div class="timer">Finished in #timer#</div>'>
    <cfreturn '<div class="header #_specStats.getStatus()#">#summary##timer##title#</div>'>
  </cffunction>



  <cffunction name="formatException" access="private" output="false">
    <cfargument name="e">
    <cfset var context = "">
    <cfset var s = "">
    <cfset var i = "">
    <cfset s = "<u>#e.type#</u><br />Message: #xmlFormat(e.message)#<br />Detail: #xmlFormat(e.detail)#<br />Stack Trace:">
    <cfloop index="i" from="1" to="#arrayLen(e.tagContext)#">
      <cfset context = e.tagContext[i]>
      <cfset s = s & "<pre>  ">
      <cfset s = s & iif(isDefined("context.id"), "context.id", de("???"))>
      <cfset s = s & " at #context.template#(#context.line#,#context.column#)</pre>">
    </cfloop>
    <cfreturn "<small>#s#</small>">
  </cffunction>



</cfcomponent>
