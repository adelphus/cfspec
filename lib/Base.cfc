<cfcomponent output="false">

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