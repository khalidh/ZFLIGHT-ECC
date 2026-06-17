CLASS zcl_invoice_service DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS create_from_order
      IMPORTING iv_orderid TYPE zsorder-orderid
      RETURNING VALUE(rv_invoiceid) TYPE zsinvoice-invoiceid
      RAISING zcx_flight_error.
ENDCLASS.

CLASS zcl_invoice_service IMPLEMENTATION.
  METHOD create_from_order.
    DATA ls_order TYPE zsorder.
    DATA ls_invoice TYPE zsinvoice.
    DATA lt_items TYPE STANDARD TABLE OF zsorder_item.
    DATA ls_item TYPE zsorder_item.
    DATA ls_inv_item TYPE zsinvoice_item.

    zcl_flight_service=>check_authority( '01' ).

    SELECT SINGLE * FROM zsorder INTO ls_order WHERE orderid = iv_orderid.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>technical_error.
    ENDIF.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING nr_range_nr = '01' object = 'ZINV_ID'
      IMPORTING number = rv_invoiceid
      EXCEPTIONS OTHERS = 1.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>number_range_failed.
    ENDIF.

    MOVE-CORRESPONDING ls_order TO ls_invoice.
    ls_invoice-invoiceid = rv_invoiceid.
    ls_invoice-orderid = iv_orderid.
    ls_invoice-bill_date = sy-datum.
    ls_invoice-status = 'OPEN'.
    INSERT zsinvoice FROM ls_invoice.

    SELECT * FROM zsorder_item INTO TABLE lt_items WHERE orderid = iv_orderid.
    LOOP AT lt_items INTO ls_item.
      CLEAR ls_inv_item.
      MOVE-CORRESPONDING ls_item TO ls_inv_item.
      ls_inv_item-invoiceid = rv_invoiceid.
      INSERT zsinvoice_item FROM ls_inv_item.
    ENDLOOP.

    UPDATE zsorder SET status = 'INVOICED' WHERE orderid = iv_orderid.
  ENDMETHOD.
ENDCLASS.

