CLASS zf2_bp_i_booking DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zf2_i_booking.
ENDCLASS.

CLASS zf2_bp_i_booking IMPLEMENTATION.
ENDCLASS.

CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Booking RESULT result.

    METHODS setInitialBookingValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~setInitialBookingValues.

    METHODS validateBooking FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateBooking.

    METHODS validateBookingStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateBookingStatus.

    METHODS confirm FOR MODIFY
      IMPORTING keys FOR ACTION Booking~confirm RESULT result.

    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION Booking~cancel RESULT result.

    METHODS createOrder FOR MODIFY
      IMPORTING keys FOR ACTION Booking~createOrder RESULT result.
ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.
  METHOD get_instance_authorizations.
    READ ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        FIELDS ( BookingStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(bookings).

    result = VALUE #(
      FOR booking IN bookings
      ( %tky = booking-%tky
        %update = COND #( WHEN booking-BookingStatus = 'CANCELLED'
                          THEN if_abap_behv=>auth-unauthorized
                          ELSE if_abap_behv=>auth-allowed )
        %delete = COND #( WHEN booking-BookingStatus = 'NEW'
                          THEN if_abap_behv=>auth-allowed
                          ELSE if_abap_behv=>auth-unauthorized )
        %action-confirm = COND #( WHEN booking-BookingStatus = 'NEW'
                                  THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized )
        %action-cancel = COND #( WHEN booking-BookingStatus = 'NEW'
                                      OR booking-BookingStatus = 'CONFIRMED'
                                 THEN if_abap_behv=>auth-allowed
                                 ELSE if_abap_behv=>auth-unauthorized )
        %action-createOrder = COND #( WHEN booking-BookingStatus = 'CONFIRMED'
                                      THEN if_abap_behv=>auth-allowed
                                      ELSE if_abap_behv=>auth-unauthorized ) ) ).
  ENDMETHOD.

  METHOD setInitialBookingValues.
    READ ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        FIELDS ( BookingDate BookingStatus SeatClass CurrencyCode BaseAmount TaxAmount TotalAmount )
        WITH CORRESPONDING #( keys )
      RESULT DATA(bookings).

    MODIFY ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( BookingDate BookingStatus SeatClass CurrencyCode BaseAmount TaxAmount TotalAmount )
        WITH VALUE #(
          FOR booking IN bookings
          ( %tky = booking-%tky
            BookingDate = COND #( WHEN booking-BookingDate IS INITIAL THEN cl_abap_context_info=>get_system_date( ) ELSE booking-BookingDate )
            BookingStatus = COND #( WHEN booking-BookingStatus IS INITIAL THEN 'NEW' ELSE booking-BookingStatus )
            SeatClass = COND #( WHEN booking-SeatClass IS INITIAL THEN 'ECO' ELSE booking-SeatClass )
            CurrencyCode = COND #( WHEN booking-CurrencyCode IS INITIAL THEN 'EUR' ELSE booking-CurrencyCode )
            BaseAmount = COND #( WHEN booking-BaseAmount IS INITIAL THEN '0.00' ELSE booking-BaseAmount )
            TaxAmount = COND #( WHEN booking-TaxAmount IS INITIAL THEN '0.00' ELSE booking-TaxAmount )
            TotalAmount = COND #( WHEN booking-TotalAmount IS INITIAL THEN booking-BaseAmount + booking-TaxAmount ELSE booking-TotalAmount ) ) )
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateBooking.
    READ ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        FIELDS ( CustomerID CarrierID ConnectionID FlightDate BaseAmount TaxAmount TotalAmount CurrencyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(bookings).

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).
      IF <booking>-CustomerID IS INITIAL
          OR <booking>-CarrierID IS INITIAL
          OR <booking>-ConnectionID IS INITIAL
          OR <booking>-FlightDate IS INITIAL.
        APPEND VALUE #( %tky = <booking>-%tky ) TO failed-booking.
        APPEND VALUE #(
          %tky = <booking>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Customer, carrier, connection and flight date are mandatory for a booking.' ) )
          TO reported-booking.
      ENDIF.

      IF <booking>-TotalAmount < 0 OR <booking>-BaseAmount < 0 OR <booking>-TaxAmount < 0.
        APPEND VALUE #( %tky = <booking>-%tky ) TO failed-booking.
        APPEND VALUE #(
          %tky = <booking>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Booking amounts must not be negative.' ) )
          TO reported-booking.
      ENDIF.

      IF <booking>-CurrencyCode IS INITIAL.
        APPEND VALUE #( %tky = <booking>-%tky ) TO failed-booking.
        APPEND VALUE #(
          %tky = <booking>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Currency is mandatory for a booking.' ) )
          TO reported-booking.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateBookingStatus.
    READ ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        FIELDS ( BookingStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(bookings).

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).
      IF <booking>-BookingStatus <> 'NEW'
          AND <booking>-BookingStatus <> 'CONFIRMED'
          AND <booking>-BookingStatus <> 'CANCELLED'.
        APPEND VALUE #( %tky = <booking>-%tky ) TO failed-booking.
        APPEND VALUE #(
          %tky = <booking>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Booking status must be NEW, CONFIRMED or CANCELLED.' ) )
          TO reported-booking.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD confirm.
    READ ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        FIELDS ( BookingStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(bookings).

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>) WHERE BookingStatus <> 'NEW'.
      APPEND VALUE #( %tky = <booking>-%tky ) TO failed-booking.
      APPEND VALUE #(
        %tky = <booking>-%tky
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text = 'Only NEW bookings can be confirmed.' ) )
        TO reported-booking.
    ENDLOOP.

    MODIFY ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( BookingStatus )
        WITH VALUE #( FOR booking IN bookings WHERE ( BookingStatus = 'NEW' )
          ( %tky = booking-%tky BookingStatus = 'CONFIRMED' ) )
      FAILED DATA(update_failed)
      REPORTED DATA(update_reported).

    failed = CORRESPONDING #( DEEP update_failed ).
    reported = CORRESPONDING #( DEEP update_reported ).

    READ ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_bookings).

    result = VALUE #( FOR booking IN updated_bookings ( %tky = booking-%tky %param = booking ) ).
  ENDMETHOD.

  METHOD cancel.
    READ ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        FIELDS ( BookingStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(bookings).

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>) WHERE BookingStatus = 'CANCELLED'.
      APPEND VALUE #( %tky = <booking>-%tky ) TO failed-booking.
      APPEND VALUE #(
        %tky = <booking>-%tky
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text = 'Booking is already cancelled.' ) )
        TO reported-booking.
    ENDLOOP.

    MODIFY ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( BookingStatus CancelReason )
        WITH VALUE #( FOR key IN keys
          ( %tky = key-%tky
            BookingStatus = 'CANCELLED'
            CancelReason = key-%param-CancelReason ) )
      FAILED DATA(update_failed)
      REPORTED DATA(update_reported).

    failed = CORRESPONDING #( DEEP update_failed ).
    reported = CORRESPONDING #( DEEP update_reported ).

    READ ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_bookings).

    result = VALUE #( FOR booking IN updated_bookings ( %tky = booking-%tky %param = booking ) ).
  ENDMETHOD.

  METHOD createOrder.
    READ ENTITIES OF zf2_i_booking IN LOCAL MODE
      ENTITY Booking
        FIELDS ( BookingID CustomerID BookingStatus TotalAmount TaxAmount CurrencyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(bookings).

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).
      IF <booking>-BookingStatus <> 'CONFIRMED'.
        APPEND VALUE #( %tky = <booking>-%tky ) TO failed-booking.
        APPEND VALUE #(
          %tky = <booking>-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Only CONFIRMED bookings can create an order.' ) )
          TO reported-booking.
        CONTINUE.
      ENDIF.

      MODIFY ENTITIES OF zf2_i_order
        ENTITY SalesOrder
          CREATE FIELDS ( BookingID CustomerID OrderDate OrderStatus NetAmount TaxAmount GrossAmount CurrencyCode )
          WITH VALUE #( (
            %cid = |ORDER_{ <booking>-BookingID }|
            BookingID = <booking>-BookingID
            CustomerID = <booking>-CustomerID
            OrderDate = cl_abap_context_info=>get_system_date( )
            OrderStatus = 'NEW'
            NetAmount = <booking>-TotalAmount - <booking>-TaxAmount
            TaxAmount = <booking>-TaxAmount
            GrossAmount = <booking>-TotalAmount
            CurrencyCode = <booking>-CurrencyCode ) )
        REPORTED DATA(order_reported)
        FAILED DATA(order_failed).

      reported = CORRESPONDING #( DEEP order_reported ).
      failed = CORRESPONDING #( DEEP order_failed ).
    ENDLOOP.

    result = VALUE #( FOR booking IN bookings ( %tky = booking-%tky %param = booking ) ).
  ENDMETHOD.
ENDCLASS.
