@EndUserText.label: 'Manage Payments'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZF2_C_Payment
  provider contract transactional_query
  as projection on ZF2_I_Payment
{
  key PaymentID,
      InvoiceID,
      PaymentDate,
      Amount,
      CurrencyCode,
      PaymentMethod,
      Reference,
      _Invoice : redirected to parent ZF2_C_Invoice
}

