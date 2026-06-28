# ZFLIGHT_RAP - SAP BTP RAP/OData target

This folder contains the target objects for a future SAP BTP ABAP Environment migration.

The ECC implementation remains under `src/abap/`. The objects here are RAP-oriented and are meant to be created in ADT as ABAP Cloud-compatible artifacts.

## Object Groups

| Folder | Content |
|---|---|
| `tables/` | Persistent tables for ABAP Cloud |
| `cds/interface/` | Interface CDS view entities `ZF2_I_*` |
| `cds/projection/` | Projection CDS view entities `ZF2_C_*` |
| `behavior/` | Behavior definitions and behavior pools |
| `services/` | OData V4 service definitions and binding notes |
| `metadata/` | Fiori Elements UI metadata extensions |
| `auth/` | DCL and IAM catalog notes |
| `classes/` | ABAP Cloud helper classes |
| `tests/` | ABAP Unit skeletons |

## Creation Order

1. Create package `ZFLIGHT_RAP`.
2. Create persistent tables from `tables/`.
3. Create interface CDS views from `cds/interface/`.
4. Create projection CDS views from `cds/projection/`.
5. Create behavior definitions from `behavior/` for `ZF2_I_*`.
6. Create behavior projections from `behavior/` for `ZF2_C_*`.
7. Create service definitions and service bindings from `services/`.
8. Create metadata extensions from `metadata/`.
9. Create DCL/IAM objects from `auth/`.
10. Add helper classes and ABAP Unit tests.

## Object Inventory

Persistent tables:

- `ZF2_CARRIER`
- `ZF2_CONNECTION`
- `ZF2_FLIGHT`
- `ZF2_CUSTOMER`
- `ZF2_BOOKING`
- `ZF2_ORDER`
- `ZF2_ORDER_ITEM`
- `ZF2_INVOICE`
- `ZF2_PAYMENT`
- `ZF2_STATUS_HIST`

Interface CDS:

- `ZF2_I_FLIGHT_CARRIER`
- `ZF2_I_FLIGHT_CONNECTION`
- `ZF2_I_Flight`
- `ZF2_I_Customer`
- `ZF2_I_Booking`
- `ZF2_I_Order`
- `ZF2_I_ORDER_ITEM`
- `ZF2_I_Invoice`
- `ZF2_I_Payment`
- `ZF2_I_STATUS_HISTORY`

Projection CDS:

- `ZF2_C_FLIGHT_CARRIER`
- `ZF2_C_FLIGHT_CONNECTION`
- `ZF2_C_Flight`
- `ZF2_C_Customer`
- `ZF2_C_Booking`
- `ZF2_C_Order`
- `ZF2_C_ORDER_ITEM`
- `ZF2_C_Invoice`
- `ZF2_C_Payment`

Services:

- `ZF2_UI_FLIGHT_MANAGE`
- `ZF2_UI_BOOKING_MANAGE`
- `ZF2_API_FLIGHT_BOOKING`

Behavior actions:

- `ZF2_I_Booking`, `ZF2_I_Order`, `ZF2_I_Invoice`, and `ZF2_I_Payment` are draft-enabled for Fiori Elements create/edit flows.
- `ZF2_I_FLIGHT_CARRIER`: create/update/delete
- `ZF2_I_FLIGHT_CONNECTION`: create/update/delete
- `ZF2_I_Booking`: `confirm`, `cancel`, `createOrder`
- `ZF2_I_Order`: `release`, `createInvoice`
- `ZF2_I_Invoice`: `registerPayment`, `cancel`
- `ZF2_I_Payment`: create/update/delete with validation

Fiori metadata extensions:

- `ZF2_C_FLIGHT_CARRIER_UI`
- `ZF2_C_FLIGHT_CONNECTION_UI`
- `ZF2_C_FLIGHT_UI`
- `ZF2_C_CUSTOMER_UI`
- `ZF2_C_BOOKING_UI`
- `ZF2_C_ORDER_UI`
- `ZF2_C_ORDER_ITEM_UI`
- `ZF2_C_INVOICE_UI`
- `ZF2_C_PAYMENT_UI`
