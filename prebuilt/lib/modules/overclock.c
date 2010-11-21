/*
	Motorola Milestone overclock module
	version 1.0-mapphone - 2010-11-19
	by Tiago Sousa <mirage@kaotik.org>, modified by nadlabak, Skrilax_CZ
	License: GNU GPLv2
	<http://www.gnu.org/licenses/old-licenses/gpl-2.0.html>

	http://code.google.com/p/milestone-overclock/

	Changelog:

	version 1.0-mapphone - 2010-11-19
	- automatic symbol detection
	- automatic values detection
	
	Description:

	The MPU (Microprocessor Unit) clock has 5 discrete pairs of possible
	rate frequencies and respective voltages, of which only 4 are passed
	down to cpufreq as you can see with a tool such as SetCPU.  The
	default frequencies are 125, 250, 500 and 550 MHz (and a hidden
	600).  By using this module, you are changing the highest pair in
	the tables of both cpufreq and MPU frequencies, so it becomes 125,
	250, 500 and, say, 800.  It's quite stable up to 1200; beyond
	that it quickly becomes unusable, specially over 1300, with lockups
	or spontaneous reboots.

	Usage:

	insmod overclock.ko
	echo 62 > /proc/overclock/max_vsel
	echo 800000 > /proc/overclock/max_rate
	
	You should set max_vsel before max_rate if the new rate is going to
	be higher than the current one, because higher frequencies often
	require more voltage than supplied by default.  Likewise, lower the
	max_rate first before max_vsel if you want to reduce both frequency
	and voltage:
	echo 550000 > /proc/overclock/max_rate
	echo 56 > /proc/overclock/max_vsel

	Remember that you are merely changing the maximum possible value
	that cpufreq can choose to use.  The current speed may well be lower
	than the one specified if the phone is idle.  I recommend the use of
	the SetCPU app to effectively change the current frequency through
	its policies (use Autodetect Speeds instead of Droid/Milestone
	profile in the device settings).

	You may also supply the addresses of the two needed in-memory kernel
	structures which may change with the firmware build and will
	probably have to be supplied either at load time with the
	freq_table_addr and mpu_opps_addr parameters or with their
	respective /proc entries.  You can ask the module to try to
	autodetect the values by specifying the parameter
	omap2_clk_init_cpufreq_table_addr=0xaddress, where address can be
	retrieved from /proc/kallsyms.  Otherwise, finding out the values
	will require live disassembly of kernel code.  See the project page
	for more information.
*/

#define DRIVER_AUTHOR "Tiago Sousa <mirage@kaotik.org>"
#define DRIVER_DESCRIPTION "Motorola Milestone CPU overclocking"
#define DRIVER_VERSION_BASE "1.0-mapphone-"

#define DRIVER_FROYO

#if defined(DRIVER_FROYO)
# define DRIVER_VERSION_TYPE "froyo"
//? don't know about stats actually -.-
# define DRIVER_HAVE_SMARTREFLEX
#elif defined(DRIVER_ECLAIR)
# define DRIVER_VERSION_TYPE "eclair"
# define DRIVER_HAVE_STATS
#else
# error "No Type Specified! (Eclair or Froyo)"
#endif

#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/init.h>

#include <linux/proc_fs.h>
#include <linux/string.h>
#include <linux/vmalloc.h>
#include <asm/uaccess.h>

#include <linux/kallsyms.h>

#include <linux/notifier.h>
#include <linux/cpufreq.h>
#include <linux/delay.h>
#include <linux/interrupt.h>
#include <linux/spinlock.h>
#include <linux/device.h>
#include <linux/slab.h>
#include <linux/cpu.h>
#include <linux/completion.h>
#include <linux/mutex.h>

#include <linux/err.h>
#include <linux/clk.h>
#include <linux/io.h>

#include <mach/hardware.h>
#include <asm/system.h>   

#if defined(DRIVER_FROYO)  
# include <plat/omap-pm.h>
#elif defined(DRIVER_ECLAIR)
# include <mach/omap-pm.h>
#endif

extern unsigned long lookup_symbol_address(const char *name);

MODULE_AUTHOR(DRIVER_AUTHOR);
MODULE_DESCRIPTION(DRIVER_DESCRIPTION);
MODULE_VERSION(DRIVER_VERSION_BASE DRIVER_VERSION_TYPE);
MODULE_LICENSE("GPL");

static uint max_rate = 0;
static uint max_vsel = 0;
static uint freq_table_addr = 0;
static uint mpu_opps_addr = 0;
static uint omap2_clk_init_cpufreq_table_addr = 0;

static struct cpufreq_frequency_table *freq_table;
static struct omap_opp *my_mpu_opps;
static struct cpufreq_policy *policy;
#define MPU_CLK         "arm_fck"
static struct clk *mpu_clk;

