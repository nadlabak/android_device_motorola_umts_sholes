#!/system/bin/sh
export PATH=/system/bin:/system/xbin:$PATH
mount -o remount,rw /system
BPVARIANT="b1b8"
BPNVMPROP="/data/property/persist.sys.bp_nvm"
BPNVMBASE="/system/etc/motorola/"
if [ -e $BPNVMPROP ]
then
    BPVARIANT=`cat $BPNVMPROP`
fi
busybox ln -sf $BPNVMBASE$BPVARIANT/* $BPNVMBASE/bp_nvm_default
mount -o remount,ro /system
