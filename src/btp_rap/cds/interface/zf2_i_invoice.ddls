@EndUserText.label: 'Flight Invoice'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZF2_I_Invoice
  as select from zf2_invoice
  association to ZF2_I_Order as _Order
    on $projection.OrderID = _Order.OrderID
  composition [0..*] of ZF2_I_Payment as _Payments
{
  key invoice_id as InvoiceID,
      order_id as OrderID,
      invoice_date as InvoiceDate,
      invoice_status as InvoiceStatus,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_amount as TotalAmount,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      paid_amount as PaidAmount,
      currency_code as CurrencyCode,
      last_changed_at as LastChangedAt,
      _Order,
      _Payments
}

