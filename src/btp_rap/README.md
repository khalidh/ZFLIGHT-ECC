# ZFLIGHT_RAP - SAP BTP RAP/OData target

This folder contains the target objects for a future SAP BTP ABAP Environment migration.

The ECC implementation remains under `src/abap/`. The objects here are RAP-oriented and are meant to be created in ADT as ABAP Cloud-compatible artifacts.

## Object Groups

| Folder | Content |
|---|---|
| `tables/` | Persistent tables for ABAP Cloud |
| `cds/interface/` | Interface CDS view entities `ZI_*` |
| `cds/projection/` | Projection CDS view entities `ZC_*` |
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

- `ZFL_CARRIER`
- `ZFL_CONNECTION`
- `ZFL_FLIGHT`
- `ZFL_CUSTOMER`
- `ZFL_BOOKING`
- `ZFL_ORDER`
- `ZFL_ORDER_ITEM`
- `ZFL_INVOICE`
- `ZFL_PAYMENT`
- `ZFL_STATUS_HIST`

Interface CDS:

- `ZI_FlightCarrier`
- `ZI_FlightConnection`
- `ZI_Flight`
- `ZI_Customer`
- `ZI_Booking`
- `ZI_Order`
- `ZI_OrderItem`
- `ZI_Invoice`
- `ZI_Payment`
- `ZI_StatusHistory`

Projection CDS:

- `ZC_FlightCarrier`
- `ZC_FlightConnection`
- `ZC_Flight`
- `ZC_Customer`
- `ZC_Booking`
- `ZC_Order`
- `ZC_OrderItem`
- `ZC_Invoice`
- `ZC_Payment`

Services:

- `ZUI_FLIGHT_MANAGE`
- `ZUI_BOOKING_MANAGE`
- `ZAPI_FLIGHT_BOOKING`

