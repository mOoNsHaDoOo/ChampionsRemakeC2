/* H077: aree, linee di vista e direzioni sulla mappa del combattimento. */
#ifndef COK_H077_H
#define COK_H077_H

#include "cok.h"

/*
 * Linea fra due caselle (Bresenham), record di $18 byte nell'originale:
 * estremi, errore, differenze, posizione, passi, costo (2 per passo, +1
 * in diagonale) e direzione dell'ultimo passo (tabella H005+$3DD2).
 */
typedef struct CokLine {
    s16 x0;                             /* +$00 */
    s16 y0;                             /* +$02 */
    s16 x1;                             /* +$04 */
    s16 y1;                             /* +$06 */
    s16 err;                            /* +$08 */
    s16 dx;                             /* +$0A */
    s16 dy;                             /* +$0C */
    s16 cx;                             /* +$0E */
    s16 cy;                             /* +$10 */
    s16 sx;                             /* +$12 */
    s16 sy;                             /* +$14 */
    u8 cost;                            /* +$16 */
    u8 dir;                             /* +$17 */
} CokLine;

void line_init(CokLine *l);             /* H077+$01CC */
u8   line_step(CokLine *l);             /* H077+$0242 */

u8   line_of_sight(s16 ox, s16 oy, s16 *tx, s16 *ty, u16 *dist, u8 *area);
                                                        /* H077+$0378 */
u8   in_direction(s16 x0, s16 y0, s16 x1, s16 y1, u16 dir); /* H077+$0508 */
void find_in_area(s16 x, s16 y, u16 radius, u16 dir, u16 size, u8 *area);
                                                        /* H077+$08AC */
#endif
