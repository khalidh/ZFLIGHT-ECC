@EndUserText.label: 'Flight Connection'
@AccessControl.authorizationCheck: #CHECK
define view entity ZF2_I_FlightConnection
  as select from zf2_connection
  association to parent ZF2_I_FlightCarrier as _Carrier
    on $projection.CarrierID = _Carrier.CarrierID
  composition [0..*] of ZF2_I_Flight as _Flights
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
      distance_unit as DistanceUnit,
      _Carrier,
      _Flights
}

