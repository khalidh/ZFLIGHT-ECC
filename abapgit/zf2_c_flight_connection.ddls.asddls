@EndUserText.label: 'Manage Connections'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZF2_C_FlightConnection
  provider contract transactional_query
  as projection on ZF2_I_FlightConnection
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
      DistanceUnit,
      _Carrier : redirected to parent ZF2_C_FlightCarrier,
      _Flights : redirected to composition child ZF2_C_Flight
}

