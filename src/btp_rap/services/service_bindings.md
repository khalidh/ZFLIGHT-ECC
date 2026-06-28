# Service Bindings

Create these bindings in ADT after activating the service definitions.

| Service Definition | Binding Type | Suggested Binding | Usage |
|---|---|---|---|
| `ZF2_UI_FLIGHT_MANAGE` | OData V4 - UI | `ZF2_UI_FLIGHT_MANAGE_O4` | Fiori Elements carrier/flight app |
| `ZF2_UI_BOOKING_MANAGE` | OData V4 - UI | `ZF2_UI_BOOKING_MANAGE_O4` | Fiori Elements booking/order/invoice app |
| `ZF2_API_FLIGHT_BOOKING` | OData V4 - Web API | `ZF2_API_FLIGHT_BOOKING_O4` | External integration API |

After publishing, assign the UI services to an IAM app and business catalog.

## ADT Creation Steps

Create the bindings directly in Eclipse ADT:

1. Right-click package `ZFLIGHT-ECC2`.
2. Choose `New` > `Other ABAP Repository Object`.
3. Search `Service Binding`.
4. Create each binding listed below.
5. Activate the binding.
6. Open the binding and click `Publish`.

## Bindings To Create

### Flight Management UI

- Name: `ZF2_UI_FLIGHT_MANAGE_O4`
- Description: `Flight Management OData V4 UI`
- Binding Type: `OData V4 - UI`
- Service Definition: `ZF2_UI_FLIGHT_MANAGE`
- Leading entity for preview: `Flights`

Expected exposed entities:

- `Carriers`
- `Connections`
- `Flights`
- `Customers`

Expected standard operations:

- `Carriers`: create/update/delete
- `Connections`: create/update/delete
- `Flights`: create/update/delete
- `Customers`: create/update/delete

### Booking Management UI

- Name: `ZF2_UI_BOOKING_MANAGE_O4`
- Description: `Booking Management OData V4 UI`
- Binding Type: `OData V4 - UI`
- Service Definition: `ZF2_UI_BOOKING_MANAGE`
- Leading entity for preview: `Bookings`

Expected exposed entities:

- `Bookings`
- `Orders`
- `OrderItems`
- `Invoices`
- `Payments`

Expected standard operations:

- `Bookings`: create/update/delete
- `Orders`: create/update/delete
- `Invoices`: create/update/delete
- `Payments`: create/update/delete

Expected actions:

- `Bookings.confirm`
- `Bookings.cancel`
- `Bookings.createOrder`
- `Orders.release`
- `Orders.createInvoice`
- `Invoices.registerPayment`
- `Invoices.cancel`

### Public Booking API

- Name: `ZF2_API_FLIGHT_BOOKING_O4`
- Description: `Flight Booking OData V4 API`
- Binding Type: `OData V4 - Web API`
- Service Definition: `ZF2_API_FLIGHT_BOOKING`

Expected exposed entities:

- `Flights`
- `Bookings`
- `Orders`
- `Invoices`
- `Payments`

## Validation Checklist

- All three service bindings are active.
- All three service bindings are published.
- Preview works for `ZF2_UI_FLIGHT_MANAGE_O4`.
- Preview works for `ZF2_UI_BOOKING_MANAGE_O4`.
- The metadata document of `ZF2_API_FLIGHT_BOOKING_O4` is reachable.
- Actions appear in the service metadata for booking, order and invoice.

## If Creation Is Blocked

- Re-activate the service definition first.
- Re-activate the projection CDS used by the service.
- Re-activate the behavior projection for the same projection CDS.
- Re-open the service binding editor after activation.
