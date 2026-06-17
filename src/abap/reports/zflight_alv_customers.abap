REPORT zflight_alv_customers.

TABLES zscustom.
DATA gt_custom TYPE STANDARD TABLE OF zscustom.
DATA gs_layout TYPE slis_layout_alv.

SELECT-OPTIONS: s_cust FOR zscustom-customid,
                s_name FOR zscustom-name_last,
                s_ctry FOR zscustom-country.

START-OF-SELECTION.
  AUTHORITY-CHECK OBJECT 'Z_FLIGHT' ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE e001(zflight_msg) WITH '03'.
  ENDIF.

  SELECT customid name_first name_last email phone country langu vip_flag erdat ernam
    FROM zscustom
    INTO CORRESPONDING FIELDS OF TABLE gt_custom
    WHERE customid IN s_cust
      AND name_last IN s_name
      AND country IN s_ctry.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = sy-repid is_layout = gs_layout
    TABLES t_outtab = gt_custom.

