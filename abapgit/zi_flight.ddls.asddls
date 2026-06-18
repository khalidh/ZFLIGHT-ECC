@EndUserText.label: 'Flight'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZI_Flight
  as select from zfl_flight
  association to ZI_FlightConnection as _Connection
    on  $projection.CarrierID    = _Connection.CarrierID
    and $projection.ConnectionID = _Connection.ConnectionID
  composition [0..*] of ZI_Booking as _Bookings
{
  key carrier_id as CarrierID,
  key connection_id as ConnectionID,
  key flight_date as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price as Price,
      currency_code as CurrencyCode,
      plane_type as PlaneType,
      seats_max as SeatsMax,
      seats_occupied as SeatsOccupied,
      flight_status as FlightStatus,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at as LastChangedAt,
      _Connection,
      _Bookings
}

