******************************************************************************
* Report  : ZMSA_R_CHAPTER6_1
* Author  : Pawel Grzeskowiak
* Email   : PawelGrzeskowiak@gmail.com, PawelGrzeskowiak@capgemini.com
* WWW     : http://pawelgrzeskowiak.pl, http://sapported.com
* Company : Capgemini
*----------------------------------------------------------------------------*
* Using Simple Transformation for XML de-serialization
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180606 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter6_4.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    CONSTANTS: lv_filepath   TYPE string VALUE 'C:\temp\carr.xml'.

    DATA: lt_carr TYPE TABLE OF scarr.
    DATA: lt_filetable    TYPE STANDARD TABLE OF string.
    DATA: lv_filecontent  TYPE string.

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = lv_filepath
      CHANGING
        data_tab                = lt_filetable
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
    ENDIF.

    CONCATENATE LINES OF lt_filetable INTO lv_filecontent.


    SELECT *
           FROM scarr
           INTO CORRESPONDING FIELDS OF TABLE @lt_carr.

    CALL TRANSFORMATION zmsa_st_chapter6_3
                        SOURCE XML lv_filecontent
                        RESULT airlines = lt_carr .


     cl_demo_output=>display( lt_carr ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).