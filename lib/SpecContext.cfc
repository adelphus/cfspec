<!---
  SpecContext is used to run spec blocks within the correct binding context. To the extent
  possible, it is a clean environment where no other variables or methods can interfere.
--->
<cfcomponent output="false">



  <cfset __cfspecKeywords = "this,$,$eval,stub,mock,fail,pend,registerMatcher,simpleMatcher">



  <cffunction name="__cfspecInit" output="false">
    <cfset __cfspecMatchers = request.singletons.getMatcherManager()>
    <cfset __cfspecShared = arrayNew(1)>
    <cfset __cfspecStatus = arrayNew(1)>
    <cfset __cfspecPush()>
    <cfreturn this>
  </cffunction>



  <cffunction name="__cfspecGetStatus" output="false">
    <cfreturn __cfspecStatus[1]>
  </cffunction>



  <cffunction name="__cfspecMergeStatus" output="false">
    <cfargument name="status">
    <cfif __cfspecStatus[1] neq "fail">
      <cfset __cfspecStatus[1] = status>
    </cfif>
  </cffunction>



  <cffunction name="__cfspecPush" output="false">
    <cfset arrayPrepend(__cfspecShared, "")>
    <cfset arrayPrepend(__cfspecStatus, "pass")>
  </cffunction>



  <cffunction name="__cfspecPop" output="false">
    <cfset arrayDeleteAt(__cfspecShared, 1)>
    <cfset arrayDeleteAt(__cfspecStatus, 1)>
  </cffunction>



  <cffunction name="__cfspecRun" output="false">
    <cfargument name="__cfspecRunner">
    <cfargument name="__cfspecSpecFile">
    <cfset variables.__cfspecRunner = arguments.__cfspecRunner>
    <cfinclude template="#__cfspecSpecFile#">
  </cffunction>



  <cffunction name="__cfspecGetBindings" output="false">
    <cfargument name="includeHidden" default="false">
    <cfset var bindings = structNew()>
    <cfset var key = "">

    <cfloop collection="#variables#" item="key">
      <cfif includeHidden or
            (findNoCase("__cfspec", key) neq 1 and not listFindNoCase(__cfspecKeywords, key))>
        <cfset bindings[key] = variables[key]>
      </cfif>
    </cfloop>

    <cfreturn bindings>
  </cffunction>



  <cffunction name="__cfspecSetBindings" output="false">
    <cfargument name="bindings">
    <cfset structAppend(variables, bindings)>
  </cffunction>



  <cffunction name="__cfspecScrub" output="false">
    <cfset var bindings = __cfspecGetBindings()>
    <cfset var shared = "">
    <cfset var key = "">
    <cfset var i = "">
    <cfloop index="i" from="1" to="#arrayLen(__cfspecShared)#">
      <cfset shared = listAppend(shared, __cfspecShared[i])>
    </cfloop>
    <cfloop collection="#bindings#" item="key">
      <cfif not listFindNoCase(shared, key)>
        <cfset structDelete(variables, key)>
      </cfif>
    </cfloop>
  </cffunction>



  <cffunction name="__cfspecSaveBindings" output="false">
    <cfset var bindings = __cfspecGetBindings()>
    <cfset var oldShared = "">
    <cfset var newShared = "">
    <cfset var key = "">
    <cfset var i = "">
    <cfloop index="i" from="2" to="#arrayLen(__cfspecShared)#">
      <cfset oldShared = listAppend(oldShared, __cfspecShared[i])>
    </cfloop>
    <cfloop collection="#bindings#" item="key">
      <cfif not listFindNoCase(oldShared, key)>
        <cfset newShared = listAppend(newShared, key)>
      </cfif>
    </cfloop>
    <cfset __cfspecShared[1] = newShared>
  </cffunction>



  <cffunction name="$" output="false">
    <cfargument name="obj">
    <cfreturn createObject("component", "Expectations").__cfspecInit(__cfspecRunner, obj)>
  </cffunction>



  <cffunction name="$eval" output="false">
    <cfargument name="obj">
    <cfreturn createObject("component", "EvalExpectations").__cfspecInit(__cfspecRunner, obj)>
  </cffunction>



  <cffunction name="stub" output="false">
    <cfset arguments.__cfspecMockType = "stub">
    <cfreturn createObject("component", "Mock").__cfspecInit(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="mock" output="false">
    <cfset arguments.__cfspecMockType = "mock">
    <cfreturn createObject("component", "Mock").__cfspecInit(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="fail" output="false">
    <cfreturn __cfspecRunner.fail(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="pend" output="false">
    <cfreturn __cfspecRunner.pend(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="registerMatcher" output="false">
    <cfargument name="pattern">
    <cfargument name="type">
    <cfreturn __cfspecMatchers.registerMatcher(pattern, type)>
  </cffunction>



  <cffunction name="simpleMatcher" output="false">
    <cfargument name="pattern">
    <cfargument name="expression">
    <cfreturn __cfspecMatchers.simpleMatcher(pattern, expression)>
  </cffunction>



</cfcomponent>
