******************************************************************************
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*
  IF i_fkkko-blart = '06' and i_fkkko-abgrd IS INITIAL.
    MESSAGE 'For returns documents return reason is obligatory' type 'E'.
  ENDIF.
