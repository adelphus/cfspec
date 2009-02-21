<!---
  SpecContext is used to run spec blocks within the correct binding context. To the extent
  possible, it is a clean environment where no other variables or methods can interfere.
--->
<cfcomponent output="false">



  <cfset __cfspecKeywords = "this,$,$eval,stub,mock,fail,pend">



  <cffunction name="__cfspecInit">
    <cfargument name="parent" default="">
    <cfset __cfspecParent = parent>
    <cfset __cfspecStatus = "pass">
    <cfreturn this>
  </cffunction>



  <cffunction name="__cfspecGetStatus">
    <cfreturn __cfspecStatus>
  </cffunction>



  <cffunction name="__cfspecMergeStatus">
    <cfargument name="status">
    <cfif __cfspecStatus neq "fail">
      <cfset __cfspecStatus = status>
    </cfif>
  </cffunction>



  <cffunction name="__cfspecPush">
    <cfreturn createObject("component", "cfspec.lib.SpecContext").__cfspecInit(this)>
  </cffunction>



  <cffunction name="__cfspecSaveBindings">
    <cfset var bindings = __cfspecGetBindings()>
    <cfset __cfspecParent.__cfspecUpdate(bindings)>
    <cfif not structIsEmpty(bindings)>
      <cfset __cfspecParent.__cfspecMergeBindings(bindings)>
    </cfif>
  </cffunction>



  <cffunction name="__cfspecMergeBindings">
    <cfargument name="bindings">
    <cfset structAppend(variables, bindings)>
  </cffunction>



  <cffunction name="__cfspecUpdate">
    <cfargument name="bindings">
    <cfset var key = "">

    <cfloop collection="#bindings#" item="key">
      <cfif structKeyExists(variables, key)>
        <cfset variables[key] = bindings[key]>
        <cfset structDelete(bindings, key)>
      </cfif>
    </cfloop>

    <cfif isObject(__cfspecParent) and not structIsEmpty(bindings)>
      <cfset __cfspecParent.__cfspecUpdate(bindings)>
    </cfif>
  </cffunction>



  <cffunction name="__cfspecScrub">
    <cfset var bindings = __cfspecGetBindings()>
    <cfset var key = "">

    <cfif isObject(__cfspecParent) and not structIsEmpty(bindings)>
      <cfset __cfspecParent.__cfspecUpdate(bindings)>
    </cfif>

    <cfloop collection="#variables#" item="key">
      <cfif findNoCase("__cfspec", key) neq 1 and not listFindNoCase(__cfspecKeywords, key)>
        <cfset structDelete(variables, key)>
      </cfif>
    </cfloop>
  </cffunction>



  <cffunction name="__cfspecPop">
    <cfreturn __cfspecParent>
  </cffunction>



  <cffunction name="__cfspecRun">
    <cfargument name="__cfspecRunner">
    <cfargument name="__cfspecSpecFile">
    <cfset variables.__cfspecRunner = arguments.__cfspecRunner>
    <cfset structAppend(variables, __cfspecGetBindings())>
    <cfinclude template="#arguments.__cfspecSpecFile#">
  </cffunction>



  <cffunction name="__cfspecGetBindings">
    <cfset var bindings = structNew()>
    <cfset var key = "">
    <cfloop collection="#variables#" item="key">
      <cfif findNoCase("__cfspec", key) neq 1 and not listFindNoCase(__cfspecKeywords, key)>
        <cfset bindings[key] = variables[key]>
      </cfif>
    </cfloop>

    <cfif isObject(__cfspecParent)>
      <cfset structAppend(bindings, __cfspecParent.__cfspecGetBindings())>
    </cfif>

    <cfreturn bindings>
  </cffunction>



  <cffunction name="$">
    <cfreturn __cfspecRunner.$(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="$eval">
    <cfreturn __cfspecRunner.$eval(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="stub">
    <cfreturn __cfspecRunner.stub(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="mock">
    <cfreturn __cfspecRunner.mock(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="fail">
    <cfreturn __cfspecRunner.fail(argumentCollection=arguments)>
  </cffunction>



  <cffunction name="pend">
    <cfreturn __cfspecRunner.pend(argumentCollection=arguments)>
  </cffunction>



</cfcomponent>
