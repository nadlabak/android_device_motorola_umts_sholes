#
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

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

$(call inherit-product-if-exists, vendor/motorola/umts_sholes/device-vendor.mk)

PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_PROPERTY_OVERRIDES += \
	ro.com.android.wifi-watchlist=GoogleGuest \
	ro.error.receiver.system.apps=com.google.android.feedback \
	ro.setupwizard.enterprise_mode=1 \
        ro.com.google.clientid=android-motorola \
	ro.com.google.clientidbase=android-motorola \
	ro.com.google.locationfeatures=1 \
	ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
	ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
	ro.config.vc_call_vol_steps=7 \
	ro.telephony.call_ring.multiple=false \
	ro.telephony.call_ring.delay=3000 \
	ro.url.safetylegal=http://www.motorola.com/staticfiles/Support/legal/?model=A853 \
	ro.setupwizard.enable_bypass=1 \
	ro.media.dec.jpeg.memcap=20000000 \
	dalvik.vm.lockprof.threshold=500 \
	dalvik.vm.dexopt-flags=m=y \
        ro.product.multi_touch_enabled=true \
        ro.product.max_num_touch=5 \
        ro.com.google.gmsversion=2.3_r4

DEVICE_PACKAGE_OVERLAYS += device/motorola/umts_sholes/overlay

PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/base/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# media config xml file
PRODUCT_COPY_FILES += \
    device/motorola/umts_sholes/media_profiles.xml:system/etc/media_profiles.xml

# sysctl config
PRODUCT_COPY_FILES += \
    device/motorola/umts_sholes/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    device/motorola/umts_sholes/prebuilt/bin/handle_bp_panic.sh:system/bin/handle_bp_panic.sh

# 2ndboot + TLS register workaround
# the stock kernel doesn't allow usage of TLS register, therefore
# prebuilt binaries are needed before the new kernel with TLS register
# usage enabled is booted
#
# /system/bin/busybox_static - statically compiled busybox
# /system/sbin/mksh - statically compiled mksh (with sh-hijack),
#         used to run sh_hijack.sh to invoke kernel restart via 2ndboot
# /system/bin/akmd2 - proprietary binary daemon patched
#         for compatibility with real TLS register usage
PRODUCT_COPY_FILES += \
    device/motorola/umts_sholes/prebuilt/bin/akmd2:system/bin/akmd2 \
    device/motorola/umts_sholes/prebuilt/sbin/mksh:system/sbin/mksh \
    device/motorola/umts_sholes/prebuilt/bin/busybox_static:system/bin/busybox_static \
    device/motorola/umts_sholes/2ndboot/hboot.cfg:system/etc/2ndboot/hboot.cfg \
    device/motorola/umts_sholes/2ndboot/2ndboot.fb.gz:system/etc/2ndboot/2ndboot.fb.gz \
    device/motorola/umts_sholes/2ndboot/hboot.bin:system/etc/2ndboot/hboot.bin \
    device/motorola/umts_sholes/2ndboot/hbootmod.ko:system/etc/2ndboot/hbootmod.ko \
    device/motorola/umts_sholes/2ndboot/devtree:system/etc/2ndboot/devtree \
    device/motorola/umts_sholes/rootfs/default.prop:root/default.prop \
    device/motorola/umts_sholes/rootfs/init.mapphone_umts.rc:root/init.mapphone_umts.rc \
    device/motorola/umts_sholes/rootfs/init.rc:root/init.rc \
    device/motorola/umts_sholes/rootfs/ueventd.rc:root/ueventd.rc

# prebuilt kernel modules
PRODUCT_COPY_FILES += \
    device/motorola/umts_sholes/prebuilt/lib/modules/pvrsrvkm.ko:system/lib/modules/pvrsrvkm.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/omaplfb.ko:system/lib/modules/omaplfb.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/tiwlan_drv.ko:system/lib/modules/tiwlan_drv.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/tiap_drv.ko:system/lib/modules/tiap_drv.ko

# ICS sound
PRODUCT_PACKAGES += \
hcitool hciattach hcidump \
libaudioutils audio.a2dp.default audio_policy.sholes \
libaudiohw_legacy audio.primary.omap3

