******************************************************************************
* Report  : ZMSA_R_CHAPTER12_3
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Simple report for debugger script testing
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter12_3.

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    DATA: lt_usr TYPE TABLE OF usr02.
    DATA: ls_usr TYPE usr02.
    DATA: lv_monday TYPE datum.
    DATA: lv_sunday TYPE datum.

    SELECT * FROM usr41 INNER JOIN usr02 ON usr41~bname = usr02~bname
       APPENDING CORRESPONDING FIELDS OF TABLE lt_usr.

    LOOP AT lt_usr INTO ls_usr.
      IF ls_usr-bname <> sy-uname.
            CHECK ls_usr-pwdlgndate IS NOT INITIAL.
          CALL FUNCTION 'GET_WEEK_INFO_BASED_ON_DATE'
            EXPORTING
              date   = sy-datum
            IMPORTING
              monday = lv_monday
              sunday = lv_sunday.

          IF ls_usr-pwdlgndate >= lv_monday AND ls_usr-pwdlgndate <= lv_sunday.                      .
            WRITE /: 'This user last password change was within this week:', ls_usr-bname .

          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).