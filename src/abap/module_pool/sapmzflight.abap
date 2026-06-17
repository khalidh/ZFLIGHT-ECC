PROGRAM sapmzflight.

TABLES: zsflight, zsbook, zscustom.

DATA ok_code TYPE sy-ucomm.
DATA save_ok TYPE sy-ucomm.
DATA gv_bookid TYPE zsbook-bookid.

* Screen 0100: main menu
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'MAIN'.
  SET TITLEBAR 'T0100'.
ENDMODULE.

MODULE user_command_0100 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
  CASE save_ok.
    WHEN 'FLIGHTS'.
      CALL SCREEN 0200.
    WHEN 'BOOKINGS'.
      CALL SCREEN 0400.
    WHEN 'CUSTOMERS'.
      CALL SCREEN 0500.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

* Screen 0200: flight list placeholder. In SE51 place a custom container
* or call report ZFLIGHT_ALV_FLIGHTS for the MVP.
MODULE user_command_0200 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
  CASE save_ok.
    WHEN 'ALV'.
      SUBMIT zflight_alv_flights AND RETURN.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0100.
  ENDCASE.
ENDMODULE.

MODULE user_command_0400 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
  CASE save_ok.
    WHEN 'ALV'.
      SUBMIT zflight_alv_bookings AND RETURN.
    WHEN 'CANCEL'.
      PERFORM cancel_booking.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0100.
  ENDCASE.
ENDMODULE.

MODULE user_command_0500 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
  CASE save_ok.
    WHEN 'ALV'.
      SUBMIT zflight_alv_customers AND RETURN.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0100.
  ENDCASE.
ENDMODULE.

FORM cancel_booking.
  DATA lo_service TYPE REF TO zcl_booking_service.
  CREATE OBJECT lo_service.
  TRY.
      lo_service->cancel( iv_bookid = gv_bookid iv_reason = 'Cancelled in SAP GUI' ).
      COMMIT WORK.
      MESSAGE s010(zflight_msg) WITH gv_bookid.
    CATCH zcx_flight_error.
      ROLLBACK WORK.
      MESSAGE e011(zflight_msg) WITH 'BOOKING_CANCEL' sy-subrc.
  ENDTRY.
ENDFORM.

