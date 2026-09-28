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
$(call inherit-product, vendor/infinity/config/common_full_phone.mk)

# Device identifier, this must come after all inclusions
PRODUCT_NAME := infinity_starlte
PRODUCT_DEVICE := starlte
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G960F
PRODUCT_MANUFACTURER := samsung

PRODUCT_GMS_CLIENTID_BASE := android-samsung

# Some Build Flags
TARGET_BOOT_ANIMATION_RES := 1080
TARGET_SUPPORTS_BLUR := false

# Whether you are compiling being an OFFICIAL Maintainer:
INFINITY_BUILD_TYPE := UNOFFICIAL

# Maintainer Name
INFINITY_MAINTAINER := localhorst04_&_bobo

# Whether the device supports Fingerprint On Display
TARGET_HAS_UDFPS := false

# Whether Including Google Apps
WITH_GAPPS := false
