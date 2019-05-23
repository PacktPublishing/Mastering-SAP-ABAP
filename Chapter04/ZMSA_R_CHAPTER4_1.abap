******************************************************************************
* Report  : ZMSA_R_CHAPTER4_1
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Reading text file from
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter4_1.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    DATA: lv_filepath TYPE string.
    DATA: lt_data TYPE TABLE OF string.

    DATA: lt_filetable TYPE filetable.
    DATA: lv_filetable TYPE file_table.
    DATA: lv_rc TYPE i.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      CHANGING
        file_table              = lt_filetable
        rc                      = lv_rc
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
    ELSEIF lv_rc < 1.
      MESSAGE 'No File choosen' TYPE 'W'.
      RETURN.
    ENDIF.

    READ TABLE lt_filetable INTO lv_filepath INDEX 1.

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename = lv_filepath
      CHANGING
        data_tab = lt_data
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
       others                  = 19
      .

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
    ENDIF.

    cl_demo_output=>display_data( lt_data ).


  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).