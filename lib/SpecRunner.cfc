<cfcomponent output="false">

  <cffunction name="runSpec">
    <cfargument name="specPath">
    <cfset $cfspec = createObject("component", "SpecRunnerContext").init(specPath)>
    <cfinclude template="#$cfspec.getSpecFile()#">

    <cfloop condition="$cfspec.nextTarget()">
      <cfset structAppend(variables, $cfspec.getContext())>
      <cftry>
        <cfinclude template="#$cfspec.getSpecFile()#">
        <cfset $cfspec.rethrowExpectedException()>
        <cfcatch type="cfspec">
          <cfset $cfspec.appendOutput("<p class='#listLast(cfcatch.type, '.')#'>should #cfcatch.message#</p>")>
          <cfset $cfspec.recoverFromException()>
        </cfcatch>
        <cfcatch type="any">
          <cfset $cfspec.appendOutput($cfspec.formatException(cfcatch))>
          <cfset $cfspec.recoverFromException()>
        </cfcatch>
      </cftry>
      <cfset $cfspec.updateContext(variables)>
      <cfset $cfspec.scrubContext(variables)>            
    </cfloop>

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
    <cfthrow type="cfspec.pend" message="#msg#">
  </cffunction>

</cfcomponent>