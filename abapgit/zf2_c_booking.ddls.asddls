@EndUserText.label: 'Manage Bookings'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZF2_C_Booking
  provider contract transactional_query
  as projection on ZF2_I_Booking
{
  key BookingID,
      CustomerID,
      CarrierID,
      ConnectionID,
      FlightDate,
      BookingDate,
      BookingStatus,
      SeatClass,
      BaseAmount,
      TaxAmount,
      TotalAmount,
      CurrencyCode,
      CancelReason,
      LastChangedAt
}
