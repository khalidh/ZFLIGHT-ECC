CLASS zcl_status_history DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS add_entry
      IMPORTING
        iv_object_type TYPE string
        iv_object_id   TYPE string
        iv_old_status  TYPE string
        iv_new_status  TYPE string
        iv_reason      TYPE string OPTIONAL.
ENDCLASS.

CLASS zcl_status_history IMPLEMENTATION.
  METHOD add_entry.
    "In RAP, call this from behavior save sequence or action handlers.
    DATA(lv_dummy) = |{ iv_object_type }:{ iv_object_id } { iv_old_status }->{ iv_new_status } { iv_reason }|.
  ENDMETHOD.
ENDCLASS.

