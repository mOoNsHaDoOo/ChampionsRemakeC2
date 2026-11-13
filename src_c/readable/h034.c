/* H034: loading of 8x8 resources (8X8D) and error messages. */
#include "h034.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h045.h"
#include "h049.h"
#include "globals.h"
#include "h010_input.h"
#include "unported.h"

/* PORT H034+$0024: link/unlk, no effect. */
void h034_init(void)
{
}

/*
 * PORT H034+$0032: loads the 8x8 tile set id from the container
 * "8x8d<group>.daa" into slot (0..4) of g_8x8_sets, with a mask
 * (transparent colour 13).  On failure it builds the message "Unable to
 * load <id> from 8x8D<group>" (which the original does not show: no
 * routine receives it), then H010+$0974 and the exit H010+$0332.
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
    /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
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
 * PORT H034+$0178: draws the 8x8 tile id in the cell (x, row): on the
 * screen, or (offscreen) in the off-screen picture of H005+$27C2.
 * The last argument is not read.
 */
void draw_8x8_tile(u16 x, u16 row, u16 id, u8 offscreen, u16 unused)
{
    struct BitMap *dest;

    (void)unused;
    dest = offscreen ? g_pic_rec_27c2->image : &g_screen->BitMap;
    draw_8x8_tile_raw(x, row, id, dest, g_8x8_sets);
}
