@EndUserText.label: 'Projection View for ZR_JournalEntry'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_JournalEntry
  provider contract transactional_query
  as projection on ZR_JournalEntry
{
  key UUID,
      Belnr,
      Bukrs,
      Waers,
      Gjahr,
      Bldat,
      Budat,
      Bktxt,
      @Semantics.user.createdBy: true
      Created_By,
      @Semantics.systemDateTime.createdAt: true
      Created_At,
      @Semantics.user.lastChangedBy: true
      Last_Changed_By,
      @Semantics.systemDateTime.lastChangedAt: true
      Last_Changed_At,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Local_Last_Changed_At,

      _Item : redirected to composition child ZC_JournalEntryItem

}
