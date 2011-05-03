#!/system/bin/sh
export PATH=/system/bin:/system/xbin:$PATH
mount -o remount,rw /system
ln -s /system/usr/keychars/qwerty.kcm.bin /system/usr/keychars/qtouch-touchscreen.kcm.bin
ln -s /system/usr/keylayout/qwerty.kl /system/usr/keylayout/qtouch-touchscreen.kl

if [ -e /proc/device-tree/System@0/Keypad@0/name ]; then
	keypad_name=`cat /proc/device-tree/System@0/Keypad@0/name`
	keypad_type=`getprop persist.sys.keypad_type`
	if [ "x$keypad_name" != "x" ]; then
		ln -s /system/usr/keylayout/$keypad_name.kl /system/usr/keylayout/sholes-keypad.kl
		rm -f /system/usr/keychars/sholes-keypad.kcm.bin
		ln -s /system/usr/keychars/$keypad_name-$keypad_type.kcm.bin /system/usr/keychars/sholes-keypad.kcm.bin
	fi
fi
mount -o remount,ro /system

