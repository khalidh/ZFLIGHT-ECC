@EndUserText.label: 'Flight Order'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZI_Order
  as select from zfl_order
  association to ZI_Booking as _Booking
    on $projection.BookingID = _Booking.BookingID
  association [0..*] to ZI_OrderItem as _Items
    on $projection.OrderID = _Items.OrderID
  association [0..1] to ZI_Invoice as _Invoice
    on $projection.OrderID = _Invoice.OrderID
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
      last_changed_at as LastChangedAt,
      _Booking,
      _Items,
      _Invoice
}

