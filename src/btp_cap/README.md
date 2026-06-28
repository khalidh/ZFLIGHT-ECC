# ZFLIGHT_CAP - SAP CAP/OData target

This folder contains a SAP CAP target generated from the ZFLIGHT ECC sources, in parallel to `src/btp_rap`.

The ECC implementation remains under `src/abap/`. The RAP target remains under `src/btp_rap/`. This CAP target translates the same domain model and core business operations into a Node.js CAP service.

## Object Groups

| Folder | Content |
|---|---|
| `db/` | CAP persistence model translated from the ABAP DDIC/RAP tables |
| `db/data/` | Local demo data for SQLite deployment |
| `srv/` | OData V4 service definition |
| `srv/handlers/` | JavaScript handlers for migrated ABAP service logic |
| `test/` | Unit tests and functional test plan |

## Source Mapping

| ECC/RAP source | CAP target |
|---|---|
| `ZSCARR` / `ZF2_CARRIER` | `zflight.Carriers` |
| `ZSPFLI` / `ZF2_CONNECTION` | `zflight.Connections` |
| `ZSFLIGHT` / `ZF2_FLIGHT` | `zflight.Flights` |
| `ZSCUSTOM` / `ZF2_CUSTOMER` | `zflight.Customers` |
| `ZSBOOK` / `ZF2_BOOKING` | `zflight.Bookings` |
| `ZSORDER` / `ZF2_ORDER` | `zflight.Orders` |
| `ZSORDER_ITEM` / `ZF2_ORDER_ITEM` | `zflight.OrderItems` |
| `ZSINVOICE` / `ZF2_INVOICE` | `zflight.Invoices` |
| `ZSPAYMENT` / `ZF2_PAYMENT` | `zflight.Payments` |
| `ZSSTATUS_HIST` / `ZF2_STATUS_HIST` | `zflight.StatusHistory` |

## Migrated Business Operations

The following ECC service methods were converted to CAP actions:

| ABAP source | CAP action |
|---|---|
| `zcl_booking_service=>create` | `FlightService.createBooking` |
| `zcl_booking_service=>cancel` | `FlightService.cancelBooking` |
| `zcl_order_service=>create_from_booking` | `FlightService.createOrderFromBooking` |
| `zcl_invoice_service=>create_from_order` | `FlightService.createInvoiceFromOrder` |
| `zcl_payment_service=>register_payment` | `FlightService.registerPayment` |

Pricing follows `zcl_pricing_service`: seat class multiplier, 5 percent fuel surcharge and 20 percent tax.

## Local Run

```bash
cd src/btp_cap
npm install
npm run deploy:sqlite
npm run load:test-data
npm start
```

The service is exposed as OData V4 under:

```text
/odata/v4/flight/
```

Useful smoke URLs:

```text
/odata/v4/flight/Flights
/odata/v4/flight/Bookings
/odata/v4/flight/Customers
```

## Creation Order

1. Create the CAP project package from `package.json`.
2. Deploy `db/schema.cds` to SQLite or SAP HANA Cloud.
3. Load demo data from `db/data/`.
4. Optionally reset and load the fuller test dataset with `npm run load:test-data`.
5. Start `srv/flight-service.cds`.
6. Validate action handlers from `srv/handlers/flight-handlers.js`.
7. Add authentication/authorization according to the target BTP landscape.

## Notes

This is a migration scaffold, not a one-to-one ABAP runtime clone. CAP replaces ABAP locks, number ranges and authorization checks with service transactions, generated business IDs and future BTP security configuration.
