<!---
  HtmlReport is an HTML version of the SpecRunner's output report.
--->
<cfcomponent output="false">



  <cffunction name="init">
    <cfargument name="specStats">
    <cfset _specStats = specStats>
    <cfset _blockStatus = arrayNew(1)>
    <cfset _block = arrayNew(1)>
    <cfset arrayAppend(_blockStatus, "pass")>
    <cfset arrayAppend(_block, "")>
    <cfreturn this>
  </cffunction>



  <cffunction name="getOutput">
    <cfset var head = "<head><title>cfSpec</title>#getStyle()#</head>">
    <cfset var body = "<body>#getSpecStatsSummary()##_block[1]#</body>">
    <cfreturn "<html>#head##body#</html>">
  </cffunction>



  <cffunction name="enterBlock">
    <cfargument name="hint">
    <cfset arrayPrepend(_blockStatus, "pass")>
    <cfset arrayPrepend(_block, '#hint#</h2><div>')>
  </cffunction>



  <cffunction name="addExample">
    <cfargument name="status">
    <cfargument name="expectation">
    <cfargument name="exception" default="">
    <cfset var s = '<div class="it #status#">#expectation#'>
    <cfif (_blockStatus[1] eq "pass") or (_blockStatus[1] eq "pend" and status neq "pass")>
      <cfset _blockStatus[1] = status>
    </cfif>
    <cfif not isSimpleValue(exception)>
      <cfset s = s & '<br /><br />' & formatException(exception)>
    </cfif>
    <cfset s = s & '</div>'>
    <cfset _block[1] = _block[1] & s>
  </cffunction>



  <cffunction name="exitBlock">
    <cfset _block[2] = _block[2] & '<h2 class="#_blockStatus[1]#">#_block[1]#</div>'>
    <cfif (_blockStatus[2] eq "pass") or (_blockStatus[2] eq "pend" and _blockStatus[1] neq "pass")>
      <cfset _blockStatus[2] = _blockStatus[1]>
    </cfif>
    <cfset arrayDeleteAt(_blockStatus, 1)>
    <cfset arrayDeleteAt(_block, 1)>
  </cffunction>



  <!--- PRIVATE --->



  <cffunction name="getStyle" access="private">
    <cfset var style = "">
    <cffile action="read" file="#expandPath('/cfspec/includes/style.css')#" variable="style">
    <cfset style = trim(reReplace(style, "\s+", " ", "all"))>
    <cfreturn "<style> #style# </style>">
  </cffunction>



  <cffunction name="getSpecStatsSummary" access="private">
    <cfset var title = '<span>cfSpec Results</span>'>
    <cfset var summary = '<div class="summary">#_specStats.getCounterSummary()#</div>'>
    <cfset var timer = '<strong>#_specStats.getTimerSummary()#</strong>'>
    <cfset timer = '<div class="timer">Finished in #timer#</div>'>
    <cfreturn '<div class="header #_specStats.getStatus()#">#summary##timer##title#</div>'>
  </cffunction>



  <cffunction name="formatException" access="private">
    <cfargument name="e">
    <cfset var context = "">
    <cfset var s = "">
    <cfset var i = "">
    <cfset s = "<u>#e.type#</u><br />Message: #e.message#<br />Detail: #e.detail#<br />Stack Trace:">
    <cfloop index="i" from="1" to="#arrayLen(e.tagContext)#">
      <cfset context = e.tagContext[i]>
      <cfset s = s & "<pre>  ">
      <cfset s = s & iif(isDefined("context.id"), "context.id", de("???"))>
      <cfset s = s & " at #context.template#(#context.line#,#context.column#)</pre>">
    </cfloop>
    <cfreturn "<small>#s#</small>">
  </cffunction>



</cfcomponent>
