@EndUserText.label: 'Manage Order Items'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZF2_C_OrderItem
  provider contract transactional_query
  as projection on ZF2_I_OrderItem
{
  key OrderID,
  key ItemNo,
      ConditionType,
      Description,
      Quantity,
      QuantityUnit,
      Amount,
      CurrencyCode,
      _Order : redirected to parent ZF2_C_Order
}
