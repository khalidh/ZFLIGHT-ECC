@EndUserText.label: 'Manage Flights'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_Flight
  provider contract transactional_query
  as projection on ZI_Flight
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
      _Bookings : redirected to composition child ZC_Booking
}

