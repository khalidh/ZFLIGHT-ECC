REPORT zorder_alv.

TABLES zsorder.
DATA gt_order TYPE STANDARD TABLE OF zsorder.
DATA gs_layout TYPE slis_layout_alv.

SELECT-OPTIONS: s_order FOR zsorder-orderid,
                s_cust  FOR zsorder-customid,
                s_date  FOR zsorder-doc_date,
                s_stat  FOR zsorder-status.

START-OF-SELECTION.
  AUTHORITY-CHECK OBJECT 'Z_FLIGHT' ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE e001(zflight_msg) WITH '03'.
  ENDIF.

  SELECT * FROM zsorder INTO TABLE gt_order
    WHERE orderid IN s_order
      AND customid IN s_cust
      AND doc_date IN s_date
      AND status IN s_stat.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = sy-repid is_layout = gs_layout
    TABLES t_outtab = gt_order.

