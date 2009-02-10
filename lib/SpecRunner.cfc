<cfcomponent output="false">

  <cffunction name="runSpecSuite">
    <cfargument name="specPath">
    <cfargument name="showOutput" default="true">
    <cfset var files = "">
    <cfdirectory action="list" directory="#specPath#" name="files">
    <cfloop query="files">
      <cfif type eq "dir" and left(name, 1) neq ".">
        <cfset runSpecSuite("#specPath#/#name#", false)>
      <cfelseif type eq "file" and findNoCase("Spec.cfm", name)>
        <cfif not isDefined("$cfspec")>
          <cfset $cfspec = createObject("component", "SpecRunnerContext").init("#specPath#/#name#")>
        <cfelse>
          <cfset $cfspec.nextInSuite("#specPath#/#name#")>
        </cfif>
        <cfset runSpec()>
      </cfif>
    </cfloop>
    <cfif showOutput>
      <cfoutput>
        <html>
          <head>
            <title>cfSpec</title>
            <style><cfinclude template="/cfspec/includes/style.css"></style>
          </head>
          <body>#$cfspec.getOutput()#</body>
        </html>
      </cfoutput>
    </cfif>
  </cffunction>

  <cffunction name="runSpecFile">
    <cfargument name="specPath">
    <cfset $cfspec = createObject("component", "SpecRunnerContext").init(specPath)>
    <cfset runSpec()>
    <cfoutput>
      <html>
        <head>
          <title>cfSpec</title>
          <style><cfinclude template="/cfspec/includes/style.css"></style>
        </head>
        <body>#$cfspec.getOutput()#</body>
      </html>
    </cfoutput>
  </cffunction>

  <cffunction name="runSpec">
    <cfset var __cfspecRunner = this>
    <cfinclude template="#$cfspec.getSpecFile()#">
    <cfloop condition="$cfspec.nextTarget()">
      <cfset structAppend(variables, $cfspec.getContext())>
      <cftry>
        <cfinclude template="#$cfspec.getSpecFile()#">
        <cfset $cfspec.throwOnDelayedMatcher()>
        <cfcatch type="cfspec">
          <cfset $cfspec.appendOutput("<div class='it #listLast(cfcatch.type, '.')#'>should #cfcatch.message#</div>")>
          <cfset $cfspec.recoverFromException(listLast(cfcatch.type, "."))>
        </cfcatch>
        <cfcatch type="any">
          <cfset $cfspec.appendOutput($cfspec.formatException(cfcatch))>
          <cfset $cfspec.recoverFromException("fail")>
        </cfcatch>
      </cftry>
      <cfset $cfspec.updateContext(variables)>
      <cfset $cfspec.scrubContext(variables)>
    </cfloop>
  </cffunction>

  <cffunction name="$" output="false">
    <cfargument name="obj">
    <cfreturn createObject("component", "Expectations").init(this, $cfspec, obj)>
  </cffunction>

  <cffunction name="$eval" output="false">
    <cfargument name="obj">
    <cfreturn createObject("component", "EvalExpectations").init(this, $cfspec, obj)>
  </cffunction>

  <cffunction name="stub" output="false">
    <cfreturn createObject("component", "Stub").init(argumentCollection=arguments)>
  </cffunction>

  <cffunction name="mock" output="false">
    <cfreturn createObject("component", "Mock").init(argumentCollection=arguments)>
  </cffunction>

  <cffunction name="fail" output="false">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = $cfspec.getHint()>
    <cfelse>
      <cfset msg = $cfspec.getHint() & ': ' & msg>
    </cfif>
    <cfthrow type="cfspec.fail" message="#msg#">
  </cffunction>

  <cffunction name="pend" output="false">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = $cfspec.getHint()>
    <cfelse>
      <cfset msg = $cfspec.getHint() & ': ' & msg>
    </cfif>
    <cfset $cfspec.incrementPendCount()>
    <cfthrow type="cfspec.pend" message="#msg#">
  </cffunction>

  <cffunction name="cfSpecBindings">
    <cfreturn variables>
  </cffunction>

  <cfscript>
    
  function describeStartTag(attributes) {
    $cfspec.pushCurrent();

    if ($cfspec.isTrial()) return "exitTemplate";
    
    if (not $cfspec.isDescribeInsideRunnable()) {
      $cfspec.popCurrent();
      return "exitTag";
    }

    if ($cfspec.isDescribeStartRunnable()) {
      $cfspec.pushContext();
      $cfspec.appendOutput("<h2 id='desc_#$cfspec.getSuiteNumber()#_#replace($cfspec.getCurrent(), ',', '_', 'all')#'>#attributes.hint#</h2><div>");
    }

    return "exitTemplate";
  }
    
  function beforeAllStartTag(attributes) {
    if ($cfspec.isTrial() or not $cfspec.isBeforeAllRunnable()) return "exitTag";
    return "";
  }

  function beforeAllEndTag(attributes) {
    //$cfspec.updateContext(bindings);
    $cfspec.setContext(variables);
    return "";
  }

  function beforeStartTag(attributes) {
    if ($cfspec.isTrial() or not $cfspec.isBeforeRunnable()) return "exitTag";
    return "";
  }

  function beforeEndTag(attributes) {
    return "";
  }
  
  function itStartTag(attributes) {
    $cfspec.stepCurrent();
    if ($cfspec.isTrial()) {
      $cfspec.makeTarget();
      return "exitTag";
    }
    if (not $cfspec.isItRunnable()) {
      return "exitTag";
    }
    $cfspec.setHint(attributes.should);
    return "";
  }
  
  function itEndTag(attributes) {
    if (not $cfspec.hasExpectedException()) {
      $cfspec.throwOnDelayedMatcher();
      if ($cfspec.hadAnExpectation()) {
        $cfspec.appendOutput("<div class='it pass'>should #attributes.should#</div>");
        $cfspec.incrementPassCount();
      } else {
        pend("There were no expectations.");
      }
    }
    return "";
  }

  function afterStartTag(attributes) {
    if ($cfspec.isTrial() or not $cfspec.isAfterRunnable()) return "exitTag";
    return "";
  }

  function afterEndTag(attributes) {
    return "";
  }

  function afterAllStartTag(attributes) {
    if ($cfspec.isTrial() or not $cfspec.isAfterAllRunnable()) return "exitTag";
    return "";
  }

  function afterAllEndTag(attributes) {
    return "";
  }
  
  function describeEndTag(attributes) {
    var css = "";
    
    $cfspec.rethrowExpectedException();
    $cfspec.popCurrent();
    
    if ($cfspec.isTrial() or not $cfspec.isDescribeEndRunnable()) return "exitTag";
    
    if ($cfspec.getContextStatus() eq "fail") {
      css = "background:##CC0000";
    } else if ($cfspec.getContextStatus() eq "pend") {
     	css = "background:##FFFF00;color:black";
    } else {
      css = "background:##00CC00";
    }

    $cfspec.popContext();
    $cfspec.appendOutput("<style>##desc_#$cfspec.getSuiteNumber()#_#replace($cfspec.getCurrent(), ',', '_', 'all')#_0{#css#}</style></div>");
    return "";
  }

</cfscript></cfcomponent>