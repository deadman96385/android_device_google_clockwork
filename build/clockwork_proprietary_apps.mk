# Lists apps that are common to internal builds and PDK builds.
# These are proprietary apps that are not provided as source to
# most pdk partners and are instead prebuilts provided as part
# of the clockwork_services.zip file.
#
# Packages added to this file should also be defined in
# vendor/google_clockwork/build/clockwork_service/dist/apps/Android.mk
#
# Proprietary packages not intended for PDK builds can be added to
# clockwork.mk instead since a missing package is ignored.

# Unconditionally included packages
# Only include those which should be included on all clockwork devices
clockwork_proprietary_apps := \
    ClockworkAmbient \
    ClockworkFrameworkPackageStubs \
    ClockworkPhone \
    ClockworkSettings \
    ClockworkSetupWizard \
    ClockworkSystemUI \
    GoogleExtServices \
    GoogleExtShared \
    GooglePackageInstaller \
    WristGesturesTutorial \
    ClockworkBugReportSender \
    ClockworkFlashlight \
    GoogleServicesFramework \
    PrebuiltDeskClockMicroApp \
    PrebuiltGmsCoreForClockworkWearable \

# Everything else below should be contionally included and configured via
# device makefiles.

# Flags should begin with one of 3 prefixes:

# CLOCKWORK_ENABLE_  - Options which default to disabled and will be turned on for select devices.
# CLOCKWORK_DISABLE_ - Options which default to enabled and will be disabled on select devices.
# CLOCKWORK_INCLUDE_ - Appropriate for some options where the meaning of "include" is more clear.

ifeq (,$(CLOCKWORK_DISABLE_RETAIL_ATTRACT_LOOP))
    clockwork_proprietary_apps += ClockworkRetailAttractLoop
endif

ifeq (,$(CLOCKWORK_DISABLE_TRANSLATE))
    clockwork_proprietary_apps += TranslatePrebuiltWearable
endif

ifeq (,$(CLOCKWORK_DISABLE_REMINDERS))
    clockwork_proprietary_apps += RemindersPrebuiltWearable
endif

ifeq (,$(CLOCKWORK_DISABLE_KEYBOARD))
    clockwork_proprietary_apps += WearKeyboard
endif

ifeq (,$(CLOCKWORK_DISABLE_HANDWRITING))
    ifneq ($(CLOCKWORK_LOCAL_EDITION), true)
        # RoW and Unified build have global WearHandwriting
        clockwork_proprietary_apps += WearHandwriting
    endif

    ifeq ($(CLOCKWORK_INSTALL_LOCAL_EDITION_APPS), true)
        # LE and Unified build have LE WearHandwriting
        clockwork_proprietary_apps += WearHandwritingLocalEdition
    endif
endif

# Add ClockworkBluetooth if product is not emulator
ifeq (,$(CLOCKWORK_EMULATOR_PRODUCT))
    clockwork_proprietary_apps += ClockworkBluetooth
endif

ifeq (,$(CLOCKWORK_DISABLE_SEARCH_APP))
    clockwork_proprietary_apps += ClockworkSearch
endif

ifeq (,$(CLOCKWORK_DISABLE_WEARSKY))
    clockwork_proprietary_apps += PrebuiltWearsky
endif

ifeq (,$(CLOCKWORK_DISABLE_GOOGLE_CONTACTS_SYNC))
    clockwork_proprietary_apps += GoogleContactsSyncAdapter
endif

# Only include MobileSignalDetector if device supports telephony.
ifneq (,$(CLOCKWORK_ENABLE_TELEPHONY))
    # Add MobileSignalDetector if product is not emulator
    ifeq (,$(CLOCKWORK_EMULATOR_PRODUCT))
        clockwork_proprietary_apps += MobileSignalDetector
    endif
endif

ifneq (,$(CLOCKWORK_ENABLE_SPEAKER))
    clockwork_proprietary_apps += TalkbackWearPrebuilt

    ifeq (,$(CLOCKWORK_DISABLE_GOOGLE_TTS))
        clockwork_proprietary_apps += GoogleTTSPrebuiltWearable
    endif
else
    # Force TTS to be part of the build even if no speaker present
    ifneq (,$(CLOCKWORK_FORCE_GOOGLE_TTS))
        clockwork_proprietary_apps += GoogleTTSPrebuiltWearable
    endif
endif

ifneq (,$(CLOCKWORK_ENABLE_DEFAULT_CHARGING_SCREEN))
    clockwork_proprietary_apps += \
        ClockworkChargingScreen
endif

ifneq (,$(CLOCKWORK_ENABLE_PLAY_AUTO_INSTALL))
    clockwork_proprietary_apps += \
        ClockworkPlayAutoInstallStub
endif

ifneq (,$(CLOCKWORK_ENABLE_TELEPHONY))
    clockwork_proprietary_apps += \
        CarrierConfig \
        MmsService \
        TeleService \
        TelephonyProvider

    # Add NumberSync package if enabled
    ifneq (,$(CLOCKWORK_ENABLE_NUMBER_SYNC))
        clockwork_proprietary_apps += NumberSync
    endif

    # Add messenger app unless disabled
    ifeq (,$(CLOCKWORK_DISABLE_GOOGLE_MESSENGER))
        clockwork_proprietary_apps += PrebuiltBugleWearable
    endif

    # Add the carrier certifier tool to eng and userdebug
    # builds so carriers have an easier time through the
    # certification process.
    ifneq ($(TARGET_BUILD_VARIANT),user)
        # And if the product is not emulator
        ifeq ($(CLOCKWORK_EMULATOR_PRODUCT),)
            clockwork_proprietary_apps += CarrierCertifier
        endif
    endif
