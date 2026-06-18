@EndUserText.label: 'Flight Order Item'
@AccessControl.authorizationCheck: #CHECK
define view entity ZF2_I_OrderItem
  as select from zf2_order_item
  association to parent ZF2_I_Order as _Order
    on $projection.OrderID = _Order.OrderID
{
  key order_id as OrderID,
  key item_no as ItemNo,
      condition_type as ConditionType,
      description as Description,
      quantity as Quantity,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      amount as Amount,
      currency_code as CurrencyCode,
      _Order
}

