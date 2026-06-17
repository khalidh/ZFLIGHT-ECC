# Livrable par etape

## Etape 1 - Architecture generale

Voir [01_architecture_generale.md](01_architecture_generale.md).

## Etape 2 - Modele de donnees detaille

Voir [02_modele_donnees.md](02_modele_donnees.md).

## Etape 3 - Tables et domaines

Voir [ZFLIGHT_DDIC_SPEC.md](../src/abap/ddic/ZFLIGHT_DDIC_SPEC.md).

## Etape 4 - Services metier

Sources:

- `zcl_flight_service.abap`
- `zcl_booking_service.abap`
- `zcl_customer_service.abap`
- `zcl_pricing_service.abap`
- `zcl_order_service.abap`
- `zcl_invoice_service.abap`
- `zcl_payment_service.abap`
- `zcx_flight_error.abap`
- `zfg_flight.abap`

## Etape 5 - Reports ALV

Sources:

- `ZFLIGHT_ALV_FLIGHTS`
- `ZFLIGHT_ALV_BOOKINGS`
- `ZFLIGHT_ALV_CUSTOMERS`
- `ZORDER_ALV`
- `ZINVOICE_ALV`
- `ZPAYMENT_ALV`
- `ZFLIGHT_LOAD_DEMO_DATA`

## Etape 6 - Module Pool

Voir `src/abap/module_pool/sapmzflight.abap` et [07_transactions_dynpro.md](07_transactions_dynpro.md).

## Etape 7 - Donnees de test

Voir `src/abap/reports/zflight_load_demo_data.abap`.

## Etape 8 - Securite

Voir [Z_FLIGHT_AUTH.md](../src/abap/security/Z_FLIGHT_AUTH.md).

## Etape 9 - Documentation

Voir tous les fichiers `docs/`.

## Etape 10 - Preparation migration BTP

Voir [06_migration_btp_rap.md](06_migration_btp_rap.md) et les objets generes dans [src/btp_rap](../src/btp_rap).
