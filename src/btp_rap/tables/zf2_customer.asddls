define table zf2_customer {
  key client      : abap.clnt not null;
  key customer_id : abap.numc(10) not null;
  first_name      : abap.char(40);
  last_name       : abap.char(40);
  email_address   : abap.char(241);
  phone_number    : abap.char(30);
  country         : land1;
  language        : spras;
  vip             : abap_boolean;
  created_by      : abp_creation_user;
  created_at      : abp_creation_tstmpl;
  last_changed_by : abp_locinst_lastchange_user;
  last_changed_at : abp_locinst_lastchange_tstmpl;
}

