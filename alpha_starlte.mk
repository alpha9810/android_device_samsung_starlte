# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2022 The LineageOS Project

# Inherit from generic products, most specific first
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Product API level
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_o.mk)

# Inherit from starlte device.mk
$(call inherit-product, device/samsung/starlte/device.mk)

# Inherit some common Lineage stuff
$(call inherit-product, vendor/alpha/config/common_full_phone.mk)

# Device identifier, this must come after all inclusions
PRODUCT_NAME := alpha_starlte
PRODUCT_DEVICE := starlte
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G960F
PRODUCT_MANUFACTURER := samsung

PRODUCT_GMS_CLIENTID_BASE := android-samsung

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="samsung starlte star2lte:16 BP4A.251205.006 eng.androi:user release-keys" \
    BuildFingerprint=samsung/starlte/starlte:16/BP4A.251205.006/eng.androi:user/release-keys \
    DeviceName=$(PRODUCT_SYSTEM_DEVICE) \
    DeviceProduct=$(PRODUCT_SYSTEM_NAME) \
    SystemDevice=$(PRODUCT_SYSTEM_DEVICE) \
    SystemName=$(PRODUCT_SYSTEM_NAME)

# Maintainer
ALPHA_BUILD_TYPE := UNOFFOCIAL
ALPHA_MAINTAINER := bobo-corazon-krazey

# Debugging
TARGET_INCLUDE_MATLOG := true
WITH_ADB_INSECURE := false

TARGET_INCLUDE_GOOGLE_COMMS := false
TARGET_INCLUDE_PIXEL_LAUNCHER := true
TARGET_SUPPORTS_QUICK_TAP := true
TARGET_SUPPORTS_CALL_RECORDING := false
TARGET_INCLUDE_STOCK_ARCORE := true
TARGET_INCLUDE_LIVE_WALLPAPERS := false
TARGET_SUPPORTS_GOOGLE_RECORDER := false

# Build config
# TARGET_BUILD_PACKAGE options:
# 1 - vanilla (default)
# 2 - microg
# 3 - gapps
TARGET_BUILD_PACKAGE := 1

# Device config
TARGET_HAS_UDFPS := false
TARGET_SUPPORTS_BLUR := false
TARGET_EXCLUDES_AUDIOFX := true
TARGET_FACE_UNLOCK_SUPPORTED := true

# Prebuilt DTB
TARGET_USES_PREBUILT_DTB := false
