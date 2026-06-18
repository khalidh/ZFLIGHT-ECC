@EndUserText.label: 'Manage Orders'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZF2_C_Order
  provider contract transactional_query
  as projection on ZF2_I_Order
{
  key OrderID,
      BookingID,
      CustomerID,
      OrderDate,
      OrderStatus,
      NetAmount,
      TaxAmount,
      GrossAmount,
      CurrencyCode,
      LastChangedAt,
      _Items,
      _Invoice
}

