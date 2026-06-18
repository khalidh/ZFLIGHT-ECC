define table zf2_order_item {
  key client   : abap.clnt not null;
  key order_id : abap.numc(10) not null;
  key item_no  : abap.numc(6) not null;
  condition_type : abap.char(4);
  description    : abap.char(80);
  @Semantics.quantity.unitOfMeasure : 'zf2_order_item.quantity_unit'
  quantity       : abap.quan(13,3);
  @Semantics.unitOfMeasure : true
  quantity_unit  : abap.unit(3);
  @Semantics.amount.currencyCode : 'zf2_order_item.currency_code'
  amount         : abap.curr(15,2);
  @Semantics.currencyCode : true
  currency_code  : abap.cuky;
}
