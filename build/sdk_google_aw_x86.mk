# Defines the Google-edition clockwork emulator system image

$(call inherit-product, device/google/clockwork/build/clockwork_emulator.mk)

# Overrides
PRODUCT_BRAND := google
PRODUCT_NAME := sdk_google_aw_x86
PRODUCT_DEVICE := generic_x86
