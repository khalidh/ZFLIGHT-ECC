# Objet d'autorisation Z_FLIGHT

## SU21

Classe conseillee: `ZFLIGHT`.

Objet: `Z_FLIGHT`.

Champs:

- `ACTVT`

Activites:

- `01`: Create.
- `02`: Change.
- `03`: Display.
- `06`: Delete.

## Controle ABAP

```abap
AUTHORITY-CHECK OBJECT 'Z_FLIGHT'
  ID 'ACTVT' FIELD iv_actvt.
IF sy-subrc <> 0.
  MESSAGE e001(zflight_msg) WITH iv_actvt RAISING not_authorized.
ENDIF.
```

