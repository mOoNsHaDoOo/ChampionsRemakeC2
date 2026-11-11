/* H040: lettore di immagini ILBM sopra il parser IFF (readpict.c di EA). */
#ifndef COK_H040_H
#define COK_H040_H

#include "h087.h"

/* Allocatore dei piani: riceve la dimensione totale, restituisce memoria. */
typedef u8 *(*IlbmAllocFn)(u32 size);

s32 read_ilbm(cok_bptr file, struct BitMap *bitmap, ILBMFrame *frame,
              IlbmAllocFn alloc);                       /* H040+$05E4 */

#endif
