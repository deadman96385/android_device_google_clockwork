# This file includes default clockwork alarm sounds
# To override it, import a different file and set CLOCKWORK_OVERRIDE_AUDIO_ALARMS := true
# in device.mk

framework_alarm_files := Oxygen

PRODUCT_COPY_FILES += $(foreach fn,$(framework_alarm_files),\
    frameworks/base/data/sounds/alarms/ogg/$(fn).ogg:system/media/audio/alarms/$(fn).ogg)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.alarm_alert=Oxygen.ogg \

framework_alarm_files :=
