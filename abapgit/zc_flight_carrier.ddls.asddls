@EndUserText.label: 'Manage Carriers'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_FlightCarrier
  provider contract transactional_query
  as projection on ZI_FlightCarrier
{
  key CarrierID,
      CarrierName,
      CurrencyCode,
      Url,
      _Connections : redirected to composition child ZC_FlightConnection
}

