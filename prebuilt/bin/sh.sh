#!/system/bin/sh.bin

   /system/xbin/mount -t tmpfs -o size=4k tmpfs /system/sbin
   /system/xbin/ln -s /system/bin/sh.bin /system/sbin/shlink
   /system/xbin/mount -o remount,rw rootfs /
   /system/xbin/rmdir /config
   /system/xbin/rmdir /sdcard
   /system/xbin/cp -fr /etc/rootfs/* /

#   echo "-16" > /proc/$$/oom_adj

   /system/xbin/umount /dev/cpuctl
   /system/xbin/umount /sqlite_stmt_journals
   /system/xbin/umount /dev/pts

   exec /system/bin/2nd-init
