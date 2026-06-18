@EndUserText.label: 'Flight Order'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZF2_I_Order
  as select from zf2_order
{
  key order_id as OrderID,
      booking_id as BookingID,
      customer_id as CustomerID,
      order_date as OrderDate,
      order_status as OrderStatus,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      net_amount as NetAmount,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      tax_amount as TaxAmount,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      gross_amount as GrossAmount,
      currency_code as CurrencyCode,
      last_changed_at as LastChangedAt
}
