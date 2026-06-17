CLASS zcl_order_service DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS create_from_booking
      IMPORTING iv_bookid TYPE zsbook-bookid
      RETURNING VALUE(rv_orderid) TYPE zsorder-orderid
      RAISING zcx_flight_error.
ENDCLASS.

CLASS zcl_order_service IMPLEMENTATION.
  METHOD create_from_booking.
    DATA lo_booking TYPE REF TO zcl_booking_service.
    DATA ls_booking TYPE zcl_booking_service=>ty_booking.
    DATA ls_order TYPE zsorder.
    DATA ls_item TYPE zsorder_item.

    zcl_flight_service=>check_authority( '01' ).
    CREATE OBJECT lo_booking.
    ls_booking = lo_booking->get( iv_bookid ).

    IF ls_booking-status <> 'CONFIRMED' AND ls_booking-status <> 'NEW'.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>invalid_status.
    ENDIF.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING nr_range_nr = '01' object = 'ZORDERID'
      IMPORTING number = rv_orderid
      EXCEPTIONS OTHERS = 1.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>number_range_failed.
    ENDIF.

    ls_order-orderid = rv_orderid.
    ls_order-bookid = iv_bookid.
    ls_order-customid = ls_booking-customid.
    ls_order-doc_date = sy-datum.
    ls_order-status = 'OPEN'.
    ls_order-net_amount = ls_booking-base_amount.
    ls_order-tax_amount = ls_booking-tax_amount.
    ls_order-gross_amount = ls_booking-total_amount.
    ls_order-currency = ls_booking-currency.
    ls_order-erdat = sy-datum.
    ls_order-ernam = sy-uname.
    INSERT zsorder FROM ls_order.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>technical_error.
    ENDIF.

    ls_item-orderid = rv_orderid.
    ls_item-itemno = '000010'.
    ls_item-material = 'ZFLIGHT'.
    ls_item-description = 'Flight reservation'.
    ls_item-qty = 1.
    ls_item-uom = 'EA'.
    ls_item-net_price = ls_booking-base_amount.
    ls_item-net_value = ls_booking-base_amount.
    ls_item-tax_value = ls_booking-tax_amount.
    ls_item-gross_value = ls_booking-total_amount.
    INSERT zsorder_item FROM ls_item.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>technical_error.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

