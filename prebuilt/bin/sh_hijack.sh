#!/system/bin/sh
   /system/xbin/mount -o remount,rw rootfs /
   /system/xbin/rmdir /config
   /system/xbin/rm -f /sbin/charge_only_mode
   /system/xbin/rm -f /init.mapphone_cdma.rc
   /system/xbin/rm -f /init.goldfish.rc
   /system/xbin/rm -f /init_prep_keypad.sh
   /system/xbin/cp -fr /etc/rootfs/* /
   /system/xbin/chmod 750 /sbin/*
   /system/xbin/chmod 750 /init*
   /system/xbin/ln -s /init /sbin/ueventd

#   echo "msc_adb" > /dev/usb_device_mode
#   echo "usb_mode_msc_adb" > /tmp/usbd_current_state

   exec /system/bin/2nd-init
