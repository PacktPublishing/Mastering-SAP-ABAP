<?sap.transform simple?>
<tt:transform xmlns:tt="http://www.sap.com/transformation-templates" xmlns:ddic="http://www.sap.com/abapxml/types/dictionary" xmlns:def="http://www.sap.com/abapxml/types/defined">
  <tt:root name="AIRLINES" type="ddic:SCARR_TAB"/>
  <tt:template>
    <AIRLINES>
      <tt:loop ref=".AIRLINES">
        <SCARR>
          <CARRID tt:value-ref="CARRID"/>
          <CARRNAME tt:value-ref="CARRNAME"/>
          <CURRCODE tt:value-ref="CURRCODE"/>
          <URL tt:value-ref="URL"/>
        </SCARR>
      </tt:loop>
    </AIRLINES>
  </tt:template>
</tt:transform>