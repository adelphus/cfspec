<cfimport taglib="/cfspec" prefix="">

<describe hint="HtmlReport">

  <before>
    <cfset stats = createObject("component", "cfspec.lib.SpecStats").init()>
    <cfset $(stats).stubs("getTimerSummary").returns("0.123 seconds")>
    <cfset $report = $(createObject("component", "cfspec.lib.HtmlReport").init(stats))>
  </before>

  <it should="output a passing report with no examples">
    <cffile action="read" file="#expandPath('htmlReports/withNoExamples.html')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>
    <cfset $report.getOutput().shouldEqual(expected)>
  </it>

  <it should="output a passing report with one passing example">
    <cffile action="read" file="#expandPath('htmlReports/withOnePassingExample.html')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset stats.incrementExampleCount()><cfset stats.incrementPassCount()>

    <cfset $report.enterBlock("with one passing example")>
    <cfset $report.addExample("pass", "should pass")>
    <cfset $report.exitBlock()>

    <cfset $report.getOutput().shouldEqual(expected)>
  </it>

  <it should="output a pending report with one pending example">
    <cffile action="read" file="#expandPath('htmlReports/withOnePendingExample.html')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset stats.incrementExampleCount()><cfset stats.incrementPendCount()>

    <cfset $report.enterBlock("with one pending example")>
    <cfset $report.addExample("pend", "should pend")>
    <cfset $report.exitBlock()>

    <cfset $report.getOutput().shouldEqual(expected)>
  </it>

  <it should="output a failing report with one failing example">
    <cffile action="read" file="#expandPath('htmlReports/withOneFailingExample.html')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset stats.incrementExampleCount()>

    <cfset $report.enterBlock("with one failing example")>
    <cfset $report.addExample("fail", "should fail")>
    <cfset $report.exitBlock()>

    <cfset $report.getOutput().shouldEqual(expected)>
  </it>

  <it should="output a pending report with two passing and one pending example">
    <cffile action="read" file="#expandPath('htmlReports/withTwoPassingAndOnePendingExample.html')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset stats.incrementExampleCount()><cfset stats.incrementPassCount()>
    <cfset stats.incrementExampleCount()><cfset stats.incrementPendCount()>
    <cfset stats.incrementExampleCount()><cfset stats.incrementPassCount()>

    <cfset $report.enterBlock("with two passing and one pending example")>
    <cfset $report.addExample("pass", "should pass")>
    <cfset $report.addExample("pend", "should pend")>
    <cfset $report.addExample("pass", "should pass")>
    <cfset $report.exitBlock()>

    <cfset $report.getOutput().shouldEqual(expected)>
  </it>

  <it should="output a failing report with two passing and one failing example">
    <cffile action="read" file="#expandPath('htmlReports/withTwoPassingAndOneFailingExample.html')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset stats.incrementExampleCount()><cfset stats.incrementPassCount()>
    <cfset stats.incrementExampleCount()>
    <cfset stats.incrementExampleCount()><cfset stats.incrementPassCount()>

    <cfset $report.enterBlock("with two passing and one failing example")>
    <cfset $report.addExample("pass", "should pass")>
    <cfset $report.addExample("fail", "should fail")>
    <cfset $report.addExample("pass", "should pass")>
    <cfset $report.exitBlock()>

    <cfset $report.getOutput().shouldEqual(expected)>
  </it>

  <it should="output a failing report with two pending and one failing example">
    <cffile action="read" file="#expandPath('htmlReports/withTwoPendingAndOneFailingExample.html')#" variable="expected">
    <cfset expected = trim(reReplace(reReplace(expected, ">\s+<", "><", "all"), "\s+", " ", "all"))>

    <cfset stats.incrementExampleCount()><cfset stats.incrementPendCount()>
    <cfset stats.incrementExampleCount()>
    <cfset stats.incrementExampleCount()><cfset stats.incrementPendCount()>

    <cfset $report.enterBlock("with two pending and one failing example")>
    <cfset $report.addExample("pend", "should pend")>
    <cfset $report.addExample("fail", "should fail")>
    <cfset $report.addExample("pend", "should pend")>
    <cfset $report.exitBlock()>

    <cfset $report.getOutput().shouldEqual(expected)>
  </it>

  <it should="output a failing report with many nested examples">
    <cffile action="read" file="#expandPath('htmlReports/withManyNestedExamples.html')#" variable="expected">
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

    <cfset $report.getOutput().shouldEqual(expected)>
  </it>

</describe>
