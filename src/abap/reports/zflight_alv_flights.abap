REPORT zflight_alv_flights.

TABLES: zsflight, zspfli.

TYPES: BEGIN OF ty_out,
         carrid    TYPE zsflight-carrid,
         connid    TYPE zsflight-connid,
         fldate    TYPE zsflight-fldate,
         cityfrom  TYPE zspfli-cityfrom,
         cityto    TYPE zspfli-cityto,
         price     TYPE zsflight-price,
         currency  TYPE zsflight-currency,
         seatsmax  TYPE zsflight-seatsmax,
         seatsocc  TYPE zsflight-seatsocc,
         free_seats TYPE i,
         status    TYPE zsflight-status,
       END OF ty_out.

DATA gt_out TYPE STANDARD TABLE OF ty_out.
DATA gs_layout TYPE slis_layout_alv.
DATA gt_fieldcat TYPE slis_t_fieldcat_alv.

SELECT-OPTIONS: s_carr FOR zsflight-carrid,
                s_conn FOR zsflight-connid,
                s_date FOR zsflight-fldate.
PARAMETERS p_open AS CHECKBOX DEFAULT 'X'.

START-OF-SELECTION.
  PERFORM authority_display.
  PERFORM select_data.
  PERFORM display_alv.

FORM authority_display.
  AUTHORITY-CHECK OBJECT 'Z_FLIGHT' ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE e001(zflight_msg) WITH '03'.
  ENDIF.
ENDFORM.

FORM select_data.
  SELECT f~carrid f~connid f~fldate p~cityfrom p~cityto
         f~price f~currency f~seatsmax f~seatsocc f~status
    FROM zsflight AS f
    INNER JOIN zspfli AS p
      ON p~carrid = f~carrid
     AND p~connid = f~connid
    INTO CORRESPONDING FIELDS OF TABLE gt_out
    WHERE f~carrid IN s_carr
      AND f~connid IN s_conn
      AND f~fldate IN s_date.

  IF p_open = 'X'.
    DELETE gt_out WHERE status <> 'OPEN'.
  ENDIF.

  FIELD-SYMBOLS <ls_out> TYPE ty_out.
  LOOP AT gt_out ASSIGNING <ls_out>.
    <ls_out>-free_seats = <ls_out>-seatsmax - <ls_out>-seatsocc.
  ENDLOOP.
ENDFORM.

FORM display_alv.
  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      i_structure_name   = 'TY_OUT'
    TABLES
      t_outtab           = gt_out
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE e011(zflight_msg) WITH 'ALV' sy-subrc.
  ENDIF.
ENDFORM.

