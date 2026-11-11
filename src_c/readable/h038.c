/* H038: Adattatori RectFill e selezione delle penne. */
#include "h038.h"

/*
 * PORT H038+$0008: copia GfxBase del runtime H015 nella cella del modulo.
 * In C la base della libreria e' gia' globale: niente da fare.
 */
void h038_init(void)
{
}

#if COK_AMIGA
#include <proto/graphics.h>
#endif

/* PORT H038+$0118: le coordinate sono word (move.w), estese da RectFill. */
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
 * PORT H038+$01B4: la macro SetOPen in linea: AOlPen = pen (byte) e
 * flag AREAOUTLINE nel RastPort.
 */
void graphics_set_open(struct RastPort *rp, u16 pen)
{
    rp->AOlPen = (BYTE)pen;
    rp->Flags |= AREAOUTLINE;
}
