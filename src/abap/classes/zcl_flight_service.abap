CLASS zcl_flight_service DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_flight,
             carrid    TYPE zscarr-carrid,
             connid    TYPE zspfli-connid,
             fldate    TYPE zsflight-fldate,
             price     TYPE zsflight-price,
             currency  TYPE zsflight-currency,
             planetype TYPE zsflight-planetype,
             seatsmax  TYPE zsflight-seatsmax,
             seatsocc  TYPE zsflight-seatsocc,
             status    TYPE zsflight-status,
           END OF ty_flight.
    TYPES tt_flight TYPE STANDARD TABLE OF ty_flight WITH DEFAULT KEY.

    CLASS-METHODS check_authority
      IMPORTING iv_actvt TYPE activ_auth
      RAISING   zcx_flight_error.

    METHODS get
      IMPORTING iv_carrid TYPE zscarr-carrid
                iv_connid TYPE zspfli-connid
                iv_fldate TYPE zsflight-fldate
      RETURNING VALUE(rs_flight) TYPE ty_flight
      RAISING   zcx_flight_error.

    METHODS search
      IMPORTING iv_carrid TYPE zscarr-carrid OPTIONAL
                iv_cityfrom TYPE zspfli-cityfrom OPTIONAL
                iv_cityto TYPE zspfli-cityto OPTIONAL
                iv_date_from TYPE d OPTIONAL
                iv_date_to TYPE d OPTIONAL
      RETURNING VALUE(rt_flights) TYPE tt_flight
      RAISING   zcx_flight_error.

    METHODS assert_capacity
      IMPORTING iv_carrid TYPE zscarr-carrid
                iv_connid TYPE zspfli-connid
                iv_fldate TYPE zsflight-fldate
      RAISING   zcx_flight_error.

    METHODS increase_occupied
      IMPORTING iv_carrid TYPE zscarr-carrid
                iv_connid TYPE zspfli-connid
                iv_fldate TYPE zsflight-fldate
      RAISING   zcx_flight_error.

    METHODS decrease_occupied
      IMPORTING iv_carrid TYPE zscarr-carrid
                iv_connid TYPE zspfli-connid
                iv_fldate TYPE zsflight-fldate
      RAISING   zcx_flight_error.
ENDCLASS.

CLASS zcl_flight_service IMPLEMENTATION.
  METHOD check_authority.
    AUTHORITY-CHECK OBJECT 'Z_FLIGHT'
      ID 'ACTVT' FIELD iv_actvt.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error
        EXPORTING textid = zcx_flight_error=>not_authorized.
    ENDIF.
  ENDMETHOD.

  METHOD get.
    check_authority( '03' ).

    SELECT SINGLE carrid connid fldate price currency planetype seatsmax seatsocc status
      FROM zsflight
      INTO rs_flight
      WHERE carrid = iv_carrid
        AND connid = iv_connid
        AND fldate = iv_fldate.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error
        EXPORTING textid = zcx_flight_error=>flight_not_found.
    ENDIF.
  ENDMETHOD.

  METHOD search.
    check_authority( '03' ).

    SELECT f~carrid f~connid f~fldate f~price f~currency
           f~planetype f~seatsmax f~seatsocc f~status
      FROM zsflight AS f
      INNER JOIN zspfli AS p
        ON p~carrid = f~carrid
       AND p~connid = f~connid
      INTO TABLE rt_flights
      WHERE f~carrid = iv_carrid
        AND p~cityfrom LIKE iv_cityfrom
        AND p~cityto LIKE iv_cityto
        AND f~fldate BETWEEN iv_date_from AND iv_date_to.

    SORT rt_flights BY fldate carrid connid.
  ENDMETHOD.

  METHOD assert_capacity.
    DATA ls_flight TYPE ty_flight.

    ls_flight = get( iv_carrid = iv_carrid iv_connid = iv_connid iv_fldate = iv_fldate ).
    IF ls_flight-status <> 'OPEN' OR ls_flight-seatsocc >= ls_flight-seatsmax.
      RAISE EXCEPTION TYPE zcx_flight_error
        EXPORTING textid = zcx_flight_error=>capacity_exceeded.
    ENDIF.
  ENDMETHOD.

  METHOD increase_occupied.
    check_authority( '02' ).
    assert_capacity( iv_carrid = iv_carrid iv_connid = iv_connid iv_fldate = iv_fldate ).

    UPDATE zsflight
      SET seatsocc = seatsocc + 1
          aedat = sy-datum
          aenam = sy-uname
      WHERE carrid = iv_carrid
        AND connid = iv_connid
        AND fldate = iv_fldate.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error
        EXPORTING textid = zcx_flight_error=>flight_not_found.
    ENDIF.
  ENDMETHOD.

  METHOD decrease_occupied.
    check_authority( '02' ).

    UPDATE zsflight
      SET seatsocc = seatsocc - 1
          aedat = sy-datum
          aenam = sy-uname
      WHERE carrid = iv_carrid
        AND connid = iv_connid
        AND fldate = iv_fldate
        AND seatsocc > 0.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error
        EXPORTING textid = zcx_flight_error=>flight_not_found.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

