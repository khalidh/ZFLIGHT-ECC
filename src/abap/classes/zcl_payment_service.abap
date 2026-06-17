CLASS zcl_payment_service DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS register_payment
      IMPORTING iv_invoiceid TYPE zsinvoice-invoiceid
                iv_amount TYPE zspayment-amount
                iv_method TYPE zspayment-pay_method
      RETURNING VALUE(rv_paymentid) TYPE zspayment-paymentid
      RAISING zcx_flight_error.
ENDCLASS.

CLASS zcl_payment_service IMPLEMENTATION.
  METHOD register_payment.
    DATA ls_invoice TYPE zsinvoice.
    DATA ls_payment TYPE zspayment.

    zcl_flight_service=>check_authority( '02' ).

    SELECT SINGLE * FROM zsinvoice INTO ls_invoice WHERE invoiceid = iv_invoiceid.
    IF sy-subrc <> 0 OR ls_invoice-status <> 'OPEN'.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>invalid_status.
    ENDIF.
    IF iv_amount < ls_invoice-gross_amount.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>invalid_amount.
    ENDIF.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING nr_range_nr = '01' object = 'ZPAY_ID'
      IMPORTING number = rv_paymentid
      EXCEPTIONS OTHERS = 1.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>number_range_failed.
    ENDIF.

    ls_payment-paymentid = rv_paymentid.
    ls_payment-invoiceid = iv_invoiceid.
    ls_payment-pay_date = sy-datum.
    ls_payment-pay_method = iv_method.
    ls_payment-amount = iv_amount.
    ls_payment-currency = ls_invoice-currency.
    ls_payment-status = 'POSTED'.
    INSERT zspayment FROM ls_payment.

    UPDATE zsinvoice SET status = 'PAID' WHERE invoiceid = iv_invoiceid.
    UPDATE zsorder SET status = 'CLOSED' WHERE orderid = ls_invoice-orderid.
  ENDMETHOD.
ENDCLASS.

