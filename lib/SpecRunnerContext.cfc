<cfcomponent output="false"><cfscript>
  
  function init(spec) {
    determineSpecFile(spec);
    $keywords = "RUNSPEC,$,STUB,MOCK,FAIL,PEND,THIS,$CFSPEC";
    $current = "0";
    $context = [];
    $targets = [];
    $target = "";
    $output = "";
    $currentTag = "?";
    $exception = "";
    $hint = "";
    return this;
  }
  
  function determineSpecFile(spec) {
    var webroot = expandPath("/");
    if (len(spec) > len(webroot) and left(spec, len(webroot)) == webroot) {
      $specFile = right(spec, len(spec) - len(webroot) + 1);
    } else {
      specPath = replace(spec, "\", "/", "all");
      while (specPath != '/' and spec != expandPath(specPath)) {
        specPath = "/" & listRest(specPath, "/");
      }
      if (specPath == "/") {
        //throw("Application", "Unable to determine the relative path for '#spec#'.")
      } else {
        $specFile = specPath;
      }
    }
  }

  function getSpecFile() {
    return $specFile;
  }

  function stepCurrent() {
    var n = val(listLast($current)) + 1;
    popCurrent();
    $current = listAppend($current, n);
  }

  function pushCurrent() {
    stepCurrent();
    $current &= ",0";
  }
  
  function popCurrent() {
    $current = reReplace($current, "(^|,)\d+$", "");
  }

  function isTrial() {
    return $target == "";
  }

  function makeTarget() {
    arrayAppend($targets, $current);
  }

  function nextTarget() {
    if (arrayIsEmpty($targets)) return false;
    $current = "0";
    $target = $targets[1];
    arrayDeleteAt($targets, 1);
    return true;
  }

  function isDescribeStartRunnable() {
    return reFind(reReplace($current, "\d+$", "") & "1(,1)*$", $target) == 1;
  }

  function isDescribeInsideRunnable() {
    return find(reReplace($current, "\d+$", ""), $target) == 1;
  }
  
  function isBeforeAllRunnable() {
    $currentTag = "beforeAll";
    return isDescribeStartRunnable();
  }
  
  function isBeforeRunnable() {
    $currentTag = "before";
    return isDescribeInsideRunnable();
  }

  function isItRunnable() {
    $currentTag = "it";
    return $target == $current;
  }

  function isAfterRunnable() {
    $currentTag = "after";
    return isDescribeInsideRunnable();
  }
  
  function isAfterAllRunnable() {
    $currentTag = "afterAll";
    return isDescribeEndRunnable();
  }

  function isDescribeEndRunnable() {
    if (find($current, $target) != 1) return false;
    if (arrayLen($targets) == 0) return true;
    return find($current, $targets[1]) != 1;
  }
  
  function setHint(hint) {
    $hint = hint;
  }

  function getHint() {
    return $hint;
  }
  
  function pushContext() {
    arrayPrepend($context, structNew());
  }
  
  function popContext() {
    arrayDeleteAt($context, 1);    
  }
  
  function getContext() {
    var context = {};
    var i = arrayLen($context);
    while (i > 0) {
      structAppend(context, $context[i]);
      i--;
    }
    return context;
  }
  
  function setContext(context) {
    var key = "";
    if (arrayIsEmpty($context)) return;
    for (key in context) {
      if (!listFind($keywords, key)) {
        $context[1][key] = context[key];
      }
    }
  }

  function updateContext(context) {
    var key = "";
    var i = "";
    if (arrayIsEmpty($context)) return;
    for (i = 1; i <= arrayLen($context); i++) {
      for (key in $context[i]) {
        if (structKeyExists(context, key)) {
          $context[i][key] = context[key];
          structDelete(context, key);
        }
      }
    }
  }
  
  function scrubContext(context) {
    for (key in context) {
      if (!listFind($keywords, key)) {
         structDelete(context, key);
      }
    }
  }
  
  function appendOutput(data) {
    $output &= data;
  }
  
  function getOutput() {
    return $output;
  }

  function hasExpectedException() {
    return !isSimpleValue($exception);
  }

  function setExpectedException(e) {
    $exception = e;
  }
  
  function getExpectedException() {
    var e = $exception;
    $exception = "";
    return e;
  }

  function rethrowExpectedException() {
    if (!isSimpleValue($exception)) {
      createObject("component", "cfspec.lib.Matcher").rethrow(getExpectedException());
    }
  }

  function recoverFromException() {
    var target = "";
    var i = 0;    
    if (listFind("beforeAll,before,after,afterAll", $currentTag)) {
      while (arrayLen($targets) and find(reReplace($current, "\d+$", ""), $targets[1]) == 1) {
        arrayDeleteAt($targets, 1);
      }
    }
    if (arrayLen($targets)) target = $targets[1];
    while ((listLen($current) gt i) and 
           (listLen(target) gt i) and 
           (listGetAt($current, i+1) == listGetAt(target, i+1))) i++;
    i = listLen($current) - i - 1;
    while (i > 0) {
      appendOutput("</div>");
      i--;
    }
  }

  function formatException(e) {
    var context = "";
    var i = "";
    var result = "<p class='error'>should #getHint()#<br /><br /><small><u>#e.type#</u><br />";
    result &= "Message: #e.message#<br />Detail: #e.detail#<br />Stack Trace:";
    for (i = 1; i <= arrayLen(e.tagContext); i++) {
      context = e.tagContext[i];
      result &= "<pre>  ";
      if (isDefined("context.id")) result &= context.id; else result &= "???";
      result &= " at #context.template#(#context.line#,#context.column#)</pre>";
    }    
    result &= "</small></p>";
    return result;
  }

  function getInflector() {
    if (!isDefined("$inflector")) {
      $inflector = createObject("component", "cfspec.util.Inflector").init();
    }
    return $inflector;
  }

</cfscript></cfcomponent>