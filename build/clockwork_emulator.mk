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

CLOCKWORK_INCLUDE_OEM_SETUP := true

# TODO: re-enable google messenger in wear-master emulator once a non-crashing
# prebuilt is imported. b/35802418, b/32968727
CLOCKWORK_DISABLE_GOOGLE_MESSENGER := true

$(call inherit-product, device/google/clockwork/build/clockwork_generic.mk)

# Apps useful for development
PRODUCT_PACKAGES += \
    CustomLocale

# Clockwork emulator devices currently require ethernet service: http://b/24847870.
# TODO: This could be removed if core_tiny.mk picks up ethernet service
PRODUCT_PACKAGES += \
    ethernet-service
# Warning: The order of PRODUCT_SYSTEM_SERVER_JARS matters.
PRODUCT_SYSTEM_SERVER_JARS += \
    ethernet-service

# Marks this as a Clockwork emulator product
CLOCKWORK_EMULATOR_PRODUCT := true

# emulator bits to make itself bootable.
include $(SRC_TARGET_DIR)/product/emulator.mk

# override default emulator overlay with clockwork sdk overlay
PRODUCT_PACKAGE_OVERLAYS := device/google/clockwork/sdk_overlay

PRODUCT_CHARACTERISTICS := emulator,nosdcard,watch
