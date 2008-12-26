<cfcomponent output="false">

  <cffunction name="init" output="false">
    <cfargument name="spec">
    <cfset variables.specFile = right(spec, len(spec) - len(expandPath('/')) + 1)>
    <cfreturn this>
  </cffunction>

  <cffunction name="run" output="false">
    <cfset var result = "">
    <cfset var target = 1>
    <cfsavecontent variable="result">
      <html>
        <head>
          <title>cfSpec</title>
          <style><cfinclude template="/cfspec/includes/style.css"></style>
        </head>
        <body>
          <cfloop condition="runTarget(target)"><cfset target++></cfloop>
        </body>
      </html>
    </cfsavecontent>
    <cfreturn result>
  </cffunction>

  <cffunction name="saveVariables" output="false">
    <cfset var backup = {}>
    <cfset var key = "">
    <cfloop collection="#variables#" item="key">
      <cfif not listFind("$,CFSPEC,FAIL,FORMATEXCEPTION,INIT,PEND,RESTOREVARIABLES,RUN,RUNTARGET,SAVEVARIABLES,SETEXCEPTION,THIS", key)>
        <cfset backup[key] = variables[key]>
      </cfif>
    </cfloop>
    <cfreturn backup>
  </cffunction>
  
  <cffunction name="restoreVariables" output="false">
    <cfargument name="backup">
    <cfset var key = "">
    <cfloop collection="#variables#" item="key">
      <cfif not listFind("$,CFSPEC,FAIL,FORMATEXCEPTION,INIT,PEND,RESTOREVARIABLES,RUN,RUNTARGET,SAVEVARIABLES,SETEXCEPTION,THIS", key)>
        <cfset structDelete(variables, key)>
      </cfif>
    </cfloop>
    <cfset structAppend(variables, backup)>
  </cffunction>

  <cffunction name="runTarget">
    <cfargument name="target">
    <cfset var backup = saveVariables()>
    <cftry>
      <cfset cfspec.current = 0>
      <cfset cfspec.target = target>
      <cfset cfspec.exception = "">
      <cfinclude template="#specFile#">
      <cfif not isSimpleValue(cfspec.exception)>
        <cfthrow type="#cfspec.exception.type#" message="#cfspec.exception.message#">
      </cfif>
      <cfcatch type="cfspec">
        <cfoutput><p class="#listLast(cfcatch.type, '.')#">should #cfcatch.message#</p></cfoutput>
      </cfcatch>
      <cfcatch type="any"><cfset formatException()></cfcatch>
    </cftry>
    <cfif cfspec.current lt cfspec.target><cfreturn false></cfif>
    <cfset restoreVariables(backup)>
    <cfreturn true>
  </cffunction>

  <cffunction name="formatException">
    <cfset var context = "">
    <cfoutput><p class="error">should #cfspec.hint#<br /><br /></cfoutput>
    <cfoutput><small><u>#cfcatch.type#</u><br />Message: #cfcatch.message#<br />Detail: #cfcatch.detail#<br />Stack Trace:</cfoutput>
    <cfloop array="#cfcatch.tagContext#" index="context">
      <cfoutput><pre>   #iif(isDefined('context.id'), 'context.id', de('???'))# at #context.template#(#context.line#,#context.column#)</pre></cfoutput>
    </cfloop>
    <cfoutput></small></p></cfoutput>  
  </cffunction>

  <cffunction name="setException" output="false">
    <cfargument name="exception">
    <cfset cfspec.exception = arguments.exception>
  </cffunction>

  <cffunction name="$" returntype="Expectations" output="false">
    <cfargument name="obj" type="any" required="true">
    <cfreturn createObject("component", "Expectations").init(this, arguments.obj)>
  </cffunction>

  <cffunction name="fail" output="false">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = cfspec.hint>
    <cfelse>
      <cfset msg = cfspec.hint & ': ' & msg>
    </cfif>
    <cfthrow type="cfspec.fail" message="#msg#">
  </cffunction>

  <cffunction name="pend" output="false">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = cfspec.hint>
    <cfelse>
      <cfset msg = cfspec.hint & ': ' & msg>
    </cfif>
    <cfthrow type="cfspec.pend" message="#msg#">
  </cffunction>

</cfcomponent>