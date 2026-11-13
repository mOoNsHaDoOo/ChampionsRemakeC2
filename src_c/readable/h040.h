/* H040: ILBM picture reader on top of the IFF parser (EA's readpict.c). */
#ifndef COK_H040_H
#define COK_H040_H

#include "h087.h"

/* Plane allocator: gets the total size, returns memory. */
typedef u8 *(*IlbmAllocFn)(u32 size);

s32 read_ilbm(cok_bptr file, struct BitMap *bitmap, ILBMFrame *frame,
              IlbmAllocFn alloc);                       /* H040+$05E4 */

#endif
