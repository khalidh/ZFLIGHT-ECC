@EndUserText.label: 'Manage Flights'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZF2_C_Flight
  provider contract transactional_query
  as projection on ZF2_I_Flight
{
  key CarrierID,
  key ConnectionID,
  key FlightDate,
      Price,
      CurrencyCode,
      PlaneType,
      SeatsMax,
      SeatsOccupied,
      FlightStatus,
      LastChangedAt,
      _Bookings : redirected to composition child ZF2_C_Booking
}

