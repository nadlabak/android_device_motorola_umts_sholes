#!/system/bin/sh
    echo 32 > /sys/bus/platform/devices/omapfb/graphics/fb0/bits_per_pixel
    echo 1 > /sys/bus/platform/devices/omapdss/display0/update_mode
    cat /data/2ndboot/2ndboot.fb > /dev/graphics/fb0
    /system/bin/busybox_static insmod /system/lib/modules/2ndboot.ko
    /system/bin/busybox_static mknod /dev/hbootctrl c 245 0
    /system/bin/hbootuser /system/etc/hboot.cfg
    /system/bin/busybox_static sleep 10

