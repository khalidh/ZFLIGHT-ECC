@EndUserText.label: 'Flight Booking'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZI_Booking
  as select from zfl_booking
  association to ZI_Customer as _Customer
    on $projection.CustomerID = _Customer.CustomerID
  association to ZI_Flight as _Flight
    on  $projection.CarrierID    = _Flight.CarrierID
    and $projection.ConnectionID = _Flight.ConnectionID
    and $projection.FlightDate   = _Flight.FlightDate
  composition [0..1] of ZI_Order as _Order
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
      last_changed_at as LastChangedAt,
      _Customer,
      _Flight,
      _Order
}

