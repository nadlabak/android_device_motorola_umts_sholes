#!/system/bin/sh
export PATH=/system/bin:/system/xbin:$PATH
mount -o remount,rw /system
LAVARIANT="ms"
LAPROP="/data/property/persist.sys.libaudio"
if [ -e $LAPROP ]
then
    LAVARIANT=`cat $LAPROP`
fi
ln -sf /system/lib/libaudio_${LAVARIANT}.so /system/lib/libaudio.so
ln -sf /system/bin/ap_gain_${LAVARIANT}.bin /system/bin/ap_gain.bin
mount -o remount,ro /system
