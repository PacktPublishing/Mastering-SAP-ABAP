******************************************************************************
* Report  : ZMSA_R_CHAPTER4_3
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Writing file to application server
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter4_3.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    DATA: lv_file TYPE string VALUE 'testfile4_3.txt'.

    OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

    TRANSFER '1st line on application server' TO lv_file.
    TRANSFER '2nd line on application server' TO lv_file.
    TRANSFER '3rd line on application server' TO lv_file.

    CLOSE DATASET lv_file.

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).