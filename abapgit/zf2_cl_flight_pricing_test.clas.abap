CLASS zf2_cl_flight_pricing_test DEFINITION
  FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS calculates_tax FOR TESTING.
ENDCLASS.

CLASS zf2_cl_flight_pricing_test IMPLEMENTATION.
  METHOD calculates_tax.
    DATA(lo_cut) = NEW zf2_cl_flight_pricing( ).
    DATA(ls_result) = lo_cut->calculate_booking_price( iv_price = 100 ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-total_amount
      exp = CONV decfloat34( '120' ) ).
  ENDMETHOD.
ENDCLASS.

