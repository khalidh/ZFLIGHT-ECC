# RAP Test Plan

## Unit Tests

- `ZF2_CL_FLIGHT_PRICING_TEST`: pricing and tax calculation.
- Add validation tests for `ZF2_CL_FLIGHT_VALIDATION`.
- Add status transition tests for booking, order and invoice actions.

## Behavior Tests

- Create booking through EML.
- Confirm booking.
- Cancel booking with reason.
- Create order from booking.
- Create invoice from order.
- Register payment and check invoice paid amount.

## OData Smoke Tests

- Publish `ZF2_UI_FLIGHT_MANAGE_O4`.
- Open preview for `Flights`.
- Publish `ZF2_UI_BOOKING_MANAGE_O4`.
- Execute `confirmBooking` and `createOrder`.
- Publish `ZF2_API_FLIGHT_BOOKING_O4`.
- Test read-only external API access with communication arrangement.

