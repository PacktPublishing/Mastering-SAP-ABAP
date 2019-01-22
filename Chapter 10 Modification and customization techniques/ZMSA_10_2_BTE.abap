******************************************************************************
* Author  : Pawel Grzeskowiak
* Email   : pawel.grzeskowiak@gmail.com
* WWW     : http://sapported.com
*----------------------------------------------------------------------------*  
  DATA: ls_mailsubject     TYPE sodocchgi1.
  DATA: lt_mailrecipients  TYPE STANDARD TABLE OF somlrec90 .
  DATA: ls_mailrecipients  TYPE somlrec90.
  DATA: lt_mailtxt         TYPE STANDARD TABLE OF soli.
  DATA: lv_mailtxt         TYPE soli.
  DATA: lv_content TYPE string.
  FIELD-SYMBOLS: <ls_bseg> TYPE bseg.



  LOOP AT t_bseg ASSIGNING <ls_bseg> WHERE dmbtr > 10000.
    IF <ls_bseg>-dmbtr > 10000.
      CONCATENATE lv_content 'Check position'  <ls_bseg>-buzei 'from document' <ls_bseg>-belnr  '<BR>' INTO lv_content SEPARATED BY space.
    ENDIF.
  ENDLOOP.

  CHECK lv_content IS NOT INITIAL.

  CONCATENATE '<HTML><BODY><H1>' lv_content '</H1></BODY></HTML>' INTO lv_content SEPARATED BY space.

  lv_mailtxt = lv_content.

  ls_mailrecipients-rec_type  = 'B'.
  ls_mailrecipients-receiver = sy-uname.
  APPEND ls_mailrecipients TO lt_mailrecipients.

  ls_mailsubject-obj_name = 'Notification Email'.
  ls_mailsubject-obj_langu = sy-langu.
  ls_mailsubject-obj_descr = 'High Amount Document Posted!'.


  APPEND lv_mailtxt TO lt_mailtxt.

  CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = ls_mailsubject
      document_type              = 'HTM'
    TABLES
      object_content             = lt_mailtxt
      receivers                  = lt_mailrecipients
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
