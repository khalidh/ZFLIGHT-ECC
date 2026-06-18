@EndUserText.label: 'Manage Carriers'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZF2_C_FlightCarrier
  provider contract transactional_query
  as projection on ZF2_I_FlightCarrier
{
  key CarrierID,
      CarrierName,
      CurrencyCode,
      Url,
      _Connections : redirected to composition child ZF2_C_FlightConnection
}

