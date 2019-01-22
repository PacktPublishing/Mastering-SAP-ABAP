******************************************************************************
* Report  : ZMSA_R_CHAPTER4_8
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Using DOI to integrate Microsoft Word in ABAP program
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter4_8.

TYPE-POOLS: soi.

DATA: lo_container TYPE REF TO cl_gui_custom_container.
DATA: lo_control   TYPE REF TO i_oi_container_control.
DATA: lo_proxy     TYPE REF TO i_oi_document_proxy.

DATA: lv_okcode TYPE syst_ucomm.

DATA: lv_closed  TYPE i.
DATA: lv_init   TYPE boolean.
DATA: lv_changed TYPE i.

TYPES: ty_row TYPE x LENGTH 2048.
DATA: lt_doc_table TYPE STANDARD TABLE OF ty_row.
DATA: lv_doc_size TYPE i.


SET SCREEN 100.

MODULE init OUTPUT.

  CHECK lv_init = abap_false.

  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  CALL METHOD c_oi_container_control_creator=>get_container_control
    IMPORTING
      control = lo_control.

  CALL METHOD c_oi_errors=>show_message EXPORTING type = 'E'.

  CREATE OBJECT lo_container
    EXPORTING
      container_name = 'CUSTOMCONTAINER'.
  CALL METHOD lo_container->set_visible EXPORTING visible = ' '.


  CALL METHOD lo_control->init_control
    EXPORTING
      r3_application_name      = 'R/3 Basis'
      inplace_enabled          = abap_true
      inplace_scroll_documents = abap_true
      parent                   = lo_container
      register_on_close_event  = abap_true
      register_on_custom_event = abap_true
      no_flush                 = abap_false.

  CALL METHOD c_oi_errors=>show_message EXPORTING type = 'E'.

  CALL METHOD lo_control->get_document_proxy
    EXPORTING
      document_type  = 'Word.Document.8'
      no_flush       = abap_false
    IMPORTING
      document_proxy = lo_proxy.

  CALL METHOD c_oi_errors=>show_message EXPORTING type = 'E'.

  lv_init = abap_true.
ENDMODULE.


MODULE user_command_0100 INPUT.
  CASE lv_okcode.

    WHEN 'OPEN'.
      CALL METHOD lo_proxy->is_destroyed
        IMPORTING
          ret_value = lv_closed.

      CHECK NOT lv_closed IS INITIAL.
      CALL METHOD lo_container->set_visible
        EXPORTING
          visible = abap_true.

      IF lv_doc_size > 0.

        CALL METHOD lo_proxy->open_document_from_table
          EXPORTING
            document_table = lt_doc_table
            document_size  = lv_doc_size
            document_title = 'DOI Test Document'
            open_inplace   = abap_true.
      ELSE.


        CALL METHOD lo_proxy->create_document
          EXPORTING
            open_inplace   = abap_true
            document_title = 'DOI Test Document'
            no_flush       = abap_false.

      ENDIF.
      CALL METHOD c_oi_errors=>show_message EXPORTING type = 'E'.


    WHEN 'CLOSE'.
      CALL METHOD lo_proxy->is_destroyed
        IMPORTING
          ret_value = lv_closed.

      IF lv_closed IS INITIAL.
        CALL METHOD lo_proxy->close_document
          EXPORTING
            do_save     = 'X'
          IMPORTING
            has_changed = lv_changed.

        CALL METHOD c_oi_errors=>show_message EXPORTING type = 'E'.

        IF NOT lv_changed IS INITIAL.
          CALL METHOD lo_proxy->save_document_to_table
            CHANGING
              document_table = lt_doc_table
              document_size  = lv_doc_size.
          CALL METHOD c_oi_errors=>show_message EXPORTING type = 'E'.
        ENDIF.

        CALL METHOD lo_proxy->release_document.
        CALL METHOD c_oi_errors=>show_message EXPORTING type = 'E'.
      ENDIF.

      CALL METHOD lo_container->set_visible EXPORTING visible = ' '.


  ENDCASE.
  CLEAR: lv_okcode.
ENDMODULE.


MODULE exit INPUT.
  CASE lv_okcode.
    WHEN 'STOP'.
      IF NOT lo_proxy IS INITIAL.
        CALL METHOD lo_proxy->close_document.
        FREE lo_proxy.
      ENDIF.
      IF NOT lo_control IS INITIAL.
        CALL METHOD lo_control->destroy_control.
        FREE lo_control.
      ENDIF.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.