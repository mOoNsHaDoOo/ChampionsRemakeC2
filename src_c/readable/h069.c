/* H069: composition of the 3D view and drawing services. */
#include "cok.h"
#include "h069.h"
#include "globals.h"
#include "h029_gfx.h"
#include "h038.h"

/* PORT H069+$0004: link/unlk, no effect. */
void h069_init(void)
{
}

/*
 * PORT H069+$0012: party marker on the outdoor map: saves the background
 * of the cell ($3E04+$186/$188, plus the frame) in record $3334
 * and fills it with colour $E.
 */
void h069_draw_marker(void)
{
    u16 x;                              /* -$2(a5) */
    u16 y;                              /* -$4(a5) */

    /* A+$186: (word) party x on the outdoor map (38x15) */
    x = (u16)(COK_GET16(g_state_a + 0x186) + 1);
    /* A+$188: (word) party y on the outdoor map (38x15) */
    y = (u16)(COK_GET16(g_state_a + 0x188) + 1);
    save_screen_cell(x, y, g_gfx_3334);
    graphics_set_apen(g_rastport, 0x0E);
    graphics_set_open(g_rastport, 0);
    graphics_rect_fill(g_rastport, (u16)(x * 8), (u16)(y * 8),
                       (u16)((x + 1) * 8 - 1), (u16)((y + 1) * 8 - 1));
}

/* PORT H069+$00A8: puts the background back under the party marker. */
void h069_restore_marker(void)
{
    /* A+$186: (word) party x on the outdoor map (38x15) */
    restore_screen_cell((u16)(COK_GET16(g_state_a + 0x186) + 1),
                        /* A+$188: (word) party y on the outdoor map (38x15) */
                        (u16)(COK_GET16(g_state_a + 0x188) + 1), g_gfx_3334);
}
