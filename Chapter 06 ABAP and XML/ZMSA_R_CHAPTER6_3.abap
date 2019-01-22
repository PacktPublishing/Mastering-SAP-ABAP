******************************************************************************
* Report  : ZMSA_R_CHAPTER6_3
* Author  : Pawel Grzeskowiak
* Email   : PawelGrzeskowiak@gmail.com, PawelGrzeskowiak@capgemini.com
* WWW     : http://pawelgrzeskowiak.pl, http://sapported.com
* Company : Capgemini
*----------------------------------------------------------------------------*
* Using Simple Transformation for XML serialization
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180606 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter6_3.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    DATA: lt_carr TYPE TABLE OF scarr.
    DATA: lv_xml  TYPE xstring.

    SELECT *
           FROM scarr
           INTO CORRESPONDING FIELDS OF TABLE @lt_carr.

    CALL TRANSFORMATION zmsa_st_chapter6_3
                        SOURCE airlines = lt_carr
                        RESULT XML lv_xml.

    cl_demo_output=>write_xml( lv_xml ).

    cl_demo_output=>display( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).