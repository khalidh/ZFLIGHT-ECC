CLASS zf2_bp_i_order DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zf2_i_order.
ENDCLASS.

CLASS zf2_bp_i_order IMPLEMENTATION.
ENDCLASS.

CLASS lhc_salesorder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR SalesOrder RESULT result.

    METHODS setInitialOrderValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR SalesOrder~setInitialOrderValues.

    METHODS validateOrder FOR VALIDATE ON SAVE
      IMPORTING keys FOR SalesOrder~validateOrder.

    METHODS validateOrderStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR SalesOrder~validateOrderStatus.

    METHODS release FOR MODIFY
      IMPORTING keys FOR ACTION SalesOrder~release RESULT result.

    METHODS createInvoice FOR MODIFY
      IMPORTING keys FOR ACTION SalesOrder~createInvoice RESULT result.
ENDCLASS.

CLASS lhc_salesorder IMPLEMENTATION.
  METHOD get_instance_authorizations.
    READ ENTITIES OF zf2_i_order IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( OrderStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    result = VALUE #(
      FOR order IN orders
      ( %tky = order-%tky
        %update = COND #( WHEN order-OrderStatus = 'INVOICED'
                          THEN if_abap_behv=>auth-unauthorized
                          ELSE if_abap_behv=>auth-allowed )
        %delete = COND #( WHEN order-OrderStatus = 'NEW'
                          THEN if_abap_behv=>auth-allowed
                          ELSE if_abap_behv=>auth-unauthorized )
        %action-release = COND #( WHEN order-OrderStatus = 'NEW'
                                  THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized )
        %action-createInvoice = COND #( WHEN order-OrderStatus = 'RELEASED'
                                        THEN if_abap_behv=>auth-allowed
                                        ELSE if_abap_behv=>auth-unauthorized ) ) ).
  ENDMETHOD.

  METHOD setInitialOrderValues.
    READ ENTITIES OF zf2_i_order IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( OrderDate OrderStatus CurrencyCode NetAmount TaxAmount GrossAmount )
        WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    MODIFY ENTITIES OF zf2_i_order IN LOCAL MODE
      ENTITY SalesOrder
        UPDATE FIELDS ( OrderDate OrderStatus CurrencyCode NetAmount TaxAmount GrossAmount )
        WITH VALUE #( FOR order IN orders
          ( %tky = order-%tky
            OrderDate = COND #( WHEN order-OrderDate IS INITIAL THEN cl_abap_context_info=>get_system_date( ) ELSE order-OrderDate )
            OrderStatus = COND #( WHEN order-OrderStatus IS INITIAL THEN 'NEW' ELSE order-OrderStatus )
            CurrencyCode = COND #( WHEN order-CurrencyCode IS INITIAL THEN 'EUR' ELSE order-CurrencyCode )
            NetAmount = COND #( WHEN order-NetAmount IS INITIAL THEN '0.00' ELSE order-NetAmount )
            TaxAmount = COND #( WHEN order-TaxAmount IS INITIAL THEN '0.00' ELSE order-TaxAmount )
            GrossAmount = COND #( WHEN order-GrossAmount IS INITIAL THEN order-NetAmount + order-TaxAmount ELSE order-GrossAmount ) ) )
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateOrder.
    READ ENTITIES OF zf2_i_order IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( BookingID CustomerID NetAmount TaxAmount GrossAmount CurrencyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>).
      IF <order>-BookingID IS INITIAL OR <order>-CustomerID IS INITIAL.
        APPEND VALUE #( %tky = <order>-%tky ) TO failed-salesorder.
        APPEND VALUE #(
          %tky = <order>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Booking and customer are mandatory for an order.' ) )
          TO reported-salesorder.
      ENDIF.

      IF <order>-GrossAmount < 0 OR <order>-NetAmount < 0 OR <order>-TaxAmount < 0.
        APPEND VALUE #( %tky = <order>-%tky ) TO failed-salesorder.
        APPEND VALUE #(
          %tky = <order>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Order amounts must not be negative.' ) )
          TO reported-salesorder.
      ENDIF.

      IF <order>-CurrencyCode IS INITIAL.
        APPEND VALUE #( %tky = <order>-%tky ) TO failed-salesorder.
        APPEND VALUE #(
          %tky = <order>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Currency is mandatory for an order.' ) )
          TO reported-salesorder.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateOrderStatus.
    READ ENTITIES OF zf2_i_order IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( OrderStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>).
      IF <order>-OrderStatus <> 'NEW'
          AND <order>-OrderStatus <> 'RELEASED'
          AND <order>-OrderStatus <> 'INVOICED'
          AND <order>-OrderStatus <> 'CANCELLED'.
        APPEND VALUE #( %tky = <order>-%tky ) TO failed-salesorder.
        APPEND VALUE #(
          %tky = <order>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Order status must be NEW, RELEASED, INVOICED or CANCELLED.' ) )
          TO reported-salesorder.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD release.
    READ ENTITIES OF zf2_i_order IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( OrderStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>) WHERE OrderStatus <> 'NEW'.
      APPEND VALUE #( %tky = <order>-%tky ) TO failed-salesorder.
      APPEND VALUE #(
        %tky = <order>-%tky
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text = 'Only NEW orders can be released.' ) )
        TO reported-salesorder.
    ENDLOOP.

    MODIFY ENTITIES OF zf2_i_order IN LOCAL MODE
      ENTITY SalesOrder
        UPDATE FIELDS ( OrderStatus )
        WITH VALUE #( FOR order IN orders WHERE ( OrderStatus = 'NEW' )
          ( %tky = order-%tky OrderStatus = 'RELEASED' ) )
      FAILED DATA(update_failed)
      REPORTED DATA(update_reported).

    failed = CORRESPONDING #( DEEP update_failed ).
    reported = CORRESPONDING #( DEEP update_reported ).

    READ ENTITIES OF zf2_i_order IN LOCAL MODE
      ENTITY SalesOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_orders).

    result = VALUE #( FOR order IN updated_orders ( %tky = order-%tky %param = order ) ).
  ENDMETHOD.

  METHOD createInvoice.
    READ ENTITIES OF zf2_i_order IN LOCAL MODE
      ENTITY SalesOrder
        FIELDS ( OrderID OrderStatus GrossAmount CurrencyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>).
      IF <order>-OrderStatus <> 'RELEASED'.
        APPEND VALUE #( %tky = <order>-%tky ) TO failed-salesorder.
        APPEND VALUE #(
          %tky = <order>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Only RELEASED orders can create an invoice.' ) )
          TO reported-salesorder.
        CONTINUE.
      ENDIF.

      MODIFY ENTITIES OF zf2_i_invoice
        ENTITY Invoice
          CREATE FIELDS ( OrderID InvoiceDate InvoiceStatus TotalAmount PaidAmount CurrencyCode )
          WITH VALUE #( (
            %cid = |INV_{ <order>-OrderID }|
            OrderID = <order>-OrderID
            InvoiceDate = cl_abap_context_info=>get_system_date( )
            InvoiceStatus = 'OPEN'
            TotalAmount = <order>-GrossAmount
            PaidAmount = '0.00'
            CurrencyCode = <order>-CurrencyCode ) )
        REPORTED DATA(invoice_reported)
        FAILED DATA(invoice_failed).

      reported = CORRESPONDING #( DEEP invoice_reported ).
      failed = CORRESPONDING #( DEEP invoice_failed ).

      MODIFY ENTITIES OF zf2_i_order IN LOCAL MODE
        ENTITY SalesOrder
          UPDATE FIELDS ( OrderStatus )
          WITH VALUE #( ( %tky = <order>-%tky OrderStatus = 'INVOICED' ) )
        REPORTED DATA(order_reported)
        FAILED DATA(order_failed).

      reported = CORRESPONDING #( DEEP order_reported ).
      failed = CORRESPONDING #( DEEP order_failed ).
    ENDLOOP.

    result = VALUE #( FOR order IN orders ( %tky = order-%tky %param = order ) ).
  ENDMETHOD.
ENDCLASS.
