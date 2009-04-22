<!---
  MockExpectations is responsible for handling the setup and evaluation
  of the expectations that are put onto a mock object.
--->
<cfcomponent>



  <cffunction name="init">
    <cfset _returns = arrayNew(1)>
    <cfreturn this>
  </cffunction>



  <cffunction name="returns">
    <cfset var i = "">
    <cfset var entry = "">
    <cfloop index="i" from="1" to="#arrayLen(arguments)#">
      <cfset entry = createObject("component", "MockReturnValue").init(arguments[i])>
      <cfset arrayAppend(_returns, entry)>
    </cfloop>
    <cfreturn this>
  </cffunction>



  <cffunction name="throws">
    <cfargument name="type">
    <cfargument name="message" default="">
    <cfargument name="detail" default="">
    <cfset var entry = createObject("component", "MockReturnException").init(type, message, detail)>
    <cfset arrayAppend(_returns, entry)>
    <cfreturn this>
  </cffunction>



  <cffunction name="getReturn">
    <cfset var entry = "">
    <cfif not arrayIsEmpty(_returns)>
      <cfset entry = _returns[1]>
      <cfif arrayLen(_returns) gt 1>
        <cfset arrayDeleteAt(_returns, 1)>
      </cfif>
      <cfreturn entry.eval()>
    </cfif>
    <cfreturn createObject("component", "cfspec.lib.Mock").__cfspecInit()>
  </cffunction>



</cfcomponent>
