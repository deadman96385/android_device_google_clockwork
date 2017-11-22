# Include this file to pick up clockwork notification sounds.

clockwork_audio_files := Tethys

PRODUCT_COPY_FILES += $(foreach fn,$(clockwork_audio_files),\
    device/google/clockwork/audio_assets/notifications/$(fn).ogg:system/media/audio/notifications/$(fn).ogg)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Tethys.ogg \

clockwork_audio_files :=
