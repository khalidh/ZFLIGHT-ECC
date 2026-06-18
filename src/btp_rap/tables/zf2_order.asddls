define table zf2_order {
  key client     : abap.clnt not null;
  key order_id   : abap.numc(10) not null;
  booking_id     : abap.numc(10);
  customer_id    : abap.numc(10);
  order_date     : abap.dats;
  order_status   : abap.char(10);
  @Semantics.amount.currencyCode : 'zf2_order.currency_code'
  net_amount     : abap.curr(15,2);
  @Semantics.amount.currencyCode : 'zf2_order.currency_code'
  tax_amount     : abap.curr(15,2);
  @Semantics.amount.currencyCode : 'zf2_order.currency_code'
  gross_amount   : abap.curr(15,2);
  @Semantics.currencyCode : true
  currency_code  : abap.cuky;
  last_changed_at: abp_lastchange_tstmpl;
}
