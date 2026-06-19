CLASS zf2_bp_i_invoice DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zf2_i_invoice.
ENDCLASS.

CLASS zf2_bp_i_invoice IMPLEMENTATION.
ENDCLASS.

CLASS lhc_invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Invoice RESULT result.

    METHODS setInitialInvoiceValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Invoice~setInitialInvoiceValues.

    METHODS validateInvoice FOR VALIDATE ON SAVE
      IMPORTING keys FOR Invoice~validateInvoice.

    METHODS validateInvoiceStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Invoice~validateInvoiceStatus.

    METHODS registerPayment FOR MODIFY
      IMPORTING keys FOR ACTION Invoice~registerPayment RESULT result.

    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION Invoice~cancel RESULT result.
ENDCLASS.

CLASS lhc_invoice IMPLEMENTATION.
  METHOD get_instance_authorizations.
    READ ENTITIES OF zf2_i_invoice IN LOCAL MODE
      ENTITY Invoice
        FIELDS ( InvoiceStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(invoices).

    result = VALUE #(
      FOR invoice IN invoices
      ( %tky = invoice-%tky
        %update = COND #( WHEN invoice-InvoiceStatus = 'PAID'
                               OR invoice-InvoiceStatus = 'CANCELLED'
                          THEN if_abap_behv=>auth-unauthorized
                          ELSE if_abap_behv=>auth-allowed )
        %delete = COND #( WHEN invoice-InvoiceStatus = 'OPEN'
                          THEN if_abap_behv=>auth-allowed
                          ELSE if_abap_behv=>auth-unauthorized )
        %action-registerPayment = COND #( WHEN invoice-InvoiceStatus = 'OPEN'
                                               OR invoice-InvoiceStatus = 'PARTIAL'
                                          THEN if_abap_behv=>auth-allowed
                                          ELSE if_abap_behv=>auth-unauthorized )
        %action-cancel = COND #( WHEN invoice-InvoiceStatus = 'OPEN'
                                 THEN if_abap_behv=>auth-allowed
                                 ELSE if_abap_behv=>auth-unauthorized ) ) ).
  ENDMETHOD.

  METHOD setInitialInvoiceValues.
    READ ENTITIES OF zf2_i_invoice IN LOCAL MODE
      ENTITY Invoice
        FIELDS ( InvoiceDate InvoiceStatus PaidAmount CurrencyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(invoices).

    MODIFY ENTITIES OF zf2_i_invoice IN LOCAL MODE
      ENTITY Invoice
        UPDATE FIELDS ( InvoiceDate InvoiceStatus PaidAmount CurrencyCode )
        WITH VALUE #( FOR invoice IN invoices
          ( %tky = invoice-%tky
            InvoiceDate = COND #( WHEN invoice-InvoiceDate IS INITIAL THEN cl_abap_context_info=>get_system_date( ) ELSE invoice-InvoiceDate )
            InvoiceStatus = COND #( WHEN invoice-InvoiceStatus IS INITIAL THEN 'OPEN' ELSE invoice-InvoiceStatus )
            PaidAmount = COND #( WHEN invoice-PaidAmount IS INITIAL THEN '0.00' ELSE invoice-PaidAmount )
            CurrencyCode = COND #( WHEN invoice-CurrencyCode IS INITIAL THEN 'EUR' ELSE invoice-CurrencyCode ) ) )
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateInvoice.
    READ ENTITIES OF zf2_i_invoice IN LOCAL MODE
      ENTITY Invoice
        FIELDS ( OrderID TotalAmount PaidAmount CurrencyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(invoices).

    LOOP AT invoices ASSIGNING FIELD-SYMBOL(<invoice>).
      IF <invoice>-OrderID IS INITIAL.
        APPEND VALUE #( %tky = <invoice>-%tky ) TO failed-invoice.
        APPEND VALUE #(
          %tky = <invoice>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Order is mandatory for an invoice.' ) )
          TO reported-invoice.
      ENDIF.

      IF <invoice>-TotalAmount < 0 OR <invoice>-PaidAmount < 0.
        APPEND VALUE #( %tky = <invoice>-%tky ) TO failed-invoice.
        APPEND VALUE #(
          %tky = <invoice>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Invoice amounts must not be negative.' ) )
          TO reported-invoice.
      ENDIF.

      IF <invoice>-PaidAmount > <invoice>-TotalAmount.
        APPEND VALUE #( %tky = <invoice>-%tky ) TO failed-invoice.
        APPEND VALUE #(
          %tky = <invoice>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Paid amount cannot exceed total invoice amount.' ) )
          TO reported-invoice.
      ENDIF.

      IF <invoice>-CurrencyCode IS INITIAL.
        APPEND VALUE #( %tky = <invoice>-%tky ) TO failed-invoice.
        APPEND VALUE #(
          %tky = <invoice>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Currency is mandatory for an invoice.' ) )
          TO reported-invoice.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateInvoiceStatus.
    READ ENTITIES OF zf2_i_invoice IN LOCAL MODE
      ENTITY Invoice
        FIELDS ( InvoiceStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(invoices).

    LOOP AT invoices ASSIGNING FIELD-SYMBOL(<invoice>).
      IF <invoice>-InvoiceStatus <> 'OPEN'
          AND <invoice>-InvoiceStatus <> 'PARTIAL'
          AND <invoice>-InvoiceStatus <> 'PAID'
          AND <invoice>-InvoiceStatus <> 'CANCELLED'.
        APPEND VALUE #( %tky = <invoice>-%tky ) TO failed-invoice.
        APPEND VALUE #(
          %tky = <invoice>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Invoice status must be OPEN, PARTIAL, PAID or CANCELLED.' ) )
          TO reported-invoice.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD registerPayment.
    READ ENTITIES OF zf2_i_invoice IN LOCAL MODE
      ENTITY Invoice
        FIELDS ( InvoiceID InvoiceStatus TotalAmount PaidAmount CurrencyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(invoices).

    LOOP AT invoices ASSIGNING FIELD-SYMBOL(<invoice>).
      READ TABLE keys WITH KEY %tky = <invoice>-%tky INTO DATA(invoice_key).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      DATA(payment_amount) = invoice_key-%param-Amount.
      DATA(new_paid_amount) = <invoice>-PaidAmount + payment_amount.
      DATA(new_status) = COND #( WHEN new_paid_amount >= <invoice>-TotalAmount THEN 'PAID' ELSE 'PARTIAL' ).

      IF <invoice>-InvoiceStatus = 'PAID' OR <invoice>-InvoiceStatus = 'CANCELLED'.
        APPEND VALUE #( %tky = <invoice>-%tky ) TO failed-invoice.
        APPEND VALUE #(
          %tky = <invoice>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Payments can only be registered on open or partially paid invoices.' ) )
          TO reported-invoice.
        CONTINUE.
      ENDIF.

      IF payment_amount <= 0 OR new_paid_amount > <invoice>-TotalAmount.
        APPEND VALUE #( %tky = <invoice>-%tky ) TO failed-invoice.
        APPEND VALUE #(
          %tky = <invoice>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Payment amount must be positive and must not exceed the remaining invoice amount.' ) )
          TO reported-invoice.
        CONTINUE.
      ENDIF.

      MODIFY ENTITIES OF zf2_i_payment
        ENTITY Payment
          CREATE FIELDS ( InvoiceID PaymentDate Amount CurrencyCode PaymentMethod Reference )
          WITH VALUE #( (
            %cid = |PAY_{ <invoice>-InvoiceID }|
            InvoiceID = <invoice>-InvoiceID
            PaymentDate = COND #( WHEN invoice_key-%param-PaymentDate IS INITIAL
                                  THEN cl_abap_context_info=>get_system_date( )
                                  ELSE invoice_key-%param-PaymentDate )
            Amount = payment_amount
            CurrencyCode = COND #( WHEN invoice_key-%param-CurrencyCode IS INITIAL
                                   THEN <invoice>-CurrencyCode
                                   ELSE invoice_key-%param-CurrencyCode )
            PaymentMethod = invoice_key-%param-PaymentMethod
            Reference = invoice_key-%param-Reference ) )
        REPORTED DATA(payment_reported)
        FAILED DATA(payment_failed).

      reported = CORRESPONDING #( DEEP payment_reported ).
      failed = CORRESPONDING #( DEEP payment_failed ).

      MODIFY ENTITIES OF zf2_i_invoice IN LOCAL MODE
        ENTITY Invoice
          UPDATE FIELDS ( PaidAmount InvoiceStatus )
          WITH VALUE #( (
            %tky = <invoice>-%tky
            PaidAmount = new_paid_amount
            InvoiceStatus = new_status ) )
        REPORTED DATA(invoice_reported)
        FAILED DATA(invoice_failed).

      reported = CORRESPONDING #( DEEP invoice_reported ).
      failed = CORRESPONDING #( DEEP invoice_failed ).
    ENDLOOP.

    READ ENTITIES OF zf2_i_invoice IN LOCAL MODE
      ENTITY Invoice
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_invoices).

    result = VALUE #( FOR invoice IN updated_invoices ( %tky = invoice-%tky %param = invoice ) ).
  ENDMETHOD.

  METHOD cancel.
    READ ENTITIES OF zf2_i_invoice IN LOCAL MODE
      ENTITY Invoice
        FIELDS ( InvoiceStatus PaidAmount )
        WITH CORRESPONDING #( keys )
      RESULT DATA(invoices).

    LOOP AT invoices ASSIGNING FIELD-SYMBOL(<invoice>).
      IF <invoice>-PaidAmount > 0.
        APPEND VALUE #( %tky = <invoice>-%tky ) TO failed-invoice.
        APPEND VALUE #(
          %tky = <invoice>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Invoices with payments cannot be cancelled.' ) )
          TO reported-invoice.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zf2_i_invoice IN LOCAL MODE
      ENTITY Invoice
        UPDATE FIELDS ( InvoiceStatus )
        WITH VALUE #( FOR invoice IN invoices WHERE ( PaidAmount = 0 )
          ( %tky = invoice-%tky InvoiceStatus = 'CANCELLED' ) )
      FAILED DATA(update_failed)
      REPORTED DATA(update_reported).

    failed = CORRESPONDING #( DEEP update_failed ).
    reported = CORRESPONDING #( DEEP update_reported ).

    READ ENTITIES OF zf2_i_invoice IN LOCAL MODE
      ENTITY Invoice
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_invoices).

    result = VALUE #( FOR invoice IN updated_invoices ( %tky = invoice-%tky %param = invoice ) ).
  ENDMETHOD.
ENDCLASS.
