@EndUserText.label: 'Manage Invoices'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_Invoice
  provider contract transactional_query
  as projection on ZI_Invoice
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
      _Payments : redirected to composition child ZC_Payment
}

