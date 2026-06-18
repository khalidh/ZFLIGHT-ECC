CLASS zf2_cl_booking_numbering DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS next_booking_id
      RETURNING VALUE(rv_booking_id) TYPE n LENGTH 10.
ENDCLASS.

CLASS zf2_cl_booking_numbering IMPLEMENTATION.
  METHOD next_booking_id.
    "Placeholder for managed RAP numbering or a released number range API.
    rv_booking_id = '0000000001'.
  ENDMETHOD.
ENDCLASS.

