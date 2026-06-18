define table zf2_connection {
  key client        : abap.clnt not null;
  key carrier_id    : abap.char(3) not null;
  key connection_id : abap.numc(4) not null;
  country_from      : land1;
  city_from         : abap.char(40);
  airport_from      : abap.char(3);
  country_to        : land1;
  city_to           : abap.char(40);
  airport_to        : abap.char(3);
  flight_time       : abap.int4;
  departure_time    : abap.tims;
  arrival_time      : abap.tims;
  distance          : abap.dec(9,2);
  distance_unit     : msehi;
}

