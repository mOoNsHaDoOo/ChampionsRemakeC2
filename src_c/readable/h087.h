/* H087: reading of ILBM chunks (Electronic Arts' ilbmr.c): BMHD, CMAP, BODY. */
#ifndef COK_H087_H
#define COK_H087_H

#include "h086.h"

#define ID_ILBM COK_MAKE_ID('I', 'L', 'B', 'M')
#define ID_BMHD COK_MAKE_ID('B', 'M', 'H', 'D')
#define ID_CMAP COK_MAKE_ID('C', 'M', 'A', 'P')
#define ID_BODY COK_MAKE_ID('B', 'O', 'D', 'Y')

#define MAX_SRC_PLANES 0x11     /* 16 planes + mask */
#define MSK_HAS_MASK   1
#define CMP_BYTE_RUN1  1

/* BitMapHeader (20 bytes in the file, big-endian). */
typedef struct BitMapHeader {
    u16 w;                      /* +$00 */
    u16 h;                      /* +$02 */
    s16 x;                      /* +$04 */
    s16 y;                      /* +$06 */
    u8 n_planes;                /* +$08 */
    u8 masking;                 /* +$09 */
    u8 compression;             /* +$0A */
    u8 pad1;                    /* +$0B */
    u16 transparent_color;      /* +$0C */
    u8 x_aspect;                /* +$0E */
    u8 y_aspect;                /* +$0F */
    s16 page_width;             /* +$10 */
    s16 page_height;            /* +$12 */
} BitMapHeader;

/* ILBMFrame ($66 bytes in the original): ClientFrame + reader state. */
typedef struct ILBMFrame {
    ClientFrame client_frame;   /* +$00 */
    u8 found_bmhd;              /* +$10 */
    u8 n_color_regs;            /* +$11 */
    BitMapHeader bm_hdr;        /* +$12 */
    u16 color_map[32];          /* +$26: RGB4 colours */
} ILBMFrame;

s32 ilbm_get_bmhd(GroupContext *context, BitMapHeader *bm_hdr); /* H087+$000C */
s32 ilbm_get_cmap(GroupContext *context, u16 *color_map, u8 *n_color_regs);
                                                                 /* H087+$009C */
s32 ilbm_get_body(GroupContext *context, struct BitMap *bitmap, u8 *mask,
                  BitMapHeader *bm_hdr, u8 *buffer, s32 buf_size);
                                                                 /* H087+$0166 */
u8  ilbm_unpack_row(u8 **source, u8 **dest, s16 src_bytes, s16 dst_bytes);
                                                                 /* H088+$000C */
u16 ilbm_row_bytes(u16 width);                                  /* H054+$000C */
u16 ilbm_max_packed_size(u16 row_size);                         /* H099+$01B0 */

#endif
