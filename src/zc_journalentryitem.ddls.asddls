@EndUserText.label: '##GENERATED ZJE_HEADER'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_JournalEntryItem
  as projection on ZR_JournalEntryItem
{
  key Uuid,
  key Buzei,
      @Semantics.amount.currencyCode: 'Waers'
      Wrbtr,
      Waers,
      Sgtxt,
      Hkont,
      Kostl,
      Prctr,
      @Semantics.user.createdBy: true
      Item_Created_By,
      @Semantics.systemDateTime.createdAt: true
      Item_Created_At,
      @Semantics.user.lastChangedBy: true
      Item_Last_Changed_By,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Item_Last_Changed_At,

      _Header : redirected to parent ZC_JournalEntry

}
