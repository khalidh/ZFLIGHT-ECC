CLASS zcl_flight_validation DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS ensure_capacity
      IMPORTING
        iv_seats_max      TYPE i
        iv_seats_occupied TYPE i
      RAISING
        cx_abap_invalid_value.
ENDCLASS.

CLASS zcl_flight_validation IMPLEMENTATION.
  METHOD ensure_capacity.
    IF iv_seats_occupied >= iv_seats_max.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

