# Copyright (C) 2009 The Android Open Source Project
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
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# WARNING: This line must come *before* including the proprietary
# variant, so that it gets overwritten by the parent (which goes
# against the traditional rules of inheritance).
USE_CAMERA_STUB := false

# inherit from the proprietary version
-include vendor/motorola/umts_sholes/BoardConfigVendor.mk

TARGET_NO_BOOTLOADER := true
TARGET_NO_RECOVERY := true
TARGET_NO_KERNEL := true
TARGET_NO_RADIOIMAGE := true

TARGET_BOARD_PLATFORM := omap3

TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_ARCH_VARIANT_CPU := cortex-a8
TARGET_ARCH_VARIANT_FPU := neon
TARGET_GLOBAL_CFLAGS += -mtune=cortex-a8
TARGET_GLOBAL_CPPFLAGS += -mtune=cortex-a8

# CONFIG_HAS_TLS_REG is not set in our kernel config
ARCH_ARM_HAVE_TLS_REGISTER := false

TARGET_OMAP3 := true
COMMON_GLOBAL_CFLAGS += -DTARGET_OMAP3 -DOMAP_COMPAT -DMILESTONE_UIDS

TARGET_BOOTLOADER_BOARD_NAME := sholes

# Wifi related defines
BOARD_WLAN_DEVICE := wl1271
BOARD_SOFTAP_DEVICE := wl1271
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := libCustomWifi
WPA_SUPPLICANT_VERSION := VER_0_6_X
BOARD_WPA_SUPPLICANT_DRIVER := CUSTOM
WIFI_DRIVER_MODULE_PATH := "/system/lib/modules/tiwlan_drv.ko"
WIFI_DRIVER_MODULE_NAME := tiwlan_drv
WIFI_DRIVER_FW_STA_PATH := "/system/etc/wifi/fw_wlan1271.bin"
WIFI_FIRMWARE_LOADER := "wlan_loader"
PRODUCT_WIRELESS_TOOLS := true
AP_CONFIG_DRIVER_WILINK := true
WIFI_DRIVER_FW_AP_PATH := "/system/etc/wifi/fw_tiwlan_ap.bin"
WPA_SUPPL_APPROX_USE_RSSI := true

BOARD_USES_GENERIC_AUDIO := false

# use pre-kernel.35 vold usb mounting
BOARD_USE_USB_MASS_STORAGE_SWITCH := true

USE_OPENGL_RENDERER := false
DEFAULT_FB_NUM := 0
BOARD_USES_OVERLAY := true
BOARD_USE_YUV422I_DEFAULT_COLORFORMAT := true

HARDWARE_OMX := true
TARGET_USE_OMAP_COMPAT  := true
BUILD_WITH_TI_AUDIO := 1
BUILD_PV_VIDEO_ENCODERS := 1

#BOARD_USES_FROYO_AUDIOPOLICY := true

#BOARD_GPS_LIBRARIES := libgps
BOARD_USES_GPSSHIM := false
#BOARD_GPS_BAD_AGPS := true

BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true

BOARD_EGL_CFG := device/motorola/umts_sholes/egl.cfg
BOARD_NO_RGBX_8888 := true

BOARD_BOOTIMAGE_PARTITION_SIZE := 0x00380000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x00480000
# real value:
#BOARD_SYSTEMIMAGE_PARTITION_SIZE := 0x0afa0000
# here we lie about the system partition size so it can be used to max
# (squisher will change the size of files anyway)
# the size of system content in the final update zip package
# needs to be veryfied manually before flashing
# (considering also additional gapps size)!
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 0x0e000000
BOARD_USERDATAIMAGE_PARTITION_SIZE := 0x0c520000
BOARD_FLASH_BLOCK_SIZE := 131072

BOARD_HAS_SMALL_RECOVERY := true

#TARGET_RECOVERY_UI_LIB := librecovery_ui_sholes librecovery_ui_generic

#TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_generic

USE_SHOLES_PROPERTY := true

TARGET_SKIA_USE_MORE_MEMORY := false

COMMON_GLOBAL_CFLAGS += -DMISSING_EGL_EXTERNAL_IMAGE -DMISSING_EGL_PIXEL_FORMAT_YV12 -DMISSING_GRALLOC_BUFFERS

TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/devices/platform/usb_mass_storage/lun0/file"

ENABLE_SENSORS_COMPAT := true
BOARD_USES_AUDIO_LEGACY := true
TARGET_PROVIDES_LIBAUDIO := true
BOARD_USE_LEGACY_TOUCHSCREEN := true

# WITH_DEXPREOPT := true

# Custom releasetools
TARGET_CUSTOM_RELEASETOOL := ./device/motorola/umts_sholes/releasetools/squisher
TARGET_PROVIDES_RELEASETOOLS := true
TARGET_RELEASETOOL_IMG_FROM_TARGET_SCRIPT := ./device/motorola/umts_sholes/releasetools/umts_sholes_img_from_target_files
TARGET_RELEASETOOL_OTA_FROM_TARGET_SCRIPT := ./device/motorola/umts_sholes/releasetools/umts_sholes_ota_from_target_files