#ifdef DRIVER_HAVE_STATS

static uint stats_addr = 0;
static uint cpufreq_stats_update_addr = 0;

struct cpufreq_stats 
{
	unsigned int cpu;
	unsigned int total_trans;
	unsigned long long  last_time;
	unsigned int max_state;
	unsigned int state_num;
	unsigned int last_index;
	cputime64_t *time_in_state;
	unsigned int *freq_table;
};

static struct cpufreq_stats *stat;

#endif

#define BUF_SIZE PAGE_SIZE
static char *buf;

static void set_max_speed(void)
{
	printk(KERN_INFO "overclock: setting max_rate %u and max_vsel %u\n", max_rate, max_vsel);
	freq_table[0].frequency = policy->max = policy->cpuinfo.max_freq =
		policy->user_policy.max = max_rate;
		
#ifdef DRIVER_HAVE_STATS
	cpufreq_stats_table->freq_table[0] = max_rate;
#endif
		
	my_mpu_opps[MAX_VDD1_OPP].vsel = max_vsel;
#ifdef DRIVER_HAVE_SMARTREFLEX
	my_mpu_opps[MAX_VDD1_OPP].sr_adjust_vsel = max_vsel;
#endif
	my_mpu_opps[MAX_VDD1_OPP].rate = max_rate*1000;
}

static void omap2_find_addrs(void)
{
	unsigned char *func = (void *)omap2_clk_init_cpufreq_table_addr;
	uint *addr;
	int first = 1, i;
	
	for(i = 0; i < 100; i+=4) 
	{
		if((func[i+3] == 0xe5 || func[i+3] == 0x15) /* ldr/ldrne */
			&& func[i+2] == 0x9f) /* [pc, */
		{ 
			addr = (void *)((uint)func)+i+8+func[i];
			if(first--) 
			{
				mpu_opps_addr = *addr;
				printk (KERN_INFO "overclock: found mpu_opps_addr at 0x%x\n", mpu_opps_addr);
			} 
			else 
			{
				freq_table_addr = *addr;
				printk (KERN_INFO "overclock: found freq_table_addr at 0x%x\n", freq_table_addr);
				break;
			}
		}
	}
}

#ifdef DRIVER_HAVE_STATS

static void stats_find_addr(void)
{
	unsigned char *func = (void *)cpufreq_stats_update_addr;
	uint *addr;
	int i;
	
	for(i = 0; i < 100; i+=4) 
	{
		if((func[i+3] == 0xe5) /* ldr */
			&& func[i+2] == 0x9f) /* [pc, */
		{ 
			addr = (void *)((uint)func)+i+8+func[i];
			stats_addr = *addr;
			printk (KERN_INFO "overclock: found stats_addr at 0x%x\n", stats_addr);
			break;
		}
	}
}

#endif

static int proc_info_read(char *buffer, char **buffer_location,
		off_t offset, int count, int *eof, void *data)
{
	int ret;
	
	if (offset > 0)
		ret = 0;
	else
		ret = scnprintf(buffer, count, "cpumin=%u cpumax=%u min=%u max=%u usermin=%u usermax=%u\nclk_get_rate=%lu\n",
				policy->cpuinfo.min_freq, policy->cpuinfo.max_freq, policy->min, policy->max, policy->user_policy.min, policy->user_policy.max, clk_get_rate(mpu_clk) / 1000);

	return ret;
}

static int proc_max_rate_read(char *buffer, char **buffer_location,
		off_t offset, int count, int *eof, void *data)
{
	int ret;
	
	if (offset > 0)
		ret = 0;
	else
		ret = scnprintf(buffer, count, "%u\n", max_rate);

	return ret;
}

static int proc_max_rate_write(struct file *filp, const char __user *buffer,
		unsigned long len, void *data)
{
	ulong newrate;
	int result;

	if(!len || len >= BUF_SIZE)
		return -ENOSPC;
		
	if(copy_from_user(buf, buffer, len))
		return -EFAULT;
		
	buf[len] = 0;
	
	if((result = strict_strtoul(buf, 0, &newrate)))
		return result;
		
	if(max_rate != newrate) 
	{
		max_rate = newrate;
		set_max_speed();
	}

	return len;
}

static int proc_max_vsel_read(char *buffer, char **buffer_location,
		off_t offset, int count, int *eof, void *data)
{
	int ret;
	
	if (offset > 0)
		ret = 0;
	else
		ret = scnprintf(buffer, count, "%u\n", max_vsel);

	return ret;
}

static int proc_max_vsel_write(struct file *filp, const char __user *buffer,
		unsigned long len, void *data)
{
	ulong newvsel;
	int result;

	if(!len || len >= BUF_SIZE)
		return -ENOSPC;
	if(copy_from_user(buf, buffer, len))
		return -EFAULT;
	buf[len] = 0;
	if((result = strict_strtoul(buf, 0, &newvsel)))
		return result;
	if(max_vsel != newvsel) 
	{
		max_vsel = newvsel;
		set_max_speed();
	}

	return len;
}

