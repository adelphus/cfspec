<!---
  Singletons is the owner of any singleton instances which can be accessed via:
    request.singletons.getXXX()
--->
<cfcomponent output="false">



  <cffunction name="init" output="false">
    <cfreturn this>
  </cffunction>



  <cffunction name="getMatcherManager" output="false">
    <cfif not isDefined("_matcherManager")>
      <cfset _matcherManager = createObject("component", "cfspec.lib.MatcherManager").init()>
    </cfif>
    <cfreturn _matcherManager>
  </cffunction>



  <cffunction name="getFileUtils" output="false">
    <cfif not isDefined("_fileUtils")>
      <cfset _fileUtils = createObject("component", "cfspec.lib.FileUtils").init()>
    </cfif>
    <cfreturn _fileUtils>
  </cffunction>



  <cffunction name="getInflector" output="false">
    <cfif not isDefined("_inflector")>
      <cfset _inflector = createObject("component", "cfspec.util.Inflector").init()>
    </cfif>
    <cfreturn _inflector>
  </cffunction>



  <cffunction name="getJavaLoader" output="false">
    <cfset var classpath = "">
    <cfset var i = "">
    <cfif not isDefined("_javaLoader")>
      <cffile action="read" file="#expandPath('/cfspec/config/classpath.json')#" variable="classpath">
      <cfset classpath = deserializeJson(classpath)>
      <cfloop index="i" from="1" to="#arrayLen(classpath)#">
        <cfset classpath[i] = expandPath(classpath[i])>
      </cfloop>
      <cfset _javaLoader = createObject("component", "cfspec.external.javaloader.JavaLoader").init(classpath)>
    </cfif>
    <cfreturn _javaLoader>
  </cffunction>



  <cffunction name="getDocBuilder" output="false">
    <cfset var tagSoup = "">
    <cfset var loader = "">
    <cfif not isDefined("_docBuilder")>
      <cfset loader = getJavaLoader()>
      <cfset tagSoup = loader.create("org.ccil.cowan.tagsoup.Parser").init()>
      <cfset tagSoup.setFeature("http://xml.org/sax/features/namespace-prefixes", false)>
      <cfset tagSoup.setFeature("http://xml.org/sax/features/namespaces", false)>
      <cfset _docBuilder = loader.create("nu.xom.Builder").init(tagSoup)>
    </cfif>
    <cfreturn _docBuilder>
  </cffunction>



  <cffunction name="getSelenium" output="false">
    <cfargument name="serverHost" default="localhost">
    <cfargument name="serverPort" default="4444">
    <cfargument name="browserStartCommand" default="*mock">
    <cfargument name="browserURL" default="http://localhost/">
    <cfset var key = hash("#serverHost#:#serverPort# #browserStartCommand# #browserURL#")>
    <cfset var loader = "">
    <cfif not isDefined("_selenium")>
      <cfset _selenium = structNew()>
    </cfif>
    <cfif not structKeyExists(_selenium, key)>
      <cfset loader = getJavaLoader()>
      <cfset _selenium[key] = loader.create("com.thoughtworks.selenium.DefaultSelenium").init(serverHost, serverPort, browserStartCommand, browserURL)>
      <cfset _selenium[key].start()>
    </cfif>
    <cfreturn _selenium[key]>
  </cffunction>



  <cffunction name="stopSelenium" output="false">
    <cfset var key = "">
    <cfif isDefined("_selenium")>
      <cfloop collection="#_selenium#" item="key">
        <cfset _selenium[key].stop()>
      </cfloop>
      <cfset structClear(_selenium)>
    </cfif>
  </cffunction>



</cfcomponent>
