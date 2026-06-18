@EndUserText.label: 'Manage Payments'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_Payment
  provider contract transactional_query
  as projection on ZI_Payment
{
  key PaymentID,
      InvoiceID,
      PaymentDate,
      Amount,
      CurrencyCode,
      PaymentMethod,
      Reference,
      _Invoice : redirected to parent ZC_Invoice
}

