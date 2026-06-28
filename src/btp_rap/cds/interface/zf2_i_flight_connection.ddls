@EndUserText.label: 'Flight Connection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZF2_I_FLIGHT_CONNECTION
  as select from zf2_connection
{
  key carrier_id as CarrierID,
  key connection_id as ConnectionID,
      country_from as CountryFrom,
      city_from as CityFrom,
      airport_from as AirportFrom,
      country_to as CountryTo,
      city_to as CityTo,
      airport_to as AirportTo,
      flight_time as FlightTime,
      departure_time as DepartureTime,
      arrival_time as ArrivalTime,
      distance as Distance,
      distance_unit as DistanceUnit
}
