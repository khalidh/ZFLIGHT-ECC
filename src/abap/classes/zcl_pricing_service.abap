CLASS zcl_pricing_service DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_price_result,
             base_amount  TYPE zsbook-base_amount,
             discount     TYPE zsbook-base_amount,
             fuel_amount  TYPE zsbook-base_amount,
             tax_amount   TYPE zsbook-tax_amount,
             total_amount TYPE zsbook-total_amount,
             currency     TYPE zsbook-currency,
           END OF ty_price_result.

    METHODS calculate_for_flight
      IMPORTING iv_base_amount TYPE zsbook-base_amount
                iv_currency TYPE zsbook-currency
                iv_seat_class TYPE zsbook-seat_class DEFAULT 'ECO'
      RETURNING VALUE(rs_price) TYPE ty_price_result
      RAISING   zcx_flight_error.
ENDCLASS.

CLASS zcl_pricing_service IMPLEMENTATION.
  METHOD calculate_for_flight.
    DATA lv_multiplier TYPE p DECIMALS 2.
    DATA lv_tax_rate TYPE p DECIMALS 2 VALUE '0.20'.

    IF iv_base_amount <= 0.
      RAISE EXCEPTION TYPE zcx_flight_error EXPORTING textid = zcx_flight_error=>invalid_amount.
    ENDIF.

    CASE iv_seat_class.
      WHEN 'BUS'. lv_multiplier = '1.80'.
      WHEN 'FST'. lv_multiplier = '3.00'.
      WHEN OTHERS. lv_multiplier = '1.00'.
    ENDCASE.

    rs_price-base_amount = iv_base_amount * lv_multiplier.
    rs_price-fuel_amount = rs_price-base_amount * '0.05'.
    rs_price-discount    = 0.
    rs_price-tax_amount  = ( rs_price-base_amount + rs_price-fuel_amount - rs_price-discount ) * lv_tax_rate.
    rs_price-total_amount = rs_price-base_amount + rs_price-fuel_amount - rs_price-discount + rs_price-tax_amount.
    rs_price-currency = iv_currency.
  ENDMETHOD.
ENDCLASS.

