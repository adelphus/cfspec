<cfimport taglib="/cfspec" prefix="">

<describe hint="One Widget">
  
  <it should="do something">
  </it>
  
  <it should="fail on purpose">
    <cfset fail()>
  </it>

  <it should="fail with a message">
    <cfset fail("the message")>
  </it>
  
  <it should="throw an exception">
    <cfthrow type="IntentionalException" message="here it is">
  </it>
  
  <it should="pend this test">
    <cfset pend()>
  </it>
  
  <describe hint="Subsection 1">

    <it should="do something">
    </it>

    <describe hint="Subsection 1(a)">

      <it should="do something">
      </it>
  
    </describe>
  
  </describe>
  
  <describe hint="Subsection 2">

    <it should="do something">
    </it>
  
  </describe>
  
</describe>