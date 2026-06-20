@EndUserText.label: 'Flight Payment'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZF2_I_Payment
  as select from zf2_payment
{
  key payment_id as PaymentID,
      invoice_id as InvoiceID,
      payment_date as PaymentDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      amount as Amount,
      currency_code as CurrencyCode,
      payment_method as PaymentMethod,
      reference as Reference
}
