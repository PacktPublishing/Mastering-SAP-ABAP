******************************************************************************
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
FIELD-SYMBOLS: <ls_order_items_in> TYPE bapiitemin.

LOOP AT order_items_in[] ASSIGNING <ls_order_items_in> WHERE short_text IS INITIAL.
  SELECT SINGLE maktx FROM makt INTO <ls_order_items_in>-SHORT_TEXT WHERE matnr = <ls_order_items_in>-material AND spras = 'E'.
ENDLOOP.
