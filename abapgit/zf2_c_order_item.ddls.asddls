@EndUserText.label: 'Manage Order Items'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZF2_C_ORDER_ITEM
  as select from ZF2_I_ORDER_ITEM
{
  key OrderID,
  key ItemNo,
      ConditionType,
      Description,
      Quantity,
      QuantityUnit,
      Amount,
      CurrencyCode
}
