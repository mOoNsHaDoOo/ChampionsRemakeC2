/* H016: graphics.library adapters for blits, waiting and raster clearing. */
#ifndef COK_H016_GFX_H
#define COK_H016_GFX_H

#include "cok.h"

s32  graphics_blt_bitmap(struct BitMap *src, u16 src_x, u16 src_y,
                         struct BitMap *dst, u16 dst_x, u16 dst_y,
                         u16 width, u16 height, u8 minterm, u8 mask,
                         u8 *temp);                     /* H016+$0014 */
void graphics_blt_clear(void *memory, u32 count, u32 flags);  /* H016+$0084 */
void graphics_blt_mask_bitmap_rastport(struct BitMap *src, u16 src_x,
                                       u16 src_y, struct RastPort *dst,
                                       u16 dst_x, u16 dst_y, u16 width,
                                       u16 height, u8 minterm, u8 *mask);
                                                              /* H016+$00A0 */
void graphics_wait_tof(void);                                 /* H016+$01AC */

#endif
