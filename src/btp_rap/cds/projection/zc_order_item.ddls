@EndUserText.label: 'Manage Order Items'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_OrderItem
  provider contract transactional_query
  as projection on ZI_OrderItem
{
  key OrderID,
  key ItemNo,
      ConditionType,
      Description,
      Quantity,
      Amount,
      CurrencyCode,
      _Order : redirected to parent ZC_Order
}

