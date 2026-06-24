@EndUserText.label: 'Manage Connections'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZF2_C_FLIGHT_CONNECTION
  as select from ZF2_I_FLIGHT_CONNECTION
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
