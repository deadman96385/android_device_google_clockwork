# Copyright (C) 2017 The Android Open-Source Project
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
# This mixin contains common targets included for SW compatible builds such
# as our dedicated SW builds and unified builds.

PRODUCT_COPY_FILES += device/google/clockwork/default-permissions_sw.xml:system/etc/default-permissions/default-permissions_sw.xml

PRODUCT_PACKAGES += ClockworkHomeGoogleLocalEdition

ifneq (,$(CLOCKWORK_ENABLE_TELEPHONY))
    # For cellular devices operating in China, they need to comply the
    # CMIIT (China Ministry of Industry and Information Technology) test.
    # This overlay just changes some string literal in Chinese to keep
    # it consistent with what the government requires on paper.
    DEVICE_PACKAGE_OVERLAYS += device/google/clockwork/overlay_cmiit
endif
