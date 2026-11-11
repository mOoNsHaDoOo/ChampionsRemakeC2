/* H003: adattatori exec.library (memoria). */
#ifndef COK_H003_EXEC_H
#define COK_H003_EXEC_H

#include "cok.h"

#define COK_MEMF_CHIP  0x00000002UL
#define COK_MEMF_CLEAR 0x00010000UL

void *exec_alloc_mem(u32 size, u32 flags);   /* H003+$0068 */
u32   exec_avail_mem(u32 requirements);         /* H003+$007E */
void  exec_copy_mem(const void *src, void *dst, u32 size); /* H003+$0090 */
void  exec_free_mem(void *block, u32 size);  /* H003+$00F6 */

#endif
