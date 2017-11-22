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

CLOCKWORK_UNIFIED_BUILD := true

CLOCKWORK_INSTALL_LOCAL_EDITION_APPS := true

# For APKs which have an LE and RoW version present LeSwitch requires
# that dex2oat be disabled.
private_unified_dex2oat_blacklist += \
    ClockworkHomeGoogle \
    ClockworkHomeGoogleLocalEdition \
    WearHandwriting \
    WearHandwritingLocalEdition \

$(call add-product-dex-preopt-module-config,$(private_unified_dex2oat_blacklist),disable)

# Delegation for OEM customization in runtime
PRODUCT_OEM_PROPERTIES += \
    gms.checkin.sw_domain \
    ro.product.locale \
    ro.product.name \
    user.language \
    user.locale \
    user.region \
    ro.oem.* \

# Properties always delegated to OEM or runtime
PRODUCT_SYSTEM_PROPERTY_BLACKLIST += \
    ro.build.fingerprint \
    ro.oem.* \
