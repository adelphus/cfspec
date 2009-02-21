<!---
  SpecRunner is the primary controlling object for the duration of the spec.
--->
<cfcomponent output="false">



  <cffunction name="init">
    <cfset resetContext()>
    <cfset _suiteNumber = 0>
    <cfset _startTime = getTickCount()>
    <cfset _exampleCount = 0>
    <cfset _passCount = 0>
    <cfset _pendCount = 0>
    <cfset _output = "">
    <cfreturn this>
  </cffunction>



  <cffunction name="runSpecSuite">
    <cfargument name="specPath">
    <cfargument name="showOutput" default="true">
    <cfset var files = "">
    <cfdirectory action="list" directory="#specPath#" name="files">
    <cfloop query="files">
      <cfif type eq "dir" and left(name, 1) neq ".">
        <cfset runSpecSuite("#specPath#/#name#", false)>
      <cfelseif type eq "file" and reFindNoCase("spec\.cfm$", name)>
        <cfset nextInSuite("#specPath#/#name#")>
        <cfset runSpec()>
      </cfif>
    </cfloop>
    <cfif showOutput>
      <cfset writeOutput(getOutputAsHtml())>
    </cfif>
  </cffunction>



  <cffunction name="nextInSuite">
    <cfargument name="specPath">
    <cfset determineSpecFile(specPath)>
    <cfset resetContext()>
    <cfset _suiteNumber = _suiteNumber + 1>
  </cffunction>



  <cffunction name="runSpecFile">
    <cfargument name="specPath">
    <cfset determineSpecFile(specPath)>
    <cfset runSpec()>
    <cfset writeOutput(getOutputAsHtml())>
  </cffunction>



  <cffunction name="runSpec">
    <cfset resetCurrent()>
    <cfset _context.__cfspecRun(this, _specFile)>
    <cfloop condition="nextTarget()">
      <cftry>
        <cfset _context.__cfspecRun(this, _specFile)>
        <cfset ensureNoDelayedMatchersArePending()>
        <cfcatch type="cfspec">
          <cfset appendOutput("<div class='it #listLast(cfcatch.type, '.')#'>should #cfcatch.message#</div>")>
          <cfset recoverFromException(listLast(cfcatch.type, "."))>
        </cfcatch>
        <cfcatch type="any">
          <cfset appendOutput(formatException(cfcatch))>
          <cfset recoverFromException("fail")>
        </cfcatch>
      </cftry>
      <cfset _context.__cfspecScrub()>
    </cfloop>
  </cffunction>



  <cffunction name="determineSpecFile">
    <cfargument name="specPath">
    <cfset var webRoot = normalizePath(expandPath("/"))>
    <cfset var specFile = normalizePath(specPath)>
    <cfset specPath = specFile>

    <cfif len(specFile) gt len(webRoot) and left(specFile, len(webRoot)) eq webRoot>
      <cfset _specFile = right(specFile, len(specFile) - len(webRoot) + 1)>
      <cfreturn>
    </cfif>

    <cfloop condition="specFile neq '/' and specPath neq normalizePath(expandPath(specFile))">
      <cfset specFile = "/" & listRest(specFile, "/")>
    </cfloop>
    <cfif specFile neq "/">
      <cfset _specFile = specFile>
      <cfreturn>
    </cfif>

    <cfthrow message="Unable to determine the relative path for '#htmlEditFormat(specPath)#'.">
  </cffunction>



  <cffunction name="normalizePath">
    <cfargument name="path">
    <cfreturn reReplace(path, "[/\\]+", "/", "all")>
  </cffunction>



  <cffunction name="recoverFromException">
    <cfargument name="status">
    <cfset var htmlId = "">
    <cfset var css = "">
    <cfset var level = "">

    <cfif status eq "pend">
      <cfset incrementPendCount()>
    </cfif>

    <cfset skipBrokenTargetsAfterException()>
    <cfset level = determineBadNestingLevelAfterException()>
    <cfset _context.__cfspecMergeStatus(status)>

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
  </cffunction>



  <cffunction name="skipBrokenTargetsAfterException">
    <cfif listFind("beforeAll,before,after,afterAll", _currentTag)>
      <cfloop condition="arrayLen(_targets) and find(reReplace(_current, '\d+$', ''), _targets[1]) eq 1">
        <cfset arrayDeleteAt(_targets, 1)>
      </cfloop>
    </cfif>
  </cffunction>



  <cffunction name="determineBadNestingLevelAfterException">
    <cfset var condition = "">
    <cfset var target = "">
    <cfset var i = 0>
    <cfif arrayLen(_targets)>
      <cfset target = _targets[1]>
    </cfif>

    <cfset condition = "(listLen(_current) gt i) and " &
                       "(listLen(target) gt i) and " &
                       "(listGetAt(_current, i + 1) eq listGetAt(target, i + 1))">

    <cfloop condition="#evaluate(condition)#">
      <cfset i = i + 1>
    </cfloop>
    <cfreturn listLen(_current) - i - 1>
  </cffunction>



  <!--- output --->



  <cffunction name="appendOutput">
    <cfargument name="s">
    <cfset _output = _output & s>
  </cffunction>



  <cffunction name="getOutputAsHtml">
    <cfset var html = "">
    <cfset var headerClass = "pass">
    <cfset var failCount = _exampleCount - _passCount - _pendCount>
    <cfset var summary = "#_exampleCount# example">
    <cfset var timerSeconds = ((getTickCount() - _startTime) / 1000) & " seconds">
    <cfif _exampleCount neq 1>
      <cfset summary = summary & "s">
    </cfif>
    <cfif failCount>
      <cfset headerClass = "fail">
    <cfelseif _pendCount>
      <cfset headerClass = "pend">
    </cfif>
    <cfset summary = summary & ", #failCount# failure">
    <cfif failCount neq 1>
      <cfset summary = summary & "s">
    </cfif>
    <cfset summary = summary & ", #_pendCount# pending">
    <cfset html = "<html><head><title>cfSpec</title>" &
                  "<link rel='stylesheet' type='text/css' href='/cfspec/includes/style.css'>" &
                  "</head><body>" &
                  "<div class='header #headerClass#'>" &
                  "<div class='summary'>#summary#</div>" &
                  "<div class='timer'>Finished in <strong>#timerSeconds#</strong></div>" &
                  "cfSpec Results</div>" & _output & "</body></html>">
    <cfreturn html>
  </cffunction>



  <cffunction name="formatException">
    <cfargument name="e">
    <cfset var html = "">
    <cfset var context = "">
    <cfset var i = "">

    <cfset html = "<div class='it fail'>should #_hint#<br /><br /><small><u>#e.type#</u><br />">
    <cfset html = html & "Message: #e.message#<br />Detail: #e.detail#<br />Stack Trace:">
    <cfloop index="i" from="1" to="#arrayLen(e.tagContext)#">
      <cfset context = e.tagContext[i]>
      <cfset html = html & "<pre>  ">
      <cfset html = html & iif(isDefined("context.id"), "context.id", de("???"))>
      <cfset html = html & " at #context.template#(#context.line#,#context.column#)</pre>">
    </cfloop>
    <cfset html = html & "</small></div>">

    <cfreturn html>
  </cffunction>



  <!--- SpecContext methods --->



  <cffunction name="$">
    <cfargument name="obj">
    <cfreturn createObject("component", "Expectations").__cfspecInit(this, obj)>
  </cffunction>



  <cffunction name="$eval">
    <cfargument name="obj">
    <cfreturn createObject("component", "EvalExpectations").__cfspecInit(this, obj)>
  </cffunction>



  <cffunction name="stub">
    <cfreturn createObject("component", "Stub").__cfspecInit(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="mock">
    <cfreturn createObject("component", "Mock").init(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="fail">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = _hint>
    <cfelse>
      <cfset msg = "#_hint#: #msg#">
    </cfif>
    <cfthrow type="cfspec.fail" message="#msg#">
  </cffunction>



  <cffunction name="pend">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = _hint>
    <cfelse>
      <cfset msg = "#_hint#: #msg#">
    </cfif>
    <cfthrow type="cfspec.pend" message="#msg#">
  </cffunction>



  <cffunction name="getBindings">
    <cfargument name="includeHidden" default="false">
    <cfreturn _context.__cfspecGetBindings(includeHidden)>
  </cffunction>



  <cffunction name="setBindings">
    <cfargument name="bindings">
    <cfset _context.__cfspecSetBindings(bindings)>
  </cffunction>



  <!--- context --->



  <cffunction name="resetContext">
    <cfset _context = createObject("component", "cfspec.lib.SpecContext").__cfspecInit()>
    <cfset resetCurrent()>
    <cfset clearPendingException()>
    <cfset _targets = arrayNew(1)>
    <cfset _target = "">
    <cfset _hint = "">
  </cffunction>



  <!--- targets --->



  <cffunction name="isTrial">
    <cfreturn _target eq "">
  </cffunction>



  <cffunction name="makeTarget">
    <cfset _exampleCount = _exampleCount + 1>
    <cfset arrayAppend(_targets, _current)>
  </cffunction>



  <cffunction name="nextTarget">
    <cfif arrayIsEmpty(_targets)>
      <cfreturn false>
    </cfif>
    <cfset resetCurrent()>
    <cfset flagDelayedMatcher(false)>
    <cfset _target = _targets[1]>
    <cfset arrayDeleteAt(_targets, 1)>
    <cfreturn true>
  </cffunction>



  <cffunction name="resetCurrent">
    <cfset _current = "0">
  </cffunction>



  <cffunction name="pushCurrent">
    <cfset stepCurrent()>
    <cfset _current = _current & ",0">
  </cffunction>



  <cffunction name="stepCurrent">
    <cfset var n = val(listLast(_current)) + 1>
    <cfset popCurrent()>
    <cfset _current = listAppend(_current, n)>
  </cffunction>



  <cffunction name="popCurrent">
    <cfset _current = reReplace(_current, "(^|,)\d+$", "")>
  </cffunction>



  <!--- counters --->



  <cffunction name="incrementPassCount">
    <cfset _passCount = _passCount + 1>
  </cffunction>



  <cffunction name="incrementPendCount">
    <cfset _pendCount = _pendCount + 1>
    <cfset _context.__cfspecMergeStatus("pend")>
  </cffunction>



  <!--- flagged and pending conditions --->



  <cffunction name="hasPendingException">
    <cfreturn not isSimpleValue(_pendingException)>
  </cffunction>



  <cffunction name="clearPendingException">
    <cfset _pendingException = "">
  </cffunction>



  <cffunction name="getPendingException">
    <cfreturn _pendingException>
  </cffunction>



  <cffunction name="setPendingException">
    <cfargument name="e">
    <cfset _pendingException = e>
  </cffunction>



  <cffunction name="flagDelayedMatcher">
    <cfargument name="flag" default="true">
    <cfset _inDelayedMatcher = flag>
  </cffunction>



  <cffunction name="isInDelayedMatcher">
    <cfreturn _inDelayedMatcher>
  </cffunction>



  <cffunction name="flagExpectationEncountered">
    <cfargument name="flag" default="true">
    <cfset _hadAnExpectation = flag>
  </cffunction>



  <cffunction name="hadAnExpectation">
    <cfreturn _hadAnExpectation>
  </cffunction>



  <!--- assertions --->



  <cffunction name="ensureNoExceptionsArePending">
    <cfif hasPendingException()>
      <cfthrow object="#getPendingException()#">
    </cfif>
  </cffunction>



  <cffunction name="ensureNoDelayedMatchersArePending">
    <cfif isInDelayedMatcher()>
      <cfset fail("encountered an incomplete expectation")>
    </cfif>
  </cffunction>



  <!--- custom matchers --->



  <cffunction name="registerMatcher">
    <cfargument name="pattern">
    <cfargument name="type">
    <cfset var matcher = arrayNew(1)>
    <cfset arrayAppend(matcher, pattern)>
    <cfset arrayAppend(matcher, type)>
    <cfset getMatchers()>
    <cfset arrayPrepend(_matchers, matcher)>
  </cffunction>



  <cffunction name="simpleMatcher">
    <cfargument name="pattern">
    <cfargument name="expression">
    <cfset var matcher = arrayNew(1)>
    <cfset arrayAppend(matcher, "(#pattern#)")>
    <cfset arrayAppend(matcher, "cfspec.lib.matchers.Simple")>
    <cfset getMatchers()>
    <cfset arrayPrepend(_matchers, matcher)>
    <cfset _simpleMatchers[pattern] = expression>
  </cffunction>



  <cffunction name="getSimpleMatcherExpression">
    <cfargument name="pattern">
    <cfreturn _simpleMatchers[pattern]>
  </cffunction>



  <!--- custom tag handling--->



  <cffunction name="isStartRunnable">
    <cfset var base = reReplace(_current, "\d+$", "")>
    <cfreturn reFind(base & "1(,1)*$", _target) eq 1>
  </cffunction>



  <cffunction name="isInsideRunnable">
    <cfset var base = reReplace(_current, "\d+$", "")>
    <cfreturn find(base, _target) eq 1>
  </cffunction>



  <cffunction name="isEndRunnable">
    <cfif find(_current, _target) neq 1>
      <cfreturn false>
    </cfif>
    <cfif arrayLen(_targets) eq 0>
      <cfreturn true>
    </cfif>
    <cfreturn find(_current, _targets[1]) neq 1>
  </cffunction>



  <cffunction name="describeStartTag">
    <cfargument name="attributes">
    <cfset pushCurrent()>

    <cfif isTrial()>
      <cfreturn "exitTemplate">
    </cfif>

    <cfif not isInsideRunnable()>
      <cfset popCurrent()>
      <cfreturn "exitTag">
    </cfif>

    <cfif isStartRunnable()>
      <cfset _context.__cfspecPush()>
      <cfset appendOutput(describeStartHelper(attributes.hint))>
    </cfif>

    <cfreturn "exitTemplate">
  </cffunction>



  <cffunction name="beforeAllStartTag">
    <cfargument name="attributes">
    <cfset _currentTag = "beforeAll">
    <cfif isTrial() or not isStartRunnable()>
      <cfreturn "exitTag">
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="beforeAllEndTag">
    <cfargument name="attributes">
    <cfset _context.__cfspecSaveBindings()>
    <cfreturn "">
  </cffunction>



  <cffunction name="beforeStartTag">
    <cfargument name="attributes">
    <cfset _currentTag = "before">
    <cfif isTrial() or not isInsideRunnable()>
      <cfreturn "exitTag">
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="beforeEndTag">
    <cfargument name="attributes">
    <cfreturn "">
  </cffunction>



  <cffunction name="itStartTag">
    <cfargument name="attributes">
    <cfset _currentTag = "it">
    <cfset stepCurrent()>

    <cfif isTrial()>
      <cfset makeTarget()>
      <cfreturn "exitTag">
    </cfif>

    <cfif _target eq _current>
      <cfset flagExpectationEncountered(false)>
    <cfelse>
      <cfreturn "exitTag">
    </cfif>

    <cfset _hint = attributes.should>
    <cfreturn "">
  </cffunction>



  <cffunction name="itEndTag">
    <cfargument name="attributes">
    <cfif not hasPendingException()>
      <cfset ensureNoDelayedMatchersArePending()>
      <cfif hadAnExpectation()>
        <cfset incrementPassCount()>
        <cfset appendOutput("<div class='it pass'>should #attributes.should#</div>")>
      <cfelse>
        <cfset pend("There were no expectations.")>
      </cfif>
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="afterStartTag">
    <cfargument name="attributes">
    <cfset _currentTag = "after">
    <cfif isTrial() or not isInsideRunnable()>
      <cfreturn "exitTag">
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="afterEndTag">
    <cfargument name="attributes">
    <cfreturn "">
  </cffunction>



  <cffunction name="afterAllStartTag">
    <cfargument name="attributes">
    <cfset _currentTag = "afterAll">
    <cfif isTrial() or not isEndRunnable()>
      <cfreturn "exitTag">
    </cfif>
    <cfreturn "">
  </cffunction>



  <cffunction name="afterAllEndTag">
    <cfargument name="attributes">
    <cfreturn "">
  </cffunction>



  <cffunction name="describeEndTag">
    <cfargument name="attributes">
    <cfset var status = "">

    <cfset ensureNoExceptionsArePending()>
    <cfset popCurrent()>

    <cfif isTrial() or not isEndRunnable()>
      <cfreturn "exitTag">
    </cfif>

    <cfset status = _context.__cfspecGetStatus()>
    <cfset _context.__cfspecPop()>

    <cfset appendOutput(describeEndHelper(status))>
    <cfreturn "">
  </cffunction>



  <cffunction name="describeStartHelper">
    <cfargument name="hint">
    <cfset var htmlId = "desc_#_suiteNumber#_" & replace(_current, ",", "_", "all")>
    <cfreturn "<h2 id='#htmlId#'>#htmlEditFormat(hint)#</h2><div>">
  </cffunction>



  <cffunction name="describeEndHelper">
    <cfargument name="status">
    <cfset var htmlId = "desc_#_suiteNumber#_" & replace(_current, ",", "_", "all") & "_0">
    <cfset var css = "">
    <cfswitch expression="#status#">
      <cfcase value="fail">  <cfset css = "background:##CC0000">              </cfcase>
      <cfcase value="pend">  <cfset css = "background:##FFFF00;color:black">  </cfcase>
      <cfdefaultcase>        <cfset css = "background:##00CC00">       </cfdefaultcase>
    </cfswitch>
    <cfreturn "<style>###htmlId#{#css#}</style></div>">
  </cffunction>



  <!--- singletons --->



  <cffunction name="getMatchers">
    <cfif not isDefined("_matchers")>
      <cffile action="read" file="#expandPath('/cfspec/config/matchers.json')#" variable="_matchers">
      <cfset _matchers = deserializeJson(_matchers)>
      <cfset _simpleMatchers = structNew()>
    </cfif>
    <cfreturn _matchers>
  </cffunction>



  <cffunction name="getInflector">
    <cfif not isDefined("_inflector")>
      <cfset _inflector = createObject("component", "cfspec.util.Inflector").init()>
    </cfif>
    <cfreturn _inflector>
  </cffunction>



  <cffunction name="getJavaLoader">
    <cfset var classpath = "">
    <cfset var i = "">
    <cfif not isDefined("_javaLoader")>
      <cffile action="read" file="#expandPath('/cfspec/config/classpath.json')#" variable="classpath">
      <cfset classpath = deserializeJson(classpath)>
      <cfloop index="i" from="1" to="#arrayLen(classpath)#">
        <cfset classpath[i] = expandPath(classpath[i])>
      </cfloop>
      <cfset _javaLoader = createObject("component", "cfspec.external.javaloader.JavaLoader").init(classpath)>
    </cfif>
    <cfreturn _javaLoader>
  </cffunction>



</cfcomponent>
