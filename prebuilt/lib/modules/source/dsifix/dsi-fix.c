/*
 * DSI-fix - add error recovery scheduling missing from dsi.c
 * (in Milestone 2.6.32 kernel), by Nadlabak
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

#include "hook.h"

//#define DEBUG
#ifdef DEBUG
#define INFO(format, ...) (printk(KERN_INFO "n:%s:%d " format, __FUNCTION__, __LINE__, ## __VA_ARGS__))
#else
#define INFO(format, ...)
#endif

#define DSI_STRUCT_ADDR 0xc05547f0

bool *enabled;
bool *recovering;
struct work_struct *work;

void dsi_show_rx_ack_with_err(u16 err)
{
	HOOK_INVOKE(dsi_show_rx_ack_with_err, err);
	if (err & (1 << 6)) {
		if (*enabled && !(*recovering)) {
			printk(KERN_INFO "DSI-fix: scheduling error recovery\n");
			schedule_work(work); 
		}
	}
}

struct hook_info g_hi[] = {
	HOOK_INIT(dsi_show_rx_ack_with_err),
	HOOK_INIT_END
};

static int __init dsifix_init(void)
{
        enabled = (bool *)(DSI_STRUCT_ADDR + 0x14c);
        recovering = (bool *)(DSI_STRUCT_ADDR + 0x14d);
        work = (void *)(DSI_STRUCT_ADDR + 0x138);
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
MODULE_DESCRIPTION("fix Milestone dsi.c via kernel function hook");
MODULE_AUTHOR("Nadlabak, Nothize");
MODULE_LICENSE("GPL");
