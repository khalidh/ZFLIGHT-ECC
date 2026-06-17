REPORT zinvoice_alv.

TABLES zsinvoice.
DATA gt_invoice TYPE STANDARD TABLE OF zsinvoice.
DATA gs_layout TYPE slis_layout_alv.

SELECT-OPTIONS: s_inv FOR zsinvoice-invoiceid,
                s_ord FOR zsinvoice-orderid,
                s_date FOR zsinvoice-bill_date,
                s_stat FOR zsinvoice-status.

START-OF-SELECTION.
  AUTHORITY-CHECK OBJECT 'Z_FLIGHT' ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE e001(zflight_msg) WITH '03'.
  ENDIF.

  SELECT * FROM zsinvoice INTO TABLE gt_invoice
    WHERE invoiceid IN s_inv
      AND orderid IN s_ord
      AND bill_date IN s_date
      AND status IN s_stat.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = sy-repid is_layout = gs_layout
    TABLES t_outtab = gt_invoice.

