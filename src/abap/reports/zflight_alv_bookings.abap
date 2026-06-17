REPORT zflight_alv_bookings.

TABLES: zsbook, zscustom.

TYPES: BEGIN OF ty_out,
         bookid       TYPE zsbook-bookid,
         customid     TYPE zsbook-customid,
         name_first   TYPE zscustom-name_first,
         name_last    TYPE zscustom-name_last,
         carrid       TYPE zsbook-carrid,
         connid       TYPE zsbook-connid,
         fldate       TYPE zsbook-fldate,
         bookdate     TYPE zsbook-bookdate,
         status       TYPE zsbook-status,
         total_amount TYPE zsbook-total_amount,
         currency     TYPE zsbook-currency,
       END OF ty_out.

DATA gt_out TYPE STANDARD TABLE OF ty_out.
DATA gs_layout TYPE slis_layout_alv.

SELECT-OPTIONS: s_book FOR zsbook-bookid,
                s_cust FOR zsbook-customid,
                s_date FOR zsbook-bookdate,
                s_stat FOR zsbook-status.

START-OF-SELECTION.
  AUTHORITY-CHECK OBJECT 'Z_FLIGHT' ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE e001(zflight_msg) WITH '03'.
  ENDIF.

  SELECT b~bookid b~customid c~name_first c~name_last
         b~carrid b~connid b~fldate b~bookdate b~status
         b~total_amount b~currency
    FROM zsbook AS b
    INNER JOIN zscustom AS c
      ON c~customid = b~customid
    INTO CORRESPONDING FIELDS OF TABLE gt_out
    WHERE b~bookid IN s_book
      AND b~customid IN s_cust
      AND b~bookdate IN s_date
      AND b~status IN s_stat.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = sy-repid is_layout = gs_layout
    TABLES t_outtab = gt_out.

