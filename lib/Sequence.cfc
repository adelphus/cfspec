<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfargument name="name" default="(sequence)">
    <cfset _name = name>
    <cfset _expectations = arrayNew(1)>
    <cfset _callCount = 0>
    <cfset _failureMessages = arrayNew(1)>
    <cfreturn this>
  </cffunction>



  <cffunction name="addExpectation" output="false">
    <cfargument name="expectation">
    <cfset arrayAppend(_expectations, expectation)>
  </cffunction>



  <cffunction name="called" output="false">
    <cfargument name="expectation">
    <cfset var system = createObject("java", "java.lang.System")>
    <cfset var next = "">
    <cfif arrayLen(_expectations) gt 0>
      <cfset next = _expectations[1]>
      <cfif system.identityHashCode(next) eq system.identityHashCode(expectation)>
        <cfset _callCount = _callCount + 1>
        <cfif next.getMaxCallCount() eq _callCount>
          <cfset arrayDeleteAt(_expectations, 1)>
          <cfset _callCount = 0>
        </cfif>
      <cfelseif next.getMinCallCount() le _callCount>
        <cfset arrayDeleteAt(_expectations, 1)>
        <cfset _callCount = 0>
        <cfset called(expectation)>
      <cfelse>
        <cfset arrayAppend(_failureMessages, "#_name#: expected #next.getMockName()#.#next.asString()#,"
                                           & " got #expectation.getMockName()#.#expectation.asString()#.")>
      </cfif>
    </cfif>
  </cffunction>



  <cffunction name="__cfspecGetFailureMessages" output="false">
    <cfreturn _failureMessages>
  </cffunction>



</cfcomponent>
