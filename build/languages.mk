# Supported languages for Android Wear
ifeq ($(CLOCKWORK_LOCAL_EDITION), true)
  # For Local Edition, we only want the zh_CN locale to be available to the
  # user. However, we also need the English locales available in the system
  # for CTS testing and for debugging.
  PRODUCT_LOCALES := zh_CN en_US en_GB
else
  PRODUCT_LOCALES := en_US en_GB en_XA cs_CZ da_DK de_DE es_ES es_US es_419 fi_FI fr_FR fr_CA hi_IN in_ID it_IT ja_JP ko_KR nb_NO nl nl_BE pl pt_BR pt_PT ru_RU sv_SE th tr_TR vi_VN zh_HK zh_TW
  ifeq ($(CLOCKWORK_UNIFIED_BUILD), true)
    PRODUCT_LOCALES += zh_CN
  endif
endif

