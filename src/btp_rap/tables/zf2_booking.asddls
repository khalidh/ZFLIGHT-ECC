define table zf2_booking {
  key client        : abap.clnt not null;
  key booking_id    : abap.numc(10) not null;
  customer_id       : abap.numc(10);
  carrier_id        : abap.char(3);
  connection_id     : abap.numc(4);
  flight_date       : abap.dats;
  booking_date      : abap.dats;
  booking_status    : abap.char(10);
  seat_class        : abap.char(3);
  @Semantics.amount.currencyCode : 'zf2_booking.currency_code'
  base_amount       : abap.curr(15,2);
  @Semantics.amount.currencyCode : 'zf2_booking.currency_code'
  tax_amount        : abap.curr(15,2);
  @Semantics.amount.currencyCode : 'zf2_booking.currency_code'
  total_amount      : abap.curr(15,2);
  @Semantics.currencyCode : true
  currency_code     : abap.cuky;
  cancel_reason     : abap.char(80);
  local_last_changed_at : abp_locinst_lastchange_tstmpl;
  last_changed_at       : abp_lastchange_tstmpl;
}
