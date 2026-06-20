@EndUserText.label: 'Flight Booking'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZF2_I_Booking
  as select from zf2_booking
{
  key booking_id as BookingID,
      customer_id as CustomerID,
      carrier_id as CarrierID,
      connection_id as ConnectionID,
      flight_date as FlightDate,
      booking_date as BookingDate,
      booking_status as BookingStatus,
      seat_class as SeatClass,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      base_amount as BaseAmount,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      tax_amount as TaxAmount,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_amount as TotalAmount,
      currency_code as CurrencyCode,
      cancel_reason as CancelReason,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at as LastChangedAt
}
