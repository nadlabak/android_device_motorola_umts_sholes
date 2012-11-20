#!/sbin/sh

# move tts files to /cdrom
mount /cdrom
rm -rf /cdrom/*
cp -rp /system/tts/lang_pico /cdrom
rm /system/tts/lang_pico/*
ln -s /cdrom/lang_pico/* /system/tts/lang_pico

#symlink kcm for keypad-ru_qwerty.kl
ln -s /system/usr/keychars/sholes-keypad-qwerty.kcm /system/usr/keychars/sholes-keypad-ru_qwerty.kcm

# clear dex files
rm /cache/dalvik-cache/*.dex
mount /data
rm /data/dalvik-cache/*.dex
mount /sddata
rm /sddata/dalvik-cache/*.dex

