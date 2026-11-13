/* H016: graphics.library adapters for blits, waiting and raster clearing. */
#include "h016_gfx.h"

/*
 * PORT H016+$0008: copies GfxBase (-$14(a4) of the H015 runtime) into the
 * module cell.  In C GfxBase is already global: nothing to do.
 */
void h016_init(void)
{
}

#if COK_AMIGA
#include <proto/graphics.h>
#endif

/* PORT H016+$0084 */
void graphics_blt_clear(void *memory, u32 count, u32 flags)
{
    BltClear((PLANEPTR)memory, count, flags);
}

/* PORT H016+$0014: coordinates as words, minterm and plane mask as bytes. */
s32 graphics_blt_bitmap(struct BitMap *src, u16 src_x, u16 src_y,
                        struct BitMap *dst, u16 dst_x, u16 dst_y,
                        u16 width, u16 height, u8 minterm, u8 mask, u8 *temp)
{
    return (s32)BltBitMap(src, (s16)src_x, (s16)src_y, dst, (s16)dst_x,
                          (s16)dst_y, (s16)width, (s16)height, minterm, mask,
                          (PLANEPTR)temp);
}

/* PORT H016+$01AC */
void graphics_wait_tof(void)
{
    WaitTOF();
}

/*
 * PORT H016+$00A0: BltMaskBitMapRastPort, coordinates as words and minterm
 * as a byte.
 */
void graphics_blt_mask_bitmap_rastport(struct BitMap *src, u16 src_x,
                                       u16 src_y, struct RastPort *dst,
                                       u16 dst_x, u16 dst_y, u16 width,
                                       u16 height, u8 minterm, u8 *mask)
{
    BltMaskBitMapRastPort(src, (s16)src_x, (s16)src_y, dst, (s16)dst_x,
                          (s16)dst_y, (s16)width, (s16)height, minterm,
                          (PLANEPTR)mask);
}
