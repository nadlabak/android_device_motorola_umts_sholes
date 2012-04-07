/*
 C *opyright (C) 2011 - 2012 Skrilax_CZ
 Based on Motorola Usb daemon
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <ctype.h>
#include <errno.h>
#include <sys/socket.h>
#include <linux/netlink.h>

#include <cutils/properties.h>
#define LOG_TAG "usbd"
#include <cutils/log.h>

#define USBD_VER "1.0_CM"

/* The following defines should be general for all Motorola phones */

#define PROPERTY_ADB_ENABLED                "persist.service.adb.enable"

/* usb status */
#define USB_MODEL_NAME_PATH                 "/sys/devices/platform/cpcap_battery/power_supply/usb/model_name"
#define USB_ONLINE_PATH                     "/sys/devices/platform/cpcap_battery/power_supply/usb/online"

/* input from model_name */
#define USB_INPUT_CABLE_NORMAL              "usb"
#define USB_INPUT_CABLE_FACTORY             "factory"

/* usb state */
#define USBD_STATE_CABLE_DISCONNECTED       0
#define USBD_STATE_CABLE_CONNECTED          1
#define USBD_STATE_GET_DESCRIPTOR           2
#define USBD_STATE_USB_ENUMERATED           3

/* cable events */
#define USBD_EVENT_CABLE_DISCONNECTED       "cable_disconnected"
#define USBD_EVENT_CABLE_CONNECTED          "cable_connected"
#define USBD_EVENT_GET_DESCRIPTOR           "get_descriptor"
#define USBD_EVENT_USB_ENUMERATED           "usb_enumerated"

/* adb status */
#define USBD_ADB_STATUS_ON                  "usbd_adb_status_on"
#define USBD_ADB_STATUS_OFF                 "usbd_adb_status_off"

/* event prefixes */
#define USBD_START_PREFIX                   "usbd_start_"
#define USBD_REQ_SWITCH_PREFIX              "usbd_req_switch_"
#define USB_MODE_PREFIX                     "usb_mode_"

/* response suffix */
#define USBD_RESP_OK                        ":ok"
#define USBD_RESP_FAIL                      ":fail"

/* adb suffix */
#define USB_MODE_ADB_SUFFIX                 "_adb"

/* structure */
struct usb_mode_info
{
	const char* apk_mode;
	const char* apk_mode_adb;
	const char* apk_start;
	const char* apk_req_switch;
	
	const char* kern_mode;
	const char* kern_mode_adb;
};

#define USB_MODE_INFO(apk,kern) \
{ \
.apk_mode =         USB_MODE_PREFIX       apk, \
.apk_mode_adb =     USB_MODE_PREFIX       apk   USB_MODE_ADB_SUFFIX, \
.apk_start =        USB_START_PREFIX      apk, \
.apk_req_switch =   USB_REQ_SWITCH_PREFIX apk, \
.kern_mode =                              kern, \
.kern_mode_adb =                          kern  USB_MODE_ADB_SUFFIX, \
}

/* The following defines have matching equivalents in usb.apk
 * and in kernel g_mot_android module (see mot_android.c)
 * if you change them here, don't forget to update them there
 * or you will break usb.
 *
 * On Motorola Milestone, the configuration is altered
 * in a module mot_usb.ko.
 */

/* usb modes for Usb.apk */
#define USB_APK_MODE_NGP              "ngp"
#define USB_APK_MODE_NGP_MTP          "ngp_mtp"
#define USB_APK_MODE_MTP              "mtp"
#define USB_APK_MODE_MODEM            "acm"
#define USB_APK_MODE_MSC              "msc"
#define USB_APK_MODE_RNDIS            "rndis"
#define USB_APK_MODE_CHARGE_ONLY      "charge_only"

/* usb modes for kernel */
#define USB_KERN_MODE_NET             "eth"
#define USB_KERN_MODE_NGP             "acm_eth"
#define USB_KERN_MODE_NGP_MTP         "acm_eth_mtp"
#define USB_KERN_MODE_MTP             "mtp"
#define USB_KERN_MODE_MODEM           "acm"
#define USB_KERN_MODE_MSC             "msc"
#define USB_KERN_MODE_RNDIS           "rndis"
#define USB_KERN_MODE_CHARGE_ONLY     "charge_only"

/* available modes */
static struct usb_mode_info usb_modes[] = 
{
	USB_MODE_INFO(USB_APK_MODE_NGP,         USB_KERN_MODE_NGP),
	USB_MODE_INFO(USB_APK_MODE_NGP_MTP,     USB_KERN_MODE_NGP_MTP),
	USB_MODE_INFO(USB_APK_MODE_MTP,         USB_KERN_MODE_MTP),
	USB_MODE_INFO(USB_APK_MODE_MODEM,       USB_KERN_MODE_MODEM),
	USB_MODE_INFO(USB_APK_MODE_MSC,         USB_KERN_MODE_MSC),
	USB_MODE_INFO(USB_APK_MODE_RNDIS,       USB_KERN_MODE_RNDIS),
	USB_MODE_INFO(USB_APK_MODE_CHARGE_ONLY, USB_KERN_MODE_CHARGE_ONLY),
};

