@EndUserText.label: 'Manage Payments'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZF2_C_Payment
  provider contract transactional_query
  as projection on ZF2_I_Payment
{
  key PaymentID,
      InvoiceID,
      PaymentDate,
      Amount,
      CurrencyCode,
      PaymentMethod,
      Reference
}
