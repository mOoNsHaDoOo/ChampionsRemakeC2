/* H044: drawing of 8x8 elements (glyphs or tiles) and graphics/UI services. */
#include "h044_tiles.h"
#include "h022_view.h"
#include "h030.h"
#include "h034.h"
#include "globals.h"

/*
 * Module data: $B6 bytes below a4 (from -$B6 to -$1).  H044_M(off) is the
 * byte -off(a4); the tables are indices of 8x8 tiles (0..5) for the frames.
 */
u8 g_h044_bss[0xB6];
#define H044_M(off) g_h044_bss[0xB6 - (off)]

/* count bytes set to value from byte -at(a4) upwards (increasing addresses). */
static void fill(unsigned at, unsigned count, u8 value)
{
    /* H044_bss+$B6: use: variable address of the fill() filling (base -at(a4)) */
    memset(&H044_M(at), value, count);
}

/* PORT H044+$00BA */
void h044_init(void)
{
    /* -$2A: 40 bytes cleared (top row of the frame). */
    fill(0x2A, 40, 0);
    H044_M(0x23) = 1; /* H044_bss+$93: top frame, column 7: tile 1 */
    H044_M(0x21) = 2; /* H044_bss+$95: top frame, column 9: tile 2 */
    H044_M(0x18) = 1; /* H044_bss+$9E: top frame, column 18: tile 1 */
    H044_M(0x16) = 2; /* H044_bss+$A0: top frame, column 20: tile 2 */
    H044_M(0x0D) = 1; /* H044_bss+$A9: top frame, column 29: tile 1 */
    H044_M(0x0B) = 2; /* H044_bss+$AB: top frame, column 31: tile 2 */

    /* -$42: 24 bytes set to 4 (side borders). */
    fill(0x42, 24, 4);
    /* H044_bss+$74: full-screen side borders, rows 0..23 (24 bytes), row 0: tile 0 */
    H044_M(0x42) = 0;
    H044_M(0x41) = 3; /* H044_bss+$75: full-screen side borders, row 1: tile 3 */
    H044_M(0x33) = 5; /* H044_bss+$83: full-screen side borders, row 15: tile 5 */
    H044_M(0x32) = 0; /* H044_bss+$84: full-screen side borders, row 16: tile 0 */
    H044_M(0x31) = 3; /* H044_bss+$85: full-screen side borders, row 17: tile 3 */
    H044_M(0x2C) = 5; /* H044_bss+$8A: full-screen side borders, row 22: tile 5 */
    H044_M(0x2B) = 0; /* H044_bss+$8B: full-screen side borders, row 23: tile 0 */

    /* -$54: 17 bytes set to 4. */
    fill(0x54, 17, 4);
    H044_M(0x54) = 0; /* H044_bss+$62: border col $10 exploration, rows 0..16 (17 bytes), row 0: tile 0 */
    H044_M(0x53) = 3; /* H044_bss+$63: border col $10 exploration, row 1: tile 3 */
    H044_M(0x45) = 5; /* H044_bss+$71: border col $10 exploration, row 15: tile 5 */
    H044_M(0x44) = 0; /* H044_bss+$72: border col $10 exploration, row 16: tile 0 */

    /* -$6C: 24 bytes set to 4. */
    fill(0x6C, 24, 4);
    H044_M(0x6C) = 0; /* H044_bss+$4A: border col $27 memorisation, rows 0..23 (24 bytes), row 0: tile 0 */
    H044_M(0x6B) = 3; /* H044_bss+$4B: border col $27 memorisation, row 1: tile 3 */
    H044_M(0x5D) = 5; /* H044_bss+$59: border col $27 memorisation, row 15: tile 5 */
    H044_M(0x5C) = 0; /* H044_bss+$5A: border col $27 memorisation, row 16: tile 0 */
    H044_M(0x5B) = 3; /* H044_bss+$5B: border col $27 memorisation, row 17: tile 3 */
    H044_M(0x56) = 5; /* H044_bss+$60: border col $27 memorisation, row 22: tile 5 */
    H044_M(0x55) = 0; /* H044_bss+$61: border col $27 memorisation, row 23: tile 0 */

    /* -$7A: indices 2..14 set to 4. */
    fill(0x7A, 13, 4);
    H044_M(0x7A) = 0; /* H044_bss+$3C: border cols 2/$E exploration, rows 2..14 (13 bytes), row 2: tile 0 */
    H044_M(0x79) = 3; /* H044_bss+$3D: border cols 2/$E exploration, row 3: tile 3 */
    H044_M(0x6F) = 5; /* H044_bss+$47: border cols 2/$E exploration, row 13: tile 5 */
    H044_M(0x6E) = 0; /* H044_bss+$48: border cols 2/$E exploration, row 14: tile 0 */

    /* -$92: 23 bytes set to 4. */
    fill(0x92, 23, 4);
    H044_M(0x92) = 0; /* H044_bss+$24: border cols 0/$16/$27 combat, rows 0..22, row 0: tile 0 */
    H044_M(0x91) = 3; /* H044_bss+$25: border cols 0/$16/$27 combat, row 1: tile 3 */
    H044_M(0x7D) = 5; /* H044_bss+$39: border cols 0/$16/$27 combat, row 21: tile 5 */
    H044_M(0x7C) = 0; /* H044_bss+$3A: border cols 0/$16/$27 combat, row 22: tile 0 */

    /* -$AA: 23 bytes set to 4. */
    fill(0xAA, 23, 4);
    H044_M(0xAA) = 0; /* H044_bss+$C: border cols 0/$27 character, rows 0..22 (23 bytes), row 0: tile 0 */
    H044_M(0xA9) = 3; /* H044_bss+$D: border cols 0/$27 character, row 1: tile 3 */
    H044_M(0xA3) = 5; /* H044_bss+$13: border cols 0/$27 character, row 7: tile 5 */
    H044_M(0xA2) = 0; /* H044_bss+$14: border cols 0/$27 character, row 8: tile 0 */
    H044_M(0xA1) = 3; /* H044_bss+$15: border cols 0/$27 character, row 9: tile 3 */
    H044_M(0x9B) = 5; /* H044_bss+$1B: border cols 0/$27 character, row 15: tile 5 */
    H044_M(0x9A) = 0; /* H044_bss+$1C: border cols 0/$27 character, row 16: tile 0 */
    H044_M(0x99) = 3; /* H044_bss+$1D: border cols 0/$27 character, row 17: tile 3 */
    H044_M(0x97) = 5; /* H044_bss+$1F: border cols 0/$27 character, row 19: tile 5 */
    H044_M(0x96) = 0; /* H044_bss+$20: border cols 0/$27 character, row 20: tile 0 */
    H044_M(0x95) = 3; /* H044_bss+$21: border cols 0/$27 character, row 21: tile 3 */
    H044_M(0x94) = 5; /* H044_bss+$22: border cols 0/$27 character, row 22: tile 5 */

    /* -$B6: indices 9..19 set to 4. */
    fill(0xB6, 11, 4);
    H044_M(0xB6) = 3; /* H044_bss+$0: border col $13 rows 9..19 (11 bytes, tile-$114), row 9: tile 3 */
    H044_M(0xB0) = 5; /* H044_bss+$6: border col $13 character screen, row 15: tile 5 */
    H044_M(0xAF) = 0; /* H044_bss+$7: border col $13 character screen, row 16: tile 0 */
    H044_M(0xAE) = 3; /* H044_bss+$8: border col $13 character screen, row 17: tile 3 */
    H044_M(0xAC) = 5; /* H044_bss+$A: border col $13 character screen, row 19: tile 5 */

    /* -$2(a4): loop counter, left at its last value ($14). */
    H044_M(0x02) = 0x00; /* H044_bss+$B4: (word, high byte) loop counter of the init, stays $0014 */
    H044_M(0x01) = 0x14; /* H044_bss+$B5: (word, low byte) loop counter of the init, stays $0014 */
}

