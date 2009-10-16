<cfimport taglib="/cfspec" prefix="">

<describe hint="XmlReport">

  <before>
    <cfset stats = createObject("component", "cfspec.lib.SpecStats").init()>
    <cfset $(stats).stubs("getTimer").returns(0.123)>
    <cfset $report = $(createObject("component", "cfspec.lib.XmlReport").init())>
    <cfset $report.setSpecStats(stats)>
    <cfset $report.setSpecFile("spec/exampleSpec.cfm")>
    <cfset $report.stubs("getTimestamp").returns("2009-10-16T23:13:49")>
    <cfset $report.stubs("getTimer").returns(0.007)>
    <cfset assetPath = "/cfspec/spec/lib/xmlReports">
  </before>

  <it should="output a passing report with no examples">
    <cffile action="read" file="#expandPath('#assetPath#/withNoExamples.xml')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>
    <cfset output = reReplace($report.getOutput().value(), "<style>.*?</script>", "")>
    <cfset $(output).shouldEqual(expected)>
  </it>

  <it should="output a passing report with one passing example">
    <cffile action="read" file="#expandPath('#assetPath#/withOnePassingExample.xml')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset stats.incrementExampleCount()><cfset stats.incrementPassCount()>

    <cfset $report.enterBlock("with one passing example")>
    <cfset $report.addExample("pass", "should pass")>
    <cfset $report.exitBlock()>

    <cfset output = reReplace($report.getOutput().value(), "<style>.*?</script>", "")>
    <cfset $(output).shouldEqual(expected)>
  </it>

  <it should="output a pending report with one pending example">
    <cffile action="read" file="#expandPath('#assetPath#/withOnePendingExample.xml')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset stats.incrementExampleCount()><cfset stats.incrementPendCount()>

    <cfset $report.enterBlock("with one pending example")>
    <cfset $report.addExample("pend", "should pend")>
    <cfset $report.exitBlock()>

    <cfset output = reReplace($report.getOutput().value(), "<style>.*?</script>", "")>
    <cfset $(output).shouldEqual(expected)>
  </it>

  <it should="output a failing report with one failing example">
    <cffile action="read" file="#expandPath('#assetPath#/withOneFailingExample.xml')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset stats.incrementExampleCount()>

    <cfset $report.enterBlock("with one failing example")>
    <cfset $report.addExample("fail", "should fail")>
    <cfset $report.exitBlock()>

    <cfset output = reReplace($report.getOutput().value(), "<style>.*?</script>", "")>
    <cfset $(output).shouldEqual(expected)>
  </it>

  <it should="output a failing report with one failing example (with exception)">
    <cffile action="read" file="#expandPath('#assetPath#/withOneFailingExampleWithException.xml')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset exception = structNew()>
    <cfset exception.type = "MyException">
    <cfset exception.message = "My message">
    <cfset exception.detail = "My detail">
    <cfset exception.tagContext = arrayNew(1)>

    <cfset stats.incrementExampleCount()>

    <cfset $report.enterBlock("with one failing example")>
    <cfset $report.addExample("error", "should throw exception", exception)>
    <cfset $report.exitBlock()>

    <cfset output = reReplace($report.getOutput().value(), "<style>.*?</script>", "")>
    <cfset $(output).shouldEqual(expected)>
  </it>

  <it should="output a failing report with many nested examples">
    <cffile action="read" file="#expandPath('#assetPath#/withManyNestedExamples.xml')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset stats.incrementExampleCount()>
    <cfset stats.incrementExampleCount()><cfset stats.incrementPendCount()>
    <cfset stats.incrementExampleCount()><cfset stats.incrementPassCount()>
    <cfset stats.incrementExampleCount()><cfset stats.incrementPendCount()>
    <cfset stats.incrementExampleCount()><cfset stats.incrementPassCount()>
    <cfset stats.incrementExampleCount()><cfset stats.incrementPassCount()>

    <cfset $report.enterBlock("with some failing examples")>
    <cfset $report.enterBlock("with some failing examples")>
    <cfset $report.enterBlock("with one failing, one pending and one passing example")>
    <cfset $report.addExample("fail", "should fail")>
    <cfset $report.addExample("pend", "should pend")>
    <cfset $report.addExample("pass", "should pass")>
    <cfset $report.exitBlock()>
    <cfset $report.exitBlock()>
    <cfset $report.enterBlock("with some pending examples")>
    <cfset $report.enterBlock("with one pending and one passing example")>
    <cfset $report.addExample("pend", "should pend")>
    <cfset $report.addExample("pass", "should pass")>
    <cfset $report.exitBlock()>
    <cfset $report.exitBlock()>
    <cfset $report.enterBlock("with some passing examples")>
    <cfset $report.enterBlock("with one passing example")>
    <cfset $report.addExample("pass", "should pass")>
    <cfset $report.exitBlock()>
    <cfset $report.exitBlock()>
    <cfset $report.exitBlock()>

    <cfset output = reReplace($report.getOutput().value(), "<style>.*?</script>", "")>
    <cfset $(output).shouldEqual(expected)>
  </it>

</describe>
