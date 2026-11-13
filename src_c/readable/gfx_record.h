/* H029 graphic record (struct GfxRecord), used by several modules. */
#ifndef COK_GFX_RECORD_H
#define COK_GFX_RECORD_H

#include "cok.h"

/*
 * Graphic record (20 bytes in the original, MEMF_CLEAR): a 5-plane
 * picture and its optional mask.  On the host pointers are 64-bit,
 * so the structure is larger, with the same fields.
 */
struct GfxRecord {
    u16 rows;                   /* +$00: rows */
    u16 count;                  /* +$02: units across (2nd argument) */
    u16 w4;                     /* +$04 */
    u16 w6;                     /* +$06 */
    u16 width8;                 /* +$08: unit width in bytes (8 px) */
    u16 plane_bytes;            /* +$0A: bytes of the 5 planes (word) */
    struct BitMap *mask;        /* +$0C: mask, one plane repeated 5 times */
    struct BitMap *image;       /* +$10: 5-plane picture */
};

#endif
