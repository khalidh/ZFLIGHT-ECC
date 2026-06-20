@EndUserText.label: 'Manage Carriers'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZF2_C_FLIGHT_CARRIER
  provider contract transactional_query
  as projection on ZF2_I_FLIGHT_CARRIER
{
  key CarrierID,
      CarrierName,
      CurrencyCode,
      Url
}
