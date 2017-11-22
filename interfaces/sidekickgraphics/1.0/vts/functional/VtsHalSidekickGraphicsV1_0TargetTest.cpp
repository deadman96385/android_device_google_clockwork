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

#define LOG_TAG "sidekickgraphics_hidl_hal_test"

#include <android-base/logging.h>
#include <vendor/google_clockwork/sidekickgraphics/1.0/ISidekickGraphics.h>
#include <vendor/google_clockwork/sidekickgraphics/1.0/types.h>
#include <VtsHalHidlTargetTestBase.h>

#include <cstring>
#include <unistd.h>

using ::vendor::google_clockwork::sidekickgraphics::V1_0::Capability;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::Capabilities;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::ColorCapability;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::DrawableInfo;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::DrawableType;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::ISidekickGraphics;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::NumberInfo;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::NumberSource;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::DisplayPowerState;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::ResourceId;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::RGB;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::Status;
using ::vendor::google_clockwork::sidekickgraphics::V1_0::Time;
using ::android::hardware::Return;
using ::android::hardware::Void;
using ::android::hardware::hidl_vec;
using ::android::sp;
using std::memcpy;

// The main test class for SIDEKICKGRAPHICS HIDL HAL.
class SidekickGraphicsHidlTest : public ::testing::VtsHalHidlTargetTestBase {
 public:
  virtual void SetUp() override {
    sidekick = ::testing::VtsHalHidlTargetTestBase::getService<ISidekickGraphics>();
    ASSERT_NE(sidekick, nullptr);
    Status status;
    status = sidekick->reset();
    ASSERT_EQ(status, Status::OK);
  }

  virtual void TearDown() override {}
 void receiveCapabilities (Status status, Capabilities capabilities,
                                 ColorCapability colorInfo,
                            uint32_t bytesAvailable);
  sp<ISidekickGraphics> sidekick;
};

// A class for test environment setup (kept since this file is a template).
class SidekickGraphicsHidlEnvironment : public ::testing::Environment {
 public:
  virtual void SetUp() {}
  virtual void TearDown() {}

 private:
};


TEST_F(SidekickGraphicsHidlTest, CanGetCapabilities) {
  sidekick->getCapabilities([](Status status, Capabilities capabilities,
                               ColorCapability colorInfo,
                               uint32_t bytesAvailable) {
                              ASSERT_EQ(status, Status::OK);
                              ASSERT_NE((unsigned)capabilities, 0U);
                              ASSERT_NE(colorInfo.redBits, 0U);
                              ASSERT_NE(bytesAvailable, 0U);
                            });
}

TEST_F(SidekickGraphicsHidlTest, FpsIsReasonable) {

  Status status;
  status = sidekick->setDesiredFps(100);
  EXPECT_EQ(status, Status::INSUFFICIENT_RESOURCE);
  status = sidekick->setDesiredFps(2);
  EXPECT_EQ(status, Status::OK);
}

TEST_F(SidekickGraphicsHidlTest, CanSetPalette) {
  ColorCapability colorInfo;

  sidekick->getCapabilities([colorInfo](Status status, Capabilities,
                                        ColorCapability color,
                                        uint32_t) {
                              ASSERT_TRUE(status == Status::OK);
                              std::memcpy((void*)&colorInfo, (void*)&color,
                                          sizeof(colorInfo));
                            });
  ASSERT_GT(colorInfo.paletteSize, 0U);
  ASSERT_LT(colorInfo.paletteSize, 65537U); // Sanity check
  hidl_vec<RGB> palette;
  palette.resize(colorInfo.paletteSize+1);
  for (uint32_t i = 0; i < colorInfo.paletteSize+1; i++) {
    palette[i].red = i;
  }
  Status status;
  status = sidekick->setPalette(palette);
  EXPECT_EQ(status, Status::BAD_VALUE);
  palette.resize(colorInfo.paletteSize);
  status = sidekick->setPalette(palette);
  EXPECT_EQ(status, Status::OK);
}

