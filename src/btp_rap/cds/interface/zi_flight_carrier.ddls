@EndUserText.label: 'Flight Carrier'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZI_FlightCarrier
  as select from zfl_carrier
  composition [0..*] of ZI_FlightConnection as _Connections
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

