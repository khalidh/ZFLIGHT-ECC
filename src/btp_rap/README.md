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
4. Create behavior definitions from `behavior/`.
5. Create projection CDS views from `cds/projection/`.
6. Create behavior projections from `behavior/`.
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

- `ZF2_I_FlightCarrier`
- `ZF2_I_FlightConnection`
- `ZF2_I_Flight`
- `ZF2_I_Customer`
- `ZF2_I_Booking`
- `ZF2_I_Order`
- `ZF2_I_OrderItem`
- `ZF2_I_Invoice`
- `ZF2_I_Payment`
- `ZF2_I_StatusHistory`

Projection CDS:

- `ZF2_C_FlightCarrier`
- `ZF2_C_FlightConnection`
- `ZF2_C_Flight`
- `ZF2_C_Customer`
- `ZF2_C_Booking`
- `ZF2_C_Order`
- `ZF2_C_OrderItem`
- `ZF2_C_Invoice`
- `ZF2_C_Payment`

Services:

- `ZF2_UI_FLIGHT_MANAGE`
- `ZF2_UI_BOOKING_MANAGE`
- `ZF2_API_FLIGHT_BOOKING`