static const std::vector<uint8_t> png_4x4 {
  0x89, 0x50, 0x4e, 0x47, 0xd, 0xa, 0x1a, 0xa, 0x0, 0x0, 0x0,
  0xd, 0x49, 0x48, 0x44, 0x52, 0x0, 0x0, 0x0, 0x4, 0x0, 0x0,
  0x0, 0x4, 0x8, 0x6, 0x0, 0x0, 0x0, 0xa9, 0xf1, 0x9e, 0x7e,
  0x0, 0x0, 0x0, 0x9, 0x70, 0x48, 0x59, 0x73, 0x0, 0x0, 0xb,
  0x13, 0x0, 0x0, 0xb, 0x13, 0x1, 0x0, 0x9a, 0x9c, 0x18, 0x0,
  0x0, 0x0, 0x7, 0x74, 0x49, 0x4d, 0x45, 0x7, 0xe1, 0x4, 0xf,
  0x0, 0x25, 0x27, 0xf1, 0xd6, 0xb1, 0x9d, 0x0, 0x0, 0x0, 0x19,
  0x74, 0x45, 0x58, 0x74, 0x43, 0x6f, 0x6d, 0x6d, 0x65, 0x6e, 0x74,
  0x0, 0x43, 0x72, 0x65, 0x61, 0x74, 0x65, 0x64, 0x20, 0x77, 0x69,
  0x74, 0x68, 0x20, 0x47, 0x49, 0x4d, 0x50, 0x57, 0x81, 0xe, 0x17,
  0x0, 0x0, 0x0, 0x49, 0x49, 0x44, 0x41, 0x54, 0x8, 0xd7, 0x5,
  0xc1, 0xb1, 0x9, 0x80, 0x30, 0x14, 0x45, 0xd1, 0xf7, 0x34, 0x90,
  0x5d, 0xac, 0xad, 0xad, 0x1d, 0xe2, 0x2f, 0xe1, 0xc, 0xe2, 0x4c,
  0xb6, 0x19, 0x23, 0xd8, 0x9b, 0xca, 0x1, 0xc, 0x8, 0xd7, 0x73,
  0x2c, 0x9, 0xe0, 0xf8, 0x7a, 0x9f, 0x25, 0x9d, 0x43, 0x44, 0xc8,
  0xf6, 0x78, 0xb7, 0xb6, 0xa5, 0x9c, 0x57, 0x1, 0x5c, 0xb5, 0x16,
  0x49, 0xb, 0xb0, 0x27, 0xdb, 0x2, 0x5e, 0x60, 0xb2, 0xfd, 0xfc,
  0x18, 0xd5, 0x20, 0xa, 0x8d, 0x37, 0xac, 0xc6, 0x0, 0x0, 0x0,
  0x0, 0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82, };

TEST_F(SidekickGraphicsHidlTest, TestBeginEndResourceLogic) {
  Status status;

  sidekick->getCapabilities([](Status status, Capabilities,
                               ColorCapability,
                               uint32_t) {
                              ASSERT_EQ(status, Status::OK);
                                        });
  status = sidekick->beginResources(12345);
  EXPECT_EQ(status, Status::BAD_VALUE); // Bad resource ID
  status = sidekick->endResources();
  EXPECT_EQ(status, Status::UNSUPPORTED_OPERATION); // No valid Begin yet
  status = sidekick->beginResources(0);
  EXPECT_EQ(status, Status::OK); // This should work
  status = sidekick->beginResources(0);
  EXPECT_EQ(status, Status::UNSUPPORTED_OPERATION); // Out of order
  status = sidekick->endResources();
  EXPECT_EQ(status, Status::OK); // This should work
  status = sidekick->endResources();
  EXPECT_EQ(status, Status::UNSUPPORTED_OPERATION); // Out of order
}

TEST_F(SidekickGraphicsHidlTest, TestResourceMemory) {
  Status status;
  DrawableInfo drawableInfo = {};
  ResourceId id1, id2;
  uint32_t memory_start, memory_1, memory_2;

  drawableInfo.width = 4;
  drawableInfo.height = 4;
  drawableInfo.display = true;
  drawableInfo.offsetX = 4;
  drawableInfo.offsetY = 4;
  drawableInfo.rotationInfo.rotates = false;
  drawableInfo.transformInfo.scaleX = 1;
  drawableInfo.transformInfo.scaleY = 1;
  drawableInfo.type = DrawableType::GENERIC;

  sidekick->getCapabilities([&memory_start](Status status,
                                            Capabilities capabilities,
                                            ColorCapability,
                                            uint32_t memory) {
                              ASSERT_EQ(status, Status::OK);
                              ASSERT_NE(capabilities & Capability::BITMAP, 0U);
                              memory_start = memory;
                            });
  EXPECT_EQ(sidekick->getBytesAvailable(), memory_start);
  status = sidekick->beginResources(0);
  ASSERT_EQ(status, Status::OK);
  EXPECT_EQ(sidekick->getBytesAvailable(), memory_start);
  sidekick->sendBitmapPng8888(drawableInfo, png_4x4,
                              [&memory_1, &id1](Status status, ResourceId id,
                                                uint32_t memory) {
                                ASSERT_EQ(status, Status::OK);
                                memory_1 = memory;
                                id1 = id;
                              });
  EXPECT_NE(memory_1, 0U);
  EXPECT_EQ(memory_start - memory_1, sidekick->getBytesAvailable());
  sidekick->sendBitmapPng8888(drawableInfo, png_4x4,
                              [&memory_2, &id2](Status status, ResourceId id,
                                                uint32_t memory) {
                                ASSERT_EQ(status, Status::OK);
                                memory_2 = memory;
                                id2 = id;
                              });
  EXPECT_EQ(memory_1, memory_2);
  EXPECT_EQ(memory_start - memory_1 - memory_2, sidekick->getBytesAvailable());
  EXPECT_NE(id2, 0U);
  EXPECT_NE(id1, id2);
  status = sidekick->endResources();
  ASSERT_EQ(status, Status::OK);
  status = sidekick->beginResources(id1);
  ASSERT_EQ(status, Status::OK);
  EXPECT_EQ(memory_start - memory_1, sidekick->getBytesAvailable());
  status = sidekick->replaceDrawableInfo(id1, drawableInfo);
  EXPECT_EQ(status, Status::OK);
  status = sidekick->replaceDrawableInfo(id1 + 1, drawableInfo);
  EXPECT_EQ(status, Status::BAD_VALUE);
  status = sidekick->endResources();
  ASSERT_EQ(status, Status::OK);
  status = sidekick->beginResources(0);
  ASSERT_EQ(status, Status::OK);
  EXPECT_EQ(memory_start, sidekick->getBytesAvailable());
  status = sidekick->endResources();
  ASSERT_EQ(status, Status::OK);
}

