/* H034: caricamento risorse 8x8 (8X8D) e messaggi di errore. */
#ifndef COK_H034_H
#define COK_H034_H

#include "cok.h"

void load_8x8_set(u8 id, u8 slot);      /* H034+$0032 */
void draw_8x8_tile(u16 x, u16 row, u16 id, u8 offscreen, u16 unused);
                                        /* H034+$0178 */

#endif
