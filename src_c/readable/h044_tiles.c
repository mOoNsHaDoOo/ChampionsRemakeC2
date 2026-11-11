/* H044: disegno di elementi 8x8 (glifi o tile) e servizi grafici/UI. */
#include "h044_tiles.h"
#include "h022_view.h"
#include "h030.h"
#include "h034.h"
#include "globals.h"

/*
 * Dati del modulo: $B6 byte sotto a4 (da -$B6 a -$1).  H044_M(off) e' il
 * byte -off(a4); le tabelle sono indici di tile 8x8 (0..5) per le cornici.
 */
u8 g_h044_bss[0xB6];
#define H044_M(off) g_h044_bss[0xB6 - (off)]

/* count byte a value dal byte -at(a4) in su (indirizzi crescenti). */
static void fill(unsigned at, unsigned count, u8 value)
{
    memset(&H044_M(at), value, count);
}

/* PORT H044+$00BA */
void h044_init(void)
{
    /* -$2A: 40 byte azzerati (riga superiore della cornice). */
    fill(0x2A, 40, 0);
    H044_M(0x23) = 1;
    H044_M(0x21) = 2;
    H044_M(0x18) = 1;
    H044_M(0x16) = 2;
    H044_M(0x0D) = 1;
    H044_M(0x0B) = 2;

    /* -$42: 24 byte a 4 (bordi laterali). */
    fill(0x42, 24, 4);
    H044_M(0x42) = 0;
    H044_M(0x41) = 3;
    H044_M(0x33) = 5;
    H044_M(0x32) = 0;
    H044_M(0x31) = 3;
    H044_M(0x2C) = 5;
    H044_M(0x2B) = 0;

    /* -$54: 17 byte a 4. */
    fill(0x54, 17, 4);
    H044_M(0x54) = 0;
    H044_M(0x53) = 3;
    H044_M(0x45) = 5;
    H044_M(0x44) = 0;

    /* -$6C: 24 byte a 4. */
    fill(0x6C, 24, 4);
    H044_M(0x6C) = 0;
    H044_M(0x6B) = 3;
    H044_M(0x5D) = 5;
    H044_M(0x5C) = 0;
    H044_M(0x5B) = 3;
    H044_M(0x56) = 5;
    H044_M(0x55) = 0;

    /* -$7A: indici 2..14 a 4. */
    fill(0x7A, 13, 4);
    H044_M(0x7A) = 0;
    H044_M(0x79) = 3;
    H044_M(0x6F) = 5;
    H044_M(0x6E) = 0;

    /* -$92: 23 byte a 4. */
    fill(0x92, 23, 4);
    H044_M(0x92) = 0;
    H044_M(0x91) = 3;
    H044_M(0x7D) = 5;
    H044_M(0x7C) = 0;

    /* -$AA: 23 byte a 4. */
    fill(0xAA, 23, 4);
    H044_M(0xAA) = 0;
    H044_M(0xA9) = 3;
    H044_M(0xA3) = 5;
    H044_M(0xA2) = 0;
    H044_M(0xA1) = 3;
    H044_M(0x9B) = 5;
    H044_M(0x9A) = 0;
    H044_M(0x99) = 3;
    H044_M(0x97) = 5;
    H044_M(0x96) = 0;
    H044_M(0x95) = 3;
    H044_M(0x94) = 5;

    /* -$B6: indici 9..19 a 4. */
    fill(0xB6, 11, 4);
    H044_M(0xB6) = 3;
    H044_M(0xB0) = 5;
    H044_M(0xAF) = 0;
    H044_M(0xAE) = 3;
    H044_M(0xAC) = 5;

    /* -$2(a4): contatore dei cicli, lasciato all'ultimo valore ($14). */
    H044_M(0x02) = 0x00;
    H044_M(0x01) = 0x14;
}

/*
 * PORT H044+$00C8: tile della cornice superiore nella colonna x (riga 0).
 * Di norma dalla tabella di -$2A(a4); le colonne 8, $13 e $1E (giunzioni)
 * prendono la tile dallo stato persistente A ($3F2 + $A, $3F4 + 6,
 * $3F6 + $E).  Per x < 8 vale comunque la tabella: la tabella di salto
 * dell'originale usa x stesso come indice, quindi x = 0..2 passano dai
 * rami delle giunzioni prima di essere corretti.
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
        tile = (u16)(COK_GET16(g_state_a + 0x3F2) + 0x0A);
        break;
    case 1:
        tile = (u16)(COK_GET16(g_state_a + 0x3F4) + 6);
        break;
    case 2:
        tile = (u16)(COK_GET16(g_state_a + 0x3F6) + 0x0E);
        break;
    default:
        tile = H044_M(0x2A - x);
        break;
    }
    if (x < 8) {
        tile = H044_M(0x2A - x);
    }
    draw_8x8_tile(x, 0, (u16)(tile + 0x114), 0, 0);
}

/*
 * PORT H044+$01C2: cornice a tutto schermo.  Colore 13 a $F0F (palette
 * H005+$52AE, 16 colori), interno cancellato, riga superiore, lati (dalla
 * tabella di -$42(a4); con mid le righe $F..$11 usano la tile 4) e riga
 * inferiore.
 */
