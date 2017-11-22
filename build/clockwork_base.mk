#
# Copyright (C) 2013 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Base platform for Clockwork builds
# Clockwork packages should be added to clockwork.mk instead of here


# build/core/dex_preopt_libart.mk will pick up the first preloaded-classes
# file it finds in PRODUCT_COPY_FILES. For Wear, we use a much smaller list
# of preloaded classes for performance reasons. The default preloaded-classes
# file specified in build/target/product/base.mk (included from
# build/target/product/core_tiny.mk) will not be used.
PRODUCT_COPY_FILES := \
    device/google/clockwork/preloaded-classes-wear:system/etc/preloaded-classes

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_tiny.mk)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.logd.kernel=eng \
    ro.config.low_ram=true \
    ro.config.max_starting_bg=8 \
    ro.bluetooth.hfp.ver=1.6 \
    dalvik.vm.dex2oat-threads=4 

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.adb.secure=1 \
    persist.adb.notify=0 \
    bluetooth.force_pm_timer=2000 \
    config.disable_systemui=true \
    config.disable_rtt=true \
    config.disable_mediaproj=true \
    config.disable_networktime=true \
    config.disable_serial=true \
    config.disable_searchmanager=true \
    config.disable_textservices=false \
    config.disable_samplingprof=true \
    config.disable_consumerir=true \
    config.disable_vrmanager=true \
    contacts.display_photo_size=200 \

# Disable camera service for all clockwork devices except for emulators
# Emulators currently require camera service and will ANR otherwise.
# TODO(b/33205103): Find a clean way to disable camera on emulator as well.
ifneq ($(CLOCKWORK_EMULATOR_PRODUCT), true)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
      config.disable_cameraservice=true
endif

# On userdebug and eng builds, persist logs by default
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PROPERTY_OVERRIDES += \
    logd.logpersistd=logcatd \
    logd.logpersistd.buffer="default,kernel" \
    logd.logpersistd.size=30
endif

SMALLER_FONT_FOOTPRINT := true

$(call inherit-product-if-exists, vendor/google/security/adb/vendor_key.mk)
$(call inherit-product-if-exists, external/noto-fonts/fonts.mk)
$(call inherit-product-if-exists, external/hyphenation-patterns/patterns.mk)
$(call inherit-product-if-exists, frameworks/base/data/keyboards/keyboards.mk)

ifneq ($(CLOCKWORK_OVERRIDE_AUDIO_ALARMS), true)
    # Import default audio alarms configuration
    $(call inherit-product-if-exists, device/google/clockwork/build/clockwork_audio_alarms.mk)
endif

# Extra framework bits
PRODUCT_PACKAGES += \
    librs_jni \
    libwear-bluetooth-jni \
    vibrator.default \
    wear-service

# System tools
PRODUCT_PACKAGES += \
    screenrecord

# Bluetooth proxy
PRODUCT_PACKAGES += \
    sysproxy \
    sysproxyd

# Support Runtime Resource Overlay go/sku-colors
PRODUCT_PACKAGES += \
    idmap

# HIDL requirements
PRODUCT_PACKAGES += \
    hwservicemanager \
    android.hardware.configstore@1.0-impl \
    android.hardware.configstore@1.0-service \
    android.hidl.memory@1.0-service \
    android.hidl.memory@1.0-impl

# Debug system tools
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    downloader \
    net_test_bluetooth \
    logcompressor \
    nc \
    su_exec \
    net_bdtool \
    net_hci \
    net_test_bluedroid \
    sysproxyctl

endif

# Multi DNS introduced API 16
PRODUCT_PACKAGES += \
    mdnsd

PRODUCT_SYSTEM_SERVER_JARS += \
    wear-service

PRODUCT_COPY_FILES += \
    device/google/clockwork/watch_features.xml:system/etc/permissions/watch_features.xml \
    device/google/clockwork/clockwork.xml:system/etc/sysconfig/clockwork.xml

# enable android.hardware.audio.output if hardware supports speakers
ifneq (,$(CLOCKWORK_ENABLE_SPEAKER))
    PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.audio.output.xml:system/etc/permissions/android.hardware.audio.output.xml
endif

# Include the right languages for all products
$(call inherit-product, device/google/clockwork/build/languages.mk)

# Marks this as a Clockwork product: a target with a Clockwork system image, but not necessarily
# a device.
ifndef CLOCKWORK_PRODUCT
CLOCKWORK_PRODUCT := true
endif
