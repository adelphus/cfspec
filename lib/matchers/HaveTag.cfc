<!---
  HaveTag expects the target to contain at least one of the specified XPath tag.
--->
<cfcomponent extends="cfspec.lib.Matcher" output="false">



  <cffunction name="setArguments">
    <cfset _matcherName = "HaveTag">
    <cfset requireArgs(arguments, 1)>
    <cfset _selector = arguments[1]>
    <cfset verifyArg(isSimpleValue(_selector), "selector", "should be a valid xpath selector")>
  </cffunction>



  <cffunction name="isMatch">
    <cfargument name="target">
    <cfset var xpath = _selector>
    <cfset var results = "">
    <cfset var doc = buildDoc(target)>
    <cfif find("/", xpath) neq 1>
      <cfset xpath = "//#xpath#">
    </cfif>
    <cfset results = xmlSearch(xmlParse(doc.toXml()), xpath)>
    <cfreturn arrayLen(results) gt 0>
  </cffunction>



  <cffunction name="getFailureMessage">
    <cfreturn "expected to have tag #inspect(_selector)#, but the tag was not found">
  </cffunction>



  <cffunction name="getNegativeFailureMessage">
    <cfreturn "expected not to have tag #inspect(_selector)#, but the tag was found">
  </cffunction>



  <cffunction name="getDescription">
    <cfreturn "have tag #inspect(_selector)#">
  </cffunction>



  <cffunction name="initDocBuilder">
    <cfset var loader = _runner.getJavaLoader()>
    <cfset var tagSoup = loader.create("org.ccil.cowan.tagsoup.Parser").init()>
    <cfset tagSoup.setFeature("http://xml.org/sax/features/namespace-prefixes", false)>
    <cfset tagSoup.setFeature("http://xml.org/sax/features/namespaces", false)>
    <cfset _docBuilder = loader.create("nu.xom.Builder").init(tagSoup)>
  </cffunction>



  <cffunction name="buildDoc">
    <cfargument name="target">
    <cfif not isDefined("_docBuilder")>
      <cfset initDocBuilder()>
    </cfif>
    <cfset var targetAsBytes = createObject("java", "java.lang.String").init(target).getBytes()>
    <cfset var targetAsStream = createobject("java","java.io.ByteArrayInputStream").init(targetAsBytes)>
    <cfreturn _docBuilder.build(targetAsStream)>
  </cffunction>



</cfcomponent>