#ifdef NUMBER_TEST
TEST_F(SidekickGraphicsHidlTest, TestAcceptsNumber) {
  Status status;
  DrawableInfo drawableInfo = {};
  NumberInfo numberInfo = {};

  drawableInfo.width = 4;
  drawableInfo.height = 4;
  drawableInfo.display = true;
  drawableInfo.offsetX = 4;
  drawableInfo.offsetY = 4;
  drawableInfo.rotationInfo.rotates = false;
  drawableInfo.transformInfo.scaleX = 1;
  drawableInfo.transformInfo.scaleY = 1;
  drawableInfo.type = DrawableType::BACKGROUND;

  numberInfo.source = NumberSource::HOUR_12;
  numberInfo.font = DrawableType::HOUR_DIGIT;
  numberInfo.leadingZeroes = 0;
  numberInfo.digits = 2;

  sidekick->getCapabilities([](Status status,
                                            Capabilities capabilities,
                                            ColorCapability,
                                            uint32_t) {
                              ASSERT_EQ(status, Status::OK);
                              ASSERT_NE(capabilities & Capability::BITMAP, 0U);
                            });
  status = sidekick->beginResources(0);
  ASSERT_EQ(status, Status::OK);
  for (int i = 0; i < 10; i++) {
    drawableInfo.rank = i;
    sidekick->sendBitmapPng8888(drawableInfo, png_4x4,
                                [](Status status, ResourceId id,
                                                  uint32_t bytesUsed) {
                                  ASSERT_EQ(status, Status::OK);
                                  ASSERT_NE(id, 0U);
                                  ASSERT_NE(bytesUsed, 0U);
                                });
  }
  drawableInfo.type = DrawableType::NUMBER;
  sidekick->sendNumberResource(drawableInfo, numberInfo,
                               [](Status status,
                                  ResourceId resourceId,
                                  uint32_t bytesUsed) {
                                 EXPECT_EQ(status, Status::OK);
                                 EXPECT_NE(resourceId, 0U);
                                 EXPECT_NE(bytesUsed, 0U);
                               });
  status = sidekick->endResources();
  ASSERT_EQ(status, Status::OK);
}
#endif

TEST_F(SidekickGraphicsHidlTest, TestTimeSetting) {
  Status status;

  sidekick->getLastDisplayedTime([](Status status, Time) {
      // No time displayed yet.
      EXPECT_EQ(status, Status::INSUFFICIENT_RESOURCE);
    });
  sidekick->beginDisplay(DisplayPowerState::IDLE);
  sleep(1);
  sidekick->getLastDisplayedTime([](Status status, Time lastTime) {
      EXPECT_EQ(status, Status::OK);
      EXPECT_GT(lastTime.daysSinceEpoch, 0);
    });
  Time time = {-1, 0}; // Dec. 31, 1969
  sidekick->setDisplayTime(time);
  sleep(1);
  sidekick->getLastDisplayedTime([](Status status, Time lastTime) {
      EXPECT_EQ(status, Status::OK);
      EXPECT_LT(lastTime.daysSinceEpoch, 0);
    });
  status = sidekick->reset();
  EXPECT_EQ(status, Status::OK);
  sidekick->getLastDisplayedTime([](Status status, Time lastTime) {
      // Should again say No time displayed yet.
      EXPECT_EQ(status, Status::INSUFFICIENT_RESOURCE);
      EXPECT_GT(lastTime.daysSinceEpoch, 0);
    });
}

int main(int argc, char **argv) {
  ::testing::AddGlobalTestEnvironment(new SidekickGraphicsHidlEnvironment);
  ::testing::InitGoogleTest(&argc, argv);
  int status = RUN_ALL_TESTS();
  LOG(INFO) << "Test result = " << status;
  return status;
}
