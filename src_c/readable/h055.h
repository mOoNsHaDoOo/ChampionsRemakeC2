/* H055: AllocRaster, FreeRaster and InitRastPort adapters. */
#ifndef COK_H055_H
#define COK_H055_H

#include "cok.h"

void graphics_init_rastport(struct RastPort *rp);       /* H055+$0044 */
PLANEPTR graphics_alloc_raster(u16 width, u16 height);  /* H055+$0014 */
void     graphics_free_raster(PLANEPTR p, u16 width, u16 height); /* H055+$002A */

#endif
