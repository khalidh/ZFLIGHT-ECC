@EndUserText.label: 'Manage Invoices'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZF2_C_Invoice
  provider contract transactional_query
  as projection on ZF2_I_Invoice
{
  key InvoiceID,
      OrderID,
      InvoiceDate,
      InvoiceStatus,
      TotalAmount,
      PaidAmount,
      CurrencyCode,
      LastChangedAt,
      _Order,
      _Payments
}
