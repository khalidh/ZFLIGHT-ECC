@EndUserText.label: 'Manage Connections'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZF2_C_FLIGHT_CONNECTION
  provider contract transactional_query
  as projection on ZF2_I_FLIGHT_CONNECTION
{
  key CarrierID,
  key ConnectionID,
      CountryFrom,
      CityFrom,
      AirportFrom,
      CountryTo,
      CityTo,
      AirportTo,
      FlightTime,
      DepartureTime,
      ArrivalTime,
      Distance,
      DistanceUnit
}
