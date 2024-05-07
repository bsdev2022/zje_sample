@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED ZJE_HEADER'
define root view entity ZR_JournalEntry
  as select from zje_header
  composition [0..*] of ZR_JournalEntryItem as _Item
{
  key uuid                  as Uuid,
      belnr                 as Belnr,
      bukrs                 as Bukrs,
      gjahr                 as Gjahr,
      waers                 as Waers,
      bldat                 as Bldat,
      budat                 as Budat,
      bktxt                 as Bktxt,
      @Semantics.user.createdBy: true
      created_by            as Created_By,
      @Semantics.systemDateTime.createdAt: true
      created_at            as Created_At,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as Last_Changed_By,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as Last_Changed_At,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as Local_Last_Changed_At,

      _Item

}
