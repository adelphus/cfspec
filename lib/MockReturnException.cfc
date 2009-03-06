<!---
  This holds an exception that will be thrown within a mocks execution chain.
--->
<cfcomponent>



  <cffunction name="init">
    <cfargument name="type">
    <cfargument name="message">
    <cfargument name="detail">
    <cfset _type = type>
    <cfset _message = message>
    <cfset _detail = detail>
    <cfreturn this>
  </cffunction>



  <cffunction name="eval">
    <cfthrow type="#_type#" message="#_message#" detail="#_detail#">
  </cffunction>



</cfcomponent>
