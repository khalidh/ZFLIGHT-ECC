define table zfl_order_item {
  key client   : abap.clnt not null;
  key order_id : abap.numc(10) not null;
  key item_no  : abap.numc(6) not null;
  condition_type : abap.char(4);
  description    : abap.char(80);
  quantity       : abap.quan(13,3);
  amount         : abap.curr(15,2);
  currency_code  : abap.cuky;
}