PRODUCT_PACKAGES += \
    e2fsck \
    MilestoneParts \
    librs_jni \
    tiwlan.ini \
    dspexec \
    libbridge \
    wlan_cu \
    libtiOsLib \
    wlan_loader \
    libCustomWifi \
    wpa_supplicant.conf \
    dhcpcd.conf \
    iwmulticall \
    hostap \
    hostapd.conf \
    libhostapdcli \
    tiap_loader \
    tiap_cu \
    libOMX.TI.AAC.decode \
    libOMX.TI.AAC.encode \
    libOMX.TI.AMR.decode \
    libOMX.TI.AMR.encode \
    libOMX.TI.WBAMR.decode \
    libOMX.TI.WBAMR.encode \
    libLCML \
    libOMX_Core \
    libOMX.TI.Video.Decoder \
    libOMX.TI.Video.encoder \
    libOMX.TI.JPEG.Encoder \
    sensors.sholes \
    lights.sholes \
    camera.sholes \
    Usb \
    Torch \
    Toggle2G \
    CMFileManager \
    mot_boot_mode \
    charge_only_mode \
    usbd \
    HwaSettings \
    hbootuser

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_COPY_FILES += \
    device/motorola/umts_sholes/vold.fstab:system/etc/vold.fstab \
    device/motorola/umts_sholes/prebuilt/default.prop:system/default.prop \
    device/motorola/umts_sholes/prebuilt/etc/wifi/dnsmasq.conf:system/etc/wifi/dnsmasq.conf \
    device/motorola/umts_sholes/prebuilt/etc/wifi/tiwlan_ap.ini:/system/etc/wifi/tiwlan_ap.ini \
    device/motorola/umts_sholes/prebuilt/etc/wifi/tiwlan.ini:/system/etc/wifi/tiwlan.ini \
    device/motorola/umts_sholes/prebuilt/etc/wifi/wpa_supplicant.conf:/system/etc/wifi/wpa_supplicant.conf \
    device/motorola/umts_sholes/prebuilt/etc/init.d/10overclock:/system/etc/init.d/10overclock \
    device/motorola/umts_sholes/prebuilt/etc/init.d/01sysctl:/system/etc/init.d/01sysctl \
    device/motorola/umts_sholes/prebuilt/etc/init.d/05mountsd:/system/etc/init.d/05mountsd \
    device/motorola/umts_sholes/prebuilt/etc/init.d/07app2ext:/system/etc/init.d/07app2ext \
    device/motorola/umts_sholes/prebuilt/etc/init.d/08lib2ext:/system/etc/init.d/08lib2ext \
    device/motorola/umts_sholes/prebuilt/etc/init.d/60autoboot_or:/system/etc/init.d/60autoboot_or \
    device/motorola/umts_sholes/prebuilt/etc/init.d/12swap:/system/etc/init.d/12swap \
    device/motorola/umts_sholes/prebuilt/etc/init.d/99cpufreq_stats:/system/etc/init.d/99cpufreq_stats \
    device/motorola/umts_sholes/prebuilt/etc/init.d/30rngd:/system/etc/init.d/30rngd \
    device/motorola/umts_sholes/prebuilt/etc/location.cfg:/system/etc/location.cfg \
    device/motorola/umts_sholes/prebuilt/etc/powervr.ini:/system/etc/powervr.ini \
    device/motorola/umts_sholes/prebuilt/etc/gpsconfig.xml:/system/etc/gpsconfig.xml \
    device/motorola/umts_sholes/prebuilt/etc/excluded-input-devices.xml:/system/etc/excluded-input-devices.xml \
    device/motorola/umts_sholes/prebuilt/bin/init_bp_nvm.sh:/system/bin/init_bp_nvm.sh \
    device/motorola/umts_sholes/prebuilt/bin/init_early_bind_mounts.sh:/system/bin/init_early_bind_mounts.sh \
    device/motorola/umts_sholes/prebuilt/bin/install_tool.sh:/system/bin/install_tool.sh \
    device/motorola/umts_sholes/prebuilt/bin/rngd:/system/bin/rngd \
    device/motorola/umts_sholes/prebuilt/bin/sh_hijack.sh:/system/bin/sh_hijack.sh \
    device/motorola/umts_sholes/prebuilt/bin/tcmd:/system/bin/tcmd \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholes-keypad.kcm:/system/usr/keychars/sholes-keypad.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholes-keypad-qwerty.kcm:/system/usr/keychars/sholes-keypad-qwerty.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholes-keypad-euro_qwerty.kcm:/system/usr/keychars/sholes-keypad-euro_qwerty.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholes-keypad-qwertz.kcm:/system/usr/keychars/sholes-keypad-qwertz.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholes-keypad-azerty.kcm:/system/usr/keychars/sholes-keypad-azerty.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholes-keypad-swe_qwerty.kcm:/system/usr/keychars/sholes-keypad-swe_qwerty.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholes-keypad-arabic.kcm:/system/usr/keychars/sholes-keypad-arabic.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholes-keypad-cyrillic.kcm:/system/usr/keychars/sholes-keypad-cyrillic.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholes-keypad-hebrew.kcm:/system/usr/keychars/sholes-keypad-hebrew.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholes-keypad-russian.kcm:/system/usr/keychars/sholes-keypad-russian.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keychars/cpcap-key.kcm:/system/usr/keychars/cpcap-key.kcm \
    device/motorola/umts_sholes/prebuilt/usr/keylayout/sholes-keypad.kl:/system/usr/keylayout/sholes-keypad.kl \
    device/motorola/umts_sholes/prebuilt/usr/keylayout/sholes-keypad-ru_qwerty.kl:/system/usr/keylayout/sholes-keypad-ru_qwerty.kl \
    device/motorola/umts_sholes/prebuilt/usr/keylayout/cpcap-key.kl:/system/usr/keylayout/cpcap-key.kl \
    device/motorola/umts_sholes/prebuilt/usr/keylayout/qtouch-touchscreen.kl:/system/usr/keylayout/qtouch-touchscreen.kl \
    device/motorola/umts_sholes/prebuilt/usr/idc/qtouch-touchscreen.idc:/system/usr/idc/qtouch-touchscreen.idc \
    device/motorola/umts_sholes/prebuilt/usr/idc/sholes-keypad.idc:/system/usr/idc/sholes-keypad.idc \
    device/motorola/umts_sholes/prebuilt/lib/libgki.so:/system/lib/libgki.so \
    device/motorola/umts_sholes/prebuilt/vendor/app/.holder:/system/vendor/app/.holder \
    device/motorola/umts_sholes/prebuilt/vendor/lib/.holder:/system/vendor/lib/.holder

PRODUCT_NAME := umts_sholes
PRODUCT_DEVICE := umts_sholes

