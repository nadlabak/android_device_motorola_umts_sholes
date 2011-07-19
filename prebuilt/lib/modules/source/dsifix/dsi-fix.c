/*
 * DSI-fix v2 - get rid of DSI False Control Errors by optimization - don't send
 * the coordinates to panel before every frame if they haven't changed, as in such
 * case they are already programmed, (for Milestone 2.6.32 kernel), by Nadlabak
 *
 * hooking taken from "n - for testing kernel function hooking" by Nothize.
 *
 * Copyright (C) 2011 Nadlabak, 2010 Nothize
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

#include <linux/module.h>
#include <linux/device.h>
#include <plat/display.h>
#include "hook.h"

//#define DSI_STRUCT_ADDR 0xc05547f0

#define EDISCO_CMD_SET_COLUMN_ADDRESS	0x2A
#define EDISCO_CMD_SET_PAGE_ADDRESS	0x2B
#define EDISCO_CMD_VC   0

u16 xlast, ylast, wlast, hlast = 0;

static void mapphone_panel_setup_update(struct omap_dss_device *dssdev,
				      u16 x, u16 y, u16 w, u16 h) {
	u8 data[5];
	int ret;

//	printk(KERN_INFO "DSI-fix: x %d, y %d, w %d, h %d", x, y, w, h);
//	printk(KERN_INFO "DSI-fix: xlast %d, ylast %d, wlast %d, hlast %d", xlast, ylast, wlast, hlast);

	/* set page, column address */
	if (y != ylast || h != hlast) {
		data[0] = EDISCO_CMD_SET_PAGE_ADDRESS;
		data[1] = y >> 8;
		data[2] = y & 0xff;
		data[3] = (y + h - 1) >> 8;
		data[4] = (y + h - 1) & 0xff;
		ret = dsi_vc_dcs_write(EDISCO_CMD_VC, data, 5);
		if (ret)
			return;
		ylast = y;
		hlast = h;
	}

	if (x != xlast || w != wlast) {
		data[0] = EDISCO_CMD_SET_COLUMN_ADDRESS;
		data[1] = x >> 8;
		data[2] = x & 0xff;
		data[3] = (x + w - 1) >> 8;
		data[4] = (x + w - 1) & 0xff;
		ret = dsi_vc_dcs_write(EDISCO_CMD_VC, data, 5);
		if (ret)
			return;
		xlast = x;
		wlast = w;
	}
}

struct hook_info g_hi[] = {
	HOOK_INIT(mapphone_panel_setup_update),
	HOOK_INIT_END
};

static int __init dsifix_init(void)
{
	hook_init();
	return 0;
}

static void __exit dsifix_exit(void)
{
	hook_exit();
}

module_init(dsifix_init);
module_exit(dsifix_exit);

MODULE_ALIAS("DSI-fix");
MODULE_DESCRIPTION("fix Milestone DSS drivers via kernel function hook");
MODULE_AUTHOR("Nadlabak");
MODULE_LICENSE("GPL");
