# Defines the Google-edition clockwork emulator system image

include device/google/clockwork/build/clockwork_sw_top_config.mk
$(call inherit-product, device/google/clockwork/build/clockwork_emulator.mk)
$(call inherit-product, device/google/clockwork/build/clockwork_sw_mode_mixin.mk)

# Overrides
PRODUCT_BRAND := google
PRODUCT_NAME := sdk_google_aw_sw_x86
PRODUCT_DEVICE := generic_x86
