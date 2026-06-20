@EndUserText.label: 'Flight'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZF2_I_Flight
  as select from zf2_flight
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
      last_changed_at as LastChangedAt
}
