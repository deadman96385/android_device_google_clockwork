# Include this file to pick up clockwork ringtone sounds.

clockwork_audio_files := Atria Callisto Dione Ganymede Luna Oberon Phobos Pyxis Sedna Triton Umbriel

PRODUCT_COPY_FILES += $(foreach fn,$(clockwork_audio_files),\
    device/google/clockwork/audio_assets/ringtones/$(fn).ogg:system/media/audio/ringtones/$(fn).ogg)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Atria.ogg \

clockwork_audio_files :=
