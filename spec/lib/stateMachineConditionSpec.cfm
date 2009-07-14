<cfimport taglib="/cfspec" prefix="">

<describe hint="StateMachineCondition">

  <before>
    <cfset machine = stub("state machine")>
    <cfset condition = createObject("component", "cfspec.lib.StateMachineCondition")
		                      .init(machine, "test")>
  </before>

  <it should="verify that the condition is active">
    <cfset machine.stubs("getState").returns("test")>
    <cfset $(condition).shouldBeActive()>
  </it>

  <it should="verify that the condition is not active">
    <cfset machine.stubs("getState").returns("other")>
    <cfset $(condition).shouldNotBeActive()>
  </it>

</describe>