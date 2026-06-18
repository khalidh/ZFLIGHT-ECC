@EndUserText.label: 'Manage Bookings'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_Booking
  provider contract transactional_query
  as projection on ZI_Booking
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
      LastChangedAt,
      _Customer,
      _Flight,
      _Order : redirected to composition child ZC_Order
}

