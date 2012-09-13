## Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := Milestone

# Boot animation
TARGET_BOOTANIMATION_NAME := 480

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_mini_phone.mk)

# Inherit device configuration
$(call inherit-product, device/motorola/umts_sholes/full_umts_sholes.mk)

## Device identifier. This must come after all inclusions
PRODUCT_NAME := cm_umts_sholes
PRODUCT_BRAND := motorola
PRODUCT_DEVICE := umts_sholes
PRODUCT_MODEL := Milestone
PRODUCT_MANUFACTURER := Motorola

#Set build fingerprint / ID / Product Name ect.
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_ID=SHOLS_U2_05.26.3 PRODUCT_NAME=umts_sholes TARGET_DEVICE=umts_sholes BUILD_FINGERPRINT=MOTO_RTEU/umts_sholes/umts_sholes/sholes:2.2.1/SHOLS_U2_05.26.3/296482885:user/release-keys PRODUCT_BRAND=MOTO_RTEU PRIVATE_BUILD_DESC="umts_sholes-user 2.2.1 SHOLS_U2_05.26.3 296482885 release-keys" BUILD_NUMBER=296482885 BUILD_UTC_DATE=1295422848 TARGET_BUILD_TYPE=user BUILD_VERSION_TAGS=release-keys USER=android-build


