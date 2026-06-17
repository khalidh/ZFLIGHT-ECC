define table zfl_status_hist {
  key client       : abap.clnt not null;
  key history_uuid : sysuuid_x16 not null;
  object_type      : abap.char(20);
  object_id        : abap.char(30);
  old_status       : abap.char(10);
  new_status       : abap.char(10);
  changed_by       : abp_creation_user;
  changed_at       : abp_creation_tstmpl;
  change_reason    : abap.char(80);
}

