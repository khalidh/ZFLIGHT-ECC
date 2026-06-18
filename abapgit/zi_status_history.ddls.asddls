@EndUserText.label: 'Flight Status History'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_StatusHistory
  as select from zfl_status_hist
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