/* File descriptors */
int uevent_fd = -1;
int listener_fd = -1;

/* Status variables */
int usb_current_mode = 0;
int usb_factory_cable = 0;
int usb_state = USBD_STATE_CABLE_DISCONNECTED;
int usb_online = 0;

/* Opens uevent socked for usbd */
int open_uevent_socket(void)
{
	struct sockaddr_nl addr;
	int sz = 64*1024;
	
	memset(&addr, 0, sizeof(addr));
	addr.nl_family = AF_NETLINK;
	addr.nl_pid = getpid();
	addr.nl_groups = 0xFFFFFFFF;
	
	uevent_fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);
	if (uevent_fd < 0)
	{
		LOGE("%s(): Unable to create uevent socket '%s'\n", __func__, strerror(errno));
		return -1;
	}
	
	if (setsockopt(uevent_fd, SOL_SOCKET, SO_RCVBUFFORCE, &sz, sizeof(sz)) < 0) 
	{
		LOGE("%s(): Unable to set uevent socket options '%s'\n", __func__, strerror(errno));
		return -1;
	}
	
	if (bind(uevent_fd, (struct sockaddr *) &addr, sizeof(addr)) < 0)
	{
		LOGE("%s(): Unable to bind uevent socket '%s'\n", __func__, strerror(errno));
		return -1;
	}
	
	return 0;
}

/* initialize usbd socket */
int init_usdb_socket()
{
	/* FIXME: magic */
	if (fd < 0)
	{
		LOGE("%s(): Obtaining file descriptor socket 'usbd' failed: %s\n", __func__, strerror(errno));
		return 1;
	}
	
	if (listen(fd, 4) < 0)
	{
		LOGE("%s(): Unable to listen on fd '%d' for socket 'usbd': %s", __func__, fd, strerror(errno));
		return 1;
	}
	
	return 0;
}

/* Gets adb status */
int get_adb_enabled_status(void)
{
	char buff[PROPERTY_VALUE_MAX];
	int ret;
	
	ret = property_get(PROPERTY_ADB_ENABLED, buff, "0");
	if (!ret)
		return -1;
	
	return (!strcmp(buff, "1"));
}

/* Sends adb status to usb.apk (or other listeners) */
int usbd_send_adb_status(int status)
{
	int ret;
	
	if (status == 1)
	{
		LOGI("%s(): Send ADB Enable message\n", __func__);
		ret = send_data(USBD_ADB_STATUS_ON, strlen(USBD_ADB_STATUS_ON) + 1);
		
	}
	else
	{
		LOGI("%s(): Send ADB Disable message\n", __func__);
		ret = send_data(USBD_ADB_STATUS_OFF, strlen(USBD_ADB_STATUS_OFF) + 1);
	}
	
	return ret <= 0; /*1 = fail */
	
}

/* Get usb mode index */
int usbd_get_mode_index(const char* mode, int apk)
{
	int i;
	
	for (i = 0; i < ARRAY_SIZE(usb_modes); i++)
	{
		if (apk)
		{
			if (!strncmp(mode, usb_modes[i].apk_mode), strlen(usb_modes[i].apk_mode))
				return i;
		}
		else
		{
			if (!strncmp(mode, usb_modes[i].kern_mode), strlen(usb_modes[i].kern_mode))
				return i;
		}
	}
	
	return -1;
}

/* Sets usb mode */
int usbd_set_usb_mode(int new_mode)
{
	int adb_sts;
	const char* mode_str;
	
	if (new_mode >= 0 && new_mode < ARRAY_SIZE(usb_modes))
	{		
		/* Moto gadget driver expects us to append "_adb" for adb on */
		if (get_adb_enabled_status() == 1)
			mode_str = usb_modes[new_mode].kern_mode_adb;
		else
			mode_str = usb_modes[new_mode].kern_mode;
		
		if (write(usb_mode_fd, mode_str, strlen(mode_str) + 1) < 0)
			return -1;
		
		usb_current_mode = new_mode;
		return 0;
	}
	else
	{
		LOGE("%s(): Cannot set usb mode to '%d'\n", __func__, new_mode);
		return 1;
	}
}

