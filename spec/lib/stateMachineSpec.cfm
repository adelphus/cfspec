<cfimport taglib="/cfspec" prefix="">

<describe hint="StateMachine">

  <before>
    <cfset $machine = $(createObject("component", "cfspec.lib.StateMachine").init("power"))>
    <cfset $machine.startsAs("off")>
  </before>

  <it should="start in it's initial state">
    <cfset $machine.is("off").shouldBeTrue()>
  </it>

  <it should="not be in a different state">
    <cfset $machine.is("on").shouldBeFalse()>
  </it>

  <describe hint="becomes">

    <it should="return a StateMachineTransition">
      <cfset $machine.becomes("on").shouldBeAnInstanceOf("cfspec.lib.StateMachineTransition")>
    </it>

    <it should="not change the current state">
      <cfset $machine.becomes("on")>
      <cfset $machine.is("on").shouldBeFalse()>
    </it>

    <it should="change to the transition state when the transition is run">
      <cfset $machine.becomes("on").run()>
      <cfset $machine.is("on").shouldBeTrue()>
    </it>

  </describe>

</describe>
