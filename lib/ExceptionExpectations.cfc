<cfcomponent extends="Expectations" output="false">

  <cffunction name="init" returntype="Expectations" output="false">
    <cfargument name="runner" type="any" required="true">
    <cfargument name="actual" type="any" required="true">
    <cfset variables.runner = arguments.runner>
    <cfset variables.actual = arguments.actual>
    <cfreturn this>
  </cffunction>

  <cffunction name="onMissingMethod" returntype="any" output="false">
    <cfargument name="missingMethodName" type="string" required="true">
    <cfargument name="missingMethodArguments" type="any" required="true">
    <cfreturn this>
  </cffunction>

  <cffunction name="shouldThrow" returntype="boolean" output="false">
    <cfset runner.setException("")>
    <cfreturn true>
  </cffunction>

  <cffunction name="shouldNotThrow" returntype="boolean" output="false">
    <cfreturn false>
  </cffunction>

</cfcomponent>