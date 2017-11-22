# Copyright (C) 2015 The Android Open-Source Project
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

PRODUCT_COPY_FILES += \
    device/google/clockwork/unified_google_features.xml:system/etc/sysconfig/unified_google_features.xml \
    device/google/clockwork/cn_google_features.xml:system/leswitch/cn_google_features.xml \
    device/google/clockwork/leswitch/leswitch.sh:system/leswitch/leswitch.sh \
    device/google/clockwork/leswitch/oem.prop:system/leswitch/oem.prop \
    device/google/clockwork/leswitch/init.unified.sh:system/bin/init.unified.sh \

BOARD_SEPOLICY_DIRS += device/google/clockwork/sepolicy_unified

$(call inherit-product, device/google/clockwork/build/clockwork_sw_compatible_mixin.mk)
