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

## Get non-open-source GSM-specific aspects if available
$(call inherit-product-if-exists, vendor/motorola/umts_sholes/umts_sholes-vendor.mk)

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

PRODUCT_PACKAGES += \
    MmParts \
    librs_jni \
    tiwlan.ini \
    dspexec \
    libbridge \
    overlay.omap3 \
    wlan_cu \
    libtiOsLib \
    wlan_loader \
    libCustomWifi \
    wpa_supplicant.conf \
    dhcpcd.conf \
    libOMX.TI.AAC.decode \
    libOMX.TI.AAC.encode \
    libOMX.TI.AMR.decode \
    libOMX.TI.AMR.encode \
    libOMX.TI.WBAMR.decode \
    libOMX.TI.WBAMR.encode \
    libOMX.TI.JPEG.Encoder \
    libLCML \
    libOMX_Core \
    libOMX.TI.Video.Decoder \
    libOMX.TI.Video.encoder \
    libVendor_ti_omx \
    sensors.sholes \
    lights.omap3 \
    libaudiopolicy \
    iwmulticall \
    hostap \
    hostapd.conf \
    libhostapdcli \
    Usb \
    mot_boot_mode \
    charge_only_mode_mm

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
    device/motorola/umts_sholes/prebuilt/etc/init.d/07app2ext:/system/etc/init.d/07app2ext \
    device/motorola/umts_sholes/prebuilt/etc/init.d/08lib2ext:/system/etc/init.d/08lib2ext \
    device/motorola/umts_sholes/prebuilt/etc/init.d/60autoboot_or:/system/etc/init.d/60autoboot_or \
    device/motorola/umts_sholes/prebuilt/etc/location.cfg:/system/etc/location.cfg \
    device/motorola/umts_sholes/prebuilt/etc/powervr.ini:/system/etc/powervr.ini \
    device/motorola/umts_sholes/prebuilt/etc/gpsconfig.xml:/system/etc/gpsconfig.xml \
    device/motorola/umts_sholes/prebuilt/etc/excluded-input-devices.xml:/system/etc/excluded-input-devices.xml \
    device/motorola/umts_sholes/prebuilt/etc/rootfs/default.prop:/system/etc/rootfs/default.prop \
    device/motorola/umts_sholes/prebuilt/etc/rootfs/init.rc:/system/etc/rootfs/init.rc \
    device/motorola/umts_sholes/prebuilt/etc/rootfs/init.mapphone_umts.rc:/system/etc/rootfs/init.mapphone_umts.rc \
    device/motorola/umts_sholes/prebuilt/etc/rootfs/ueventd.rc:/system/etc/rootfs/ueventd.rc \
    device/motorola/umts_sholes/prebuilt/app/Toggle2G.apk:/system/app/Toggle2G.apk \
    device/motorola/umts_sholes/prebuilt/bin/2nd-init:/system/bin/2nd-init \
    device/motorola/umts_sholes/prebuilt/bin/init_prep_keypad.sh:/system/bin/init_prep_keypad.sh \
    device/motorola/umts_sholes/prebuilt/bin/init_bp_nvm.sh:/system/bin/init_bp_nvm.sh \
    device/motorola/umts_sholes/prebuilt/bin/init_early_bind_mounts.sh:/system/bin/init_early_bind_mounts.sh \
    device/motorola/umts_sholes/prebuilt/bin/ttsmovetool.sh:/system/bin/ttsmovetool.sh \
    device/motorola/umts_sholes/prebuilt/bin/sh_hijack.sh:/system/bin/sh_hijack.sh \
    device/motorola/umts_sholes/prebuilt/bin/tcmd:/system/bin/tcmd \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp0b-keypad.kcm.bin:/system/usr/keychars/sholesp0b-keypad.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp2a-keypad-arabic.kcm.bin:/system/usr/keychars/sholesp2a-keypad-arabic.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp2a-keypad-hebrew.kcm.bin:/system/usr/keychars/sholesp2a-keypad-hebrew.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp2a-keypad-russian.kcm.bin:/system/usr/keychars/sholesp2a-keypad-russian.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp2a-keypad-russian2.kcm.bin:/system/usr/keychars/sholesp2a-keypad-russian2.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp1b-keypad.kcm.bin:/system/usr/keychars/sholesp1b-keypad.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp1a-keypad.kcm.bin:/system/usr/keychars/sholesp1a-keypad.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/icestorms0a-keypad.kcm.bin:/system/usr/keychars/icestorms0a-keypad.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp2a-keypad-qwerty.kcm.bin:/system/usr/keychars/sholesp2a-keypad-qwerty.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp2a-keypad-euro_qwerty.kcm.bin:/system/usr/keychars/sholesp2a-keypad-euro_qwerty.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp2a-keypad-qwertz.kcm.bin:/system/usr/keychars/sholesp2a-keypad-qwertz.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp2a-keypad-azerty.kcm.bin:/system/usr/keychars/sholesp2a-keypad-azerty.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp2a-keypad-swe_qwerty.kcm.bin:/system/usr/keychars/sholesp2a-keypad-swe_qwerty.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keychars/sholesp2a-keypad-cyrillic.kcm.bin:/system/usr/keychars/sholesp2a-keypad-cyrillic.kcm.bin \
    device/motorola/umts_sholes/prebuilt/usr/keylayout/sholesp1a-keypad.kl:/system/usr/keylayout/sholesp1a-keypad.kl \
    device/motorola/umts_sholes/prebuilt/usr/keylayout/sholesp0b-keypad.kl:/system/usr/keylayout/sholesp0b-keypad.kl \
    device/motorola/umts_sholes/prebuilt/usr/keylayout/cpcap-key.kl:/system/usr/keylayout/cpcap-key.kl \
    device/motorola/umts_sholes/prebuilt/usr/keylayout/sholesp2a-keypad.kl:/system/usr/keylayout/sholesp2a-keypad.kl \
    device/motorola/umts_sholes/prebuilt/usr/keylayout/sholesp1b-keypad.kl:/system/usr/keylayout/sholesp1b-keypad.kl \
    device/motorola/umts_sholes/prebuilt/usr/keylayout/sholesp2a-keypad-russian.kl:/system/usr/keylayout/sholesp2a-keypad-russian.kl \
    device/motorola/umts_sholes/prebuilt/lib/libgki.so:/system/lib/libgki.so \
    device/motorola/umts_sholes/prebuilt/lib/modules/symsearch.ko:/system/lib/modules/symsearch.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/mot_usb.ko:/system/lib/modules/mot_usb.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/tiwlan_drv.ko:/system/lib/modules/tiwlan_drv.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/dsifix.ko:/system/lib/modules/dsifix.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/slow-work.ko:/system/lib/modules/slow-work.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/xt_multiport.ko:/system/lib/modules/xt_multiport.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/overclock.ko:/system/lib/modules/overclock.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/cpufreq_interactive.ko:/system/lib/modules/cpufreq_interactive.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/cpufreq_smartass.ko:/system/lib/modules/cpufreq_smartass.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/cpufreq_conservative.ko:/system/lib/modules/cpufreq_conservative.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/cpufreq_stats.ko:/system/lib/modules/cpufreq_stats.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/jbd2.ko:/system/lib/modules/jbd2.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/ext4.ko:/system/lib/modules/ext4.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/tun.ko:/system/lib/modules/tun.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/cifs.ko:/system/lib/modules/cifs.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/nls_utf8.ko:/system/lib/modules/nls_utf8.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/lockd.ko:/system/lib/modules/lockd.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/auth_rpcgss.ko:/system/lib/modules/auth_rpcgss.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/rpcsec_gss_krb5.ko:/system/lib/modules/rpcsec_gss_krb5.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/sunrpc.ko:/system/lib/modules/sunrpc.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/nfs.ko:/system/lib/modules/nfs.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/qtouch_num.ko:/system/lib/modules/qtouch_num.ko

$(call inherit-product, build/target/product/full_base.mk)

# use high-density artwork where available
PRODUCT_LOCALES += hdpi

PRODUCT_NAME := umts_sholes
PRODUCT_DEVICE := umts_sholes
