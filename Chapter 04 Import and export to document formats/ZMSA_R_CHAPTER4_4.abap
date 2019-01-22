******************************************************************************
* Report  : ZMSA_R_CHAPTER4_4
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Reading file from application server
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter4_4.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    DATA: lv_file TYPE string VALUE 'testfile4_3.txt'.
    DATA: lv_line TYPE string.
    DATA: lt_data TYPE TABLE OF string.

    OPEN DATASET lv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.

    DO.
      READ DATASET lv_file INTO lv_line.
      IF sy-subrc = 0.
        APPEND lv_line TO lt_data.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

    CLOSE DATASET lv_file.

    cl_demo_output=>display_data( lt_data ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).