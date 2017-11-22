#
# Copyright (C) 2014 The Android Open-Source Project
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

# Defines the clockwork system image.
# Cloned from build/target/product/sdk.mk, but removes all the product packages and non essential files.
# This configuration doesn't include emulator bits.

# Define the host tools and libs that are parts of the SDK.
-include sdk/build/product_sdk.mk
-include development/build/product_sdk.mk

CLOCKWORK_ENABLE_SPEAKER := true

CLOCKWORK_ENABLE_TELEPHONY := true

PRODUCT_COPY_FILES := \
    device/generic/goldfish/data/etc/apns-conf.xml:system/etc/apns-conf.xml \
    device/google/clockwork/audio_media_codecs.xml:system/etc/media_codecs.xml \
    device/google/clockwork/bootanimations/square_280/bootanimation.zip:system/media/bootanimation.zip \
    frameworks/av/media/libeffects/data/audio_effects.conf:system/etc/audio_effects.conf \
    frameworks/native/data/etc/wearable_core_hardware.xml:system/etc/permissions/wearable_core_hardware.xml \
    frameworks/native/data/etc/android.software.connectionservice.xml:system/etc/permissions/android.software.connectionservice.xml \
    hardware/libhardware_legacy/audio/audio_policy.conf:system/etc/audio_policy.conf \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \

$(call inherit-product-if-exists, frameworks/base/data/sounds/AllAudio.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product-if-exists, external/roboto-fonts/fonts.mk)
$(call inherit-product-if-exists, frameworks/base/data/keyboards/keyboards.mk)

# Disable secure adb: doesn't currently work with sdk build: http://b/13984340
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.adb.secure=0

PRODUCT_CHARACTERISTICS := nosdcard,watch

$(call inherit-product, device/google/clockwork/build/clockwork.mk)
$(call inherit-product, device/google/clockwork/build/clockwork_audio.mk)

# locale + densities. en_US is both first and in alphabetical order to
# ensure this is the default locale.
PRODUCT_LOCALES := \
    en_US \
    ldpi \
    hdpi \
    mdpi \
    xhdpi \

ifeq ($(CLOCKWORK_LOCAL_EDITION), true)
    PRODUCT_LOCALES += zh_CN
endif

# Overrides
PRODUCT_BRAND := generic
PRODUCT_NAME := clockwork_sdk
PRODUCT_DEVICE := generic

PRODUCT_SDK_ATREE_FILES := \
    vendor/google_clockwork/sdk/build/sdk.atree \
    vendor/google_clockwork/sdk/build/sdk_devices.atree \

