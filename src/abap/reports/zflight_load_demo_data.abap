REPORT zflight_load_demo_data.

PARAMETERS p_reset AS CHECKBOX DEFAULT space.

DATA: ls_carr TYPE zscarr,
      ls_conn TYPE zspfli,
      ls_flt  TYPE zsflight,
      ls_cust TYPE zscustom,
      lv_i TYPE i,
      lv_j TYPE i.

START-OF-SELECTION.
  AUTHORITY-CHECK OBJECT 'Z_FLIGHT' ID 'ACTVT' FIELD '01'.
  IF sy-subrc <> 0.
    MESSAGE e001(zflight_msg) WITH '01'.
  ENDIF.

  IF p_reset = 'X'.
    DELETE FROM zsbook.
    DELETE FROM zsflight.
    DELETE FROM zspfli.
    DELETE FROM zscustom.
    DELETE FROM zscarr.
  ENDIF.

  DO 20 TIMES.
    lv_i = sy-index.
    CLEAR ls_carr.
    ls_carr-carrid = lv_i.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT' EXPORTING input = ls_carr-carrid IMPORTING output = ls_carr-carrid.
    CONCATENATE 'Airline' lv_i INTO ls_carr-carrname SEPARATED BY space.
    ls_carr-currcode = 'EUR'.
    ls_carr-erdat = sy-datum.
    ls_carr-ernam = sy-uname.
    INSERT zscarr FROM ls_carr.
  ENDDO.

  DO 100 TIMES.
    lv_i = sy-index.
    CLEAR ls_conn.
    ls_conn-carrid = ( lv_i MOD 20 ) + 1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT' EXPORTING input = ls_conn-carrid IMPORTING output = ls_conn-carrid.
    ls_conn-connid = lv_i.
    ls_conn-countryfr = 'FR'.
    ls_conn-cityfrom = 'PARIS'.
    ls_conn-airpfrom = 'CDG'.
    ls_conn-countryto = 'DE'.
    ls_conn-cityto = 'BERLIN'.
    ls_conn-airpto = 'BER'.
    ls_conn-fltime = 105 + lv_i.
    ls_conn-deptime = '080000'.
    ls_conn-arrtime = '100000'.
    INSERT zspfli FROM ls_conn.
  ENDDO.

  DO 1000 TIMES.
    lv_i = sy-index.
    CLEAR ls_flt.
    ls_flt-carrid = ( lv_i MOD 20 ) + 1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT' EXPORTING input = ls_flt-carrid IMPORTING output = ls_flt-carrid.
    ls_flt-connid = ( lv_i MOD 100 ) + 1.
    ls_flt-fldate = sy-datum + ( lv_i MOD 180 ).
    ls_flt-price = 120 + ( lv_i MOD 500 ).
    ls_flt-currency = 'EUR'.
    ls_flt-planetype = 'A320'.
    ls_flt-seatsmax = 180.
    ls_flt-seatsocc = 0.
    ls_flt-status = 'OPEN'.
    ls_flt-erdat = sy-datum.
    ls_flt-ernam = sy-uname.
    INSERT zsflight FROM ls_flt.
  ENDDO.

  DO 500 TIMES.
    lv_j = sy-index.
    CLEAR ls_cust.
    ls_cust-customid = lv_j.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT' EXPORTING input = ls_cust-customid IMPORTING output = ls_cust-customid.
    CONCATENATE 'First' lv_j INTO ls_cust-name_first SEPARATED BY space.
    CONCATENATE 'Last' lv_j INTO ls_cust-name_last SEPARATED BY space.
    CONCATENATE 'customer' lv_j '@example.com' INTO ls_cust-email.
    ls_cust-country = 'FR'.
    ls_cust-langu = sy-langu.
    ls_cust-erdat = sy-datum.
    ls_cust-ernam = sy-uname.
    INSERT zscustom FROM ls_cust.
  ENDDO.

  COMMIT WORK.
  WRITE: / 'Demo data loaded. Use Z_BOOKING_CREATE or ZFLIGHT transaction to generate bookings.'.