/*
 * PORT H044+$00C8: tile of the top frame in column x (row 0).
 * Normally from the table at -$2A(a4); columns 8, $13 and $1E (joints)
 * take the tile from persistent state A ($3F2 + $A, $3F4 + 6,
 * $3F6 + $E).  For x < 8 the table applies anyway: the jump table
 * of the original uses x itself as the index, so x = 0..2 go through the
 * joint branches before being corrected.
 */
static void draw_top_border_cell(u16 x)
{
    u16 index = x;
    u16 tile = 0;

    if (x == 8) {
        index = 0;
    } else if (x == 0x13) {
        index = 1;
    } else if (x == 0x1E) {
        index = 2;
    }
    switch (index) {
    case 0:
        /* A+$3F2: (word) phase (0..3) of cycle 1: frame icon column 8 */
        tile = (u16)(COK_GET16(g_state_a + 0x3F2) + 0x0A);
        break;
    case 1:
        /* A+$3F4: (word) phase (0..3) of cycle 2: frame icon column $13 */
        tile = (u16)(COK_GET16(g_state_a + 0x3F4) + 6);
        break;
    case 2:
        /* A+$3F6: (word) phase (0..3) of cycle 3: frame icon column $1E */
        tile = (u16)(COK_GET16(g_state_a + 0x3F6) + 0x0E);
        break;
    default:
        /* H044_bss+$8C: top frame row 0, columns 0..39 (40 bytes, tile-$114) */
        tile = H044_M(0x2A - x);
        break;
    }
    if (x < 8) {
        /* H044_bss+$8C: top frame row 0, columns 0..39 (40 bytes, tile-$114) */
        tile = H044_M(0x2A - x);
    }
    draw_8x8_tile(x, 0, (u16)(tile + 0x114), 0, 0);
}

