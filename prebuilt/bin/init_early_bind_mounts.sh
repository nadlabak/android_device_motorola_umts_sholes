#!/system/bin/sh
#
export PATH=/system/bin:/system/xbin:$PATH
busybox rm -f /data/logger/*
mount -o bind /cache/logger /data/logger
mount -o bind /pds/public /pds/public/battd
mount -o bind /sd-ext/vendor/app /system/vendor/app
mount -o bind /sd-ext/vendor/lib /system/vendor/lib
mount -o bind /sd-ext/usr /system/usr
mount -o bind /sd-ext/fonts /system/fonts
mount -o bind /sd-ext/media /system/media

