<cfcomponent output="false">

  <cffunction name="init" output="false">
    <cfargument name="spec">
    <cfset var webroot = expandPath('/') />
    <cfset var searching = true />
    <cfset var specPath = spec />
    <cfif len(spec) lte len(webroot) or left(spec,len(webroot)) is not webroot>
      <!--- not under webroot - need to deduce location --->
      <cfset specPath = replace(spec,'\','/','all') />
      <cfset searching = spec is not expandPath(specPath) />
      <cfloop condition="searching">
        <cfset specPath = "/" & listRest(specPath,"/") />
        <cfset searching = specPath is not "/" and spec is not expandPath(specPath)>
      </cfloop>
      <cfif specPath is "/">
        <cfthrow message="Unable to figure out the relative path for #spec#" />
      <cfelse>
        <cfset variables.specFile = specPath />
      </cfif>
    <cfelse>
      <cfset variables.specFile = right(spec, len(spec) - len(expandPath('/')) + 1)>
    </cfif>
    <cfreturn this>
  </cffunction>

  <cffunction name="run" output="false">
    <cfset var result = "">
    <cfset var target = 0>
    <cfset cfspec.context = arrayNew(1)>
    <cfset cfspec.scope = "">
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
      <cfif not listFind("$,CFSPEC,FAIL,FORMATEXCEPTION,INIT,MOCK,PEND,RESTOREVARIABLES,RUN,RUNTARGET,SAVEVARIABLES,SETEXCEPTION,STUB,THIS", key)>
        <cfset backup[key] = variables[key]>
      </cfif>
    </cfloop>
    <cfreturn backup>
  </cffunction>
  
  <cffunction name="restoreVariables" output="false">
    <cfargument name="backup">
    <cfset var key = "">
    <cfloop collection="#variables#" item="key">
      <cfif not listFind("$,CFSPEC,FAIL,FORMATEXCEPTION,INIT,MOCK,PEND,RESTOREVARIABLES,RUN,RUNTARGET,SAVEVARIABLES,SETEXCEPTION,STUB,THIS", key)>
        <cfset structDelete(variables, key)>
      </cfif>
    </cfloop>
    <cfset structAppend(variables, backup)>
  </cffunction>

  <cffunction name="runTarget">
    <cfargument name="target">
    <cfset var backup = saveVariables()>
    <cfset var key = "">
    <cfset var i = "">
    <cftry>
      <cfset cfspec.current = 0>
      <cfset cfspec.target = target>
      <cfset cfspec.exception = "">
      <cfset cfspec.saveContext = false>
      <cfif arrayLen(cfspec.context)>
        <cfloop index="i" from="#arrayLen(cfspec.context)#" to="1" step="-1">
          <cfset structAppend(variables, cfspec.context[i])>
        </cfloop>
      </cfif>
      <cfinclude template="#specFile#">
      <cfif not isSimpleValue(cfspec.exception)>
      	<cfset createObject("component", "cfspec.lib.Matcher").rethrow(cfspec.exception)>
      </cfif>
      <cfcatch type="cfspec">
        <cfoutput><p class="#listLast(cfcatch.type, '.')#">should #cfcatch.message#</p></cfoutput>
      </cfcatch>
      <cfcatch type="any"><cfset formatException()></cfcatch>
    </cftry>
    <cfif arrayLen(cfspec.context)>
      <cfloop index="i" from="1" to="#arrayLen(cfspec.context)#">
        <cfloop collection="#cfspec.context[i]#" item="key">
          <cfif isDefined(key)>
            <cfset cfspec.context[i][key] = variables[key]>
            <cfset structDelete(variables, key)>
          </cfif>
        </cfloop>      
      </cfloop>
      <cfif cfspec.saveContext>
        <cfset structAppend(cfspec.context[1], saveVariables())>
      </cfif>
    </cfif>
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

  <cffunction name="setExpectedException" output="false">
    <cfargument name="exception">
    <cfset cfspec.exception = arguments.exception>
  </cffunction>

  <cffunction name="getExpectedException" output="false">
    <cfset var exception = cfspec.exception>
    <cfset cfspec.exception = "">
    <cfreturn exception>
  </cffunction>

  <cffunction name="$" returntype="Expectations" output="false">
    <cfargument name="obj" type="any" required="true">
    <cfreturn createObject("component", "Expectations").init(this, arguments.obj)>
  </cffunction>

  <cffunction name="stub" output="false">
    <cfreturn createObject("component", "Stub").init(argumentCollection=arguments)>
  </cffunction>

  <cffunction name="mock" output="false">
    <cfreturn createObject("component", "Stub")>
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