endif

# Add fitness app unless disabled
ifeq (,$(CLOCKWORK_DISABLE_FITNESS))
    # Don't include fit in developer preview builds
    ifneq (true,$(CLOCKWORK_DEVELOPER_PREVIEW))
        # Don't include fit in emulators
        ifeq ($(CLOCKWORK_EMULATOR_PRODUCT),)
            clockwork_proprietary_apps += FitnessPrebuiltWearable
        endif
    endif
endif

# Add Elements watch faces if not disabled
ifeq (,$(CLOCKWORK_DISABLE_ELEMENTS_WATCHFACES))
    clockwork_proprietary_apps += \
        AnalogComplicationWatchFace \
        DigitalComplicationWatchFace
endif

# Add hero watch faces if enabled
ifneq (,$(CLOCKWORK_ENABLE_HERO_WATCHFACES))
    # Don't include hero watchfaces for developer preview builds
    ifneq (true,$(CLOCKWORK_DEVELOPER_PREVIEW))
        clockwork_proprietary_apps += HeroWatchFacesPrebuilt
    endif
endif

# Add tapandpay package if enabled
ifneq (,$(CLOCKWORK_ENABLE_TAPANDPAY))
    # Don't include tapandpay for developer preview builds
    ifneq (true,$(CLOCKWORK_DEVELOPER_PREVIEW))
        clockwork_proprietary_apps += PrebuiltTapAndPayWearable
    endif
endif

# Include round icons if enabled
ifneq (,$(CLOCKWORK_ENABLE_ROUND_ICONS))
    clockwork_proprietary_apps += ClockworkRoundLauncherIcons
endif

ifeq ($(CLOCKWORK_INCLUDE_GMSCORE_SIDECAR_AUTH), true)
    clockwork_proprietary_apps += PrebuiltGmsCoreForClockwork_AuthSidecar
endif

ifeq ($(CLOCKWORK_INCLUDE_GMSCORE_SIDECAR_FITNESS), true)
    clockwork_proprietary_apps += PrebuiltGmsCoreForClockwork_FitnessSidecar
endif

ifeq ($(CLOCKWORK_INCLUDE_GMSCORE_SIDECAR_SECURITY), true)
    clockwork_proprietary_apps += PrebuiltGmsCoreForClockwork_SecuritySidecar
endif

ifeq ($(CLOCKWORK_INCLUDE_GMSCORE_SIDECAR_TAPANDPAY), true)
    # Don't include tapandpay sidecar for developer preview builds
    ifneq (true,$(CLOCKWORK_DEVELOPER_PREVIEW))
        clockwork_proprietary_apps += PrebuiltGmsCoreForClockwork_TapAndPaySidecar
    endif
endif

ifeq ($(CLOCKWORK_INCLUDE_GMSCORE_SIDECAR_WEARABLE), true)
    clockwork_proprietary_apps += PrebuiltGmsCoreForClockwork_WearableSidecar
endif

ifeq ($(CLOCKWORK_INCLUDE_OEM_SETUP), true)
    clockwork_proprietary_apps += ClockworkOemSetup
endif

ifeq ($(CLOCKWORK_ENABLE_GOOGLEPARTNERSETUP), true)
    # GooglePartnerSetup is currently only used for Android Pay.
    # Ensure Android Pay is enabled before including.
    ifeq ($(CLOCKWORK_ENABLE_TAPANDPAY), true)
        clockwork_proprietary_apps += GooglePartnerSetup
    else
        $(error CLOCKWORK_ENABLE_GOOGLEPARTNERSETUP requires CLOCKWORK_ENABLE_TAPANDPAY)
    endif
endif

ifeq ($(CLOCKWORK_INSTALL_LOCAL_EDITION_APPS), true)
    clockwork_proprietary_apps += \
        ClockworkHotwordLocalEdition \
        MobvoiVoiceSearch \

    # TODO(b/37056468): Remove the condition after the bug gets fixed. Sogou Map
    # is a must-have on all SW compatible build.
    ifeq (,$(CLOCKWORK_DISABLE_SOGOU_MAPS))
        ifeq ($(CLOCKWORK_EMULATOR_PRODUCT),)
            # It does not make sense to have a map app in emulator
            clockwork_proprietary_apps += PrebuiltSogouMapWearable
        endif
    endif

    # TODO(b/37056468): Remove the condition after the bug gets fixed. Pinyin IME
    # is a must-have on all SW compatible build.
    ifeq (,$(CLOCKWORK_DISABLE_PINYIN_KEYBOARD))
        clockwork_proprietary_apps += WearPinyinKeyboard
    endif

    ifneq (,$(CLOCKWORK_ENABLE_SPEAKER))
        clockwork_proprietary_apps += MobvoiTextToSpeech
    endif

    ifeq (,$(CLOCKWORK_DISABLE_DEFAULT_LOCAL_EDITION_APP_STORE))
        clockwork_proprietary_apps += MobvoiAppStore
    endif
endif

ifeq ($(CLOCKWORK_UNIFIED_BUILD), true)
    clockwork_proprietary_apps += ClockworkLeSwitch

    clockwork_proprietary_apps += \
        AlipayPrebuilt \
        AmberWeatherPrebuilt \
        CtripPrebuilt \
        DianpingPrebuilt \
        DidiPrebuilt \
        KeepPrebuilt \

endif

$(call inherit-product, vendor/clockwork/clockwork-vendor.mk)
