<cfcomponent output="false">

  <cffunction name="init">
    <cfargument name="spec">
    <cfset variables.specFile = right(spec, len(spec) - len(expandPath('/')) + 1)>
    <cfreturn this>
  </cffunction>

  <cffunction name="run">
    <cfset var result = "">
    <cfset var target = 1>
    <cfsavecontent variable="result">
      <html>
        <head>
          <title>cfSpec</title>
          <style><cfinclude template="/cfspec/includes/style.css"></style>
        </head>
        <body>
          <cfloop condition="runTarget(target)"><cfset target += 1></cfloop>
        </body>
      </html>
    </cfsavecontent>
    <cfreturn result>
  </cffunction>

  <cffunction name="$" returntype="Expectations">
    <cfargument name="obj" type="any" required="true">
    <cfreturn createObject("component", "Expectations").init(arguments.obj)>
  </cffunction>

  <cffunction name="fail">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = cfspec.hint>
    <cfelse>
      <cfset msg = cfspec.hint & ': ' & msg>
    </cfif>
    <cfthrow type="cfspec.fail" message="#msg#">
  </cffunction>

  <cffunction name="pend">
    <cfargument name="msg" default="">
    <cfif msg eq "">
      <cfset msg = cfspec.hint>
    <cfelse>
      <cfset msg = cfspec.hint & ': ' & msg>
    </cfif>
    <cfthrow type="cfspec.pend" message="#msg#">
  </cffunction>

  <cffunction name="runTarget">
    <cfargument name="target">
    <cfset var backup = variables>
    <cfset variables = structNew()>
    <cftry>
      <cfset variables.cfspec.current = 0>
      <cfset variables.cfspec.target = target>
      <cfinclude template="#backup.specFile#">
      <cfcatch type="cfspec">
        <cfoutput><p class="#listLast(cfcatch.type, '.')#">should #cfcatch.message#</p></cfoutput>
      </cfcatch>
      <cfcatch type="any"><cfset formatException()></cfcatch>
    </cftry>
    <cfif variables.cfspec.current lt variables.cfspec.target>
      <cfset variables = backup>    
      <cfreturn false>
    </cfif>
    <cfset variables = backup>    
    <cfreturn true>
  </cffunction>
  
  <cffunction name="formatException">
    <cfset var context = "">
    <cfoutput><p class="error">should #cfspec.hint#<br /><br /></cfoutput>
    <cfoutput><small><u>#cfcatch.type#</u><br />Message: #cfcatch.message#<br />Detail: #cfcatch.detail#<br />Stack Trace:</cfoutput>
    <cfloop array="#cfcatch.tagContext#" index="context">
      <cfoutput><pre>   #context.id# at #context.template#(#context.line#,#context.column#)</pre></cfoutput>
    </cfloop>
    <cfoutput></small></p></cfoutput>  
  </cffunction>

</cfcomponent>