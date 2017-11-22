#ifndef VENDOR_GOOGLE_CLOCKWORK_SIDEKICKGRAPHICS_V1_0_SIDEKICKGRAPHICS_H
#define VENDOR_GOOGLE_CLOCKWORK_SIDEKICKGRAPHICS_V1_0_SIDEKICKGRAPHICS_H

#include <vendor/google_clockwork/sidekickgraphics/1.0/ISidekickGraphics.h>
#include <hidl/MQDescriptor.h>
#include <hidl/Status.h>

namespace vendor {
namespace google_clockwork {
namespace sidekickgraphics {
namespace V1_0 {
namespace implementation {

using ::android::hidl::base::V1_0::DebugInfo;
using ::android::hidl::base::V1_0::IBase;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::AlsMode;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::BurnInMode;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::ColorCapability;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::DisplayPowerState;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::DrawableInfo;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::FontInfo;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::ISidekickGraphics;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::NumberInfo;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::RGB;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::Status;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::Time;
using ::android::hardware::hidl_array;
using ::android::hardware::hidl_memory;
using ::android::hardware::hidl_string;
using ::android::hardware::hidl_vec;
using ::android::hardware::Return;
using ::android::hardware::Void;
using ::android::sp;

struct SidekickGraphics : public ISidekickGraphics {
    // Methods from ::vendor::google_clockwork::sidekickgraphics::V1_0::ISidekickGraphics follow.
    Return<Status> reset() override;
    Return<void> getCapabilities(getCapabilities_cb _hidl_cb) override;
    Return<Status> setAlsMode(AlsMode mode, float brightenAlpha, float dimmingAlpha) override;
    Return<Status> configureAlsLevels(bool brightnessIsDiscrete, const hidl_vec<uint16_t>& lightValues, const hidl_vec<uint16_t>& lightValuesDown, const hidl_vec<uint16_t>& brightnessValues) override;
    Return<Status> configureAlsPalettes(const hidl_vec<uint16_t>& thresholds, const hidl_vec<RGB>& palettes) override;
    Return<Status> setBurnInMode(BurnInMode mode) override;
    Return<void> getLastBrightness(getLastBrightness_cb _hidl_cb) override;
    Return<void> getTimePerFrame(getTimePerFrame_cb _hidl_cb) override;
    Return<Status> setDesiredFps(uint32_t fps) override;
    Return<Status> setPalette(const hidl_vec<RGB>& palette) override;
    Return<Status> beginResources(uint32_t replaceFrom) override;
    Return<Status> endResources() override;
    Return<uint32_t> getBytesAvailable() override;
    Return<Status> beginDisplay(DisplayPowerState power) override;
    Return<void> endDisplay(DisplayPowerState power) override;
    Return<void> sendBitmapPng8888(const DrawableInfo& drawableInfo, const hidl_vec<uint8_t>& bitmap, sendBitmapPng8888_cb _hidl_cb) override;
    Return<void> sendFontPng8888(const FontInfo& fontInfo, const hidl_vec<uint8_t>& bitmap, sendFontPng8888_cb _hidl_cb) override;
    Return<void> sendNumberResource(const DrawableInfo& drawableInfo, const NumberInfo& numberInfo, sendNumberResource_cb _hidl_cb) override;
    Return<Status> replaceDrawableInfo(uint32_t id, const DrawableInfo& info) override;
    Return<Status> setGamma(float gamma) override;
    Return<void> setDisplayTime(const Time& time) override;
    Return<void> unsetDisplayTime() override;
    Return<void> getLastDisplayedTime(getLastDisplayedTime_cb _hidl_cb) override;

    // Methods from ::android::hidl::base::V1_0::IBase follow.

};

extern "C" ISidekickGraphics* HIDL_FETCH_ISidekickGraphics(const char* name);

}  // namespace implementation
}  // namespace V1_0
}  // namespace sidekickgraphics
}  // namespace google_clockwork
}  // namespace vendor

#endif  // VENDOR_GOOGLE_CLOCKWORK_SIDEKICKGRAPHICS_V1_0_SIDEKICKGRAPHICS_H