static int proc_freq_table_addr_read(char *buffer, char **buffer_location,
		off_t offset, int count, int *eof, void *data)
{
	int ret;
	
	if (offset > 0)
		ret = 0;
	else
		ret = scnprintf(buffer, count, "0x%x\n", (uint)freq_table);

	return ret;
}

static int proc_mpu_opps_addr_read(char *buffer, char **buffer_location,
		off_t offset, int count, int *eof, void *data)
{
	int ret;
	
	if (offset > 0)
		ret = 0;
	else
		ret = scnprintf(buffer, count, "0x%x\n", (uint)mpu_opps_addr);

	return ret;
}

static int proc_omap2_clk_init_cpufreq_table_addr_read(char *buffer,
		char **buffer_location, off_t offset, int count, int *eof,
		void *data)
{
	int ret;
	
	if (offset > 0)
		ret = 0;
	else
		ret = scnprintf(buffer, count, "0x%x\n",
			(uint)omap2_clk_init_cpufreq_table_addr);

	return ret;
}

static int proc_freq_table_read(char *buffer, char **buffer_location,
		off_t offset, int count, int *eof, void *data)
{
	int i, ret = 0;
	
	if (offset > 0)
		ret = 0;
	else
		for(i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++) 
		{
			if(ret >= count)
				break;
				
			ret += scnprintf(buffer+ret, count-ret, "freq_table[%d] index=%u frequency=%u\n", i, freq_table[i].index, freq_table[i].frequency);
		}

	return ret;
}

static int proc_freq_table_write(struct file *filp, const char __user *buffer,
		unsigned long len, void *data)
{
	uint index, frequency;

	if(!len || len >= BUF_SIZE)
		return -ENOSPC;
	if(copy_from_user(buf, buffer, len))
		return -EFAULT;
	buf[len] = 0;
	
	if(sscanf(buf, "%d %d", &index, &frequency) == 2) 
	{
		freq_table[index].frequency = frequency;
#ifdef DRIVER_HAVE_STATS
		cpufreq_stats_table->freq_table[index] = frequency;
#endif
	}
	else
		printk(KERN_INFO "overclock: insufficient parameters for freq_table\n");

	return len;
}                        
                        
static int proc_mpu_opps_read(char *buffer, char **buffer_location,
		off_t offset, int count, int *eof, void *data)
{
	int i, ret = 0;
	
	if (offset > 0)
		ret = 0;
	else
		for(i = MAX_VDD1_OPP; my_mpu_opps[i].rate; i--) 
		{
			if(ret >= count)
				break;
				
			#ifdef DRIVER_HAVE_SMARTREFLEX
				ret += scnprintf(buffer+ret, count-ret, "mpu_opps[%d] rate=%lu opp_id=%u vsel=%u sr_adjust_vsel=%u\n", i, 
				my_mpu_opps[i].rate, my_mpu_opps[i].opp_id, my_mpu_opps[i].vsel, my_mpu_opps[i].sr_adjust_vsel); 		
			#else
				ret += scnprintf(buffer+ret, count-ret, "mpu_opps[%d] rate=%lu opp_id=%u vsel=%u\n", i, 
				my_mpu_opps[i].rate, my_mpu_opps[i].opp_id, my_mpu_opps[i].vsel); 		
			#endif
		}

	return ret;
}

static int proc_mpu_opps_write(struct file *filp, const char __user *buffer,
		unsigned long len, void *data)
{
	uint index, rate, vsel;

	if(!len || len >= BUF_SIZE)
		return -ENOSPC;
		
	if(copy_from_user(buf, buffer, len))
		return -EFAULT;
		
	buf[len] = 0;
	if(sscanf(buf, "%d %d %d", &index, &rate, &vsel) == 3) 
	{
		my_mpu_opps[index].rate = rate;
		my_mpu_opps[index].vsel = vsel;
#ifdef DRIVER_HAVE_SMARTREFLEX
		my_mpu_opps[index].sr_adjust_vsel = vsel;
#endif
	} 
	else
		printk(KERN_INFO "overclock: insufficient parameters for mpu_opps\n");

	return len;
}                        
     
#ifdef DRIVER_HAVE_STATS    

static int proc_cpufreq_stats_update_addr_read(char *buffer,
		char **buffer_location, off_t offset, int count, int *eof,
		void *data)
{
	int ret;
	
	if (offset > 0)
		ret = 0;
	else
		ret = scnprintf(buffer, count, "0x%x\n",
			(uint)cpufreq_stats_update_addr);

	return ret;
}

#endif
                        
