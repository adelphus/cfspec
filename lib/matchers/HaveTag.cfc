<cfcomponent extends="cfspec.lib.Matcher" output="false"><cfscript>

  function init() {
    $tagName = arguments[1];
    return this;
  }

  function isMatch(actual) {
    var loader = $context.getJavaLoader();
    var tagSoup = loader.create("org.ccil.cowan.tagsoup.Parser").init();
    var doc = loader.create("nu.xom.Document");
    var xpath = $tagName;
    var builder = "";
    var results = "";
    tagSoup.setFeature("http://xml.org/sax/features/namespace-prefixes", false);
    tagSoup.setFeature("http://xml.org/sax/features/namespaces", false);
    builder = loader.create("nu.xom.Builder").init(tagSoup);
    doc = builder.build(
                    createobject("java","java.io.ByteArrayInputStream").init(
                      createObject("java", "java.lang.String").init(actual).getBytes()
                  ));
    if (find("/", xpath) != 1) xpath = "//#xpath#";
    results = xmlSearch(xmlParse(doc.toXml()), xpath);
    return arrayLen(results) > 0;
  }

  function getFailureMessage() {
    return "expected to have tag #inspect($tagName)#, but the tag was not found";
  }

  function getNegativeFailureMessage() {
    return "expected not to have tag #inspect($tagName)#, but the tag was found";
  }

  function getDescription() {
    return "have tag #inspect($tagName)#";
  }
  
</cfscript></cfcomponent>