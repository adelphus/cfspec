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
    <cfinclude template="#$cfspec.getSpecFile()#">
    <cfloop condition="$cfspec.nextTarget()">
      <cfset structAppend(variables, $cfspec.getContext())>
      <cftry>
        <cfinclude template="#$cfspec.getSpecFile()#">
        <cfset $cfspec.rethrowExpectedException()>
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

</cfcomponent>