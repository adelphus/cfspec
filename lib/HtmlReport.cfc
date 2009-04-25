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
    <cfargument name="detail">
    <cfif (_blockStatus[1] eq "pass") or (_blockStatus[1] eq "pend" and status neq "pass")>
      <cfset _blockStatus[1] = status>
    </cfif>
    <cfset _block[1] = _block[1] & '<div class="it #status#">#expectation#</div>'>
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
    <cffile action="read" file="#expandPath('../includes/style.css')#" variable="style">
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

<!---


  <cffunction name="toString">
    <cfreturn "<html>#getHead()##getBody()#</html>">
  </cffunction>



  <cffunction name="getHead">
    <cfset var css = "">
    <cffile action="read" file="#expandPath('/cfspec/includes/style.css')#" variable="css">
    <cfset css = reReplace(css, "\s\s+", " ", "all")>
    <cfreturn "<head><title>cfSpec</title><style>#css#</style></head>">
  </cffunction>



  <cffunction name="getBody">
    <cfreturn "<body><div class='header #_specStats.getStatus()#'>" &
              "<div class='summary'>#_specStats.getCounterSummary()#</div>" &
              "<div class='timer'>Finished in <strong>#_specStats.getTimerSummary()#</strong></div>" &
              "cfSpec Results</div>" & _output & "</body>">
  </cffunction>



  <cffunction name="reportException">
    <cfargument name="e">
    <cfset var context = "">
    <cfset var i = "">

    <cfset _output = _output & "<div class='it fail'>should #getHint()#<br /><br />" &
                     "<small><u>#e.type#</u><br />" &
                     "Message: #e.message#<br />" &
                     "Detail: #e.detail#<br />" &
                     "Stack Trace:">

    <cfloop index="i" from="1" to="#arrayLen(e.tagContext)#">
      <cfset context = e.tagContext[i]>
      <cfset _output = _output & "<pre>  " & 
                       iif(isDefined("context.id"), "context.id", de("???")) &
                       " at #context.template#(#context.line#,#context.column#)</pre>">
    </cfloop>

    <cfset _output = _output & "</small></div>">
  </cffunction>



  <cffunction name="enterBlock">
    <cfargument name="hint">
    <cfset var htmlId = "desc_#_specRunner.getSuiteNumber()#_" &
                        replace(_specRunner.getCurrent(), ",", "_", "all")>
    <cfset _output = _output & "<h2 id='#htmlId#'>#htmlEditFormat(hint)#</h2><div>">
  </cffunction>



  <cffunction name="reportTest">
    <cfargument name="hint">
    <cfset _output = _output & "<div class='it pass'>should #htmlEditFormat(hint)#</div>")>
  </cffunction>



  <cffunction name="exitBlock">
    <cfargument name="status">
    <cfset var htmlId = "desc_#_specRunner.getSuiteNumber()#_" &
                        replace(_specRunner.getCurrent(), ",", "_", "all") & "_0">
    <cfset var css = "">

    <cfswitch expression="#status#">
      <cfcase value="fail">  <cfset css = "background:##CC0000">              </cfcase>
      <cfcase value="pend">  <cfset css = "background:##FFFF00;color:black">  </cfcase>
      <cfdefaultcase>        <cfset css = "background:##00CC00">       </cfdefaultcase>
    </cfswitch>

    <cfset _output = _output & "<style>###htmlId#{#css#}</style></div>">
  </cffunction>
































    <cfloop condition="level gt 0">
      <cfset css = "">
      <cfif _context.__cfspecGetStatus() eq "pend">
        <cfset css = "background:##FFFF00;color:black">
      </cfif>
      <cfset _context.__cfspecPop()>
      <cfset popCurrent()>
      <cfif css neq "">
        <cfset htmlId = "desc_#_suiteNumber#_#replace(_current, ',', '_', 'all')#_0">
        <cfset appendOutput("<style>###htmlId#{#css#}</style>")>
      </cfif>
      <cfset appendOutput("</div>")>
      <cfset level = level - 1>
    </cfloop>


    --->
</cfcomponent>
