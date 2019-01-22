******************************************************************************
* Report  : ZMSA_R_CHAPTER6_5
* Author  : Pawel Grzeskowiak
* Email   : PawelGrzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Using sXML library to convert XML into JSON format
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180606 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter6_5.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.

    TYPES: BEGIN OF ty_carr,
             carrid   TYPE  s_carr_id,
             carrname TYPE  s_carrname,
             currcode TYPE  s_currcode,
             url       TYPE s_carrurl,
           END OF ty_carr.

    DATA: lt_carr TYPE TABLE OF ty_carr.
    DATA: lv_result TYPE string.

    SELECT *
           FROM scarr
           INTO CORRESPONDING FIELDS OF TABLE @lt_carr.

    DATA(lo_json_writer_t) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

    CALL TRANSFORMATION id SOURCE values = lt_carr
                           RESULT XML lo_json_writer_t.

    cl_abap_conv_in_ce=>create( )->convert(
      EXPORTING
        input = lo_json_writer_t->get_output( )
      IMPORTING
        data = lv_result ).

    cl_demo_output=>write_json( lv_result ).

    cl_demo_output=>display( ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).