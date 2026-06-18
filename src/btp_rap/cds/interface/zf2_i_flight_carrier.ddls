@EndUserText.label: 'Flight Carrier'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZF2_I_FLIGHT_CARRIER
  as select from zf2_carrier
  association [0..*] to ZF2_I_FLIGHT_CONNECTION as _Connections
    on $projection.CarrierID = _Connections.CarrierID
{
  key carrier_id as CarrierID,
      carrier_name as CarrierName,
      currency_code as CurrencyCode,
      url as Url,
      created_by as CreatedBy,
      created_at as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,
      _Connections
}
