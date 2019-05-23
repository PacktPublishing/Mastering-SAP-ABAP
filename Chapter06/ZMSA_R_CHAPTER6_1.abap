******************************************************************************
* Report  : ZMSA_R_CHAPTER6_1
* Author  : Pawel Grzeskowiak
* Email   : PawelGrzeskowiak@gmail.com, PawelGrzeskowiak@capgemini.com
* WWW     : http://pawelgrzeskowiak.pl, http://sapported.com
* Company : Capgemini
*----------------------------------------------------------------------------*
* Basic XML parsing and displaying
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180606 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter6_1.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    CONSTANTS: lv_filepath   TYPE localfile VALUE 'C:\temp\carr.xml'.
    DATA: lo_xml     TYPE REF TO cl_xml_document.

    CREATE OBJECT lo_xml.

    lo_xml->import_from_file( filename = lv_filepath ).

    lo_xml->display( ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).