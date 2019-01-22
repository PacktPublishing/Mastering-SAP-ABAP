******************************************************************************
* Report  : ZMSA_R_CHAPTER12_4
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
* Simple report for eCatt testing
******************************************************************************
* CHANGE HISTORY : (Latest change first, descending order)                   *
*----------------------------------------------------------------------------*
* AUTHOR           | YYYYMMDD | Description                *
*----------------------------------------------------------------------------*
* PawelGrzeskowiak | 20180720 | Initial Version
*----------------------------------------------------------------------------
REPORT zmsa_r_chapter12_4.

DATA: lv_result TYPE string.


PARAMETERS: p_num1 TYPE int4.
PARAMETERS: p_num2 TYPE int4 .
PARAMETERS: p_radio1 RADIOBUTTON GROUP rad1.
PARAMETERS: p_radio2 RADIOBUTTON GROUP rad1.
PARAMETERS: p_radio3 RADIOBUTTON GROUP rad1.
PARAMETERS: p_radio4 RADIOBUTTON GROUP rad1.
PARAMETERS: p_result TYPE string NO-DISPLAY.

AT SELECTION-SCREEN.
      CLEAR: p_result.
      CASE abap_true.
        WHEN p_radio1.
          p_result = p_num1 + p_num2.
        WHEN p_radio2.
          p_result = p_num1 - p_num2.
        WHEN p_radio3.
          p_result = p_num1 * p_num2.
        WHEN p_radio4.
          IF p_num2 IS INITIAL OR p_num2 = 0.
            p_result = 'N/A'.
          ELSE.
            p_result = p_num1 / p_num2.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.
      MESSAGE p_result TYPE 'S'.