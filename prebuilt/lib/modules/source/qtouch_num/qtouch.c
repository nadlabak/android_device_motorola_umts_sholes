/*
 * qtouch_num - set number of multitouch points for Milestone, by Nadlabak
 * hooking taken from "n - for testing kernel function hooking" by Nothize
 * uses symsearch module by Skrilax
 *
 * number of touches can be set by write to /proc/qtouch/num_touch (2-10)
 * the screen has to be on (touchscreen active) at the time of write
 *
 * Copyright (C) 2011 Nadlabak
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
#include <linux/earlysuspend.h>
#include <linux/qtouch_obp_ts.h>
#include <linux/proc_fs.h>
#include <linux/vmalloc.h>
#include <asm/uaccess.h>

#include "hook.h"
#include "symsearch.h"

#define BUF_SIZE 16
static char *buf;

struct qtm_object {
	struct qtm_obj_entry		entry;
	uint8_t				report_id_min;
	uint8_t				report_id_max;
};

struct coordinate_map {
	int x_data;
	int y_data;
	int z_data;
	int w_data;
	int down;
};

#define _BITMAP_LEN			BITS_TO_LONGS(QTM_OBP_MAX_OBJECT_NUM)
#define _NUM_FINGERS			10
struct qtouch_ts_data {
	struct i2c_client		*client;
	struct input_dev		*input_dev;
	struct work_struct		init_work;
	struct work_struct		work;
	struct work_struct		boot_work;
	struct qtouch_ts_platform_data	*pdata;
	struct coordinate_map		finger_data[_NUM_FINGERS];
	struct early_suspend		early_suspend;

	struct qtm_object		obj_tbl[QTM_OBP_MAX_OBJECT_NUM];
	unsigned long			obj_map[_BITMAP_LEN];

	uint32_t			last_keystate;
	uint16_t			eeprom_checksum;
	uint8_t				checksum_cnt;
	int				x_delta;
	int				y_delta;
	uint8_t				family_id;
	uint8_t				variant_id;
	uint8_t				fw_version;
	uint8_t				build_version;
	uint8_t				fw_error_count;
	uint32_t			touch_fw_size;
	uint8_t				*touch_fw_image;
	uint8_t				base_fw_version;

	atomic_t			irq_enabled;
	int				status;

	uint8_t				mode;
	int				boot_pkt_size;
	int				current_pkt_sz;
	uint8_t				org_i2c_addr;

	uint8_t				*msg_buf;
	int				msg_size;
};

uint16_t eeprom_checksum;
bool checksumNeedsCorrection = false;
struct qtouch_ts_data *ts_;
uint8_t num_touch = 0;

SYMSEARCH_DECLARE_FUNCTION_STATIC(int, ss_mapphone_touch_reset);

/* used to find out ts address */
static int qtouch_read(struct qtouch_ts_data *ts, void *buf, int buf_sz) {
	if (!ts_) {
		ts_ = ts;
		printk(KERN_INFO "qtouch_num: ts address is 0x%lx. \n", ts);
	}
	return HOOK_INVOKE(qtouch_read, ts, buf, buf_sz);
}

static int qtouch_hw_init(struct qtouch_ts_data *ts) {
	if (checksumNeedsCorrection) {
		ts->eeprom_checksum = eeprom_checksum;
		checksumNeedsCorrection = false;
	}
	return HOOK_INVOKE(qtouch_hw_init, ts);
}

static int proc_qtouch_num_read(char *buffer, char **buffer_location,
		off_t offset, int count, int *eof, void *data) {
	int ret;
	if (offset > 0)
		ret = 0;
	else
		ret = scnprintf(buffer, count, "%u\n", num_touch);
	return ret;
}

static int proc_qtouch_num_write(struct file *filp, const char __user *buffer,
		unsigned long len, void *data) {
	uint8_t new_num_touch;
	if (!len || len >= BUF_SIZE)
		return -ENOSPC;
	if (copy_from_user(buf, buffer, len))
		return -EFAULT;
	buf[len] = 0;
	if (sscanf(buf, "%u", &new_num_touch) == 1) {
		if (new_num_touch > 10) new_num_touch = 10;
		else if (new_num_touch < 2) new_num_touch = 2;
		if (num_touch != new_num_touch) {
			num_touch = new_num_touch;
			if (ts_) {
				ts_->pdata->multi_touch_cfg.num_touch = num_touch;
				printk(KERN_INFO "qtouch_num: num_touch set to %u \n",num_touch);
				printk(KERN_INFO "qtouch_num: forcing checksum error to run qtouch_hw_init\n");
				ts_->pdata->flags |= QTOUCH_EEPROM_CHECKSUM;
				eeprom_checksum = ts_->eeprom_checksum;
				ts_->eeprom_checksum = 0;
				ts_->checksum_cnt = 0;
				checksumNeedsCorrection = true;
				ss_mapphone_touch_reset();
			} else
				printk(KERN_INFO "qtouch_num: ts address not set!\n");
				printk(KERN_INFO "qtouch_num: was the screen off at the time of insmod?\n");
		}
	} else
		printk(KERN_INFO "qtouh_num: wrong parameter for num_touch\n");
	return len;
}

struct hook_info g_hi[] = {
	HOOK_INIT(qtouch_read),
	HOOK_INIT(qtouch_hw_init),
	HOOK_INIT_END
};

static int __init qtouch_init(void) {
	struct proc_dir_entry *proc_entry;
	SYMSEARCH_BIND_FUNCTION_TO(qtouch_num, mapphone_touch_reset, ss_mapphone_touch_reset);
	buf = (char *)vmalloc(BUF_SIZE);
	proc_mkdir("qtouch", NULL);
	proc_entry = create_proc_read_entry("qtouch/num_touch", 0644, NULL, proc_qtouch_num_read, NULL);
	proc_entry->write_proc = proc_qtouch_num_write;
	hook_init();
	/* reset will provoke qtouch_read call, so we can get the ts struct address immediately */
	ss_mapphone_touch_reset();
	return 0;
}

static void __exit qtouch_exit(void) {
	hook_exit();
        remove_proc_entry("qtouch/num_touch", NULL);
	remove_proc_entry("qtouch", NULL);
	vfree(buf);
}

module_init(qtouch_init);
module_exit(qtouch_exit);

MODULE_ALIAS("QTOUCH_NUM");
MODULE_DESCRIPTION("change qtouch num_touch via kernel function hook");
MODULE_AUTHOR("Nadlabak");
MODULE_LICENSE("GPL");
