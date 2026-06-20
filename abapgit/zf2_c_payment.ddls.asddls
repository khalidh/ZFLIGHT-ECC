@EndUserText.label: 'Manage Payments'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZF2_C_Payment
  as select from ZF2_I_Payment
{
  key PaymentID,
      InvoiceID,
      PaymentDate,
      Amount,
      CurrencyCode,
      PaymentMethod,
      Reference
}
