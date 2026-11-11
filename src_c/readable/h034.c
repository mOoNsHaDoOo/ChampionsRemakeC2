/* H034: caricamento risorse 8x8 (8X8D) e messaggi di errore. */
#include "h034.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h045.h"
#include "h049.h"
#include "globals.h"
#include "h010_input.h"
#include "unported.h"

/* PORT H034+$0024: link/unlk, nessun effetto. */
void h034_init(void)
{
}

/*
 * PORT H034+$0032: carica il set di tile 8x8 id dal contenitore
 * "8x8d<gruppo>.daa" nel posto slot (0..4) di g_8x8_sets, con maschera
 * (colore trasparente 13).  Se non riesce compone il messaggio "Unable to
 * load <id> from 8x8D<gruppo>" (che l'originale non mostra: nessuna
 * routine lo riceve), poi H010+$0974 e l'uscita H010+$0332.
 */
void load_8x8_set(u8 id, u8 slot)
{
    char name[0x52];            /* -$F8 */
    char group[2];              /* -$2 */
    char message[0x52];         /* -$54 */
    char number[0x52];          /* -$A6 */

    if (slot > 4) {
        return;
    }
    h026_copy(0x50, name, 4, "8x8d");
    format_number(1, group, (s32)G_RESOURCE_GROUP, 0, 0x0A, 1, '0');
    h026_append(0x50, name, 1, group);
    load_indexed_gfx_record(0x50, name, id, 1, 0x0D, &g_8x8_sets[slot]);
    if (g_8x8_sets[slot] != NULL) {
        return;
    }
    h026_copy(0x50, message, 0x0F, "Unable to load ");
    format_number(0x50, number, (s32)id, 0, 0x0A, 3, '0');
    h026_append(0x50, message, 0x50, number);
    h026_append(0x50, message, 0x0A, " from 8x8D");
    h026_append(0x50, message, 1, group);
    wait_for_key();
    quit_game();
}

/*
 * PORT H034+$0178: disegna la tile 8x8 id nella cella (x, row): sullo
 * schermo, oppure (offscreen) nell'immagine fuori schermo di H005+$27C2.
 * L'ultimo argomento non e' letto.
 */
void draw_8x8_tile(u16 x, u16 row, u16 id, u8 offscreen, u16 unused)
{
    struct BitMap *dest;

    (void)unused;
    dest = offscreen ? g_pic_rec_27c2->image : &g_screen->BitMap;
    draw_8x8_tile_raw(x, row, id, dest, g_8x8_sets);
}
