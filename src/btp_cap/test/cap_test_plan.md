# ZFLIGHT CAP Test Plan

## Local smoke test

1. Run `npm install`.
2. Run `npm run deploy:sqlite`.
3. Run `npm run load:test-data`.
4. Run `npm start`.
5. Open `/odata/v4/flight/Flights` and verify test flights are returned.

## Business flow

1. Call `createBooking` for customer `C000000001`, carrier `LH`, connection `0400`, flight date `2026-07-15`, seat class `ECO`.
2. Verify the returned booking has status `NEW` and calculated amounts.
3. Verify the flight `seatsOccupied` increased by 1.
4. Call `createOrderFromBooking` for the returned booking.
5. Verify one order and one item were created.
6. Call `createInvoiceFromOrder`.
7. Verify the order status changed to `INVOICED`.
8. Call `registerPayment` with an amount greater than or equal to the invoice total.
9. Verify invoice status `PAID`, order status `CLOSED`, and status history entries.

## Negative checks

1. Try creating a booking on a closed or full flight and expect HTTP 409.
2. Try cancelling an already cancelled booking and expect HTTP 409.
3. Try registering a payment below invoice total and expect HTTP 400.
