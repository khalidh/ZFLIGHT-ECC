@EndUserText.label: 'Manage Order Items'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZF2_C_ORDER_ITEM
  provider contract transactional_query
  as projection on ZF2_I_ORDER_ITEM
{
  key OrderID,
  key ItemNo,
      ConditionType,
      Description,
      Quantity,
      QuantityUnit,
      Amount,
      CurrencyCode,
      _Order
}
