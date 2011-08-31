/*
 * DSI/MMC/NAND-fix v2.61
 * - fix display freezes and kernel panics caused by DSS/DSI kernel drivers
 * used in stock Milestone kernel for Froyo by function hooking - added error
 * recovery calls and other modifications.
 * - fix SD card read/write errors (mmcblk0: error -110 - common and known
 * linux-omap issue) by replacement of set_data_timeout function in omap_hsmmc.c
 * to use the default DTO value of 0xE instead of dynamic calculation.
 * - disable duplicated NAND suspend/resume calls to get rid of the
 * "nand_resume called for a chip which is not in suspend_state" messages.
 *
 * hooking taken from "n - for testing kernel function hooking" by Nothize.
 * depends on symsearch module by Skrilax_CZ
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

#include <linux/device.h>
#include <linux/io.h>
#include <linux/kallsyms.h>
#include <linux/module.h>
#include <plat/display.h>
#include "dss.h"
#include "hook.h"
#include "symsearch.h"

#define DTO			0xe
#define DTO_MASK		0x000F0000
#define DTO_SHIFT		16
#define OMAP_HSMMC_SYSCTL	0x012C

/*
 * MMC Host controller read/write API's
 */
#define OMAP_HSMMC_READ(base, reg)	\
	__raw_readl((base) + OMAP_HSMMC_##reg)

#define OMAP_HSMMC_WRITE(base, reg, val) \
	__raw_writel((val), (base) + OMAP_HSMMC_##reg)

struct omap_hsmmc_host {
	struct	device		*dev;
	struct	mmc_host	*mmc;
	struct	mmc_request	*mrq;
	struct	mmc_command	*cmd;
	struct	mmc_data	*data;
	struct	clk		*fclk;
	struct	clk		*iclk;
	struct	clk		*dbclk;
	struct	semaphore	sem;
	struct	work_struct	mmc_carddetect_work;
	void	__iomem		*base;
	resource_size_t		mapbase;
	spinlock_t		irq_lock; /* Prevent races with irq handler */
	unsigned long		flags;
	unsigned int		id;
	unsigned int		dma_len;
	unsigned int		dma_sg_idx;
	unsigned char		bus_mode;
	unsigned char		power_mode;
	u32			*buffer;
	u32			bytesleft;
	int			suspended;
	int			irq;
	int			use_dma, dma_ch;
	int			dma_line_tx, dma_line_rx;
	int			slot_id;
	int			got_dbclk;
	int			response_busy;
	int			context_loss;
	int			dpm_state;
	int			vdd;
	int			protect_card;
	int			reqs_blocked;

	struct	omap_mmc_platform_data	*pdata;
};

// #define DSI_STRUCT_ADDR 0xc05547f0
// - not used anymore, autodetected

#define EDISCO_CMD_SET_COLUMN_ADDRESS	0x2A
#define EDISCO_CMD_SET_PAGE_ADDRESS	0x2B
#define EDISCO_CMD_VC   0

#define DSI_CATCH_MISSING_TE
#define MOT_DISP_430_MIPI_480_854_CM    0x001a0000
#define MOT_DISP_370_MIPI_480_854_CM    0x001a0001

#define DSI_CMD_VC   1
#define DSI_VIDEO_VC 0

#define DSI_BASE		0x4804FC00

struct dsi_reg { u16 idx; };

#define DSI_REG(idx)		((const struct dsi_reg) { idx })

#define DSI_SZ_REGS		SZ_1K
/* DSI Protocol Engine */

#define DSI_REVISION			DSI_REG(0x0000)
#define DSI_SYSCONFIG			DSI_REG(0x0010)
#define DSI_SYSSTATUS			DSI_REG(0x0014)
#define DSI_IRQSTATUS			DSI_REG(0x0018)
#define DSI_IRQENABLE			DSI_REG(0x001C)
#define DSI_CTRL			DSI_REG(0x0040)
#define DSI_COMPLEXIO_CFG1		DSI_REG(0x0048)
#define DSI_COMPLEXIO_IRQ_STATUS	DSI_REG(0x004C)
#define DSI_COMPLEXIO_IRQ_ENABLE	DSI_REG(0x0050)
#define DSI_CLK_CTRL			DSI_REG(0x0054)
#define DSI_TIMING1			DSI_REG(0x0058)
#define DSI_TIMING2			DSI_REG(0x005C)
#define DSI_VM_TIMING1			DSI_REG(0x0060)
#define DSI_VM_TIMING2			DSI_REG(0x0064)
#define DSI_VM_TIMING3			DSI_REG(0x0068)
#define DSI_CLK_TIMING			DSI_REG(0x006C)
#define DSI_TX_FIFO_VC_SIZE		DSI_REG(0x0070)
#define DSI_RX_FIFO_VC_SIZE		DSI_REG(0x0074)
#define DSI_COMPLEXIO_CFG2		DSI_REG(0x0078)
#define DSI_RX_FIFO_VC_FULLNESS		DSI_REG(0x007C)
#define DSI_VM_TIMING4			DSI_REG(0x0080)
#define DSI_TX_FIFO_VC_EMPTINESS	DSI_REG(0x0084)
#define DSI_VM_TIMING5			DSI_REG(0x0088)
#define DSI_VM_TIMING6			DSI_REG(0x008C)
#define DSI_VM_TIMING7			DSI_REG(0x0090)
#define DSI_STOPCLK_TIMING		DSI_REG(0x0094)
#define DSI_VC_CTRL(n)			DSI_REG(0x0100 + (n * 0x20))
#define DSI_VC_TE(n)			DSI_REG(0x0104 + (n * 0x20))
#define DSI_VC_LONG_PACKET_HEADER(n)	DSI_REG(0x0108 + (n * 0x20))
#define DSI_VC_LONG_PACKET_PAYLOAD(n)	DSI_REG(0x010C + (n * 0x20))
#define DSI_VC_SHORT_PACKET_HEADER(n)	DSI_REG(0x0110 + (n * 0x20))
#define DSI_VC_IRQSTATUS(n)		DSI_REG(0x0118 + (n * 0x20))
#define DSI_VC_IRQENABLE(n)		DSI_REG(0x011C + (n * 0x20))

/* DSIPHY_SCP */

#define DSI_DSIPHY_CFG0			DSI_REG(0x200 + 0x0000)
#define DSI_DSIPHY_CFG1			DSI_REG(0x200 + 0x0004)
#define DSI_DSIPHY_CFG2			DSI_REG(0x200 + 0x0008)
#define DSI_DSIPHY_CFG5			DSI_REG(0x200 + 0x0014)

/* DSI_PLL_CTRL_SCP */

#define DSI_PLL_CONTROL			DSI_REG(0x300 + 0x0000)
#define DSI_PLL_STATUS			DSI_REG(0x300 + 0x0004)
#define DSI_PLL_GO			DSI_REG(0x300 + 0x0008)
#define DSI_PLL_CONFIGURATION1		DSI_REG(0x300 + 0x000C)
#define DSI_PLL_CONFIGURATION2		DSI_REG(0x300 + 0x0010)

#define REG_GET(idx, start, end) \
	FLD_GET(dsi_read_reg(idx), start, end)

#define REG_FLD_MOD(idx, val, start, end) \
	dsi_write_reg(idx, FLD_MOD(dsi_read_reg(idx), val, start, end))

/* Global interrupts */
#define DSI_IRQ_VC0		(1 << 0)
#define DSI_IRQ_VC1		(1 << 1)
#define DSI_IRQ_VC2		(1 << 2)
#define DSI_IRQ_VC3		(1 << 3)
#define DSI_IRQ_WAKEUP		(1 << 4)
#define DSI_IRQ_RESYNC		(1 << 5)
#define DSI_IRQ_PLL_LOCK	(1 << 7)
#define DSI_IRQ_PLL_UNLOCK	(1 << 8)
#define DSI_IRQ_PLL_RECALL	(1 << 9)
#define DSI_IRQ_COMPLEXIO_ERR	(1 << 10)
#define DSI_IRQ_HS_TX_TIMEOUT	(1 << 14)
#define DSI_IRQ_LP_RX_TIMEOUT	(1 << 15)
#define DSI_IRQ_TE_TRIGGER	(1 << 16)
#define DSI_IRQ_ACK_TRIGGER	(1 << 17)
#define DSI_IRQ_SYNC_LOST	(1 << 18)
#define DSI_IRQ_LDO_POWER_GOOD	(1 << 19)
#define DSI_IRQ_TA_TIMEOUT	(1 << 20)
#define DSI_IRQ_ERROR_MASK \
	(DSI_IRQ_HS_TX_TIMEOUT | DSI_IRQ_LP_RX_TIMEOUT | DSI_IRQ_SYNC_LOST | \
	DSI_IRQ_TA_TIMEOUT)
#define DSI_IRQ_CHANNEL_MASK	0xf

/* Virtual channel interrupts */
#define DSI_VC_IRQ_CS		(1 << 0)
#define DSI_VC_IRQ_ECC_CORR	(1 << 1)
#define DSI_VC_IRQ_PACKET_SENT	(1 << 2)
#define DSI_VC_IRQ_FIFO_TX_OVF	(1 << 3)
#define DSI_VC_IRQ_FIFO_RX_OVF	(1 << 4)
#define DSI_VC_IRQ_BTA		(1 << 5)
#define DSI_VC_IRQ_ECC_NO_CORR	(1 << 6)
#define DSI_VC_IRQ_FIFO_TX_UDF	(1 << 7)
#define DSI_VC_IRQ_PP_BUSY_CHANGE (1 << 8)
#define DSI_VC_IRQ_ERROR_MASK \
	(DSI_VC_IRQ_CS | DSI_VC_IRQ_ECC_CORR | DSI_VC_IRQ_FIFO_TX_OVF | \
	DSI_VC_IRQ_FIFO_RX_OVF | DSI_VC_IRQ_ECC_NO_CORR | \
	DSI_VC_IRQ_FIFO_TX_UDF)

/* ComplexIO interrupts */
#define DSI_CIO_IRQ_ERRSYNCESC1		(1 << 0)
#define DSI_CIO_IRQ_ERRSYNCESC2		(1 << 1)
#define DSI_CIO_IRQ_ERRSYNCESC3		(1 << 2)
#define DSI_CIO_IRQ_ERRESC1		(1 << 5)
#define DSI_CIO_IRQ_ERRESC2		(1 << 6)
#define DSI_CIO_IRQ_ERRESC3		(1 << 7)
#define DSI_CIO_IRQ_ERRCONTROL1		(1 << 10)
#define DSI_CIO_IRQ_ERRCONTROL2		(1 << 11)
#define DSI_CIO_IRQ_ERRCONTROL3		(1 << 12)
#define DSI_CIO_IRQ_STATEULPS1		(1 << 15)
#define DSI_CIO_IRQ_STATEULPS2		(1 << 16)
#define DSI_CIO_IRQ_STATEULPS3		(1 << 17)
#define DSI_CIO_IRQ_ERRCONTENTIONLP0_1	(1 << 20)
#define DSI_CIO_IRQ_ERRCONTENTIONLP1_1	(1 << 21)
#define DSI_CIO_IRQ_ERRCONTENTIONLP0_2	(1 << 22)
#define DSI_CIO_IRQ_ERRCONTENTIONLP1_2	(1 << 23)
#define DSI_CIO_IRQ_ERRCONTENTIONLP0_3	(1 << 24)
#define DSI_CIO_IRQ_ERRCONTENTIONLP1_3	(1 << 25)
#define DSI_CIO_IRQ_ULPSACTIVENOT_ALL0	(1 << 30)
#define DSI_CIO_IRQ_ULPSACTIVENOT_ALL1	(1 << 31)

#define DSI_DT_DCS_SHORT_WRITE_0	0x05
#define DSI_DT_DCS_SHORT_WRITE_1	0x15
#define DSI_DT_DCS_READ			0x06
#define DSI_DT_SET_MAX_RET_PKG_SIZE	0x37
#define DSI_DT_NULL_PACKET		0x09
#define DSI_DT_DCS_LONG_WRITE		0x39

#define DSI_DT_RX_ACK_WITH_ERR		0x02
#define DSI_DT_RX_DCS_LONG_READ		0x1c
#define DSI_DT_RX_SHORT_READ_1		0x21
#define DSI_DT_RX_SHORT_READ_2		0x22

#define FINT_MAX 2200000
#define FINT_MIN 750000
#define REGN_MAX (1 << 7)
#define REGM_MAX ((1 << 11) - 1)
#define REGM3_MAX (1 << 4)
#define REGM4_MAX (1 << 4)
#define LP_DIV_MAX ((1 << 13) - 1)

enum fifo_size {
	DSI_FIFO_SIZE_0		= 0,
	DSI_FIFO_SIZE_32	= 1,
	DSI_FIFO_SIZE_64	= 2,
	DSI_FIFO_SIZE_96	= 3,
	DSI_FIFO_SIZE_128	= 4,
};

enum dsi_vc_mode {
	DSI_VC_MODE_L4 = 0,
	DSI_VC_MODE_VP,
};

struct dsi_update_region {
	bool dirty;
	u16 x, y, w, h;
	struct omap_dss_device *device;
};

static struct dsi_struct
{
	void __iomem	*base;

	struct dsi_clock_info current_cinfo;

	struct regulator *vdds_dsi_reg;

	struct {
		enum dsi_vc_mode mode;
		struct omap_dss_device *dssdev;
		enum fifo_size fifo_size;
		int dest_per;	/* destination peripheral 0-3 */
	} vc[4];

	struct mutex lock;
	struct mutex bus_lock;

	unsigned pll_locked;

	struct completion bta_completion;
	struct completion packet_sent_completion;


	struct task_struct *thread;
	wait_queue_head_t waitqueue;

	spinlock_t update_lock;
	bool framedone_received;
	struct dsi_update_region update_region;
	struct dsi_update_region active_update_region;
	struct completion update_completion;

	enum omap_dss_update_mode user_update_mode;
	enum omap_dss_update_mode update_mode;
	bool te_enabled;
	bool use_ext_te;

#ifdef DSI_CATCH_MISSING_TE
	struct timer_list te_timer;
#endif

	unsigned long cache_req_pck;
	unsigned long cache_clk_freq;
	struct dsi_clock_info cache_cinfo;

	u32		errors;
	spinlock_t	errors_lock;
#ifdef DEBUG
	ktime_t perf_setup_time;
	ktime_t perf_start_time;
	ktime_t perf_start_time_auto;
	int perf_measure_frames;
#endif
	int debug_read;
	int debug_write;

	struct {
		struct work_struct work;
		struct omap_dss_device *dssdev;
		bool enabled;
		bool recovering;
	} error_recovery;
};

struct dsi_struct *dsi;
// u16 xlast, ylast, wlast, hlast = 0;
void *p_dsi_update_thread_start;
void *p_dsi_update_thread_end;
bool framedonetimeout = false;

SYMSEARCH_DECLARE_FUNCTION_STATIC(const char *, ss_kallsyms_lookup, unsigned long, unsigned long *, unsigned long *, char **, char *);
SYMSEARCH_DECLARE_FUNCTION_STATIC(void, ss_dss_clk_enable, enum dss_clock);
SYMSEARCH_DECLARE_FUNCTION_STATIC(void, ss_dss_clk_disable, enum dss_clock);
SYMSEARCH_DECLARE_FUNCTION_STATIC(void, ss_dsi_display_uninit_dispc, struct omap_dss_device *);
SYMSEARCH_DECLARE_FUNCTION_STATIC(void, ss_dsi_display_uninit_dsi, struct omap_dss_device *);
SYMSEARCH_DECLARE_FUNCTION_STATIC(int, ss_dsi_display_resume, struct omap_dss_device *);
SYMSEARCH_DECLARE_FUNCTION_STATIC(int, ss__dsi_reset);
SYMSEARCH_DECLARE_FUNCTION_STATIC(int, ss_dsi_core_init);
SYMSEARCH_DECLARE_FUNCTION_STATIC(int, ss_dsi_display_init_dispc, struct omap_dss_device *);
SYMSEARCH_DECLARE_FUNCTION_STATIC(int, ss_dsi_display_init_dsi, struct omap_dss_device *);
SYMSEARCH_DECLARE_FUNCTION_STATIC(int, ss_dsi_set_te, struct omap_dss_device *, bool);
SYMSEARCH_DECLARE_FUNCTION_STATIC(int, ss_dsi_set_update_mode, struct omap_dss_device *, enum omap_dss_update_mode);
SYMSEARCH_DECLARE_FUNCTION_STATIC(int, ss_dsi_force_tx_stop_mode_io);
SYMSEARCH_DECLARE_FUNCTION_STATIC(int, ss_dsi_vc_enable, int, bool);
SYMSEARCH_DECLARE_FUNCTION_STATIC(void, ss_dsi_show_rx_ack_with_err, u16);
SYMSEARCH_DECLARE_ADDRESS_STATIC(dsi_irq_handler);


// needed functions from dsi.c that are not available to symsearch

static inline void dsi_write_reg(const struct dsi_reg idx, u32 val)
{
	__raw_writel(val, dsi->base + idx.idx);
}

static inline u32 dsi_read_reg(const struct dsi_reg idx)
{
	return __raw_readl(dsi->base + idx.idx);
}

static inline int wait_for_bit_change(const struct dsi_reg idx, int bitnum,
		int value)
{
	int t = 100000;

	while (REG_GET(idx, bitnum, bitnum) != value) {
		if (--t == 0)
			return !value;
	}

	return value;
}

static inline void enable_clocks(bool enable)
{
	if (enable)
		ss_dss_clk_enable(DSS_CLK_ICK | DSS_CLK_FCK1);
	else
		ss_dss_clk_disable(DSS_CLK_ICK | DSS_CLK_FCK1);
}

static inline void dsi_enable_pll_clock(bool enable)
{
	if (enable)
		ss_dss_clk_enable(DSS_CLK_FCK2);
	else
		ss_dss_clk_disable(DSS_CLK_FCK2);

	if (enable && dsi->pll_locked) {
		if (wait_for_bit_change(DSI_PLL_STATUS, 1, 1) != 1)
			DSSERR("cannot lock PLL when enabling clocks\n");
	}
}

static inline int dsi_if_enable(bool enable)
{
	DSSDBG("dsi_if_enable(%d)\n", enable);

	enable = enable ? 1 : 0;
	REG_FLD_MOD(DSI_CTRL, enable, 0, 0); /* IF_EN */

	if (wait_for_bit_change(DSI_CTRL, 0, enable) != enable) {
			DSSERR("Failed to set dsi_if_enable to %d\n", enable);
			return -EIO;
	}

	return 0;
}

static void schedule_error_recovery(void)
{
	if (dsi->error_recovery.enabled && !dsi->error_recovery.recovering)
		schedule_work(&dsi->error_recovery.work);
}

static void dsi_vc_flush_long_data(int channel)
{
	while (REG_GET(DSI_VC_CTRL(channel), 20, 20)) {
		u32 val;
		val = dsi_read_reg(DSI_VC_SHORT_PACKET_HEADER(channel));
		DSSDBG("\t\tb1 %#02x b2 %#02x b3 %#02x b4 %#02x\n",
				(val >> 0) & 0xff,
				(val >> 8) & 0xff,
				(val >> 16) & 0xff,
				(val >> 24) & 0xff);
	}
}


// custom functions

static int dsi_do_display_suspend(struct omap_dss_device *dssdev)
{
	DSSDBG("dsi_do_display_suspend\n");

	complete_all(&dsi->update_completion);

	if (dssdev->state == OMAP_DSS_DISPLAY_DISABLED ||
			dssdev->state == OMAP_DSS_DISPLAY_SUSPENDED)
		return 0;

	dsi->update_mode = OMAP_DSS_UPDATE_DISABLED;
	dssdev->state = OMAP_DSS_DISPLAY_SUSPENDED;

	dsi->update_region.dirty = false;

	enable_clocks(1);
	dsi_enable_pll_clock(1);

	ss_dsi_display_uninit_dispc(dssdev);

	ss_dsi_display_uninit_dsi(dssdev);

	enable_clocks(0);
	dsi_enable_pll_clock(0);

	return 0;
}

static int dsi_do_display_resume(struct omap_dss_device *dssdev)
{
	int r;

	DSSDBG("dsi_do_display_resume\n");

	if (dssdev->state != OMAP_DSS_DISPLAY_SUSPENDED) {
		DSSERR("dssdev not suspended\n");
		r = -EINVAL;
		goto err0;
	}

	enable_clocks(1);
	dsi_enable_pll_clock(1);

	r = ss__dsi_reset();
	if (r)
		goto err1;

	ss_dsi_core_init();

	r = ss_dsi_display_init_dispc(dssdev);
	if (r)
		goto err1;

	r = ss_dsi_display_init_dsi(dssdev);
	if (r)
		goto err2;

	dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;

	r = ss_dsi_set_te(dssdev, dsi->te_enabled);
	if (r)
		goto err2;

	ss_dsi_set_update_mode(dssdev, dsi->user_update_mode);

	enable_clocks(0);
	dsi_enable_pll_clock(0);

	return 0;

err2:
	ss_dsi_display_uninit_dispc(dssdev);
err1:
	enable_clocks(0);
	dsi_enable_pll_clock(0);
err0:
	DSSDBG("dsi_do_display_resume FAILED\n");
	return r;
}


// hooked functions:

// MMC
static void set_data_timeout(struct omap_hsmmc_host *host,
			     unsigned int timeout_ns,
			     unsigned int timeout_clks)
{
	uint32_t reg;

//	printk(KERN_INFO "DSI/MMC-fix: set_data_timeout called\n");
	reg = OMAP_HSMMC_READ(host->base, SYSCTL);

	reg &= ~DTO_MASK;
	reg |= DTO << DTO_SHIFT;
	OMAP_HSMMC_WRITE(host->base, SYSCTL, reg);
	if (0) HOOK_INVOKE(set_data_timeout, host, timeout_ns, timeout_clks);
}

// NAND
static int omap_nand_suspend(struct platform_device *pdev, pm_message_t state)
{
	if (0) HOOK_INVOKE(omap_nand_suspend, pdev, state);
	return 0;
}
static int omap_nand_resume(struct platform_device *pdev)
{
	if (0) HOOK_INVOKE(omap_nand_resume, pdev);
	return 0;
}

// DSI
static int dsi_display_suspend(struct omap_dss_device *dssdev)
{
	mutex_lock(&dsi->lock);
	dsi_bus_lock();
	dsi_do_display_suspend(dssdev);
	dsi_do_display_resume(dssdev);
	dsi_bus_unlock();
	mutex_unlock(&dsi->lock);
	return HOOK_INVOKE(dsi_display_suspend, dssdev);
}

static u16 dsi_vc_flush_receive_data(int channel)
{
	/* RX_FIFO_NOT_EMPTY */
	while (REG_GET(DSI_VC_CTRL(channel), 20, 20)) {
		u32 val;
		u8 dt;
		val = dsi_read_reg(DSI_VC_SHORT_PACKET_HEADER(channel));
		DSSDBG("\trawval %#08x\n", val);
		dt = FLD_GET(val, 5, 0);
		if (dt == DSI_DT_RX_ACK_WITH_ERR) {
			u16 err = FLD_GET(val, 23, 8);
			ss_dsi_show_rx_ack_with_err(err);
			schedule_error_recovery();
		} else if (dt == DSI_DT_RX_SHORT_READ_1) {
			DSSDBG("\tDCS short response, 1 byte: %#x\n",
					FLD_GET(val, 23, 8));
		} else if (dt == DSI_DT_RX_SHORT_READ_2) {
			DSSDBG("\tDCS short response, 2 byte: %#x\n",
					FLD_GET(val, 23, 8));
		} else if (dt == DSI_DT_RX_DCS_LONG_READ) {
			DSSDBG("\tDCS long response, len %d\n",
					FLD_GET(val, 23, 8));
			dsi_vc_flush_long_data(channel);
		} else {
			DSSERR("\tunknown datatype 0x%02x\n", dt);
		}
	}
	if (0) return HOOK_INVOKE(dsi_vc_flush_receive_data, channel);
	return 0;
}

static void dsi_error_recovery_worker(struct work_struct *work)
{
	u32 r;
	struct omap_dss_device *dssdev = dsi->error_recovery.dssdev;

	printk(KERN_INFO "DSI-fix: recovering from error\n");

	mutex_lock(&dsi->lock);

	if (!dsi->error_recovery.enabled)
		goto end;

	dsi_bus_lock();

	dsi->error_recovery.recovering = true;

	enable_clocks(1);
	dsi_enable_pll_clock(1);
	ss_dsi_force_tx_stop_mode_io();

	r = dsi_read_reg(DSI_TIMING1);
	r = FLD_MOD(r, 0, 15, 15);	/* FORCE_TX_STOP_MODE_IO */
	dsi_write_reg(DSI_TIMING1, r);

	ss_dsi_vc_enable(0, 0);
	ss_dsi_vc_enable(1, 0);

	dsi_if_enable(0);

	ss_dsi_vc_enable(0, 1);
	ss_dsi_vc_enable(1, 1);

	dsi_if_enable(1);

	ss_dsi_force_tx_stop_mode_io();

	enable_clocks(0);
	dsi_enable_pll_clock(0);

	/* Now check to ensure there is communication. */
	/* If not, we need to hard reset */
	if (dssdev->driver->run_test) {
		if (framedonetimeout || dssdev->driver->run_test(dssdev, 1) != 0) {
			printk(KERN_INFO "DSI-fix: framedone timeout - doing hard reset \n");
			dsi_do_display_suspend(dssdev);
			dsi_do_display_resume(dssdev);
			framedonetimeout = false;
		}
	}

	dsi->error_recovery.recovering = false;

	dsi_bus_unlock();

end:
	mutex_unlock(&dsi->lock);
	if (0) HOOK_INVOKE(dsi_error_recovery_worker, work);
} 

/* unused for now...
int dsi_vc_send_bta_sync(int channel)
{
	// suppress dsi_vc_send_bta_sync call if it comes from dsi_update_thread
	void *p;
	p = __builtin_return_address(0);
	if (p > p_dsi_update_thread_start && p < p_dsi_update_thread_end) {
		return 0;
	} else {
		return HOOK_INVOKE(dsi_vc_send_bta_sync, channel);
	}
}


static void mapphone_panel_setup_update(struct omap_dss_device *dssdev,
				      u16 x, u16 y, u16 w, u16 h)
{
	u8 data[5];
	int ret;

//	printk(KERN_INFO "DSI-fix: x %d, y %d, w %d, h %d", x, y, w, h);
//	printk(KERN_INFO "DSI-fix: xlast %d, ylast %d, wlast %d, hlast %d", xlast, ylast, wlast, hlast);

	// set page, column address
	if (y != ylast || h != hlast) {
		data[0] = EDISCO_CMD_SET_PAGE_ADDRESS;
		data[1] = y >> 8;
		data[2] = y & 0xff;
		data[3] = (y + h - 1) >> 8;
		data[4] = (y + h - 1) & 0xff;
		ret = dsi_vc_dcs_write_nosync(EDISCO_CMD_VC, data, 5);
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
		ret = dsi_vc_dcs_write_nosync(EDISCO_CMD_VC, data, 5);
		if (ret)
			return;
		xlast = x;
		wlast = w;
	}
	if (0) HOOK_INVOKE(mapphone_panel_setup_update, dssdev, x, y, w, h);
}
*/

void dispc_enable_lcd_out(bool enable)
{
	void *p;
	p = __builtin_return_address(0);
	HOOK_INVOKE(dispc_enable_lcd_out, enable);
	if (!enable && p > p_dsi_update_thread_start && p < p_dsi_update_thread_end)
	{
		/* framedone timeout happened */
		framedonetimeout = true;
		schedule_error_recovery();
	}
}

// find the dsi structure address
void find_dsi_struct_addr(void)
{
	unsigned char *func = (void *)SYMSEARCH_GET_ADDRESS(dsi_irq_handler);
	uint *addr;
	int i;

	for(i = 0; i < 100; i+=4) 
	{
		if((func[i+3] == 0xe5) /* ldr */
			&& func[i+2] == 0x9f) /* [pc, */
		{ 
			addr = (void *)((uint)func)+i+8+(func[i+1]&0x0f)*0x100+func[i];
			dsi = *addr;
			printk (KERN_INFO "DSI-fix: found dsi struct addr at 0x%x\n", dsi);
			break;
		}
	}
}

struct hook_info g_hi[] = {
	HOOK_INIT(set_data_timeout),
	HOOK_INIT(omap_nand_suspend),
	HOOK_INIT(omap_nand_resume),
	HOOK_INIT(dsi_display_suspend),
	HOOK_INIT(dsi_vc_flush_receive_data),
	HOOK_INIT(dsi_error_recovery_worker),
//	HOOK_INIT(dsi_vc_send_bta_sync),
//	HOOK_INIT(mapphone_panel_setup_update),
	HOOK_INIT(dispc_enable_lcd_out),
	HOOK_INIT_END
};

static int __init dsifix_init(void)
{
	unsigned long size;
	char name[KSYM_NAME_LEN];
	printk(KERN_INFO "DSI/MMC/NAND-fix v2.61");
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, kallsyms_lookup, ss_kallsyms_lookup);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dss_clk_disable, ss_dss_clk_disable);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dss_clk_enable, ss_dss_clk_enable);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_display_uninit_dispc, ss_dsi_display_uninit_dispc);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_display_uninit_dsi, ss_dsi_display_uninit_dsi);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_display_resume, ss_dsi_display_resume);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, _dsi_reset, ss__dsi_reset);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_core_init, ss_dsi_core_init);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_display_init_dispc, ss_dsi_display_init_dispc);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_display_init_dsi, ss_dsi_display_init_dsi);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_set_te, ss_dsi_set_te);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_set_update_mode, ss_dsi_set_update_mode);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_force_tx_stop_mode_io, ss_dsi_force_tx_stop_mode_io);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_vc_enable, ss_dsi_vc_enable);
	SYMSEARCH_BIND_FUNCTION_TO(dsifix, dsi_show_rx_ack_with_err, ss_dsi_show_rx_ack_with_err);
	SYMSEARCH_BIND_ADDRESS(dsifix, dsi_irq_handler);
	find_dsi_struct_addr();
	p_dsi_update_thread_start = lookup_symbol_address("dsi_update_thread");
	ss_kallsyms_lookup((unsigned long)p_dsi_update_thread_start, &size, NULL, NULL, name);
	p_dsi_update_thread_end = p_dsi_update_thread_start + size;
	hook_init();
	return 0;
}

static void __exit dsifix_exit(void)
{
	hook_exit();
}

module_init(dsifix_init);
module_exit(dsifix_exit);

MODULE_ALIAS("DSI/MMC/NAND-fix");
MODULE_DESCRIPTION("fix Milestone DSS/MMC/NAND drivers via kernel function hooks");
MODULE_AUTHOR("Nadlabak");
MODULE_LICENSE("GPL");
