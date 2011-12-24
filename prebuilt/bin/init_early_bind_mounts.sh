#!/system/bin/sh
#
export PATH=/system/bin:/system/xbin:$PATH
rm -f /data/logger/*
mount -o bind /cache/logger /data/logger
mount -o bind /pds/public /pds/public/battd

