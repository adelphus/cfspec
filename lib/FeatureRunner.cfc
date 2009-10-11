<!---
  FeatureRunner is the primary controlling object for the duration of the feature suite.
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfset _fileUtils = request.singletons.getFileUtils()>
    <cfset _suiteNumber = 0>
    <cfset _steps = structNew()>
    <cfset resetContext()>
    <cfreturn this>
  </cffunction>



  <cffunction name="setReport" output="false">
    <cfargument name="report">
    <cfset _report = report>
  </cffunction>



  <cffunction name="setSpecStats" output="false">
    <cfargument name="specStats">
    <cfset _specStats = specStats>
    <cfif isDefined("_report")>
      <cfset _report.setSpecStats(specStats)>
    </cfif>
  </cffunction>



  <cffunction name="loadStepDefinitions">
    <cfargument name="stepPath">
    <cfset var files = "">
    <cfdirectory action="list" directory="#stepPath#" name="files">
    <cfloop query="files">
      <cfif type eq "file" and reFindNoCase("steps\.cfm$", name)>
        <cfset _stepFile = _fileUtils.relativePath("#stepPath#/#name#")>
        <cfset resetCurrent()>
        <cfset _context.__cfspecRun(this, _stepFile)>
      </cfif>
    </cfloop>
  </cffunction>



  <cffunction name="runFeatureSuite" output="false">
    <cfargument name="specPath">
    <cfset var files = "">
    <cfdirectory action="list" directory="#specPath#" name="files">
    <cfloop query="files">
      <cfif type eq "dir" and left(name, 1) neq ".">
        <cfset runFeatureSuite("#specPath#/#name#")>
      <cfelseif type eq "file" and reFindNoCase("\.feature$", name)>
        <cfset _suiteNumber = _suiteNumber + 1>
        <cfset runFeature("#specPath#/#name#")>
      </cfif>
    </cfloop>
  </cffunction>



  <cffunction name="runFeature" output="false">
    <cfargument name="specPath">
    <cfset var story = "">
    <cfset var line = "">
    <cfset var matchData = "">
    <cfset var result = "">
    <cfset var title = "">
    <cfset var background = arrayNew(1)>
    <cfset var i = "">
    <cffile action="read" file="#specPath#" variable="story">
    <cfset story = listToArray(story, chr(10))>

    <!--- extract the story title --->
    <cfloop condition="arrayLen(story) and not reFindNoCase('^\s*Feature:', story[1])">
      <cfset arrayDeleteAt(story, 1)>
    </cfloop>
    <cfif not arrayLen(story)><cfthrow message="Feature missing title (#specPath#)"></cfif>
    <cfset title = trim(reReplaceNoCase(story[1], "^\s*Feature:(.*)$", "\1"))>
    <cfset arrayDeleteAt(story, 1)>
    <cfset _report.enterBlock(title)>

    <!--- extract the background --->
    <cfloop condition="arrayLen(story) and not reFindNoCase('^\s*(Background|Scenario):', story[1])">
      <cfset arrayDeleteAt(story, 1)>
    </cfloop>
    <cfif arrayLen(story) and reFind("^\s*Background:", story[1])>
      <cfset arrayDeleteAt(story, 1)>
      <cfloop condition="arrayLen(story) and not reFindNoCase('^\s*Scenario:', story[1])">
        <cfif reFindNoCase("^\s*(Given|When|Then|And)", story[1])>
          <cfset arrayAppend(background, story[1])>
        </cfif>
        <cfset arrayDeleteAt(story, 1)>
      </cfloop>
    </cfif>

    <cfloop condition="arrayLen(story)">

      <!--- extract scenario --->
      <cfloop condition="arrayLen(story) and not reFindNoCase('^\s*Scenario:', story[1])">
        <cfset arrayDeleteAt(story, 1)>
      </cfloop>
      <cfif not arrayLen(story)><cfbreak></cfif>
      <cfset title = trim(reReplaceNoCase(story[1], "^\s*Scenario:(.*)$", "\1"))>
      <cfset arrayDeleteAt(story, 1)>
      <cfset _report.enterBlock(title)>

      <cfset resetContext()>
      <!--- run background steps --->
      <cfif not arrayIsEmpty(background)>
        <cfloop index="i" from="1" to="#arrayLen(background)#">
          <cfset title = trim(reReplaceNoCase(background[i], "^\s*((?:Given|When|Then|And)\s+.*)$", "\1"))>
          <cfset result = runStep(trim(reReplaceNoCase(title, "^(Given|When|Then|And)", "")))>
          <cfset title = "Background: " & title>
          <cfif isObject(result)>
            <cfif find("cfspec", result.type)>
              <cfset _report.addExample(listLast(result.type, "."), title & result.message)>
            <cfelse>
              <cfset _report.addExample("fail", title, result)>
            </cfif>
          <cfelse>
            <cfset _report.addExample(result, title)>
          </cfif>
        </cfloop>
      </cfif>
      <!--- run scenario steps --->
      <cfloop condition="arrayLen(story) and not reFindNoCase('^\s*Scenario:', story[1])">
        <cfloop condition="arrayLen(story) and not reFindNoCase('^\s*(Scenario:|Given|When|Then|And)', story[1])">
          <cfset arrayDeleteAt(story, 1)>
        </cfloop>
        <cfif arrayLen(story) and not reFindNoCase("^\s*Scenario:", story[1])>
          <cfset title = trim(reReplaceNoCase(story[1], "^\s*((?:Given|When|Then|And)\s+.*)$", "\1"))>
          <cfset arrayDeleteAt(story, 1)>
          <cfset result = runStep(trim(reReplaceNoCase(title, "^(Given|When|Then|And)", "")))>
          <cfif isObject(result)>
            <cfif find("cfspec", result.type)>
              <cfset _report.addExample(listLast(result.type, "."), title & result.message)>
            <cfelse>
              <cfset _report.addExample("fail", title, result)>
            </cfif>
          <cfelse>
            <cfset _report.addExample(result, title)>
          </cfif>
        </cfif>
      </cfloop>
      <cftry>
        <cfset ensureAllMockExpectationsArePassing()>
        <cfcatch type="cfspec.fail">
          <cfset _specStats.incrementExampleCount()>
          <cfset _report.addExample("fail", reReplace(cfcatch.message, "^: ", ""))>
        </cfcatch>
      </cftry>

      <cfset _report.exitBlock()>
    </cfloop>
    <cfset _report.exitBlock()>
  </cffunction>



  <cffunction name="runStep" output="false">
    <cfargument name="step">
    <cfset var regexp = "">
    <cfset var matchData = "">
    <cfset var stepTarget = "">
    <cfset var bindings = structNew()>
    <cfset var key = "">
    <cfset var i = "">
    <cfset _specStats.incrementExampleCount()>
    <cfloop collection="#_steps#" item="regexp">
      <cfset matchData = reFindNoCase("^\s*#regexp#\s*$", step, 1, true)>
      <cfif matchData.pos[1]>
        <cfset stepTarget = _steps[regexp]>
        <cfset resetCurrent()>
        <cfset _target = stepTarget.target>

        <cfset i = 2>
        <cfloop list="#stepTarget.keys#" index="key">
          <cfset bindings[key] = "">
          <cfif matchData.len[i]>
            <cfset bindings[key] = mid(step, matchData.pos[i], matchData.len[i])>
          </cfif>
          <cfset i = i + 1>
        </cfloop>

        <cftry>
          <cfset _context.__cfspecSetBindings(bindings)>
          <cfset flagDelayedMatcher(false)>
          <cfset _context.__cfspecRun(this, stepTarget.file)>

          <cfset ensureNoDelayedMatchersArePending()>

          <cfcatch type="any">
            <cfreturn cfcatch>
          </cfcatch>
        </cftry>
        <cfset _specStats.incrementPassCount()>
        <cfreturn "pass">
      </cfif>
    </cfloop>
    <cfset _specStats.incrementPendCount()>
    <cfreturn "pend">
  </cffunction>



  <cffunction name="clearPendingException" output="false">
    <cfset _pendingException = "">
  </cffunction>



  <cffunction name="getPendingException" output="false">
    <cfreturn _pendingException>
  </cffunction>



  <cffunction name="setPendingException" output="false">
    <cfargument name="e">
    <cfset _pendingException = e>
  </cffunction>



  <cffunction name="flagDelayedMatcher" output="false">
    <cfargument name="flag" default="true">
    <cfset _inDelayedMatcher = flag>
  </cffunction>



  <cffunction name="flagExpectationEncountered" output="false">
    <cfargument name="flag" default="true">
    <cfset _hadAnExpectation = flag>
  </cffunction>



  <cffunction name="ensureNoExceptionsArePending" output="false">
    <cfif hasPendingException()>
      <cfthrow object="#getPendingException()#">
    </cfif>
  </cffunction>



  <cffunction name="ensureNoDelayedMatchersArePending" output="false">
    <cfif isInDelayedMatcher()>
      <cfset fail("encountered an incomplete expectation")>
    </cfif>
  </cffunction>



  <cffunction name="getBindings" output="false">
    <cfargument name="includeHidden" default="false">
    <cfreturn _context.__cfspecGetBindings(includeHidden)>
  </cffunction>



  <cffunction name="setBindings" output="false">
    <cfargument name="bindings">
    <cfset _context.__cfspecSetBindings(bindings)>
  </cffunction>



  <cffunction name="fail" output="false">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = _hint>
    <cfelse>
      <cfset msg = "#_hint#: #msg#">
    </cfif>
    <cfthrow type="cfspec.fail" message="#msg#">
  </cffunction>



  <cffunction name="pend" output="false">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = _hint>
    <cfelse>
      <cfset msg = "#_hint#: #msg#">
    </cfif>
    <cfthrow type="cfspec.pend" message="#msg#">
  </cffunction>



  <cffunction name="stepTag" output="false">
    <cfargument name="attributes">
    <cfset stepCurrent()>

    <cfif isTrial()>
      <cfset makeTarget(attributes)>
      <cfreturn "exitTag">
    </cfif>

    <cfif _target eq _current>
      <cfset flagExpectationEncountered(false)>
    <cfelse>
      <cfreturn "exitTag">
    </cfif>

    <cfreturn "">
  </cffunction>



  <!--- PRIVATE --->



  <cffunction name="recoverFromException" access="private" output="false">
    <cfargument name="status">
    <cfset var level = "">

    <cfif status eq "pend">
      <cfset _specStats.incrementPendCount()>
      <cfset _context.__cfspecMergeStatus("pend")>
    </cfif>

    <cfset skipBrokenTargetsAfterException()>
    <cfset level = determineBadNestingLevelAfterException()>
    <cfset _context.__cfspecMergeStatus(status)>

    <cfloop condition="level gt 0">
      <cfset _context.__cfspecPop()>
      <cfset popCurrent()>
      <cfset _report.exitBlock()>
      <cfset level = level - 1>
    </cfloop>
  </cffunction>



  <cffunction name="skipBrokenTargetsAfterException" access="private" output="false">
    <cfif listFind("beforeAll,before,after,afterAll", _currentTag)>
      <cfloop condition="arrayLen(_targets) and find(reReplace(_current, '\d+$', ''), _targets[1]) eq 1">
        <cfset arrayDeleteAt(_targets, 1)>
      </cfloop>
    </cfif>
  </cffunction>



  <cffunction name="determineBadNestingLevelAfterException" access="private" output="false">
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



  <cffunction name="resetContext" access="private" output="false">
    <cfset _context = createObject("component", "cfspec.lib.SpecContext").__cfspecInit()>
    <cfset _targets = arrayNew(1)>
    <cfset _target = "">
    <cfset _hint = "">
    <cfset resetCurrent()>
    <cfset clearPendingException()>
  </cffunction>



  <cffunction name="isTrial" access="private" output="false">
    <cfreturn _target eq "">
  </cffunction>



  <cffunction name="makeTarget" access="private" output="false">
    <cfargument name="attributes">
    <cfset var regexp = "">

    <cfif structKeyExists(attributes, "given")>
      <cfset regexp = attributes.given>
    <cfelseif structKeyExists(attributes, "when")>
      <cfset regexp = attributes.when>
    <cfelseif structKeyExists(attributes, "then")>
      <cfset regexp = attributes.then>
    </cfif>
    <cfset regexp = trim(regexp)>

    <cfset defineStepMatcher(regexp, attributes)>
  </cffunction>



  <cffunction name="nextTarget" access="private" output="false">
    <cfif arrayIsEmpty(_targets)>
      <cfreturn false>
    </cfif>
    <cfset resetCurrent()>
    <cfset flagDelayedMatcher(false)>
    <cfset _target = _targets[1]>
    <cfset arrayDeleteAt(_targets, 1)>
    <cfreturn true>
  </cffunction>



  <cffunction name="resetCurrent" access="private" output="false">
    <cfset _current = "0">
  </cffunction>



  <cffunction name="pushCurrent" access="private" output="false">
    <cfset stepCurrent()>
    <cfset _current = _current & ",0">
  </cffunction>



  <cffunction name="stepCurrent" access="private" output="false">
    <cfset var n = val(listLast(_current)) + 1>
    <cfset popCurrent()>
    <cfset _current = listAppend(_current, n)>
  </cffunction>



  <cffunction name="popCurrent" access="private" output="false">
    <cfset _current = reReplace(_current, "(^|,)\d+$", "")>
  </cffunction>



  <cffunction name="hasPendingException" access="private" output="false">
    <cfreturn not isSimpleValue(_pendingException)>
  </cffunction>



  <cffunction name="isInDelayedMatcher" access="private" output="false">
    <cfreturn _inDelayedMatcher>
  </cffunction>



  <cffunction name="hadAnExpectation" access="private" output="false">
    <cfreturn _hadAnExpectation>
  </cffunction>



  <cffunction name="ensureAllMockExpectationsArePassing" access="private" output="false">
    <cfset var bindings = getBindings()>
    <cfset var fullMessages = "">
    <cfset var messages = "">
    <cfset var key = "">
    <cfset var i = "">
    <cfloop collection="#bindings#" item="key">
      <cfif isObject(bindings[key]) and structKeyExists(bindings[key], "__cfspecGetFailureMessages")>
        <cfset flagExpectationEncountered()>
        <cfset messages = bindings[key].__cfspecGetFailureMessages()>
        <cfloop index="i" from="1" to="#arrayLen(messages)#">
          <cfset fullMessages = listAppend(fullMessages, messages[i], "<br />")>
        </cfloop>
      </cfif>
    </cfloop>
    <cfif fullMessages neq "">
      <cfset fail(fullMessages)>
    </cfif>
  </cffunction>



  <cffunction name="defineStepMatcher" access="private" output="false">
    <cfargument name="pattern">
    <cfargument name="attributes">
    <cfset var matcher = structNew()>
    <cfset matcher.file = _stepFile>
    <cfset matcher.target = _current>
    <cfset matcher.keys = "">
    <cfif structKeyExists(attributes, "arguments")>
      <cfset matcher.keys = attributes.arguments>
    </cfif>
    <cfset _steps[pattern] = matcher>
  </cffunction>



</cfcomponent>
