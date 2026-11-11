/* H037: adattatore graphics.library/InitBitMap. */
#ifndef COK_H037_H
#define COK_H037_H

#include "cok.h"

void graphics_init_bitmap(struct BitMap *bm, u16 depth, u16 width,
                          u16 height);                  /* H037+$0014 */

#endif
