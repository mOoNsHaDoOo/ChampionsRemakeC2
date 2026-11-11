/* H069: composizione della vista 3D e servizi di disegno. */
#include "cok.h"
#include "h069.h"
#include "globals.h"
#include "h029_gfx.h"
#include "h038.h"

/* PORT H069+$0004: link/unlk, nessun effetto. */
void h069_init(void)
{
}

/*
 * PORT H069+$0012: segno del party sulla mappa all'aperto: salva lo
 * sfondo della cella ($3E04+$186/$188, piu' la cornice) nel record $3334
 * e la riempie col colore $E.
 */
void h069_draw_marker(void)
{
    u16 x;                              /* -$2(a5) */
    u16 y;                              /* -$4(a5) */

    x = (u16)(COK_GET16(g_state_a + 0x186) + 1);
    y = (u16)(COK_GET16(g_state_a + 0x188) + 1);
    save_screen_cell(x, y, g_gfx_3334);
    graphics_set_apen(g_rastport, 0x0E);
    graphics_set_open(g_rastport, 0);
    graphics_rect_fill(g_rastport, (u16)(x * 8), (u16)(y * 8),
                       (u16)((x + 1) * 8 - 1), (u16)((y + 1) * 8 - 1));
}

/* PORT H069+$00A8: rimette lo sfondo sotto il segno del party. */
void h069_restore_marker(void)
{
    restore_screen_cell((u16)(COK_GET16(g_state_a + 0x186) + 1),
                        (u16)(COK_GET16(g_state_a + 0x188) + 1), g_gfx_3334);
}