/*
 * PORT H044+$01C2: full-screen frame.  Colour 13 at $F0F (palette
 * H005+$52AE, 16 colours), interior cleared, top row, sides (from the
 * table at -$42(a4); with mid the rows $F..$11 use tile 4) and bottom
 * row.
 */
void draw_screen_frame(u8 mid)
{
    u16 x;
    u16 y;
    u16 tile;

    H005_SET_W(0x52C8, 0x0F0F); /* $52C8: (word) colour 13 of the palette $52AE (set to $F0F) */
    /* $52AE: current screen palette, RGB4 (16 or 32 colours) */
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x52AE], 0x10);
    clear_text_cells(1, 1, 0x26, 0x16);
    for (x = 0; x <= 0x27; ++x) {
        draw_top_border_cell(x);
    }
    for (y = 0; y <= 0x17; ++y) {
        if (y > 0x0E && y < 0x12 && mid) {
            tile = 4;
        } else {
            /* H044_bss+$74: full-screen side borders, rows 0..23 (24 bytes), row 0: tile 0 */
            tile = H044_M(0x42 - y);
        }
        draw_8x8_tile(0, y, (u16)(tile + 0x114), 0, 0);
        draw_8x8_tile(0x27, y, (u16)(tile + 0x114), 0, 0);
    }
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x17, 0x114, 0, 0);
    }
}

/* PORT H044+$02D8: frame of the credits, with two lines at rows 4 and 6. */
void draw_credits_frame(void)
{
    u16 x;

    draw_screen_frame(1);
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 4, 0x114, 0, 0);
        draw_8x8_tile(x, 6, 0x114, 0, 0);
    }
}

/*
 * PORT H044+$068E: frame of the character screen: screen
 * cleared, palette H005+$52AE (16 colours), top row, horizontal
 * rows 8, $10, $14 and $17, sides (table at -$AA(a4)) and vertical
 * divider at column $13 between rows 9 and $13 (table at -$B6(a4)).
 */
void draw_character_frame(void)
{
    u16 x;                              /* -$2(a5) */
    u16 y;                              /* -$4(a5) */

    clear_text_cells(0, 0, 0x27, 0x17);
    /* $52AE: current screen palette, RGB4 (16 or 32 colours) */
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x52AE], 0x10);
    for (x = 0; x <= 0x27; ++x) {
        draw_top_border_cell(x);
        draw_8x8_tile(x, 8, 0x114, 0, 0);
        draw_8x8_tile(x, 0x10, 0x114, 0, 0);
        draw_8x8_tile(x, 0x14, 0x114, 0, 0);
        draw_8x8_tile(x, 0x17, 0x114, 0, 0);
    }
    for (y = 0; y <= 0x16; ++y) {
        /* H044_bss+$C: border cols 0/$27 character, rows 0..22 (23 bytes), row 0: tile 0 */
        draw_8x8_tile(0, y, (u16)(H044_M(0xAA - y) + 0x114), 0, 0);
        /* H044_bss+$C: border cols 0/$27 character, rows 0..22 (23 bytes), row 0: tile 0 */
        draw_8x8_tile(0x27, y, (u16)(H044_M(0xAA - y) + 0x114), 0, 0);
    }
    for (y = 9; y <= 0x13; ++y) {
        /* H044_bss+$0: border col $13 rows 9..19 (11 bytes, tile-$114), row 9: tile 3 */
        draw_8x8_tile(0x13, y, (u16)(H044_M(0xB6 - (y - 9)) + 0x114), 0, 0);
    }
}

/*
 * PORT H044+$07DE: frame of the item screen: whole frame,
 * row of tiles at row 2 and joints at the sides of row 3.
 */
