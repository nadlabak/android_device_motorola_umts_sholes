/* 
 * hijack: - hijacks function in kernel
 *
 * Copyright (C) 2010 Skrilax_CZ
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
#include "symsearch.h"
 
struct hijack_info hijack_function(unsigned long hijack_address, unsigned long redirection_address)
{
	struct hijack_info hijack;
	unsigned long branch_instr;
	
	hijack.hijack_address = hijack_address;
	hijack.redirection_address = redirection_address;
	hijack.instruction_backup = *((unsigned long*)(hijack_address));
	
	//B redirection_address 
	//(HEX=0xEA000000 + ((redirection_address - hijack_address + 8)/4 & 0x00FFFFFF) )
	branch_instr = 0xEA000000 + ((redirection_address - hijack_address + 8)/4 & 0x00FFFFFF);
	*((unsigned long*)(hijack_address)) = branch_instr;
	return hijack;
}
EXPORT_SYMBOL(hijack_function);

void restore_function(struct hijack_info hijack)
{
	*((unsigned long*)(hijack.hijack_address)) = hijack.instruction_backup;
}
EXPORT_SYMBOL(restore_function);
