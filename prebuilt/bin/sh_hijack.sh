#!/system/bin/sh
    echo 32 > /sys/devices/platform/omapfb/graphics/fb0/bits_per_pixel
    echo 1 > /sys/devices/omapdss/display0/update_mode
    /system/bin/busybox_static gunzip -c /etc/2ndboot/2ndboot.fb.gz > /dev/graphics/fb0
    /system/bin/busybox_static cp -f /proc/bootinfo /data/bootinfo
    /system/bin/busybox_static insmod /system/lib/modules/hbootmod.ko > /cache/2ndboot.log 2>&1
    /system/bin/busybox_static mknod /dev/hbootctrl c 245 0 >> /cache/2ndboot.log 2>&1
    echo 255 > /sys/class/leds/green/brightness
    /system/bin/hbootuser /etc/hboot.cfg >> /cache/2ndboot.log 2>&1
    /system/bin/busybox_static sleep 10

