#!/sbin/sh

# move tts files to /cdrom
mount /cdrom
rm -rf /cdrom/*
cp -rp /system/tts/lang_pico /cdrom
rm /system/tts/lang_pico/*
ln -s /cdrom/lang_pico/* /system/tts/lang_pico

# symlink sh to static mksh (in sbin) to use it before TLS-enable module is loaded
# set the permissions for the static mksh
ln -fs /system/sbin/mksh /system/bin/sh
chown root.shell /system/sbin/mksh
chmod 755 /system/sbin/mksh

# clear dex files
rm /cache/dalvik-cache/*.dex
mount /data
rm /data/dalvik-cache/*.dex
mount /sddata
rm /sddata/dalvik-cache/*.dex

