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
    device/google/clockwork/cn_google_features.xml:system/etc/sysconfig/cn_google_features.xml

PRODUCT_PROPERTY_OVERRIDES += \
    gms.checkin.sw_domain=checkin.gstatic.com \
    user.locale=zh_CN \
    user.language=zh \
    user.region=CN \
    persist.sys.language=zh \
    persist.sys.country=CN \

ifneq (,$(CLOCKWORK_ENABLE_TELEPHONY))
    # Celullar devices need to pass CMIIT regulation with permission review mode.
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.permission_review_required=1
endif

$(call inherit-product, device/google/clockwork/build/clockwork_sw_compatible_mixin.mk)
