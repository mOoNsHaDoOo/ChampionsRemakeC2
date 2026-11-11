/* H055: Adattatori AllocRaster, FreeRaster e InitRastPort. */
#include "h055.h"

/*
 * PORT H055+$0008: copia GfxBase del runtime H015 nella cella del modulo.
 * In C la base della libreria e' gia' globale: niente da fare.
 */
void h055_init(void)
{
}

#if COK_AMIGA
#include <proto/graphics.h>
#endif

/* PORT H055+$0014 */
PLANEPTR graphics_alloc_raster(u16 width, u16 height)
{
    return AllocRaster((ULONG)width, (ULONG)height);
}

/* PORT H055+$0044 */
void graphics_init_rastport(struct RastPort *rp)
{
    InitRastPort(rp);
}

/* PORT H055+$002A */
void graphics_free_raster(PLANEPTR p, u16 width, u16 height)
{
    FreeRaster(p, (ULONG)width, (ULONG)height);
}
