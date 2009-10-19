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
    <cfargument name="isTopLevel" default="true">
    <cfset var files = "">
    <cfif isTopLevel>
      <cfif fileExists("#specPath#/support/env.cfm")>
        <cfset _context.__cfspecRun(this, _fileUtils.relativePath(specPath & '/support/env.cfm'))>
        <cfset _context.__cfspecSaveBindings()>
      </cfif>
    </cfif>
    <cfdirectory action="list" directory="#specPath#" name="files">
    <cfloop query="files">
      <cfif type eq "dir" and left(name, 1) neq ".">
        <cfset runFeatureSuite("#specPath#/#name#", false)>
      <cfelseif type eq "file" and reFindNoCase("\.feature$", name)>
        <cfif not structKeyExists(request, "target") or listFindNoCase(request.target, listFirst(name, "."))>
          <cfset _suiteNumber = _suiteNumber + 1>
          <cfset runFeature("#specPath#/#name#")>
        </cfif>
      </cfif>
    </cfloop>
    <cfif isTopLevel>
      <cfset request.singletons.stopSelenium()>
    </cfif>
  </cffunction>



  <cffunction name="runFeature" output="false">
    <cfargument name="specPath">
    <cfset var story = structNew()>
    <cfset var lines = "">
    <cfset var i = "">
    <cffile action="read" file="#specPath#" variable="story.fullText">
    <cfset lines = story.fullText.split("\n")>
    <cfset story.lines = arrayNew(1)>
    <cfloop index="i" from="1" to="#arrayLen(lines)#">
      <cfset arrayAppend(story.lines, lines[i])>
    </cfloop>
    <cfset story.lineNumber = 1>
    <cfset story.lineCount = arrayLen(story.lines)>

    <cfset parseOptionalBlankLines(story)>
    <cfif story.lineNumber gt story.lineCount><cfreturn></cfif>
    <cfset parseFeatureIntroduction(story)>
    <cfif story.lineNumber gt story.lineCount><cfreturn></cfif>
    <cfset parseOptionalBackground(story)>
    <cfif story.lineNumber gt story.lineCount><cfreturn></cfif>

    <cfloop condition="story.lineNumber le story.lineCount">
      <cfset parseScenario(story)>
    </cfloop>

    <cfset _report.enterBlock(story.title)>
    <cfloop index="i" from="1" to="#arrayLen(story.scenarios)#">
      <cfset runScenario(story.scenarios[i])>
    </cfloop>
    <cfset _report.exitBlock()>
  </cffunction>

  <cffunction name="runScenario" access="private" output="false">
    <cfargument name="scenario">
    <cfset var selenium = "">
    <cfset var binding = structNew()>
    <cfset _report.enterBlock(scenario.title)>
    <cfif structKeyExists(request, "selenium")>
      <cfset selenium = request.singletons.getSelenium(argumentCollection=request.selenium)>
      <cfset binding.selenium = selenium>
      <cfset _context.__cfspecSetBindings(binding)>
    </cfif>
    <cfif structKeyExists(request, "beforeEachScenario")>
      <cfset evaluate(request.beforeEachScenario)>
    </cfif>
    <cfset runSteps(scenario.story.background, "Background")>
    <cfset runSteps(scenario.steps)>
    <cftry>
      <cfset ensureAllMockExpectationsArePassing()>
      <cfcatch type="cfspec.fail">
        <cfset _specStats.incrementExampleCount()>
        <cfset _report.addExample("fail", reReplace(cfcatch.message, "^: ", ""))>
      </cfcatch>
    </cftry>
    <cfset _context.__cfspecScrub()>
    <cfset _report.exitBlock()>
  </cffunction>

  <cffunction name="runSteps" access="private" output="false">
    <cfargument name="steps">
    <cfargument name="context" default="">
    <cfset var title = "">
    <cfset var step = "">
    <cfset var stepDefinition = "">
    <cfset var value = "">
    <cfset var indent = "">
    <cfset var fields = "">
    <cfset var field = "">
    <cfset var row = "">
    <cfloop condition="not arrayIsEmpty(steps)">
      <cfif not reFindNoCase("^\s*((?:Given|When|Then|And|But)\s+.*)$", steps[1])>
        <cfthrow message="Expected a feature step, but got '#steps[1]#'">
      </cfif>
      <cfset title = trim(reReplaceNoCase(steps[1], "^\s*((?:Given|When|Then|And|But)\s+.*)$", "\1"))>
      <cfset step = trim(reReplaceNoCase(title, "^(Given|When|Then|And|But)", ""))>
      <cfset stepDefinition = findStepDefinition(step)>
      <cfset arrayDeleteAt(steps, 1)>
      <cfif context neq "">
        <cfset title = "(#context#) #title#">
      </cfif>
      <cfif isStruct(stepDefinition)>
        <cfif structKeyExists(stepDefinition, "multilineBinding")>
          <cfif reFind('^\s*"""\s*$', steps[1])>
            <!--- multi-line string --->
            <cfset indent = reReplace(steps[1], "^(\s*).*$", "\1")>
            <cfset arrayDeleteAt(steps, 1)>
            <cfloop condition="not arrayIsEmpty(steps)">
              <cfif reFind('^\s*"""\s*$', steps[1])><cfbreak></cfif>
              <cfset value = listAppend(value, steps[1], chr(10))>
              <cfset arrayDeleteAt(steps, 1)>
            </cfloop>
            <cfset arrayDeleteAt(steps, 1)>
            <cfset value = reReplace(value, "(^|\n)#indent#", "\1", "all")>
            <cfset title = listAppend(title, '"""#chr(10)##value##chr(10)#"""', chr(10))>
            <cfset title = replace(title, chr(10), "<br />", "all")>
          <cfelseif reFind("^\s*(\|\s*[^|]+\s*)+\|\s*$", steps[1])>
          <!--- multi-line table --->
            <cfset row = trim(reReplace(steps[1], "^\s*\|(.+)\|\s*$", "\1"))>
            <cfset row = reReplace(row, "\s*\|\s*", "|", "all")>
            <cfset fields = listChangeDelims(row, ",", "|")>
            <cfset value = queryNew(fields)>
            <cfset arrayDeleteAt(steps, 1)>
            <cfset title = title & "<br /><table class='step-table'><tr><th>#replace(fields, ',', '</th><th>', 'all')#</th></tr>">
            <cfloop condition="not arrayIsEmpty(steps)">
              <cfif not reFind("^\s*(\|\s*[^|]+\s*)+\|\s*$", steps[1])><cfbreak></cfif>
              <cfset row = trim(reReplace(steps[1], "^\s*\|(.+)\|\s*$", "\1"))>
              <cfset row = reReplace(row, "\s*\|\s*", "|", "all")>
              <cfset row = row.split("\|")>
              <cfif arrayLen(row) neq listLen(fields)>
                <cfthrow message="Expected a table row with #listLen(fields)# column(s), but got '#steps[1]#'">
              </cfif>
              <cfset queryAddRow(value)>
              <cfset indent = 1>
              <cfloop list="#fields#" index="field">
                <cfset querySetCell(value, field, row[indent])>
                <cfset indent = indent + 1>
              </cfloop>
              <cfset title = title & "<tr><td>#arrayToList(row, '</td><td>')#</td></tr>">
              <cfset arrayDeleteAt(steps, 1)>
            </cfloop>
            <cfset title = title & "</table>">
          <cfelse>
            <cfthrow message="Expected a multi-line feature step, but got '#steps[1]#'">
          </cfif>
          <cfset stepDefinition.bindings[stepDefinition.multilineBinding] = value>
        </cfif>
        <cfset stepDefinition.title = title>
        <cfset runStep(stepDefinition)>
      <cfelse>
        <cfset _report.addExample("pend", title)>
        <cfset _specStats.incrementExampleCount()>
        <cfset _specStats.incrementPendCount()>
      </cfif>
    </cfloop>
  </cffunction>

  <cffunction name="runStep" access="private" output="false">
    <cfargument name="step">
    <cfset _specStats.incrementExampleCount()>
    <cfset resetCurrent()>
    <cfset _target = step.target>
    <cftry>
      <cfset _context.__cfspecSetBindings(step.bindings)>
      <cfset flagDelayedMatcher(false)>
      <cfset _context.__cfspecRun(this, step.file)>
      <cfset ensureNoDelayedMatchersArePending()>
      <cfcatch type="cfspec">
        <cfset _report.addExample(listLast(cfcatch.type, "."), step.title & cfcatch.message)>
        <cfif cfcatch.type eq "cfspec.pend">
          <cfset _specStats.incrementPendCount()>
        </cfif>
        <cfreturn>
      </cfcatch>
      <cfcatch type="any">
        <cfset _report.addExample("fail", step.title, cfcatch)>
        <cfreturn>
      </cfcatch>
    </cftry>
    <cfset _report.addExample("pass", step.title)>
    <cfset _specStats.incrementPassCount()>
  </cffunction>

  <cffunction name="findStepDefinition" access="private" output="false">
    <cfargument name="step">
    <cfset var pattern = "">
    <cfset var matchData = "">
    <cfset var stepTarget = "">
    <cfset var key = "">
    <cfset var i = "">
    <cfloop collection="#_steps#" item="pattern">
      <cfset matchData = reFindNoCase("^#pattern#$", step, 1, true)>
      <cfif matchData.pos[1]>
        <cfset stepTarget = structCopy(_steps[pattern])>
        <cfset stepTarget.bindings = structNew()>
        <cfset i = 2>
        <cfloop list="#stepTarget.keys#" index="key">
          <cfset stepTarget.bindings[key] = "">
          <cfif i gt arrayLen(matchData.len)>
            <cfset stepTarget.multilineBinding = key>
          <cfelseif matchData.len[i]>
            <cfset stepTarget.bindings[key] = mid(step, matchData.pos[i], matchData.len[i])>
          </cfif>
          <cfset i = i + 1>
        </cfloop>
        <cfreturn stepTarget>
      </cfif>
    </cfloop>
    <cfreturn false>
  </cffunction>

  <cffunction name="parseOptionalBlankLines" access="private" output="false">
    <cfargument name="story">
    <cfloop condition="story.lineNumber le story.lineCount and reFind('^\s*$', story.lines[story.lineNumber] & ' ')">
      <cfset story.lineNumber = story.lineNumber + 1>
    </cfloop>
  </cffunction>

  <cffunction name="parseFeatureIntroduction" access="private" output="false">
    <cfargument name="story">
    <cfset var line = story.lines[story.lineNumber]>
    <cfif not reFindNoCase("^\s*Feature:", line)>
      <cfthrow message="Expected 'Feature: TITLE', but got '#line#'">
    </cfif>
    <cfset story.title = trim(reReplaceNoCase(line, "^\s*Feature:(.+)$", "\1"))>
    <cfset story.lineNumber = story.lineNumber + 1>
    <cfloop condition="story.lineNumber le story.lineCount and not reFind('^\s*$', story.lines[story.lineNumber] & ' ')">
      <cfset story.lineNumber = story.lineNumber + 1>
    </cfloop>
    <cfset parseOptionalBlankLines(story)>
    <cfset story.background = arrayNew(1)>
    <cfset story.scenarios = arrayNew(1)>
  </cffunction>

  <cffunction name="parseOptionalBackground" access="private" output="false">
    <cfargument name="story">
    <cfset var line = story.lines[story.lineNumber]>
    <cfif not reFindNoCase("^\s*Background:\s*$", line)><cfreturn></cfif>
    <cfset story.lineNumber = story.lineNumber + 1>
    <cfloop condition="story.lineNumber le story.lineCount and not reFind('^\s*$', story.lines[story.lineNumber] & ' ')">
      <cfset arrayAppend(story.background, story.lines[story.lineNumber])>
      <cfset story.lineNumber = story.lineNumber + 1>
    </cfloop>
    <cfset parseOptionalBlankLines(story)>
  </cffunction>

  <cffunction name="parseScenario" access="private" output="false">
    <cfargument name="story">
    <cfset var scenarioOutline = structNew()>
    <cfset var scenario = structNew()>
    <cfset var line = story.lines[story.lineNumber]>
    <cfset var isOutline = false>
    <cfset var examples = "">
    <cfset var i = "">
    <cfif not reFindNoCase("^\s*Scenario( Outline)?:", line)>
      <cfthrow message="Expected 'Scenario: TITLE', but got '#line#'">
    </cfif>
    <cfset isOutline = reFindNoCase("^\s*Scenario Outline:", line)>
    <cfset scenario.story = story>
    <cfset scenario.title = trim(reReplaceNoCase(line, "^\s*Scenario:(.+)$", "\1"))>
    <cfset story.lineNumber = story.lineNumber + 1>
    <cfset scenario.steps = arrayNew(1)>
    <cfloop condition="story.lineNumber le story.lineCount and not reFind('^\s*$', story.lines[story.lineNumber] & ' ')">
      <cfset arrayAppend(scenario.steps, story.lines[story.lineNumber])>
      <cfset story.lineNumber = story.lineNumber + 1>
    </cfloop>
    <cfset parseOptionalBlankLines(story)>
    <cfif isOutline>
      <cfset scenarioOutline = scenario>
      <cfset scenarioOutline.title = replace(scenarioOutline.title, "##", "####", "all")>
      <cfset scenarioOutline.title = reReplace(scenarioOutline.title, "<(\w+)>", "##\1##", "all")>
      <cfloop index="i" from="1" to="#arrayLen(scenarioOutline.steps)#">
        <cfset scenarioOutline.steps[i] = replace(scenarioOutline.steps[i], "##", "####", "all")>
        <cfset scenarioOutline.steps[i] = reReplace(scenarioOutline.steps[i], "<(\w+)>", "##\1##", "all")>
      </cfloop>
      <cfset examples = parseScenarioOutlineExamples(story)>
      <cfloop query="examples">
        <cfset scenario = structCopy(scenarioOutline)>
        <cfset scenario.title = evaluate(de(scenario.title))>
        <cfloop index="i" from="1" to="#arrayLen(scenario.steps)#">
          <cfset scenario.steps[i] = evaluate(de(scenario.steps[i]))>
        </cfloop>
        <cfset arrayAppend(story.scenarios, scenario)>
      </cfloop>
    <cfelse>
      <cfset arrayAppend(story.scenarios, scenario)>
    </cfif>
  </cffunction>



  <cffunction name="parseScenarioOutlineExamples" access="private" output="false">
    <cfargument name="story">
    <cfset var line = story.lines[story.lineNumber]>
    <cfset var steps = arrayNew(1)>
    <cfset var row = "">
    <cfset var fields = "">
    <cfset var field = "">
    <cfset var indent = "">
    <cfset var value = "">
    <cfif not reFindNoCase("^\s*Examples:\s*$", line)>
      <cfthrow message="Expected 'Examples:', but got '#line#'">
    </cfif>
    <cfset story.lineNumber = story.lineNumber + 1>
    <cfloop condition="story.lineNumber le story.lineCount and not reFind('^\s*$', story.lines[story.lineNumber] & ' ')">
      <cfset arrayAppend(steps, story.lines[story.lineNumber])>
      <cfset story.lineNumber = story.lineNumber + 1>
    </cfloop>
    <cfif arrayIsEmpty(steps)><cfreturn queryNew("")></cfif>
    <cfif not reFind("^\s*(\|\s*[^|]+\s*)+\|\s*$", steps[1])>
      <cfthrow message="Expected a table of examples, but got '#steps[1]#'">
    </cfif>
    <cfset row = trim(reReplace(steps[1], "^\s*\|(.+)\|\s*$", "\1"))>
    <cfset row = reReplace(row, "\s*\|\s*", "|", "all")>
    <cfset fields = listChangeDelims(row, ",", "|")>
    <cfset value = queryNew(fields)>
    <cfset arrayDeleteAt(steps, 1)>
    <cfloop condition="not arrayIsEmpty(steps)">
      <cfif not reFind("^\s*(\|\s*[^|]+\s*)+\|\s*$", steps[1])><cfbreak></cfif>
      <cfset row = trim(reReplace(steps[1], "^\s*\|(.+)\|\s*$", "\1"))>
      <cfset row = reReplace(row, "\s*\|\s*", "|", "all")>
      <cfset row = row.split("\|")>
      <cfif arrayLen(row) neq listLen(fields)>
        <cfthrow message="Expected a table row with #listLen(fields)# column(s), but got '#steps[1]#'">
      </cfif>
      <cfset queryAddRow(value)>
      <cfset indent = 1>
      <cfloop list="#fields#" index="field">
        <cfset querySetCell(value, field, row[indent])>
        <cfset indent = indent + 1>
      </cfloop>
      <cfset arrayDeleteAt(steps, 1)>
    </cfloop>
    <cfset parseOptionalBlankLines(story)>
    <cfreturn value>
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
