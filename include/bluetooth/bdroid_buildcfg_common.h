/*
 * Copyright (C) 2014 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _BDROID_BUILDCFG_COMMON_H
#define _BDROID_BUILDCFG_COMMON_H

#define BTA_FTS_OPS_IDLE_TO_SNIFF_DELAY_MS 2000
#define GKI_TIMER_INTERVAL_FOR_WAKELOCK 100
#define PRELOAD_START_TIMEOUT_MS 5000

// The amount of time in ms to delay shutdown of BTA.
#define BTA_DISABLE_DELAY 1000

// Disable absolute volume on Wear (http://b/26070064).
#define AVRC_ADV_CTRL_INCLUDED FALSE

// Don't publish SDP records for HSP, just publish HFP.
#define BTIF_HF_SERVICES (BTA_HFP_SERVICE_MASK)

#define BTIF_HF_FEATURES   ( BTA_AG_FEAT_ECNR   | \
                             BTA_AG_FEAT_REJECT | \
                             BTA_AG_FEAT_ECS    | \
                             BTA_AG_FEAT_EXTERR | \
                             BTA_AG_FEAT_BTRH   | \
                             BTA_AG_FEAT_UNAT)

#define BTIF_HF_CLIENT_FEATURES ( \
    BTA_HF_CLIENT_FEAT_ECNR | \
    BTA_HF_CLIENT_FEAT_CLI | \
    BTA_HF_CLIENT_FEAT_VOL | \
    BTA_HF_CLIENT_FEAT_ECS \
    )

// Allow one-time LE IO cap to be specified on first bond.
// Set to no-input-no-output to force Just Works pairing.
#define WEAR_LE_IO_CAP_OVERRIDE TRUE

#endif
