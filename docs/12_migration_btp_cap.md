# Migration BTP CAP

## Objectif

Cette cible transpose les sources ABAP ECC ZFLIGHT vers une application SAP CAP Node.js exposant des services OData V4.

Elle complete la cible RAP existante sans la remplacer:

- `src/abap/`: implementation ECC classique.
- `src/btp_rap/`: cible SAP BTP ABAP Environment / RAP.
- `src/btp_cap/`: cible SAP CAP Node.js / OData V4.

## Structure

| Dossier | Role |
|---|---|
| `src/btp_cap/db/schema.cds` | Modele persistant CAP derive du DDIC |
| `src/btp_cap/db/data/` | Donnees de demo chargees en SQLite |
| `src/btp_cap/srv/flight-service.cds` | Service OData V4 |
| `src/btp_cap/srv/handlers/` | Logique metier migree depuis les classes ABAP |
| `src/btp_cap/test/` | Tests unitaires et plan de test fonctionnel |

## Mapping Metier

| ABAP ECC | CAP |
|---|---|
| `zcl_booking_service->create` | `createBooking` |
| `zcl_booking_service->cancel` | `cancelBooking` |
| `zcl_order_service->create_from_booking` | `createOrderFromBooking` |
| `zcl_invoice_service->create_from_order` | `createInvoiceFromOrder` |
| `zcl_payment_service->register_payment` | `registerPayment` |
| `zcl_pricing_service->calculate_for_flight` | `calculatePrice` |

## Execution Locale

```bash
cd src/btp_cap
npm install
npm run deploy:sqlite
npm run load:test-data
npm start
```

Service local:

```text
/odata/v4/flight/
```

## Points A Finaliser Pour Une Vraie Livraison BTP

1. Ajouter la configuration XSUAA/IAS et les restrictions CAP.
2. Remplacer les IDs generes localement par une strategie cible robuste.
3. Ajouter les annotations Fiori Elements si une UI CAP est souhaitee.
4. Brancher HANA Cloud au lieu de SQLite.
5. Ajouter des tests d'integration OData pour les actions metier.