void draw_screen_frame(u8 mid)
{
    u16 x;
    u16 y;
    u16 tile;

    H005_SET_W(0x52C8, 0x0F0F);
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x52AE], 0x10);
    clear_text_cells(1, 1, 0x26, 0x16);
    for (x = 0; x <= 0x27; ++x) {
        draw_top_border_cell(x);
    }
    for (y = 0; y <= 0x17; ++y) {
        if (y > 0x0E && y < 0x12 && mid) {
            tile = 4;
        } else {
            tile = H044_M(0x42 - y);
        }
        draw_8x8_tile(0, y, (u16)(tile + 0x114), 0, 0);
        draw_8x8_tile(0x27, y, (u16)(tile + 0x114), 0, 0);
    }
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x17, 0x114, 0, 0);
    }
}

/* PORT H044+$02D8: cornice dei crediti, con due linee alle righe 4 e 6. */
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
 * PORT H044+$068E: cornice della schermata del personaggio: schermo
 * cancellato, palette H005+$52AE (16 colori), riga superiore, righe
 * orizzontali 8, $10, $14 e $17, lati (tabella di -$AA(a4)) e divisorio
 * verticale alla colonna $13 tra le righe 9 e $13 (tabella di -$B6(a4)).
 */
void draw_character_frame(void)
{
    u16 x;                              /* -$2(a5) */
    u16 y;                              /* -$4(a5) */

    clear_text_cells(0, 0, 0x27, 0x17);
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x52AE], 0x10);
    for (x = 0; x <= 0x27; ++x) {
        draw_top_border_cell(x);
        draw_8x8_tile(x, 8, 0x114, 0, 0);
        draw_8x8_tile(x, 0x10, 0x114, 0, 0);
        draw_8x8_tile(x, 0x14, 0x114, 0, 0);
        draw_8x8_tile(x, 0x17, 0x114, 0, 0);
    }
    for (y = 0; y <= 0x16; ++y) {
        draw_8x8_tile(0, y, (u16)(H044_M(0xAA - y) + 0x114), 0, 0);
        draw_8x8_tile(0x27, y, (u16)(H044_M(0xAA - y) + 0x114), 0, 0);
    }
    for (y = 9; y <= 0x13; ++y) {
        draw_8x8_tile(0x13, y, (u16)(H044_M(0xB6 - (y - 9)) + 0x114), 0, 0);
    }
}

/*
 * PORT H044+$07DE: cornice della schermata degli oggetti: cornice intera,
 * riga di tile alla riga 2 e giunzioni ai lati della riga 3.
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
 * PORT H044+$0586: cornice del combattimento: schermo cancellato, palette
 * H005+$522E (32 colori), riga superiore, lati e divisorio alla colonna
 * $16 (tabella di -$92(a4)) e riga $16.
 */
void draw_combat_frame(void)
{
    u16 x;                              /* -$2(a5) */
    u16 y;                              /* -$4(a5) */

    clear_text_cells(0, 0, 0x27, 0x17);
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x522E], 0x20);
    for (x = 0; x <= 0x27; ++x) {
        draw_top_border_cell(x);
    }
    for (y = 0; y <= 0x16; ++y) {
        draw_8x8_tile(0, y, (u16)(H044_M(0x92 - y) + 0x114), 0, 0);
        draw_8x8_tile(0x16, y, (u16)(H044_M(0x92 - y) + 0x114), 0, 0);
        draw_8x8_tile(0x27, y, (u16)(H044_M(0x92 - y) + 0x114), 0, 0);
    }
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x16, 0x114, 0, 0);
    }
}

/*
 * PORT H044+$0330: cornice dell'esplorazione: cornice intera, riga $10,
 * divisorio alla colonna $10 (tabella di -$54(a4)) e il riquadro della
 * vista (righe e colonne 2 ed $E, lati dalla tabella di -$7A(a4)).
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
        draw_8x8_tile(0x10, y, (u16)(H044_M(0x54 - y) + 0x114), 0, 0);
    }
    for (x = 2; x <= 0x0E; ++x) {
        draw_8x8_tile(x, 2, 0x114, 0, 0);
        draw_8x8_tile(x, 0x0E, 0x114, 0, 0);
    }
    for (y = 2; y <= 0x0E; ++y) {
        draw_8x8_tile(2, y, (u16)(H044_M(0x7A - (y - 2)) + 0x114), 0, 0);
        draw_8x8_tile(0x0E, y, (u16)(H044_M(0x7A - (y - 2)) + 0x114), 0, 0);
    }
}

/* PORT H044+$0452: cornice intera con la riga $10 (all'aperto). */
void draw_wild_frame(void)
{
    u16 x;                              /* -$2(a5) */

    draw_screen_frame(0);
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x10, 0x114, 0, 0);
    }
}

/*
 * PORT H044+$0492: cornice della scelta degli incantesimi da memorizzare:
 * righe 1..$10 cancellate, riga superiore, lati (sinistro dalla tabella
 * di -$42(a4), destro da -$6C(a4)) e righe $17 e $10.  La palette non
 * cambia.
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
        draw_8x8_tile(0, y, (u16)(H044_M(0x42 - y) + 0x114), 0, 0);
        draw_8x8_tile(0x27, y, (u16)(H044_M(0x6C - y) + 0x114), 0, 0);
    }
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x17, 0x114, 0, 0);
    }
    for (x = 0; x <= 0x27; ++x) {
        draw_8x8_tile(x, 0x10, 0x114, 0, 0);
    }
}
