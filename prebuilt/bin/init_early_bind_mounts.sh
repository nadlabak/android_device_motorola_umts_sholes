#!/system/bin/sh
#
export PATH=/system/bin:/system/xbin:$PATH
busybox rm -f /data/logger/*
mount -o bind /cache/logger /data/logger
mount -o bind /pds/public /pds/public/battd
mount -o bind /data/vendor/app /system/vendor/app
mount -o bind /data/vendor/lib /system/vendor/lib

