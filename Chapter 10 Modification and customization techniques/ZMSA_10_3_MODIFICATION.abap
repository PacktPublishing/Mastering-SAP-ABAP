******************************************************************************
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
CONSTANTS: cv_augru TYPE C length 10  VALUE 'VBAK-AUGRU'.
   CONSTANTS: cv_tcode TYPE C LENGTH 4   VALUE 'VA01'.

    IF sy-tcode = cv_tcode.
      CASE screen-name.
        WHEN cv_augru.
          IF vbak-augru IS INITIAL.
            vbak-augru = '001'.
          ENDIF.
      ENDCASE.
    ENDIF. 
