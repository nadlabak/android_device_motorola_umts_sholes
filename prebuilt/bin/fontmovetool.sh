#!/sbin/sh

mount /cdrom
rm -f /cdrom/cdrom_vfat.bin
rm -rf /cdrom/fonts
cp -rp /system/fonts /cdrom
rm /system/fonts/*
ln -s /cdrom/fonts/* /system/fonts

