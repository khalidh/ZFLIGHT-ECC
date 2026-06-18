define table zfl_order {
  key client     : abap.clnt not null;
  key order_id   : abap.numc(10) not null;
  booking_id     : abap.numc(10);
  customer_id    : abap.numc(10);
  order_date     : abap.dats;
  order_status   : abap.char(10);
  net_amount     : abap.curr(15,2);
  tax_amount     : abap.curr(15,2);
  gross_amount   : abap.curr(15,2);
  currency_code  : abap.cuky;
  last_changed_at: abp_lastchange_tstmpl;
}

