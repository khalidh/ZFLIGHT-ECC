define table zf2_carrier {
  key client     : abap.clnt not null;
  key carrier_id : abap.char(3) not null;
  carrier_name   : abap.char(40);
  currency_code  : abap.cuky;
  url            : abap.char(255);
  created_by     : abp_creation_user;
  created_at     : abp_creation_tstmpl;
  last_changed_by: abp_locinst_lastchange_user;
  last_changed_at: abp_locinst_lastchange_tstmpl;
}

