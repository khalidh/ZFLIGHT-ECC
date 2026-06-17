# IAM Objects

Create these BTP IAM objects after publishing the OData services.

| IAM Object | Suggested Name | Content |
|---|---|---|
| IAM App | `ZFLIGHT_RAP_APP` | App descriptor for flight/booking management |
| Business Catalog | `ZFLIGHT_RAP_BC` | Contains `ZUI_FLIGHT_MANAGE_O4` and `ZUI_BOOKING_MANAGE_O4` |
| Business Role Template | `ZFLIGHT_RAP_BR` | End-user role for flight office users |
| Communication Scenario | `ZFLIGHT_RAP_API_CS` | External API access to `ZAPI_FLIGHT_BOOKING_O4` |

Recommended scopes:

- Display user: read-only access to all CDS entities.
- Booking clerk: create/change bookings and customers.
- Billing clerk: release orders, create invoices and register payments.
- Admin: full maintenance including demo data.

