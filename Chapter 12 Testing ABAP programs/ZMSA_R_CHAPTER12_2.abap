******************************************************************************
* Report  : ZMSA_R_CHAPTER12_2
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Simple report with huge memory consumption
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter12_2.

TABLES sscrfields.
DATA: gt_usr TYPE TABLE OF usr02.

SELECTION-SCREEN:
    PUSHBUTTON 2(10)  but1 USER-COMMAND load.
INITIALIZATION.
  but1 = 'Load Data'.

AT SELECTION-SCREEN.
  CASE sscrfields.
    WHEN 'LOAD'.
      SELECT * FROM usr02 APPENDING CORRESPONDING FIELDS OF TABLE gt_usr.
  ENDCASE.

START-OF-SELECTION.
"do nothing