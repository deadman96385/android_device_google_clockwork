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

# Common make file for all Clockwork builds

$(call inherit-product, device/google/clockwork/build/clockwork_base.mk)

# Uncomment for clockwork developer preview branches
# CLOCKWORK_DEVELOPER_PREVIEW := true

# The clockwork_proprietary_apps.mk provides the variable
# $(clockwork_proprietary_apps) which lists Clockwork proprietary apps.
include $(LOCAL_PATH)/clockwork_proprietary_apps.mk

DEVICE_PACKAGE_OVERLAYS := device/google/clockwork/overlay

BOARD_PLAT_PRIVATE_SEPOLICY_DIR := device/google/clockwork/sepolicy

# HACK : The current GmsCore doesn't have an intent verifier, so we use the AOSP one
# for the time being. b/27336841 b/27442095
# TODO: Remove StatementService once GmsCore is updated!
PRODUCT_PACKAGES += \
    $(clockwork_proprietary_apps) \
    DownloadProvider \
    KeyChain \
    MediaProvider \
    clockwork-system \
    clockwork-system.xml \
    com.google.android.wearable \
    com.google.android.wearable.xml \
    ClockworkProxy \
    StatementService

# Allocate several MBs of system image headroom in non-PDK builds
# to catch build errors locally instead of on the build server.
ifneq ($(TARGET_BUILD_PDK),true)
  PRODUCT_SYSTEM_HEADROOM := 4194304
endif

# This is not part of the clockwork_proprietary_apps because it is also built
# from source in the PDK.
# Remove the temporary ClockworkGmsRuntimeResourceOverlay when b/33462865 is fixed
# and integrated. Tacked by b/35760793.
PRODUCT_PACKAGES += \
    ClockworkHomeGoogleRuntimeResourceOverlay \
    ClockworkGmsRuntimeResourceOverlay

ifneq ($(CLOCKWORK_LOCAL_EDITION), true)
  PRODUCT_PACKAGES += \
      ClockworkHome
endif

ifneq (,$(CLOCKWORK_ENABLE_TELEPHONY))
  PRODUCT_PACKAGES += \
      rild

  # Add CMAS unless disabled.
  ifeq (,$(CLOCKWORK_DISABLE_CMAS))
    PRODUCT_PACKAGES += CellBroadcastReceiver
  endif
endif

ifneq (,$(CLOCKWORK_ENABLE_TAPANDPAY))
  # Don't include NfcPlacement for developer preview builds
  ifneq (true,$(CLOCKWORK_DEVELOPER_PREVIEW))
    PRODUCT_PACKAGES += \
      NfcPlacement
  endif
endif

ifneq ($(CLOCKWORK_LOCAL_EDITION), true)
  # Overrides ClockworkHome package
  PRODUCT_PACKAGES += \
      ClockworkHomeGoogle
endif

# Add NumberSync permissions if enabled
ifneq (,$(CLOCKWORK_ENABLE_NUMBER_SYNC))
  PRODUCT_COPY_FILES += \
      device/google/clockwork/default-permissions_numbersync.xml:system/etc/default-permissions/default-permissions_numbersync.xml
endif

# Request that the experimental RemoteAdbStub package be added to non-emulator
# userdebug and eng builds. See http://go/remote-adb-tools. This package provides
# necessary permissions to the actual RemoteAdb app if side-loaded, but is
# otherwise empty. This is for internal use, not for PDK. System image cost is
# approximately 10 KB.
ifneq (,$(filter eng userdebug, $(TARGET_BUILD_VARIANT)))
  ifeq (,$(CLOCKWORK_EMULATOR_PRODUCT))
    PRODUCT_PACKAGES += PrebuiltRemoteAdbStub
  endif
endif

# Systrace debugger for userdebug build
ifneq (,$(filter eng userdebug, $(TARGET_BUILD_VARIANT)))
  ifeq (,$(CLOCKWORK_EMULATOR_PRODUCT))
    PRODUCT_PACKAGES += Traceur
  endif
endif

# The following are only added for CTS: try to remove in future platform versions.
PRODUCT_PACKAGES += \
    UserDictionaryProvider \

PRODUCT_PACKAGES += \
    Telecom \
    BlockedNumberProvider

# Managed Provisioning (http://b/32020215)
PRODUCT_PACKAGES += \
    ManagedProvisioning

PRODUCT_COPY_FILES += \
    system/core/rootdir/etc/public.libraries.wear.txt:system/etc/public.libraries.txt

clockwork_proprietary_apps :=

is_emulator_user_build := false
ifeq (user,$(TARGET_BUILD_VARIANT))
  ifeq (true,$(CLOCKWORK_EMULATOR_PRODUCT))
    is_emulator_user_build := true
  endif
endif

# Use dev-keys with this product, unless it is an emulator user build.
ifneq (true,$(is_emulator_user_build))
  $(call inherit-product-if-exists, vendor/google/products/devkey.mk)
endif

is_emulator_user_build :=