void draw_items_frame(void)
{
    u16 x;                              /* -$2(a5) */

    draw_screen_frame(1);
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 2, 0x114, 0, 0);
    }
    draw_8x8_tile(0, 3, 0x117, 0, 0);
    draw_8x8_tile(0x27, 3, 0x117, 0, 0);
}

/*
 * PORT H044+$0586: combat frame: screen cleared, palette
 * H005+$522E (32 colours), top row, sides and divider at column
 * $16 (table at -$92(a4)) and row $16.
 */
void draw_combat_frame(void)
{
    u16 x;                              /* -$2(a5) */
    u16 y;                              /* -$4(a5) */

    clear_text_cells(0, 0, 0x27, 0x17);
    /* $522E: palette of the loaded picture, 32 RGB4 colours ($40 bytes) */
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x522E], 0x20);
    for (x = 0; x <= 0x27; ++x) {
        draw_top_border_cell(x);
    }
    for (y = 0; y <= 0x16; ++y) {
        /* H044_bss+$24: border cols 0/$16/$27 combat, rows 0..22, row 0: tile 0 */
        draw_8x8_tile(0, y, (u16)(H044_M(0x92 - y) + 0x114), 0, 0);
        /* H044_bss+$24: border cols 0/$16/$27 combat, rows 0..22, row 0: tile 0 */
        draw_8x8_tile(0x16, y, (u16)(H044_M(0x92 - y) + 0x114), 0, 0);
        /* H044_bss+$24: border cols 0/$16/$27 combat, rows 0..22, row 0: tile 0 */
        draw_8x8_tile(0x27, y, (u16)(H044_M(0x92 - y) + 0x114), 0, 0);
    }
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x16, 0x114, 0, 0);
    }
}

/*
 * PORT H044+$0330: exploration frame: whole frame, row $10,
 * divider at column $10 (table at -$54(a4)) and the box of the
 * view (rows and columns 2 and $E, sides from the table at -$7A(a4)).
 */
void draw_explore_frame(void)
{
    u16 x;                              /* -$2(a5) */
    u16 y;                              /* -$4(a5) */

    draw_screen_frame(0);
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x10, 0x114, 0, 0);
    }
    for (y = 0; y <= 0x10; ++y) {
        /* H044_bss+$62: border col $10 exploration, rows 0..16 (17 bytes), row 0: tile 0 */
        draw_8x8_tile(0x10, y, (u16)(H044_M(0x54 - y) + 0x114), 0, 0);
    }
    for (x = 2; x <= 0x0E; ++x) {
        draw_8x8_tile(x, 2, 0x114, 0, 0);
        draw_8x8_tile(x, 0x0E, 0x114, 0, 0);
    }
    for (y = 2; y <= 0x0E; ++y) {
        /* H044_bss+$3C: border cols 2/$E exploration, rows 2..14 (13 bytes), row 2: tile 0 */
        draw_8x8_tile(2, y, (u16)(H044_M(0x7A - (y - 2)) + 0x114), 0, 0);
        /* H044_bss+$3C: border cols 2/$E exploration, rows 2..14 (13 bytes), row 2: tile 0 */
        draw_8x8_tile(0x0E, y, (u16)(H044_M(0x7A - (y - 2)) + 0x114), 0, 0);
    }
}

/* PORT H044+$0452: whole frame with row $10 (outdoors). */
void draw_wild_frame(void)
{
    u16 x;                              /* -$2(a5) */

    draw_screen_frame(0);
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x10, 0x114, 0, 0);
    }
}

/*
 * PORT H044+$0492: frame of the choice of the spells to memorise:
 * rows 1..$10 cleared, top row, sides (left from the table
 * at -$42(a4), right from -$6C(a4)) and rows $17 and $10.  The palette does not
 * change.
 */
void draw_memorize_frame(void)
{
    u16 x;                              /* -$2(a5) */
    u16 y;                              /* -$4(a5) */

    clear_text_cells(1, 1, 0x26, 0x10);
    for (x = 0; x <= 0x27; ++x) {
        draw_top_border_cell(x);
    }
    for (y = 0; y <= 0x17; ++y) {
        /* H044_bss+$74: full-screen side borders, rows 0..23 (24 bytes), row 0: tile 0 */
        draw_8x8_tile(0, y, (u16)(H044_M(0x42 - y) + 0x114), 0, 0);
        /* H044_bss+$4A: border col $27 memorisation, rows 0..23 (24 bytes), row 0: tile 0 */
        draw_8x8_tile(0x27, y, (u16)(H044_M(0x6C - y) + 0x114), 0, 0);
    }
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x17, 0x114, 0, 0);
    }
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x10, 0x114, 0, 0);
    }
}
