@EndUserText.label: 'Manage Orders'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_Order
  provider contract transactional_query
  as projection on ZI_Order
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

