REPORT zpayment_alv.

TABLES zspayment.
DATA gt_payment TYPE STANDARD TABLE OF zspayment.
DATA gs_layout TYPE slis_layout_alv.

SELECT-OPTIONS: s_pay FOR zspayment-paymentid,
                s_inv FOR zspayment-invoiceid,
                s_date FOR zspayment-pay_date,
                s_stat FOR zspayment-status.

START-OF-SELECTION.
  AUTHORITY-CHECK OBJECT 'Z_FLIGHT' ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE e001(zflight_msg) WITH '03'.
  ENDIF.

  SELECT * FROM zspayment INTO TABLE gt_payment
    WHERE paymentid IN s_pay
      AND invoiceid IN s_inv
      AND pay_date IN s_date
      AND status IN s_stat.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = sy-repid is_layout = gs_layout
    TABLES t_outtab = gt_payment.

