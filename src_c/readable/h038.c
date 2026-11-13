/* H038: RectFill and pen selection adapters. */
#include "h038.h"

/*
 * PORT H038+$0008: copies GfxBase of the H015 runtime into the module cell.
 * In C the library base is already global: nothing to do.
 */
void h038_init(void)
{
}

#if COK_AMIGA
#include <proto/graphics.h>
#endif

/* PORT H038+$0118: the coordinates are words (move.w), extended by RectFill. */
void graphics_rect_fill(struct RastPort *rp, u16 xmin, u16 ymin, u16 xmax,
                        u16 ymax)
{
    RectFill(rp, (s16)xmin, (s16)ymin, (s16)xmax, (s16)ymax);
}

/* PORT H038+$013C */
void graphics_set_apen(struct RastPort *rp, u16 pen)
{
    SetAPen(rp, pen);
}

/* PORT H038+$016C */
void graphics_set_bpen(struct RastPort *rp, u16 pen)
{
    SetBPen(rp, pen);
}

/*
 * PORT H038+$01B4: the SetOPen macro inline: AOlPen = pen (byte) and
 * the AREAOUTLINE flag in the RastPort.
 */
void graphics_set_open(struct RastPort *rp, u16 pen)
{
    rp->AOlPen = (BYTE)pen;
    rp->Flags |= AREAOUTLINE;
}
