CLASS lhc_zr_journalentry DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_journalentry RESULT result.

    METHODS post FOR DETERMINE ON SAVE
      IMPORTING keys FOR zr_journalentry~post.

ENDCLASS.

CLASS lhc_zr_journalentry IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD post.

    DATA: lt_entry    TYPE TABLE FOR ACTION  IMPORT i_journalentrytp~post,
          ls_entry    LIKE LINE OF lt_entry,
          ls_glitem   LIKE LINE OF ls_entry-%param-_glitems,
          ls_amount   LIKE LINE OF ls_glitem-_currencyamount,
          lt_temp_key TYPE zje_transaction_handler=>tt_temp_key,
          ls_temp_key LIKE LINE OF lt_temp_key.

    READ ENTITIES OF zr_journalentry IN LOCAL MODE
      ENTITY zr_journalentry
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(header)
      ENTITY zr_journalentry BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(item).


    " start to call I_JournalEntryTP~Post
    LOOP AT header REFERENCE INTO DATA(ls_header).
      CLEAR ls_entry.
      ls_entry-%cid = ls_header->uuid. "use UUID as CID
      ls_entry-%param-companycode = ls_header->bukrs.
      ls_entry-%param-businesstransactiontype = 'RFPO'.
      ls_entry-%param-accountingdocumenttype = 'AB'.
      ls_entry-%param-accountingdocumentheadertext = ls_header->bktxt.
      ls_entry-%param-documentdate = ls_header->bldat.
      ls_entry-%param-postingdate = ls_header->budat.
      ls_entry-%param-createdbyuser = ls_header->created_by.

      LOOP AT item REFERENCE INTO DATA(ls_item) USING KEY entity WHERE uuid = ls_header->uuid.
        CLEAR ls_glitem.
        ls_glitem-glaccountlineitem = ls_item->%data-buzei.
        ls_glitem-glaccount = ls_item->%data-hkont.
        ls_glitem-costcenter = ls_item->%data-kostl.
        ls_glitem-profitcenter = ls_item->%data-prctr.
        ls_glitem-documentitemtext = ls_item->%data-sgtxt.

        CLEAR ls_amount.
        ls_amount-currencyrole = '00'.
        ls_amount-currency = ls_header->waers.
        ls_amount-journalentryitemamount = ls_item->%data-wrbtr.
        APPEND ls_amount TO ls_glitem-_currencyamount.
        APPEND ls_glitem TO ls_entry-%param-_glitems.
      ENDLOOP.
      APPEND ls_entry TO lt_entry.
    ENDLOOP.

    IF lt_entry IS NOT INITIAL.
      MODIFY ENTITIES OF i_journalentrytp
        ENTITY journalentry
          EXECUTE post FROM lt_entry
        MAPPED FINAL(ls_post_mapped)
        FAILED FINAL(ls_post_failed)
        REPORTED FINAL(ls_post_reported).

      IF ls_post_failed IS NOT INITIAL.
        LOOP AT ls_post_reported-journalentry INTO DATA(ls_report).
          APPEND VALUE #(   uuid = ls_report-%cid
                            %create = if_abap_behv=>mk-on
                            %is_draft = if_abap_behv=>mk-on
                            %msg = ls_report-%msg ) TO reported-zr_journalentry.
        ENDLOOP.
      ENDIF.

      LOOP AT ls_post_mapped-journalentry INTO DATA(ls_je_mapped).
        ls_temp_key-cid = ls_je_mapped-%cid.
        ls_temp_key-pid = ls_je_mapped-%pid.
        APPEND ls_temp_key TO lt_temp_key.
      ENDLOOP.

    ENDIF.

    zje_transaction_handler=>get_instance( )->set_temp_key( lt_temp_key ).

  ENDMETHOD.

ENDCLASS.


CLASS lsc_zr_journalentry DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_journalentry IMPLEMENTATION.

  METHOD save_modified.

    " unmanaged save for table zje_header
    DATA: lt_create TYPE TABLE OF zje_header,
          lt_delete TYPE TABLE OF zje_header.

    lt_create = CORRESPONDING #( create-zr_journalentry MAPPING FROM ENTITY ).
    lt_delete = CORRESPONDING #( delete-zr_journalentry MAPPING FROM ENTITY ).

    zje_transaction_handler=>get_instance( )->additional_save(  it_create = lt_create
                                                                it_delete = lt_delete ).

  ENDMETHOD.

  METHOD cleanup_finalize.

    zje_transaction_handler=>get_instance( )->clean_up( ).

  ENDMETHOD.

ENDCLASS.
