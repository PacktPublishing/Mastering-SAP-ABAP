******************************************************************************
* Report  : ZMSA_R_CHAPTER4_6
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Creating xls file on presentation layer
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter4_6.

INCLUDE ole2incl.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    DATA: lv_filename TYPE localfile VALUE 'c:/temp/testfile4_6.xls'.
    DATA: lo_excel TYPE ole2_object.
    DATA: lo_workbook TYPE ole2_object.
    DATA: lo_sheet TYPE ole2_object.
    DATA: lo_cell TYPE ole2_object.

    CREATE OBJECT lo_excel 'EXCEL.APPLICATION'.

    SET PROPERTY OF lo_excel 'visible' = 1.

    CALL METHOD OF lo_excel 'Workbooks' = lo_workbook.
    CALL METHOD OF lo_workbook 'Add'.

    CALL METHOD OF lo_excel 'Worksheets' = lo_sheet
                                 EXPORTING #1 = 1.
    CALL METHOD OF lo_sheet 'Activate'.

    SET PROPERTY OF lo_sheet 'Name' = 'TestSheet'.

    DO 10 TIMES.
      CALL METHOD OF lo_sheet 'Cells' = lo_cell EXPORTING #1 = sy-index #2 = 1.
      SET PROPERTY OF lo_cell 'Value' = sy-index.
    ENDDO.

    CALL METHOD OF lo_sheet 'SaveAs'
      EXPORTING
        #1 = lv_filename
        #2 = 1.

    SET PROPERTY OF lo_excel 'visible' = 0.

    CALL METHOD OF lo_sheet 'CLOSE'
      EXPORTING
        #1 = 'YES'.

    CALL METHOD OF lo_excel 'QUIT'.

    FREE OBJECT: lo_excel,
                 lo_sheet.


  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).