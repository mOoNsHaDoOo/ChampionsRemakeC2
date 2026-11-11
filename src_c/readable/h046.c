/* H046: direzione del cursore rispetto a un punto. */
#include "cok.h"
#include "h046.h"

/* PORT H046+$0004: link/unlk, nessun effetto. */
void h046_init(void)
{
}

/*
 * PORT H046+$0012: tasto di direzione (H I M Q P O K G, come il
 * tastierino) da (px, py) verso (x, y): i settori sono separati dalle
 * pendenze $26A/$100 (circa 2,41) e $6A/$100 (circa 0,41), cioe' 67,5 e
 * 22,5 gradi.  Si provano gli otto casi in ordine.
 */
u8 cursor_direction(u16 px, u16 py, u16 x, u16 y)
{
    s16 dxa;                            /* -$6(a5) */
    s16 dya;                            /* -$8(a5) */
    s16 steep;
    s16 flat;
    u16 i = 0;                          /* -$2(a5) */
    u8 found = 0;                       /* -$3(a5) */
    u8 key = 0;                         /* -$4(a5) */
    s16 sx = (s16)x, sy = (s16)y, spx = (s16)px, spy = (s16)py;

    dxa = (s16)(sx - spx);
    if (dxa < 0) dxa = (s16)-dxa;
    dya = (s16)(sy - spy);
    if (dya < 0) dya = (s16)-dya;
    steep = (s16)((s32)dxa * 0x26A / 0x100);
    flat = (s16)((s32)dxa * 0x6A / 0x100);
    while (!found) {
        switch (i) {
        case 0:
            found = (u8)(sy <= spy && dya >= steep);
            key = 'H';
            break;
        case 1:
            found = (u8)(sy < spy && sx > spx && dya <= steep && dya >= flat);
            key = 'I';
            break;
        case 2:
            found = (u8)(sx >= spx && dya <= flat);
            key = 'M';
            break;
        case 3:
            found = (u8)(sy > spy && sx > spx && dya <= steep && dya >= flat);
            key = 'Q';
            break;
        case 4:
            found = (u8)(sy >= spy && dya >= steep);
            key = 'P';
            break;
        case 5:
            found = (u8)(sy > spy && sx < spx && dya <= steep && dya >= flat);
            key = 'O';
            break;
        case 6:
            found = (u8)(sx <= spx && dya <= flat);
            key = 'K';
            break;
        case 7:
            found = (u8)(sy < spy && sx < spx && dya <= steep && dya >= flat);
            key = 'G';
            break;
        default:
            break;
        }
        if (!found) {
            ++i;
        }
    }
    return key;
}