/* Get cable status */
int usbd_get_cable_status(void)
{
	char buf[256];
	FILE* f;
	
	/* get cable type */
	f = fopen(USB_MODEL_NAME_PATH, "r");
	
	if (!f)
	{
		LOGE("%s: Unable to open power_supply model_name file '%s'\n", __func__, strerror(errno));
		return -errno;
	}
	
	if (!fgets(buf, ARRAY_SIZE(buf), f))
	{
		fclose(f);
		LOGE("%s: Unable to read power supply model_name for cable type\n", __func__);
		return -EIO;
	}
	
	if (!strcmp(buf, USB_INPUT_CABLE_NORMAL))
		usb_factory_cable = 0;
	else if (!strcmp(buf, USB_INPUT_CABLE_FACTORY))
	{
		usb_factory_cable = 1;
		usbd_set_usb_mode(usbd_get_mode_index(USB_KERN_MODE_NET, 0));
	}
	
	fclose(f);
	
	/* get online status */
	f = fopen(USB_ONLINE_PATH, "r");
	
	if (!f)
	{
		LOGE("%s: Unable to open power_supply online file '%s'\n", __func__, strerror(errno));
		return -errno;
	}
	
	if (!fgets(buf, ARRAY_SIZE(buf), f))
	{
		fclose(f);
		LOGE("%s: Unable to read power supply online stat\n", __func__);
		return -EIO;
	}
	
	if (!strcmp(buf, "1"))
		usb_online = 1;
	else
		usb_online = 0;   
	
	fclose(f);
	
	return 0;
}

/* notify Usb.apk our current status */
int usbd_notify_current_status(int sockfd)
{
	const char* event_msg = NULL;
	
	if (usb_factory_cable)
		return 0;
	
	switch(usb_state)
	{
		case USBD_STATE_CABLE_DISCONNECTED:
			event_msg = USBD_EVENT_CABLE_DISCONNECTED;
			break;
			
		case USBD_STATE_CABLE_CONNECTED:
			event_msg = USBD_EVENT_CABLE_CONNECTED;
			break;
			
		case USBD_STATE_GET_DESCRIPTOR:
			event_msg = USBD_EVENT_GET_DESCRIPTOR;
			break;
			
		case USBD_STATE_USB_ENUMERATED:
			event_msg = USBD_EVENT_USB_ENUMERATED;
			break;
	}
	
	if (event_msg)
	{
		LOGI("%s(): Notifying App with Current Status : %s\n", __func__, event_msg);
		if (write(sockfd, event_msg, strlen(event_msg) + 1) < 0)
		{
			LOGE("%s(): Write Error : Notifying App with Current Status\n", __func__);
			return -1;
		}
	}
	//FIXME: check disassembly, there is some vars involved
	return 0;
}

/* Send usb mode to the Usb.apk */
int usbd_enum_process(int sockfd)
{
	char* mode;
	
	LOGI("%s(): current usb mode = %d\n", __func__, usb_current_mode);
	
	if (get_adb_enabled_status() == 1)
		mode = usb_modes[usb_current_mode].apk_mode_adb;
	else
		mode = usb_modes[usb_current_mode].apk_mode;
		
	if (write(sockfd, mode, strlen(mode) + 1) < 0)
	{
		LOGE("%s(): Socket Write Failure: %s\n", __func__, strerror(errno));
		return -1;
	}
	else
	{
		LOGE("%s(): enum done\n", __func__);
		return 0;
	}
	
}

/* socket event */
int usbd_socket_event(int sockfd)
{
	char buffer[1024];
	int res, new_mode;
	
	memset(buffer, 0, sizeof(buffer));
	res = read(sockfd, buffer, ARRAY_SIZE(buffer);
	
	if (res < 0)
	{
		LOGE("%s(): Socket Read Failure: %s", __func__, strerror(errno));
		return -1;
	}
	else if (res)
	{
		LOGI("%s(): recieved %s\n", __func__, buffer);
		new_mode = usbd_get_mode_index(buffer, 1);
		
		if (new_mode < 0)
		{
			LOGE("%s(): %s is not valid usb mode\n", __func__, buffer);
			return -1;
		}
		
		LOGI("%s(): Matched new usb mode = %d , current mode = %d\n", __func__, usb_current_mode, new_mode);
		
		if (new_mode != usb_current_mode)
		{
			usbd_set_usb_mode(new_mode);
			//FIXME: something is written back to sockfd
		}
		
		return 0;
	}
	else
	{
		LOGI("%s(): Socket Connection Closed\n", __func__);
		return -1;
	}
}

/* Process USB message */
int process_usb_uevent_message(int sockfd)
{
	char buffer[1024];
	
	
}

/* Usbd main */
int main(int argc, char **argv)
{
	LOGI("%s(): Start usbd - version " USBD_VER "\n", __func__);
	
	/* init uevent */
	LOGI("%s(): Initializing uevent_socket \n", __func__);
	if (open_uevent_socket())
		return 1;
	
	/* open device mode */
	LOGI("%s(): Initializing usb_device_mode \n", __func__);
	usb_mode_fd = open("/dev/usb_device_mode", O_RDONLY);
	
	if (usb_mode_fd < 0)
	{
		LOGE("%s(): Unable to open usb_device_mode '%s'\n", __func__, strerror(errno));
		return 1;
	}
	
	/* init usdb socket */
	if (init_usdb_socket() < 0)
	{
		LOGE("%s(): failed to create socket server '%s'\n", __func__, strerror(errno));
		return 1;
	}
	
	/* init cable status */
	if (usbd_get_cable_status() < 0)
	{
		LOGE("%s(): failed to get cable status (%s)\n", __func__);
		return 1;
	}
	
} 
