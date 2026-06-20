@EndUserText.label: 'Flight Order Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZF2_I_ORDER_ITEM
  as select from zf2_order_item
{
  key order_id as OrderID,
  key item_no as ItemNo,
      condition_type as ConditionType,
      description as Description,
      @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
      quantity as Quantity,
      quantity_unit as QuantityUnit,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      amount as Amount,
      currency_code as CurrencyCode
}