static int proc_version_read(char *buffer, char **buffer_location,
		off_t offset, int count, int *eof, void *data)
{
	int ret;
	
	if (offset > 0)
		ret = 0;
	else
		ret = scnprintf(buffer, count, "%s\n", DRIVER_VERSION_BASE DRIVER_VERSION_TYPE);

	return ret;
}

static int __init overclock_init(void)
{
	struct proc_dir_entry *proc_entry;

	printk(KERN_INFO "overclock: %s version %s\n", DRIVER_DESCRIPTION, DRIVER_VERSION_BASE DRIVER_VERSION_TYPE);
	printk(KERN_INFO "overclock: by %s\n", DRIVER_AUTHOR);
	
	omap2_clk_init_cpufreq_table_addr = lookup_symbol_address("omap2_clk_init_cpufreq_table");
	if(!omap2_clk_init_cpufreq_table_addr)
	{
		printk(KERN_INFO "overclock: Could not find symbol: omap2_clk_init_cpufreq_table.\n");
		return -EBUSY;
	}
	
	omap2_find_addrs();

#ifdef DRIVER_HAVE_STATS
	cpufreq_stats_update_addr = lookup_symbol_address("cpufreq_stats_update"); 	
 	if(!cpufreq_stats_update_addr)
 	{
 		printk(KERN_INFO "overclock: Could not find symbol: cpufreq_stats_update.\n");
 		return -EBUSY;
 	}
 	
 	stats_find_addr();
#endif

	freq_table = (void *)freq_table_addr;
	my_mpu_opps = *(struct omap_opp **)mpu_opps_addr;
	policy = cpufreq_cpu_get(0);
	mpu_clk = clk_get(NULL, MPU_CLK);

	max_vsel = my_mpu_opps[MAX_VDD1_OPP].vsel;
	max_rate = my_mpu_opps[MAX_VDD1_OPP].rate/1000;

	buf = (char *)vmalloc(BUF_SIZE);

#ifdef DRIVER_HAVE_STATS
	stat = *(struct cpufreq_stats **)stats_addr;  
#endif

	proc_mkdir("overclock", NULL);
	proc_entry = create_proc_read_entry("overclock/info", 0444, NULL, proc_info_read, NULL);
	proc_entry = create_proc_read_entry("overclock/max_rate", 0644, NULL, proc_max_rate_read, NULL);
	proc_entry->write_proc = proc_max_rate_write;
	proc_entry = create_proc_read_entry("overclock/max_vsel", 0644, NULL, proc_max_vsel_read, NULL);
	proc_entry->write_proc = proc_max_vsel_write;
	proc_entry = create_proc_read_entry("overclock/freq_table_addr", 0444, NULL, proc_freq_table_addr_read, NULL);
	proc_entry = create_proc_read_entry("overclock/mpu_opps_addr", 0444, NULL, proc_mpu_opps_addr_read, NULL);
	proc_entry = create_proc_read_entry("overclock/omap2_clk_init_cpufreq_table_addr", 0444, NULL, proc_omap2_clk_init_cpufreq_table_addr_read, NULL);
	proc_entry = create_proc_read_entry("overclock/freq_table", 0644, NULL, proc_freq_table_read, NULL);
	proc_entry->write_proc = proc_freq_table_write;
	proc_entry = create_proc_read_entry("overclock/mpu_opps", 0644, NULL, proc_mpu_opps_read, NULL);
	proc_entry->write_proc = proc_mpu_opps_write;
#ifdef DRIVER_HAVE_STATS 
	proc_entry = create_proc_read_entry("overclock/cpufreq_stats_update_addr", 0444, NULL, proc_cpufreq_stats_update_addr_read, NULL);  
#endif
	proc_entry = create_proc_read_entry("overclock/version", 0444, NULL, proc_version_read, NULL);

	return 0;
}

static void __exit overclock_exit(void)
{
	remove_proc_entry("overclock/version", NULL);
#ifdef DRIVER_HAVE_STATS
	remove_proc_entry("overclock/cpufreq_stats_update_addr", NULL); 
#endif
	remove_proc_entry("overclock/mpu_opps", NULL);
	remove_proc_entry("overclock/freq_table", NULL);
	remove_proc_entry("overclock/omap2_clk_init_cpufreq_table_addr", NULL);
	remove_proc_entry("overclock/mpu_opps_addr", NULL);
	remove_proc_entry("overclock/freq_table_addr", NULL);
	remove_proc_entry("overclock/max_vsel", NULL);
	remove_proc_entry("overclock/max_rate", NULL);
	remove_proc_entry("overclock/info", NULL);
	remove_proc_entry("overclock", NULL);
	 
	vfree(buf);
	printk(KERN_INFO "overclock: removed overclocking and unloaded\n");
}

module_init(overclock_init);
module_exit(overclock_exit);
