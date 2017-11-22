#
# Copyright (C) 2016 The Android Open-Source Project
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

LOCAL_PATH := $(call my-dir)

############################################
# Check that all proprietary apps have an entry in the PDK app prebuilts
# makefile

LOCAL_PDK_DIST_APPS_MK_FILE := vendor/google_clockwork/build/clockwork_service/dist/apps/Android.mk

# Include this rule only if the vendor/google_clockwork dist apps mk file exists
ifneq (,$(wildcard $(LOCAL_PDK_DIST_APPS_MK_FILE)))

include $(CLEAR_VARS)

LOCAL_MODULE := clockwork-proprietary-apps-pdk-check

LOCAL_MODULE_CLASS := FAKE
LOCAL_BUILT_MODULE_STEM := output.txt
LOCAL_INSTALLED_MODULE_STEM := $(LOCAL_MODULE)-output.txt

include $(BUILD_SYSTEM)/base_rules.mk

# The clockwork_proprietary_apps.mk provides the variable
# $(clockwork_proprietary_apps) which lists Clockwork proprietary apps.
include $(LOCAL_PATH)/clockwork_proprietary_apps.mk

# TODO List of packages whitelisted from this test temporarily. These
# should be removed and the makefiles fixed, and then this exception
# code removed.
LOCAL_EXCEPTED_PACKAGES := \
    CarrierCertifier \
    CarrierConfig \
    ClockworkContacts \
    MmsService \
    NumberSync \
    TelephonyProvider \
    TeleService \

.PHONY: $(LOCAL_BUILT_MODULE)
$(LOCAL_BUILT_MODULE): PRIVATE_PATH := $(LOCAL_PATH)
$(LOCAL_BUILT_MODULE): PRIVATE_PROPRIETARY_APPS := $(clockwork_proprietary_apps)
$(LOCAL_BUILT_MODULE): PRIVATE_PDK_DIST_APPS_MK := $(LOCAL_PDK_DIST_APPS_MK_FILE)
$(LOCAL_BUILT_MODULE): PRIVATE_EXCEPTED_PACKAGES := $(LOCAL_EXCEPTED_PACKAGES)
$(LOCAL_BUILT_MODULE):
	$(hide) echo "host $(PRIVATE_PROPRIETARY_APPS): $(PRIVATE_MODULE) ($(dir $@))"
	$(hide) mkdir -p "$(dir $@)"
	$(hide) ( \
          failed=false && \
          for package in $(PRIVATE_PROPRIETARY_APPS); do \
            if ! grep -q "LOCAL_MODULE := $${package}" $(PRIVATE_PDK_DIST_APPS_MK); then \
              if grep -q $${package} <(printf "%s\n" $(PRIVATE_EXCEPTED_PACKAGES)); then \
                echo "Warning: Package $${package} not listed in $(PRIVATE_PDK_DIST_APPS_MK)"; \
              else \
                echo "Error: Package $${package} not listed in $(PRIVATE_PDK_DIST_APPS_MK)" && \
                failed=true; \
              fi; \
            fi; \
          done && \
          ! $${failed} && \
	  echo "Woohoo!" \
	) >$@ 2>&1 || (RV=$$?; sed -e 's+^+$(PRIVATE_MODULE): +' <$@ 1>&2; exit $$RV)

endif

# Unset these variables, since CLEAR_VARS does not know about them.
clockwork_proprietary_apps :=
LOCAL_DIST_APPS_MK_FILE :=
LOCAL_EXCEPTED_PACKAGES :=

##############################################################################
### For Local Edition builds, a test that checks whether Rest-of-World
### APKs have been accidentally added to LE builds as well.
##############################################################################

ifeq ($(CLOCKWORK_LOCAL_EDITION), true)

include $(CLEAR_VARS)

LOCAL_MODULE := clockwork-le-build-apk-check

LOCAL_MODULE_CLASS := FAKE
LOCAL_BUILT_MODULE_STEM := apk-list.txt
LOCAL_INSTALLED_MODULE_STEM := $(LOCAL_MODULE)-apk-list.txt

include $(BUILD_SYSTEM)/base_rules.mk

# The clockwork_proprietary_apps.mk provides the variable
# $(clockwork_proprietary_apps) which lists Clockwork proprietary apps.
include $(LOCAL_PATH)/clockwork_proprietary_apps.mk

##############################################################################
# This is the list of internal Clockwork packages that are allowed for LE,
# checked in Android.mk in the clockwork-le-build-apk-check test. These
# packages must be useable in China, for Local Edition devices.
ALLOWED_PRODUCT_PACKAGES_FOR_LE := \
    AnalogComplicationWatchFace \
    CarrierCertifier \
    CarrierConfig \
    ClockworkAmbient \
    ClockworkBluetooth \
    ClockworkBugReportSender \
    ClockworkCMAS \
    ClockworkFlashlight \
    ClockworkFrameworkPackageStubs \
    ClockworkHotwordLocalEdition \
    ClockworkPhone \
    ClockworkRetailAttractLoop \
    ClockworkSettings \
    ClockworkSetupWizard \
    ClockworkSystemUI \
    DigitalComplicationWatchFace \
    GoogleExtServices \
    GoogleExtShared \
    GooglePackageInstaller \
    GoogleServicesFramework \
    MmsService \
    MobileSignalDetector \
    MobvoiAppStore \
    MobvoiVoiceSearch \
    MobvoiTextToSpeech \
    PrebuiltDeskClockMicroApp \
    PrebuiltGmsCoreForClockworkWearable \
    PrebuiltSogouMapWearable \
    TalkbackWearPrebuilt \
    TelephonyProvider \
    TeleService \
    WearHandwritingLocalEdition \
    WearMouse \
    WearPinyinKeyboard \
    WristGesturesTutorial \

.PHONY: $(LOCAL_BUILT_MODULE)
$(LOCAL_BUILT_MODULE): PRIVATE_PROPRIETARY_APPS := $(clockwork_proprietary_apps)
$(LOCAL_BUILT_MODULE):
	$(hide) mkdir -p "$(dir $@)"
	$(hide) ( \
          failed=false && \
          for package in $(PRIVATE_PROPRIETARY_APPS); do \
            if ! grep -q $${package} <(printf "%s\n" $(ALLOWED_PRODUCT_PACKAGES_FOR_LE)); then \
              echo "Error: Package $${package} has been added to LE builds - is this intentional?" && \
              echo "If so, please inform the Local Edition team and also update clockwork_sw_mode_mixin.mk." && \
              failed=true; \
            fi; \
          done && \
          ! $${failed} && \
	  echo "Passed!" \
	) >$@ 2>&1 || (RV=$$?; sed -e 's+^+$(PRIVATE_MODULE): +' <$@ 1>&2; exit $$RV)

endif

##############################################################################
