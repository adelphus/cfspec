<cfcomponent extends="Matcher" output="false">

  <cffunction name="matchEqualString">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isSimpleValue(expected) and compare(obj, expected) eq 0>
  </cffunction>

  <cffunction name="matchEqualStringNoCase">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isSimpleValue(obj) and compareNoCase(obj, expected) eq 0>
  </cffunction>

  <cffunction name="matchEqualNumber">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isNumeric(obj) and isNumeric(expected) and val(obj) eq val(expected)>
  </cffunction>

  <cffunction name="matchEqualBoolean">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isBoolean(obj) and isBoolean(expected) and ((obj and expected) or not (obj or expected))>
  </cffunction>

  <cffunction name="matchEqualDate">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isDate(obj) and isDate(expected) and dateCompare(obj, expected) eq 0>
  </cffunction>

  <cffunction name="matchEqual">
    <cfargument name="expected" type="any" required="true">
    <cfset var match = matchEqualDate(expected) or matchEqualNumber(expected) or matchEqualString(expected)>
    <cfif (not match) and listFindNoCase("true,false,yes,no", obj) and listFindNoCase("true,false,yes,no", expected)>
      <cfset match = matchEqualBoolean(expected)>
    </cfif>
    <cfreturn match>
  </cffunction>

  <cffunction name="matchEqualNoCase">
    <cfargument name="expected" type="any" required="true">
    <cfset var match = matchEqualDate(expected) or matchEqualNumber(expected) or matchEqualStringNoCase(expected)>
    <cfif (not match) and listFindNoCase("true,false,yes,no", obj) and listFindNoCase("true,false,yes,no", expected)>
      <cfset match = matchEqualBoolean(expected)>
    </cfif>
    <cfreturn match>
  </cffunction>

  <cffunction name="matchContain">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isSimpleValue(expected) and find(expected, obj)>
  </cffunction>

  <cffunction name="matchContainNoCase">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isSimpleValue(expected) and findNoCase(expected, obj)>
  </cffunction>

  <cffunction name="matchBeTrue">
    <cfreturn isBoolean(obj) and obj>
  </cffunction>

  <cffunction name="matchBeFalse">
    <cfreturn isBoolean(obj) and not obj>
  </cffunction>

  <cffunction name="matchMatch">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isSimpleValue(expected) and reFind(expected, obj)>
  </cffunction>

  <cffunction name="matchMatchNoCase">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isSimpleValue(expected) and reFindNoCase(expected, obj)>
  </cffunction>

  <cffunction name="matchBeEmpty">
    <cfreturn trim(toString(obj)) eq "">
  </cffunction>

  <cffunction name="matchBeLessThan">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isNumeric(obj) and isNumeric(expected) and val(obj) lt val(expected)>
  </cffunction>

  <cffunction name="matchBeLessThanOrEqualTo">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isNumeric(obj) and isNumeric(expected) and val(obj) lte val(expected)>
  </cffunction>

  <cffunction name="matchBeGreaterThan">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isNumeric(obj) and isNumeric(expected) and val(obj) gt val(expected)>
  </cffunction>

  <cffunction name="matchBeGreaterThanOrEqualTo">
    <cfargument name="expected" type="any" required="true">
    <cfreturn isNumeric(obj) and isNumeric(expected) and val(obj) gte val(expected)>
  </cffunction>

  <cffunction name="matchBeCloseTo">
    <cfargument name="expected" type="any" required="true">
    <cfargument name="delta" type="any" required="true">
    <cfreturn isNumeric(obj) and isNumeric(expected) and isNumeric(delta) and abs(val(obj) - val(expected)) lte val(delta)>
  </cffunction>

</cfcomponent>