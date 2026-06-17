define table zfl_flight {
  key client        : abap.clnt not null;
  key carrier_id    : abap.char(3) not null;
  key connection_id : abap.numc(4) not null;
  key flight_date   : abap.dats not null;
  price             : abap.curr(15,2);
  currency_code     : abap.cuky;
  plane_type        : abap.char(10);
  seats_max         : abap.int4;
  seats_occupied    : abap.int4;
  flight_status     : abap.char(10);
  local_last_changed_at : abp_locinst_lastchange_tstmpl;
  last_changed_at       : abp_lastchange_tstmpl;
}

