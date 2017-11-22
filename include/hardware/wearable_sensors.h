/*
 * Copyright (C) 2016 The Android Open Source Project
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


/*
 * SENSOR_TYPE_WEAR_LOW_LATENCY_OFFBODY_DETECT
 * trigger-mode: on-change
 * wake-up sensor: yes
 *
 * A sensor of this type triggers an event each time the wearable device
 * is removed from the body and each time it's put back onto the body.
 * It must be low-latency and be able to detect the on-body to off-body
 * transition within one second (event delivery time included),
 * and 3-second latency to determine the off-body to on-body transition
 * (event delivery time included).
 *
 * There are only two valid event values for the sensor to return :
 *    0.0 for off-body
 *    1.0 for on-body
 *
 */
#define SENSOR_TYPE_WEAR_LOW_LATENCY_OFFBODY_DETECT        (34)
#define SENSOR_STRING_TYPE_WEAR_LOW_LATENCY_OFFBODY_DETECT "android.sensor.low_latency_offbody"
