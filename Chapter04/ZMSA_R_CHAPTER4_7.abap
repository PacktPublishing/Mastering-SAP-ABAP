******************************************************************************
* Report  : ZMSA_R_CHAPTER4_7
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Creating Microsoft Word file using OLE
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter4_7.
INCLUDE ole2incl.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    DATA: lo_word TYPE ole2_object.
    DATA: lo_doc TYPE ole2_object.
    DATA: lo_selection TYPE ole2_object.
    DATA: lo_font TYPE ole2_object.
    DATA: lo_paragraph TYPE ole2_object.

    CREATE OBJECT lo_word 'Word.Application'.
    CALL METHOD OF lo_word 'Documents' = lo_doc.
    CALL METHOD OF lo_doc 'Add'.
    GET PROPERTY OF lo_word 'Selection' = lo_selection.
    GET PROPERTY OF lo_selection 'ParagraphFormat' = lo_paragraph.
    GET PROPERTY OF lo_selection 'Font' = lo_font.


    SET PROPERTY OF lo_word 'Visible' = 1.
    SET PROPERTY OF lo_font 'Size' = 22.
    SET PROPERTY OF lo_font 'Bold' = 1.
    SET PROPERTY OF lo_paragraph 'Alignment' = 1. " Centered

    CALL METHOD OF lo_selection 'TypeText'
      EXPORTING
        #1 = 'First Word Report of Airlines with OLE'.
    CALL METHOD OF lo_selection 'TypeParagraph'.

    DATA: lt_carrname TYPE TABLE OF s_carrname.
    DATA: lv_carrname TYPE s_carrname.
    SELECT carrname FROM scarr INTO TABLE lt_carrname.

    SET PROPERTY OF lo_font 'Size' = 10.

    SET PROPERTY OF lo_font 'Bold' = 0.
    SET PROPERTY OF lo_paragraph 'Alignment' = 0.

    LOOP AT lt_carrname INTO lv_carrname.
      CALL METHOD OF lo_selection 'TypeText'
        EXPORTING
          #1 = lv_carrname.
      CALL METHOD OF lo_selection 'TypeParagraph'.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).