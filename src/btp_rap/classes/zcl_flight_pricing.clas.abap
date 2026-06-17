CLASS zcl_flight_pricing DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_result,
             base_amount  TYPE decfloat34,
             tax_amount   TYPE decfloat34,
             total_amount TYPE decfloat34,
           END OF ty_result.

    METHODS calculate_booking_price
      IMPORTING
        iv_price      TYPE decfloat34
        iv_vip        TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(rs_result) TYPE ty_result.
ENDCLASS.

CLASS zcl_flight_pricing IMPLEMENTATION.
  METHOD calculate_booking_price.
    rs_result-base_amount = iv_price.
    IF iv_vip = abap_true.
      rs_result-base_amount = rs_result-base_amount * '0.90'.
    ENDIF.
    rs_result-tax_amount = rs_result-base_amount * '0.20'.
    rs_result-total_amount = rs_result-base_amount + rs_result-tax_amount.
  ENDMETHOD.
ENDCLASS.

