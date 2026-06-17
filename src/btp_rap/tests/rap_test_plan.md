# RAP Test Plan

## Unit Tests

- `ZCL_FLIGHT_PRICING_TEST`: pricing and tax calculation.
- Add validation tests for `ZCL_FLIGHT_VALIDATION`.
- Add status transition tests for booking, order and invoice actions.

## Behavior Tests

- Create booking through EML.
- Confirm booking.
- Cancel booking with reason.
- Create order from booking.
- Create invoice from order.
- Register payment and check invoice paid amount.

## OData Smoke Tests

- Publish `ZUI_FLIGHT_MANAGE_O4`.
- Open preview for `Flights`.
- Publish `ZUI_BOOKING_MANAGE_O4`.
- Execute `confirmBooking` and `createOrder`.
- Publish `ZAPI_FLIGHT_BOOKING_O4`.
- Test read-only external API access with communication arrangement.

