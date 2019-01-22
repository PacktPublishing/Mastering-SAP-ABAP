******************************************************************************
* Report  : ZMSA_R_CHAPTER9_1
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Working with BOPF
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter9_1.


PARAMETERS: p_prd_id TYPE /bobf/demo_product_id OBLIGATORY.
PARAMETERS: p_price TYPE /bobf/demo_buying_price.
PARAMETERS: p_text TYPE /bobf/demo_description.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME.
PARAMETERS: p_crt RADIOBUTTON GROUP gr1 DEFAULT 'X'.
PARAMETERS: p_dsp RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK bl1.


CLASS lcl_demo DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS main IMPORTING iv_prd_id TYPE /bobf/demo_product_id
                                 iv_price  TYPE /bobf/demo_buying_price
                                 iv_text   TYPE /bobf/demo_description
                                 iv_disp   TYPE boolean.

  PRIVATE SECTION.
    DATA: mo_transaction_mgr TYPE REF TO /bobf/if_tra_transaction_mgr.
    DATA: mo_service_manager  TYPE REF TO /bobf/if_tra_service_manager.
    DATA: mo_configuration TYPE REF TO /bobf/if_frw_configuration.
    DATA: mv_prod_id TYPE /bobf/demo_product_id.
    DATA: mv_price   TYPE /bobf/demo_buying_price.
    DATA: mv_text    TYPE /bobf/demo_description.
    DATA: mv_disp    TYPE boolean.



    METHODS:
      constructor IMPORTING
                            iv_prod_id TYPE /bobf/demo_product_id
                            iv_price   TYPE /bobf/demo_buying_price
                            iv_text    TYPE /bobf/demo_description
                  RAISING   /bobf/cx_frw,

      display_message IMPORTING io_message TYPE REF TO /bobf/if_frw_message,
      create_product,
      get_product_node RETURNING VALUE(ro_data) TYPE REF TO data,
      get_text_node    IMPORTING iv_key TYPE /bobf/conf_key RETURNING VALUE(ro_data) TYPE REF TO data,
      display_product.

ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    DATA: lo_demo TYPE REF TO lcl_demo.
    DATA: lo_cx TYPE REF TO /bobf/cx_frw.
    TRY.
        CREATE OBJECT lo_demo EXPORTING iv_price = iv_price iv_prod_id = iv_prd_id iv_text = iv_text.
        IF iv_disp = abap_true.
          lo_demo->display_product(  ).
        ELSE.
          lo_demo->create_product( ).
        ENDIF.
      CATCH /bobf/cx_frw INTO lo_cx.
        WRITE lo_cx->get_text( ).
    ENDTRY.
  ENDMETHOD.

  METHOD constructor.
    mo_transaction_mgr =
      /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    mo_service_manager =
      /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
                                       /bobf/if_demo_product_c=>sc_bo_key ).

    mo_configuration =
      /bobf/cl_frw_factory=>get_configuration( /bobf/if_demo_product_c=>sc_bo_key ).

    mv_price = iv_price.
    mv_prod_id = iv_prod_id.
    mv_text = iv_text.
  ENDMETHOD.

  METHOD create_product.
    "Modification variables used to make change on object
    DATA: lt_modification TYPE /bobf/t_frw_modification.
    FIELD-SYMBOLS: <ls_modification> TYPE /bobf/s_frw_modification.
    DATA: lo_change TYPE REF TO /bobf/if_tra_change.

    "This part is related to errors and success message handling
    DATA: lo_message TYPE REF TO /bobf/if_frw_message.
    DATA: lv_issue TYPE boolean.
    DATA: lo_exception TYPE REF TO /bobf/cx_frw.
    DATA: lv_err_return TYPE string.
    DATA: lv_rejected TYPE boolean.

    "Combined data model structure, fields of product BO
    DATA: lr_product_hdr TYPE REF TO /bobf/s_demo_product_hdr_k.
    DATA: lr_short_text TYPE REF TO /bobf/s_demo_short_text_k.

    "Create product header data
    CREATE DATA lr_product_hdr.
    lr_product_hdr->key              = /bobf/cl_frw_factory=>get_new_key( ).
    lr_product_hdr->product_id       = mv_prod_id.
    lr_product_hdr->product_type     = 'FOOD'.
    lr_product_hdr->base_uom         = 'KG'.
    lr_product_hdr->buy_price        =  mv_price.
    lr_product_hdr->buy_price_curr   = 'USD'.
    lr_product_hdr->sell_price       = lr_product_hdr->buy_price * '1.2'.
    lr_product_hdr->sell_price_curr  = 'USD'.

    "Add product header to modification table
    APPEND INITIAL LINE TO lt_modification ASSIGNING <ls_modification>.
    <ls_modification>-node = /bobf/if_demo_product_c=>sc_node-root.
    <ls_modification>-change_mode = /bobf/if_frw_c=>sc_modify_create.
    <ls_modification>-key = lr_product_hdr->key.
    <ls_modification>-data = lr_product_hdr.


    "Create short text data
    CREATE DATA lr_short_text.
    lr_short_text->key = /bobf/cl_frw_factory=>get_new_key( ).
    lr_short_text->language = sy-langu.
    lr_short_text->text = mv_text.

    "Add short text data to modification table
    APPEND INITIAL LINE TO lt_modification ASSIGNING <ls_modification>.
    <ls_modification>-node = /bobf/if_demo_product_c=>sc_node-root_text.
    <ls_modification>-change_mode = /bobf/if_frw_c=>sc_modify_create.
    <ls_modification>-source_node = /bobf/if_demo_product_c=>sc_node-root.
    <ls_modification>-association = /bobf/if_demo_product_c=>sc_association-root-root_text.
    <ls_modification>-key = lr_short_text->key.
    <ls_modification>-source_key = lr_product_hdr->key.
    <ls_modification>-data = lr_short_text.


    me->mo_service_manager->modify(
      EXPORTING
        it_modification =  lt_modification
      IMPORTING
        eo_change       = lo_change                 " Interface of Change Object
        eo_message      = lo_message                " Interface of Message Object
   ).

    IF lo_message IS BOUND.
      IF lo_message->check( ) EQ abap_true.
        me->display_message( lo_message ).
        RETURN.
      ENDIF.
    ENDIF.


    CALL METHOD me->mo_transaction_mgr->save
      IMPORTING
        ev_rejected = lv_rejected
        eo_message  = lo_message.

    IF lv_rejected EQ abap_true.
      me->display_message( lo_message ).
      RETURN.
    ENDIF.
  ENDMETHOD.

  METHOD display_message.
    DATA: lt_messages TYPE /bobf/t_frw_message_k.
    FIELD-SYMBOLS: <ls_message> TYPE /bobf/s_frw_message_k.

    IF io_message IS BOUND.
      io_message->get_messages( IMPORTING et_message = lt_messages ).
      LOOP AT lt_messages ASSIGNING <ls_message>.
        WRITE <ls_message>-message->get_text( ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD get_product_node.
    DATA lr_t_data      TYPE REF TO data.
    DATA lt_parameters    TYPE /bobf/t_frw_query_selparam.
    DATA lt_product_keys TYPE /bobf/t_frw_key.
    DATA ls_node_conf TYPE /bobf/s_confro_node.
    DATA lo_change    TYPE REF TO /bobf/if_tra_change.
    DATA lo_message   TYPE REF TO /bobf/if_frw_message.

    FIELD-SYMBOLS <lt_data> TYPE INDEX TABLE.
    FIELD-SYMBOLS <ls_parameter> LIKE LINE OF lt_parameters.
    FIELD-SYMBOLS <ls_product_key> LIKE LINE OF lt_product_keys.
    FIELD-SYMBOLS <ls_row> TYPE any.


    APPEND INITIAL LINE TO lt_parameters ASSIGNING <ls_parameter>.
    <ls_parameter>-attribute_name =
    /bobf/if_demo_product_c=>sc_query_attribute-root-select_by_elements-product_id.
    <ls_parameter>-sign           = 'I'.
    <ls_parameter>-option         = 'EQ'.
    <ls_parameter>-low            = mv_prod_id.


    CALL METHOD me->mo_service_manager->query
      EXPORTING
        iv_query_key            = /bobf/if_demo_product_c=>sc_query-root-select_by_elements
        it_selection_parameters = lt_parameters
      IMPORTING
        et_key                  = lt_product_keys.

    CALL METHOD me->mo_configuration->get_node
      EXPORTING
        iv_node_key = /bobf/if_demo_product_c=>sc_node-root
      IMPORTING
        es_node     = ls_node_conf.

    CREATE DATA lr_t_data TYPE (ls_node_conf-data_table_type).
    ASSIGN lr_t_data->* TO <lt_data>.

    CALL METHOD me->mo_service_manager->retrieve
      EXPORTING
        iv_node_key = /bobf/if_demo_product_c=>sc_node-root
        it_key      = lt_product_keys
      IMPORTING
        eo_message  = lo_message
        eo_change   = lo_change
        et_data     = <lt_data>.


    READ TABLE <lt_data> INDEX 1 ASSIGNING <ls_row>.
    IF sy-subrc EQ 0.
      GET REFERENCE OF <ls_row> INTO ro_data.
    ENDIF.

  ENDMETHOD.

  METHOD get_text_node.
    DATA lr_t_data      TYPE REF TO data.
    DATA lt_key         TYPE /bobf/t_frw_key.
    DATA ls_node_conf   TYPE /bobf/s_confro_node.
    DATA ls_association TYPE /bobf/s_confro_assoc.
    DATA lo_change      TYPE REF TO /bobf/if_tra_change.
    DATA lo_message     TYPE REF TO /bobf/if_frw_message.

    FIELD-SYMBOLS <lt_data> TYPE INDEX TABLE.
    FIELD-SYMBOLS <ls_row> TYPE any.
    FIELD-SYMBOLS <ls_key> LIKE LINE OF lt_key.

    CALL METHOD me->mo_configuration->get_assoc
      EXPORTING
        iv_assoc_key = /bobf/if_demo_product_c=>sc_association-root-root_text
        iv_node_key  = /bobf/if_demo_product_c=>sc_node-root
      IMPORTING
        es_assoc     = ls_association.

    ls_node_conf = ls_association-target_node->*.

    CREATE DATA lr_t_data TYPE (ls_node_conf-data_table_type).
    ASSIGN lr_t_data->* TO <lt_data>.

    APPEND INITIAL LINE TO lt_key ASSIGNING <ls_key>.
    <ls_key>-key = iv_key.

    CALL METHOD me->mo_service_manager->retrieve_by_association
      EXPORTING
        iv_node_key    = /bobf/if_demo_product_c=>sc_node-root
        it_key         = lt_key
        iv_association = /bobf/if_demo_product_c=>sc_association-root-root_text
        iv_fill_data   = abap_true
      IMPORTING
        eo_message     = lo_message
        eo_change      = lo_change
        et_data        = <lt_data>.


    IF lo_message IS BOUND.
      IF lo_message->check( ) EQ abap_true.
        display_message( lo_message ).
      ENDIF.
    ENDIF.

    ASSIGN lr_t_data->* TO <lt_data>.
    READ TABLE <lt_data> INDEX 1 ASSIGNING <ls_row>.
    IF sy-subrc EQ 0.
      GET REFERENCE OF <ls_row> INTO ro_data.
    ENDIF.
  ENDMETHOD.

  METHOD display_product.
    DATA lx_bopf_ex      TYPE REF TO /bobf/cx_frw.
    DATA lx_bopf_dac      TYPE REF TO /bobf/cx_dac.
    DATA lv_err_msg      TYPE string.

    DATA lr_s_root TYPE REF TO /bobf/s_demo_product_hdr_k.
    DATA lr_s_text TYPE REF TO /bobf/s_demo_short_text_k.

    TRY.
        lr_s_root ?= me->get_product_node( ).
        lr_s_text ?= me->get_text_node( lr_s_root->key ).

        WRITE: / 'Product #', lr_s_root->product_id.
        WRITE: / 'Product', lr_s_text->text.
        WRITE: / 'Buy Price', lr_s_root->buy_price LEFT-JUSTIFIED.
        WRITE: / 'Sell Price', lr_s_root->sell_price LEFT-JUSTIFIED.
      CATCH /bobf/cx_frw INTO lx_bopf_ex.
        lv_err_msg = lx_bopf_ex->get_text( ).
        WRITE: / lv_err_msg.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main(
    iv_prd_id = p_prd_id
    iv_price = p_price
    iv_text = p_text
    iv_disp = p_dsp
  ).