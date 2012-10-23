#!/system/bin/sh
#
export PATH=/system/bin:/system/xbin:$PATH

insmod /system/lib/modules/pvrsrvkm15.ko
until rmmod pvrsrvkm15; do
    sleep 1
    log "Retrying pvrsrvkm 1.5 unload"
done
insmod /system/lib/modules/pvrsrvkm.ko
insmod /system/lib/modules/omaplfb.ko
sleep 1
chmod 0666 /dev/pvrsrvkm
chown system graphics /dev/pvrsrvkm
pvrsrvinit
