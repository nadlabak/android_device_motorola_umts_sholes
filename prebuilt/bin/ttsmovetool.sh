#!/sbin/sh

mount /cdrom
rm -rf /cdrom/*
cp -rp /system/tts/lang_pico /cdrom
rm /system/tts/lang_pico/*
ln -s /cdrom/lang_pico/* /system/tts/lang_pico

