CLASS zcl_booking_service DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_booking,
             bookid       TYPE zsbook-bookid,
             customid     TYPE zsbook-customid,
             carrid       TYPE zsbook-carrid,
             connid       TYPE zsbook-connid,
             fldate       TYPE zsbook-fldate,
             bookdate     TYPE zsbook-bookdate,
             status       TYPE zsbook-status,
             seat_class   TYPE zsbook-seat_class,
             base_amount  TYPE zsbook-base_amount,
             tax_amount   TYPE zsbook-tax_amount,
             total_amount TYPE zsbook-total_amount,
             currency     TYPE zsbook-currency,
           END OF ty_booking.

    METHODS create
      IMPORTING iv_customid TYPE zsbook-customid
                iv_carrid TYPE zsbook-carrid
                iv_connid TYPE zsbook-connid
                iv_fldate TYPE zsbook-fldate
                iv_seat_class TYPE zsbook-seat_class DEFAULT 'ECO'
      RETURNING VALUE(rv_bookid) TYPE zsbook-bookid
      RAISING   zcx_flight_error.

    METHODS cancel
      IMPORTING iv_bookid TYPE zsbook-bookid
                iv_reason TYPE zsbook-cancel_reason OPTIONAL
      RAISING   zcx_flight_error.

    METHODS get
      IMPORTING iv_bookid TYPE zsbook-bookid
      RETURNING VALUE(rs_booking) TYPE ty_booking
      RAISING   zcx_flight_error.
ENDCLASS.

CLASS zcl_booking_service IMPLEMENTATION.
  METHOD create.
    DATA lo_flight TYPE REF TO zcl_flight_service.
    DATA lo_price  TYPE REF TO zcl_pricing_service.
    DATA ls_flight TYPE zcl_flight_service=>ty_flight.
    DATA ls_price  TYPE zcl_pricing_service=>ty_price_result.
    DATA ls_book   TYPE zsbook.

    zcl_flight_service=>check_authority( '01' ).

    CALL FUNCTION 'ENQUEUE_EZSFLIGHT'
      EXPORTING carrid = iv_carrid connid = iv_connid fldate = iv_fldate
      EXCEPTIONS foreign_lock = 1 system_failure = 2 OTHERS = 3.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>lock_failed.
    ENDIF.

    CREATE OBJECT lo_flight.
    CREATE OBJECT lo_price.

    TRY.
        lo_flight->assert_capacity( iv_carrid = iv_carrid iv_connid = iv_connid iv_fldate = iv_fldate ).
        ls_flight = lo_flight->get( iv_carrid = iv_carrid iv_connid = iv_connid iv_fldate = iv_fldate ).
        ls_price = lo_price->calculate_for_flight(
          iv_base_amount = ls_flight-price
          iv_currency    = ls_flight-currency
          iv_seat_class  = iv_seat_class ).

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING nr_range_nr = '01' object = 'ZBOOKID'
          IMPORTING number = rv_bookid
          EXCEPTIONS OTHERS = 1.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>number_range_failed.
        ENDIF.

        ls_book-bookid       = rv_bookid.
        ls_book-customid     = iv_customid.
        ls_book-carrid       = iv_carrid.
        ls_book-connid       = iv_connid.
        ls_book-fldate       = iv_fldate.
        ls_book-bookdate     = sy-datum.
        ls_book-status       = 'NEW'.
        ls_book-seat_class   = iv_seat_class.
        ls_book-base_amount  = ls_price-base_amount.
        ls_book-tax_amount   = ls_price-tax_amount.
        ls_book-total_amount = ls_price-total_amount.
        ls_book-currency     = ls_price-currency.
        ls_book-erdat        = sy-datum.
        ls_book-ernam        = sy-uname.

        INSERT zsbook FROM ls_book.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>technical_error.
        ENDIF.

        lo_flight->increase_occupied( iv_carrid = iv_carrid iv_connid = iv_connid iv_fldate = iv_fldate ).
      CLEANUP.
        CALL FUNCTION 'DEQUEUE_EZSFLIGHT'
          EXPORTING carrid = iv_carrid connid = iv_connid fldate = iv_fldate.
    ENDTRY.
  ENDMETHOD.

  METHOD cancel.
    DATA ls_book TYPE ty_booking.
    DATA lo_flight TYPE REF TO zcl_flight_service.

    zcl_flight_service=>check_authority( '02' ).

    CALL FUNCTION 'ENQUEUE_EZSBOOK'
      EXPORTING bookid = iv_bookid
      EXCEPTIONS foreign_lock = 1 system_failure = 2 OTHERS = 3.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>lock_failed.
    ENDIF.

    TRY.
        ls_book = get( iv_bookid ).
        IF ls_book-status = 'CANCELLED' OR ls_book-status = 'FLOWN'.
          RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>invalid_status.
        ENDIF.

        UPDATE zsbook
          SET status = 'CANCELLED'
              cancel_reason = iv_reason
              aedat = sy-datum
              aenam = sy-uname
          WHERE bookid = iv_bookid.

        CREATE OBJECT lo_flight.
        lo_flight->decrease_occupied(
          iv_carrid = ls_book-carrid
          iv_connid = ls_book-connid
          iv_fldate = ls_book-fldate ).
      CLEANUP.
        CALL FUNCTION 'DEQUEUE_EZSBOOK' EXPORTING bookid = iv_bookid.
    ENDTRY.
  ENDMETHOD.

  METHOD get.
    zcl_flight_service=>check_authority( '03' ).

    SELECT SINGLE bookid customid carrid connid fldate bookdate status seat_class
                  base_amount tax_amount total_amount currency
      FROM zsbook
      INTO rs_booking
      WHERE bookid = iv_bookid.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>booking_not_found.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

