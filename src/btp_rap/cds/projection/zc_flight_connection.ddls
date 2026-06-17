@EndUserText.label: 'Manage Connections'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_FlightConnection
  provider contract transactional_query
  as projection on ZI_FlightConnection
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
      _Carrier : redirected to parent ZC_FlightCarrier,
      _Flights : redirected to composition child ZC_Flight
}

