******************************************************************************
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*

CONSTANTS: lv_land1 TYPE land1 VALUE 'DE'.

IF  i_kna1-land1 <> lv_land1 AND i_kna1-stceg IS INITIAL.
  MESSAGE 'VAT number for this country is obligatory' TYPE 'E'.
ENDIF.
