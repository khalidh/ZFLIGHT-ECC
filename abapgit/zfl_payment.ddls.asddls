define table zfl_payment {
  key client     : abap.clnt not null;
  key payment_id : abap.numc(10) not null;
  invoice_id     : abap.numc(10);
  payment_date   : abap.dats;
  amount         : abap.curr(15,2);
  currency_code  : abap.cuky;
  payment_method : abap.char(10);
  reference      : abap.char(40);
}

