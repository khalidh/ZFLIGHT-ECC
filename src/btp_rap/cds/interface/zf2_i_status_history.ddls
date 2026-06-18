@EndUserText.label: 'Flight Status History'
@AccessControl.authorizationCheck: #CHECK
define view entity ZF2_I_STATUS_HISTORY
  as select from zf2_status_hist
{
  key history_uuid as HistoryUUID,
      object_type as ObjectType,
      object_id as ObjectID,
      old_status as OldStatus,
      new_status as NewStatus,
      changed_by as ChangedBy,
      changed_at as ChangedAt,
      change_reason as ChangeReason
}

