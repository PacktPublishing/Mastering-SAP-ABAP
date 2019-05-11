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
    DATA: lv_filename TYPE localfile VALUE 'c:/temp/testfile4_7.doc'.
    DATA: lo_word TYPE ole2_object.
    DATA: lo_doc TYPE ole2_object.
    DATA: lo_actdoc TYPE ole2_object.
    DATA: lo_app TYPE ole2_object.
    DATA: lo_selection TYPE ole2_object.
    DATA: lo_font TYPE ole2_object.
    DATA: lo_paragraph TYPE ole2_object.

    DATA: lt_carrname TYPE TABLE OF s_carrname.
    DATA: lv_carrname TYPE s_carrname.


    CREATE OBJECT lo_word 'WORD.DOCUMENT'.
    SET PROPERTY OF lo_word 'Visible' = 1.

    CALL METHOD OF lo_word 'Documents' = lo_doc.
    CALL METHOD OF lo_doc 'Add' = lo_doc.

    CALL METHOD OF lo_doc 'Activate'.

    GET PROPERTY OF lo_word 'ActiveDocument' = lo_actdoc.

    GET PROPERTY OF lo_actdoc 'Application' = lo_app.

    GET PROPERTY OF lo_app 'Selection' = lo_selection.
    GET PROPERTY OF lo_selection 'Font' = lo_font.
    GET PROPERTY OF lo_selection 'ParagraphFormat2' = lo_paragraph.


    SET PROPERTY OF lo_font 'Name' = 'Arial'.
    SET PROPERTY OF lo_font 'Size' = '22'.
    SET PROPERTY OF lo_font 'Bold' = '1'.
     SET PROPERTY OF lo_paragraph 'Bullet' = '2'.

    "SET PROPERTY OF lo_paragraph 'Alignment' = '1'. " Centered


    CALL METHOD OF lo_selection 'TypeText'
      EXPORTING
        #1 = 'First Word Report with OLE'.

    SELECT carrname FROM scarr INTO TABLE lt_carrname.

    LOOP AT lt_carrname INTO lv_carrname.
    CALL METHOD OF lo_selection 'TypeText'
      EXPORTING
        #1 = lv_carrname.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).