define table zfl_invoice {
  key client     : abap.clnt not null;
  key invoice_id : abap.numc(10) not null;
  order_id       : abap.numc(10);
  invoice_date   : abap.dats;
  invoice_status : abap.char(10);
  total_amount   : abap.curr(15,2);
  paid_amount    : abap.curr(15,2);
  currency_code  : abap.cuky;
  last_changed_at: abp_lastchange_tstmpl;
}

