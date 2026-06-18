@EndUserText.label: 'Flight Carrier'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZF2_I_FlightCarrier
  as select from zf2_carrier
  composition [0..*] of ZF2_I_FlightConnection as _Connections
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

