/* H016: adattatori graphics.library per blit, attesa e cancellazione raster. */
#include "h016_gfx.h"

/*
 * PORT H016+$0008: copia GfxBase (-$14(a4) del runtime H015) nella cella
 * del modulo.  In C GfxBase e' gia' globale: niente da fare.
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

/* PORT H016+$0014: coordinate a word, minterm e maschera dei piani a byte. */
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
 * PORT H016+$00A0: BltMaskBitMapRastPort, coordinate a word e minterm a
 * byte.
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
