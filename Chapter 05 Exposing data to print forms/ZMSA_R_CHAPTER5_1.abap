******************************************************************************
* Report  : ZMSA_R_CHAPTER5_1
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Test Smartform and Adobe Form report
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter5_1.
TABLES: vbak.

PARAMETERS: p_vbeln LIKE vbak-vbeln.
PARAMETERS: p_sf RADIOBUTTON GROUP rb1 DEFAULT 'X'.
PARAMETERS: p_af RADIOBUTTON GROUP rb1.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main IMPORTING iv_vbeln TYPE vbeln iv_smart TYPE boolean.

  PRIVATE SECTION.
    CLASS-METHODS factory  IMPORTING iv_vbeln TYPE vbeln RETURNING
                             VALUE(ro_demo) TYPE REF TO lcl_demo.
    METHODS print_smartform.
    METHODS print_adobe.
    METHODS load_data IMPORTING iv_vbeln TYPE vbeln.

    DATA: mt_vbap TYPE vbap_tty.
    DATA: ms_vbak TYPE vbak.
    DATA: mv_sender_adrc TYPE adrnr.
    DATA: mv_recipient_adrc TYPE adrnr.

ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    IF p_sf = abap_true.
      lcl_demo=>factory( p_vbeln )->print_smartform( ).
    ELSE.
      lcl_demo=>factory( p_vbeln )->print_adobe( ).
    ENDIF.
  ENDMETHOD.

  METHOD factory.
    CREATE OBJECT ro_demo.
    ro_demo->load_data( iv_vbeln ).
  ENDMETHOD.

  METHOD load_data.

    SELECT SINGLE kunnr vkorg audat vbeln FROM vbak INTO CORRESPONDING FIELDS OF ms_vbak WHERE vbeln = iv_vbeln.

    IF ms_vbak-vbeln IS NOT INITIAL.
      SELECT netwr matnr kwmeng matkl FROM vbap APPENDING CORRESPONDING FIELDS OF TABLE mt_vbap.

      SELECT SINGLE vkorg FROM tvko INTO ms_vbak-bukrs_vf WHERE vkorg = ms_vbak-vkorg.

      SELECT SINGLE adrnr FROM t001 INTO mv_sender_adrc WHERE bukrs = ms_vbak-bukrs_vf.

      SELECT SINGLE adrnr FROM kna1 INTO mv_recipient_adrc WHERE kunnr = ms_vbak-kunnr.

    ELSE.

      ms_vbak-vbeln = '100001'.
      ms_vbak-audat = '20180101'.

      SELECT SINGLE addrnumber INTO mv_recipient_adrc FROM adrc.
      mv_sender_adrc = mv_recipient_adrc.

      DATA: ls_vbap TYPE vbap.
      CLEAR: ls_vbap.
      ls_vbap-matnr = '101'.
      ls_vbap-matkl = 'Test1'.
      ls_vbap-netwr = '13.5'.
      ls_vbap-kwmeng = '10'.
      APPEND ls_vbap TO mt_vbap.

      CLEAR: ls_vbap.
      ls_vbap-matnr = '102'.
      ls_vbap-matkl = 'Test2'.
      ls_vbap-netwr = '25'.
      ls_vbap-kwmeng = '5'.
      APPEND ls_vbap TO mt_vbap.

      CLEAR: ls_vbap.
      ls_vbap-matnr = '103'.
      ls_vbap-matkl = 'Test3'.
      ls_vbap-netwr = '100'.
      ls_vbap-kwmeng = '2'.
      APPEND ls_vbap TO mt_vbap.
    ENDIF.
  ENDMETHOD.

  METHOD print_smartform.
    DATA: lv_fname TYPE rs38l_fnam.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZMSA_05_SMARTFORM'
      IMPORTING
        fm_name            = lv_fname
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

    CALL FUNCTION lv_fname
      EXPORTING
        is_vbak           = ms_vbak
        it_vbap           = mt_vbap
        iv_sender_adrc    = mv_sender_adrc
        iv_recipient_adrc = mv_recipient_adrc
      EXCEPTIONS
        formatting_error  = 1
        internal_error    = 2
        send_error        = 3
        user_canceled     = 4
        OTHERS            = 5.

  ENDMETHOD.

  METHOD print_adobe.
    DATA: ie_outputparams TYPE sfpoutputparams.
    DATA: lv_funcname TYPE funcname.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ie_outputparams.

    TRY.
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = 'ZMSA_05_AF_ADOBE'
          IMPORTING
            e_funcname = lv_funcname.
      CATCH cx_fp_api_repository.
      CATCH cx_fp_api_usage.
      CATCH cx_fp_api_internal.
    ENDTRY.

    DATA: ls_docparams TYPE sfpdocparams.
    DATA: ls_formoutput TYPE fpformoutput.

    CALL FUNCTION lv_funcname
      EXPORTING
        /1bcdwb/docparams  = ls_docparams
        is_vbak            = ms_vbak
        it_vbap            = mt_vbap
        iv_sender_adrc     = mv_sender_adrc
        iv_recipient_adrc  = mv_recipient_adrc
      IMPORTING
        /1bcdwb/formoutput = ls_formoutput
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3.


    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( EXPORTING iv_vbeln = p_vbeln iv_smart = p_sf ).