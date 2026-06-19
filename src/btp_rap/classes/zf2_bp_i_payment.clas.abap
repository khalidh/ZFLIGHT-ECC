CLASS zf2_bp_i_payment DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zf2_i_payment.
ENDCLASS.

CLASS zf2_bp_i_payment IMPLEMENTATION.
ENDCLASS.

CLASS lhc_payment DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Payment RESULT result.

    METHODS setInitialPaymentValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Payment~setInitialPaymentValues.

    METHODS validatePayment FOR VALIDATE ON SAVE
      IMPORTING keys FOR Payment~validatePayment.
ENDCLASS.

CLASS lhc_payment IMPLEMENTATION.
  METHOD get_instance_authorizations.
    READ ENTITIES OF zf2_i_payment IN LOCAL MODE
      ENTITY Payment
        FIELDS ( PaymentID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(payments).

    result = VALUE #(
      FOR payment IN payments
      ( %tky = payment-%tky
        %update = if_abap_behv=>auth-allowed
        %delete = if_abap_behv=>auth-allowed ) ).
  ENDMETHOD.

  METHOD setInitialPaymentValues.
    READ ENTITIES OF zf2_i_payment IN LOCAL MODE
      ENTITY Payment
        FIELDS ( PaymentDate CurrencyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(payments).

    MODIFY ENTITIES OF zf2_i_payment IN LOCAL MODE
      ENTITY Payment
        UPDATE FIELDS ( PaymentDate CurrencyCode )
        WITH VALUE #( FOR payment IN payments
          ( %tky = payment-%tky
            PaymentDate = COND #( WHEN payment-PaymentDate IS INITIAL THEN cl_abap_context_info=>get_system_date( ) ELSE payment-PaymentDate )
            CurrencyCode = COND #( WHEN payment-CurrencyCode IS INITIAL THEN 'EUR' ELSE payment-CurrencyCode ) ) )
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validatePayment.
    READ ENTITIES OF zf2_i_payment IN LOCAL MODE
      ENTITY Payment
        FIELDS ( InvoiceID PaymentDate Amount CurrencyCode PaymentMethod )
        WITH CORRESPONDING #( keys )
      RESULT DATA(payments).

    LOOP AT payments ASSIGNING FIELD-SYMBOL(<payment>).
      IF <payment>-InvoiceID IS INITIAL.
        APPEND VALUE #( %tky = <payment>-%tky ) TO failed-payment.
        APPEND VALUE #(
          %tky = <payment>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Invoice is mandatory for a payment.' ) )
          TO reported-payment.
      ENDIF.

      IF <payment>-PaymentDate IS INITIAL.
        APPEND VALUE #( %tky = <payment>-%tky ) TO failed-payment.
        APPEND VALUE #(
          %tky = <payment>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Payment date is mandatory.' ) )
          TO reported-payment.
      ENDIF.

      IF <payment>-Amount <= 0.
        APPEND VALUE #( %tky = <payment>-%tky ) TO failed-payment.
        APPEND VALUE #(
          %tky = <payment>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Payment amount must be positive.' ) )
          TO reported-payment.
      ENDIF.

      IF <payment>-CurrencyCode IS INITIAL OR <payment>-PaymentMethod IS INITIAL.
        APPEND VALUE #( %tky = <payment>-%tky ) TO failed-payment.
        APPEND VALUE #(
          %tky = <payment>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Currency and payment method are mandatory.' ) )
          TO reported-payment.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
