******************************************************************************
* Report  : ZMSA_R_CHAPTER12_1
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Simple report for test purpose
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter12_1.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.

    DATA: lt_bkpf_users TYPE TABLE OF bkpf.
    DATA: users_tab TYPE TABLE OF usr02.
    DATA: users_structure TYPE usr02.
    DATA: lv_message TYPE string.

    SELECT DISTINCT usnam FROM bkpf INTO CORRESPONDING FIELDS OF TABLE lt_bkpf_users WHERE bldat = sy-datum.
    SELECT * FROM usr02 APPENDING TABLE users_tab
      FOR ALL ENTRIES IN lt_bkpf_users
      WHERE bname = lt_bkpf_users-usnam.

    LOOP AT users_tab INTO users_structure.
      CONCATENATE 'Hello financial team member, your last login was at' users_structure-trdat users_structure-ltime
      INTO lv_message SEPARATED BY space.

      CALL FUNCTION 'TH_POPUP'
        EXPORTING
          client  = sy-mandt
          user    = users_structure-bname
          message = lv_message.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).