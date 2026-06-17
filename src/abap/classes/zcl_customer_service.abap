CLASS zcl_customer_service DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS exists
      IMPORTING iv_customid TYPE zscustom-customid
      RETURNING VALUE(rv_exists) TYPE abap_bool
      RAISING zcx_flight_error.

    METHODS get_name
      IMPORTING iv_customid TYPE zscustom-customid
      RETURNING VALUE(rv_name) TYPE char80
      RAISING zcx_flight_error.
ENDCLASS.

CLASS zcl_customer_service IMPLEMENTATION.
  METHOD exists.
    DATA lv_customid TYPE zscustom-customid.
    zcl_flight_service=>check_authority( '03' ).

    SELECT SINGLE customid FROM zscustom INTO lv_customid WHERE customid = iv_customid.
    IF sy-subrc = 0.
      rv_exists = abap_true.
    ELSE.
      rv_exists = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD get_name.
    DATA: lv_first TYPE zscustom-name_first,
          lv_last  TYPE zscustom-name_last.

    zcl_flight_service=>check_authority( '03' ).
    SELECT SINGLE name_first name_last FROM zscustom INTO (lv_first, lv_last) WHERE customid = iv_customid.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>technical_error.
    ENDIF.
    CONCATENATE lv_first lv_last INTO rv_name SEPARATED BY space.
  ENDMETHOD.
ENDCLASS.

