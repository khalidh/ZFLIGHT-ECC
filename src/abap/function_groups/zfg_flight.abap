FUNCTION-POOL zfg_flight.

* Function group facade for ZFLIGHT_ECC.
* Create the function modules below in SE37 and paste the relevant forms.

FUNCTION z_booking_create.
*"----------------------------------------------------------------------
*"  IMPORTING VALUE(iv_customid) TYPE zscustom-customid
*"            VALUE(iv_carrid)   TYPE zscarr-carrid
*"            VALUE(iv_connid)   TYPE zspfli-connid
*"            VALUE(iv_fldate)   TYPE zsflight-fldate
*"            VALUE(iv_seat_class) TYPE zsbook-seat_class DEFAULT 'ECO'
*"  EXPORTING VALUE(ev_bookid)   TYPE zsbook-bookid
*"  EXCEPTIONS failed
*"----------------------------------------------------------------------
  DATA lo_service TYPE REF TO zcl_booking_service.
  CREATE OBJECT lo_service.
  TRY.
      ev_bookid = lo_service->create(
        iv_customid = iv_customid
        iv_carrid = iv_carrid
        iv_connid = iv_connid
        iv_fldate = iv_fldate
        iv_seat_class = iv_seat_class ).
      COMMIT WORK.
    CATCH zcx_flight_error.
      ROLLBACK WORK.
      RAISE failed.
  ENDTRY.
ENDFUNCTION.

FUNCTION z_booking_cancel.
*"----------------------------------------------------------------------
*"  IMPORTING VALUE(iv_bookid) TYPE zsbook-bookid
*"            VALUE(iv_reason) TYPE zsbook-cancel_reason OPTIONAL
*"  EXCEPTIONS failed
*"----------------------------------------------------------------------
  DATA lo_service TYPE REF TO zcl_booking_service.
  CREATE OBJECT lo_service.
  TRY.
      lo_service->cancel( iv_bookid = iv_bookid iv_reason = iv_reason ).
      COMMIT WORK.
    CATCH zcx_flight_error.
      ROLLBACK WORK.
      RAISE failed.
  ENDTRY.
ENDFUNCTION.

FUNCTION z_booking_get.
*"----------------------------------------------------------------------
*"  IMPORTING VALUE(iv_bookid) TYPE zsbook-bookid
*"  EXPORTING VALUE(es_booking) TYPE zsbook
*"  EXCEPTIONS not_found
*"----------------------------------------------------------------------
  DATA lo_service TYPE REF TO zcl_booking_service.
  DATA ls_booking TYPE zcl_booking_service=>ty_booking.
  CREATE OBJECT lo_service.
  TRY.
      ls_booking = lo_service->get( iv_bookid ).
      MOVE-CORRESPONDING ls_booking TO es_booking.
    CATCH zcx_flight_error.
      RAISE not_found.
  ENDTRY.
ENDFUNCTION.

FUNCTION z_flight_get.
*"----------------------------------------------------------------------
*"  IMPORTING VALUE(iv_carrid) TYPE zscarr-carrid
*"            VALUE(iv_connid) TYPE zspfli-connid
*"            VALUE(iv_fldate) TYPE zsflight-fldate
*"  EXPORTING VALUE(es_flight) TYPE zsflight
*"  EXCEPTIONS not_found
*"----------------------------------------------------------------------
  DATA lo_service TYPE REF TO zcl_flight_service.
  DATA ls_flight TYPE zcl_flight_service=>ty_flight.
  CREATE OBJECT lo_service.
  TRY.
      ls_flight = lo_service->get( iv_carrid = iv_carrid iv_connid = iv_connid iv_fldate = iv_fldate ).
      MOVE-CORRESPONDING ls_flight TO es_flight.
    CATCH zcx_flight_error.
      RAISE not_found.
  ENDTRY.
ENDFUNCTION.

