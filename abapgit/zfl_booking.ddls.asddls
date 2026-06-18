define table zfl_booking {
  key client        : abap.clnt not null;
  key booking_id    : abap.numc(10) not null;
  customer_id       : abap.numc(10);
  carrier_id        : abap.char(3);
  connection_id     : abap.numc(4);
  flight_date       : abap.dats;
  booking_date      : abap.dats;
  booking_status    : abap.char(10);
  seat_class        : abap.char(3);
  base_amount       : abap.curr(15,2);
  tax_amount        : abap.curr(15,2);
  total_amount      : abap.curr(15,2);
  currency_code     : abap.cuky;
  cancel_reason     : abap.char(80);
  local_last_changed_at : abp_locinst_lastchange_tstmpl;
  last_changed_at       : abp_lastchange_tstmpl;
}

