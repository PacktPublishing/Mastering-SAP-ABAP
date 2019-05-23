******************************************************************************
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
    CASE text+0(3).
      WHEN 'FI:' OR 'SD:' OR 'MM:'.
      WHEN OTHERS.
        MESSAGE 'Name should start from module name (FI:, SD:, MM:)' TYPE 'E'.
    ENDCASE.
