<!---
  FileUtils exposes some needed functions for working with relative paths.
--->
<cfcomponent output="false">



  <cffunction name="init">
    <cfreturn this>
  </cffunction>



  <cffunction name="relativePath">
    <cfargument name="path">
    <cfset var webRoot = normalizePath(expandPath("/"))>
    <cfset var relativePath = relativePathFromMapping(path, "/", webRoot)>
    <cfif relativePath neq "">
      <cfreturn relativePath>
    </cfif>

    <cfset relativePath = relativePathFromRuntimeMappings(path)>
    <cfif relativePath neq "">
      <cfreturn relativePath>
    </cfif>

    <cfthrow message="Unable to determine the relative path for '#htmlEditFormat(path)#'.">
  </cffunction>



  <cffunction name="normalizePath">
    <cfargument name="path">
    <cfreturn reReplace(path, "[/\\]+", "/", "all")>
  </cffunction>



  <!--- PRIVATE --->



  <cffunction name="relativePathFromRuntimeMappings" access="private">
    <cfargument name="path">
    <cfset var serviceFactory = createObject("java", "coldfusion.server.ServiceFactory")>
    <cfset var mappings = serviceFactory.getRuntimeService().getMappings()>
    <cfset var relativePath = "">
    <cfset var mapping = "">
    <cfset var root = "">
    <cfloop collection="#mappings#" item="mapping">
      <cfset root = normalizePath(mappings[mapping])>
      <cfset relativePath = relativePathFromMapping(path, mapping, root)>
      <cfif relativePath neq "">
        <cfreturn relativePath>
      </cfif>
    </cfloop>
    <cfreturn "">
  </cffunction>



  <cffunction name="relativePathFromMapping" access="private">
    <cfargument name="path">
    <cfargument name="mapping">
    <cfargument name="root">
    <cfset path = normalizePath(path)>
    <cfset mapping = normalizePath(mapping)>
    <cfset root = normalizePath(root)>
    <cfif len(path) gt len(root) and left(path, len(root)) eq root>
      <cfreturn mapping & right(path, len(path) - len(root))>
    </cfif>
    <cfreturn "">
  </cffunction>



</cfcomponent>
