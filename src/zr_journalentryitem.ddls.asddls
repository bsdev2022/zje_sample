@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED ZJE_HEADER'
define view entity ZR_JournalEntryItem
  as select from zje_item
  association to parent ZR_JournalEntry as _Header on $projection.Uuid = _Header.Uuid
{
  key uuid                 as Uuid,
  key buzei                as Buzei,
      @Semantics.amount.currencyCode: 'Waers'
      wrbtr                as Wrbtr,
      _Header.Waers        as Waers,
      sgtxt                as Sgtxt,
      hkont                as Hkont,
      kostl                as Kostl,
      prctr                as Prctr,
      @Semantics.user.createdBy: true
      item_created_by      as Item_Created_By,
      @Semantics.systemDateTime.createdAt: true
      item_created_at      as Item_Created_At,
      @Semantics.user.lastChangedBy: true
      item_last_changed_by as Item_Last_Changed_By,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      item_last_changed_at as Item_Last_Changed_At,

      _Header
      
}
