# abapGit import folder

This folder contains serialized RAP objects generated from `src/btp_rap` so abapGit can detect ABAP repository objects.

The repository root `.abapgit.xml` sets `STARTING_FOLDER` to `/abapgit/` and `FOLDER_LOGIC` to `FULL`.

Import order is still governed by activation dependencies: DDLS tables, CDS interface/projection, behavior definitions, services, metadata, DCL and classes.

## Booking API smoke test

After importing and activating the objects in ADT, publish or refresh the service binding
`ZF2_API_FLIGHT_BOOKING_O4`.

The public API exposes:

- `GET /Customers` to pick a customer.
- `GET /Flights` to pick a flight.
- `POST /Bookings` to create a booking.

For OData V2 JSON payloads, send date fields with the SAP JSON date format:

```json
{
  "BookingID": "0000005011",
  "CustomerID": "0000001005",
  "CarrierID": "SQ",
  "ConnectionID": "0326",
  "FlightDate": "/Date(1784505600000)/",
  "BookingDate": "/Date(1782345600000)/",
  "BookingStatus": "NEW",
  "SeatClass": "ECO",
  "BaseAmount": "1250.00",
  "TaxAmount": "250.00",
  "TotalAmount": "1500.00",
  "CurrencyCode": "SGD"
}
```

Verify the created booking with:

```text
GET /Bookings?$filter=BookingID eq '5011'
```
