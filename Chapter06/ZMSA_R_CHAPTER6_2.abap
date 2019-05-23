******************************************************************************
* Report  : ZMSA_R_CHAPTER6_2
* Author  : Pawel Grzeskowiak
* Email   : PawelGrzeskowiak@gmail.com, PawelGrzeskowiak@capgemini.com
* WWW     : http://pawelgrzeskowiak.pl, http://sapported.com
* Company : Capgemini
*----------------------------------------------------------------------------*
* Change XML content using CL_XML_DOCUMENT class
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180606 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter6_2.

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

    CONSTANTS: cv_currname TYPE string VALUE 'CURRCODE'.
    CONSTANTS: cv_currcode_old TYPE string VALUE 'AQD'.
    CONSTANTS: cv_currcode_new TYPE string VALUE 'AQQ'.

    DATA(lo_node) = lo_xml->find_node( EXPORTING name = cv_currname ).

    IF lo_node->get_value( ) = cv_currcode_old.
        lo_node->set_value( value = cv_currcode_new ).
    ENDIF.

    lo_xml->display( ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).