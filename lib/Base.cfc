<cfcomponent output="false">
  
  <cffunction name="hasMethod">
    <cfargument name="obj">
    <cfargument name="methodName">
    <cfset var metaData = getMetaData(obj)>
    <cfset var funcs = "">
    <cfset var func = "">
    
    <cfloop condition="structKeyExists(metaData, 'extends')">
      <cfif isDefined("metaData.functions")>
        <cfset funcs = metaData.functions>
        <cfloop array="#funcs#" index="func">
          <cfif func.name eq methodName>
            <cfreturn true>
          </cfif>
        </cfloop>
      </cfif>
      <cfset metaData = metaData.extends>
    </cfloop>

    <cfreturn false>
  </cffunction>

  <cffunction name="throw">
    <cfargument name="type" default="Application">
    <cfargument name="message" default="">
    <cfargument name="detail" default="">
    <cfthrow type="#type#" message="#message#" detail="#detail#">
  </cffunction>

  <cffunction name="rethrow">
    <cfargument name="object">
    <cfthrow object="#object#">
  </cffunction>

</cfcomponent>