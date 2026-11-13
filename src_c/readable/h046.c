/* H046: cursor direction relative to a point. */
#include "cok.h"
#include "h046.h"

/* PORT H046+$0004: link/unlk, no effect. */
void h046_init(void)
{
}

/*
 * PORT H046+$0012: direction key (H I M Q P O K G, like the numeric
 * keypad) from (px, py) towards (x, y): the sectors are separated by the
 * slopes $26A/$100 (about 2.41) and $6A/$100 (about 0.41), that is 67.5
 * and 22.5 degrees.  The eight cases are tried in order.
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
