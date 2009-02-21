<!---
  SpecContext is used to run spec blocks within the correct binding context. To the extent
  possible, it is a clean environment where no other variables or methods can interfere.
--->
<cfcomponent output="false">



  <cfset __cfspecKeywords = "this,$,$eval,stub,mock,fail,pend">



  <cffunction name="__cfspecInit">
    <cfset __cfspecShared = arrayNew(1)>
    <cfset __cfspecStatus = arrayNew(1)>
    <cfset __cfspecPush()>
    <cfreturn this>
  </cffunction>



  <cffunction name="__cfspecGetStatus">
    <cfreturn __cfspecStatus[1]>
  </cffunction>



  <cffunction name="__cfspecMergeStatus">
    <cfargument name="status">
    <cfif __cfspecStatus[1] neq "fail">
      <cfset __cfspecStatus[1] = status>
    </cfif>
  </cffunction>



  <cffunction name="__cfspecPush">
    <cfset arrayPrepend(__cfspecShared, "")>
    <cfset arrayPrepend(__cfspecStatus, "pass")>
  </cffunction>



  <cffunction name="__cfspecPop">
    <cfset arrayDeleteAt(__cfspecShared, 1)>
    <cfset arrayDeleteAt(__cfspecStatus, 1)>
  </cffunction>



  <cffunction name="__cfspecRun">
    <cfargument name="__cfspecRunner">
    <cfargument name="__cfspecSpecFile">
    <cfset variables.__cfspecRunner = arguments.__cfspecRunner>
    <cfinclude template="#__cfspecSpecFile#">
  </cffunction>



  <cffunction name="__cfspecGetBindings">
    <cfset var bindings = structNew()>
    <cfset var key = "">

    <cfloop collection="#variables#" item="key">
      <cfif findNoCase("__cfspec", key) neq 1 and not listFindNoCase(__cfspecKeywords, key)>
        <cfset bindings[key] = variables[key]>
      </cfif>
    </cfloop>

    <cfreturn bindings>
  </cffunction>



  <cffunction name="__cfspecSetBindings">
    <cfargument name="bindings">
    <cfset structAppend(variables, bindings)>
  </cffunction>



  <cffunction name="__cfspecScrub">
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



  <cffunction name="__cfspecSaveBindings">
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



  <cffunction name="$">
    <cfargument name="obj">
    <cfreturn __cfspecRunner.$(obj)>
  </cffunction>



  <cffunction name="$eval">
    <cfargument name="obj">
    <cfreturn __cfspecRunner.$eval(obj)>
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
