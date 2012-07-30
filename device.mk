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
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# media config xml file
PRODUCT_COPY_FILES += \
    device/motorola/umts_sholes/media_profiles.xml:system/etc/media_profiles.xml \
    device/motorola/umts_sholes/prebuilt/etc/media_codecs.xml:system/etc/media_codecs.xml

# sysctl config
PRODUCT_COPY_FILES += \
    device/motorola/umts_sholes/sysctl.conf:system/etc/sysctl.conf

# TLS enable hack
# /system/bin/sinsmo - statically compiled toolbox with only insmod tool
# /system/sbin/mksh - statically compiled mksh (with sh-hijack),
# used only before 2nd-init to insmod the tls-enable.ko module
PRODUCT_COPY_FILES += \
    device/motorola/umts_sholes/prebuilt/sbin/mksh:system/sbin/mksh \
    device/motorola/umts_sholes/prebuilt/bin/sinsmo:system/bin/sinsmo \
    device/motorola/umts_sholes/prebuilt/lib/modules/tls-enable.ko:system/lib/modules/tls-enable.ko

# ICS sound
PRODUCT_PACKAGES += \
hcitool hciattach hcidump \
libaudioutils audio.a2dp.default audio_policy.sholes \
libaudiohw_legacy audio.primary.sholes

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
    FileManager \
    mot_boot_mode \
    charge_only_mode \
    usbd \
    HwaSettings \
    make_ext4fs \
    fs_mgr \
    2nd-init

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_COPY_FILES += \
    device/motorola/umts_sholes/vold.fstab:system/etc/vold.fstab \
    device/motorola/umts_sholes/prebuilt/etc/audio_policy.conf:system/etc/audio_policy.conf \
    device/motorola/umts_sholes/prebuilt/default.prop:system/default.prop \
    device/motorola/umts_sholes/prebuilt/etc/wifi/dnsmasq.conf:system/etc/wifi/dnsmasq.conf \
    device/motorola/umts_sholes/prebuilt/etc/wifi/tiwlan_ap.ini:/system/etc/wifi/tiwlan_ap.ini \
    device/motorola/umts_sholes/prebuilt/etc/wifi/tiwlan.ini:/system/etc/wifi/tiwlan.ini \
    device/motorola/umts_sholes/prebuilt/etc/wifi/wpa_supplicant.conf:/system/etc/wifi/wpa_supplicant.conf \
    device/motorola/umts_sholes/prebuilt/etc/init.d/10overclock:/system/etc/init.d/10overclock \
    device/motorola/umts_sholes/prebuilt/etc/init.d/01sysctl:/system/etc/init.d/01sysctl \
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
    device/motorola/umts_sholes/prebuilt/etc/rootfs/fstab.sholes:/system/etc/rootfs/fstab.sholes \
    device/motorola/umts_sholes/prebuilt/bin/init_bp_nvm.sh:/system/bin/init_bp_nvm.sh \
    device/motorola/umts_sholes/prebuilt/bin/init_early_bind_mounts.sh:/system/bin/init_early_bind_mounts.sh \
    device/motorola/umts_sholes/prebuilt/bin/install_tool.sh:/system/bin/install_tool.sh \
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
    device/motorola/umts_sholes/prebuilt/lib/modules/symsearch.ko:/system/lib/modules/symsearch.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/pvr-off.ko:/system/lib/modules/pvr-off.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/pvrsrvkm.ko:/system/lib/modules/pvrsrvkm.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/omaplfb.ko:/system/lib/modules/omaplfb.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/mot_usb.ko:/system/lib/modules/mot_usb.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/tiwlan_drv.ko:/system/lib/modules/tiwlan_drv.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/tiap_drv.ko:/system/lib/modules/tiap_drv.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/dsifix.ko:/system/lib/modules/dsifix.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/slow-work.ko:/system/lib/modules/slow-work.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/iptable_raw.ko:/system/lib/modules/iptable_raw.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/xt_multiport.ko:/system/lib/modules/xt_multiport.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/xt_tcpmss.ko:/system/lib/modules/xt_tcpmss.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/xt_TCPMSS.ko:/system/lib/modules/xt_TCPMSS.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/ip6_tables.ko:/system/lib/modules/ip6_tables.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/ip6t_LOG.ko:/system/lib/modules/ip6t_LOG.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/ip6t_REJECT.ko:/system/lib/modules/ip6t_REJECT.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/ip6table_filter.ko:/system/lib/modules/ip6table_filter.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/ip6table_raw.ko:/system/lib/modules/ip6table_raw.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/xt_quota2.ko:/system/lib/modules/xt_quota2.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/xt_owner2.ko:/system/lib/modules/xt_owner2.ko \
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
    device/motorola/umts_sholes/prebuilt/lib/modules/qtouch_num.ko:/system/lib/modules/qtouch_num.ko \
    device/motorola/umts_sholes/prebuilt/lib/modules/dsprecovery.ko:/system/lib/modules/dsprecovery.ko \
    device/motorola/umts_sholes/prebuilt/vendor/app/.holder:/system/vendor/app/.holder \
    device/motorola/umts_sholes/prebuilt/vendor/lib/.holder:/system/vendor/lib/.holder

# use high-density artwork where available
PRODUCT_LOCALES += hdpi

PRODUCT_NAME := umts_sholes
PRODUCT_DEVICE := umts_sholes
