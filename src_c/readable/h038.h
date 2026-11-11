/* H038: adattatori RectFill e selezione delle penne. */
#ifndef COK_H038_H
#define COK_H038_H

#include "cok.h"

void graphics_rect_fill(struct RastPort *rp, u16 xmin, u16 ymin, u16 xmax,
                        u16 ymax);                      /* H038+$0118 */
void graphics_set_apen(struct RastPort *rp, u16 pen);   /* H038+$013C */
void graphics_set_bpen(struct RastPort *rp, u16 pen);   /* H038+$016C */
void graphics_set_open(struct RastPort *rp, u16 pen);   /* H038+$01B4 */

#endif
