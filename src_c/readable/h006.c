/*
 * H006: preparazione dell'ambiente, percorsi, stato e risorse comuni.
 *
 * Dati del modulo (a4 = H006+$40):
 *   +$07 "df0:"       +$0C "df0:Save"    +$15 "Save"
 *   +$1A/$30/$46      Assign "Disk One:" / "Disk Two:" / "Disk Three:" ""
 *   +$5E "NormIsKing" +$69 ""  +$6B ""   +$6D "Loading...Please Wait"
 *   +$83/$8A "COMSPR" +$91/$95/$99 "sky" +$9D "ITEMS"
 *   -$2  word, contatore dei cicli (dato del modulo, non locale)
 *   -$40 long, secondi di CurrentTime
 */
#include "h006.h"
#include "h027.h"
#include "h033.h"
#include "h008.h"
#include "h002_dos.h"
#include "h003_exec.h"
#include "h021_intuition.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h016_gfx.h"
#include "h031.h"
#include "h034.h"
#include "h035.h"
#include "globals.h"
#include "unported.h"

static u16 s_i;                         /* -$2(a4) */
static u32 s_time_seconds;              /* -$40(a4) */

extern u32 g_h023_0000;                 /* H023+$0000: microsecondi */

/* PORT H006+$00EC: link/unlk, nessun effetto. */
void h006_init(void)
{
}

/* move.b (a3)+,(a2)+ / dbeq dn: al massimo limit+1 byte, NUL compreso. */
static void copy_dbeq(char *dst, const char *src, unsigned limit)
{
    unsigned i;

    for (i = 0; i <= limit; ++i) {
        dst[i] = src[i];
        if (src[i] == 0) {
            break;
        }
    }
}

/*
 * PORT H006+$00FA: carica il record 99 di "border" (con maschera, colore
 * 13) e ne copia i primi 24x8 pixel, immagine e maschera, alla x 160 del
 * set 8x8 del posto 4 (H005+$3348); poi lo libera.
 */
static void merge_border_tiles(void)
{
    struct GfxRecord *border = NULL;    /* -$4(a5) */

    load_indexed_gfx_record(6, "border", 0x63, 1, 0x0D, &border);
    (void)graphics_blt_bitmap(border->image, 0, 0, g_8x8_sets[4]->image,
                              0xA0, 0, 0x18, 8, 0xC0, 0xFF, NULL);
    (void)graphics_blt_bitmap(border->mask, 0, 0, g_8x8_sets[4]->mask,
                              0xA0, 0, 0x18, 8, 0xC0, 0xFF, NULL);
    free_gfx_record(&border);
}

/* Legge i 129 record da $12 byte del file ITEMS in H005+$336C. */
static void load_items_table(void)
{
    cok_bptr file;

    file = dos_open("ITEMS", MODE_OLDFILE);
    if (file == 0) {
        return;
    }
    (void)dos_seek(file, 2, OFFSET_BEGINNING);
    for (s_i = 0; s_i <= 0x80; ++s_i) {
        u8 *rec = &g_h005[0x336C + (u32)s_i * 0x12];

        (void)dos_read(file, rec, 5);
        h031_swap_word(rec + 4);
        (void)dos_read(file, rec + 6, 7);
        h031_swap_word(rec + 0x0C);
        (void)dos_read(file, rec + 0x0E, 4);
    }
    dos_close(file);
}

/*
 * PORT H006+$01AE (Initialize_GameEnvironment): percorso del salvataggio e
 * assegnazioni dei dischi, blocchi di stato, record grafici, azzeramento
 * dello stato di gioco, risorse comuni e tabella degli oggetti.
 */
void init_game_environment(void)
{
    G_RESOURCE_GROUP = 0;

    /* Percorso del salvataggio ($3CD4, dbeq con $50). */
    if (h026_compare_nocase(0x50, G_DATA_PREFIX, 4, "df0:") == 1) {
        copy_dbeq((char *)&g_h005[0x3CD4], "df0:Save", 0x50);
    } else {
        copy_dbeq((char *)&g_h005[0x3CD4], "Save", 0x50);
        (void)dos_execute("Assign \"Disk One:\" \"\"", 0, 0);
        (void)dos_execute("Assign \"Disk Two:\" \"\"", 0, 0);
        (void)dos_execute("Assign \"Disk Three:\" \"\"", 0, 0);
    }

    if (file_exists(0x0A, "NormIsKing") == 0) {
        intuition_current_time(&s_time_seconds, &g_h023_0000);
    }
    open_game_display();

    H005_B(0x24A2) = 1;
    H005_B(0x2489) = 0;
    H005_SET_W(0x2356, 0xA0);           /* mouse X */
    H005_SET_W(0x2354, 0x64);           /* mouse Y */
    H005_SET_W(0x2352, 0);
    H005_SET_W(0x2350, 0);

    g_state_a = (u8 *)exec_alloc_mem(0x800, COK_MEMF_CLEAR);
    g_state_b = (u8 *)exec_alloc_mem(0x800, COK_MEMF_CLEAR);
    g_state_c = (u8 *)exec_alloc_mem(0x400, COK_MEMF_CLEAR);
    g_ecl_buffer = (u8 *)exec_alloc_mem(0x1E00, COK_MEMF_CLEAR);
    g_h005_282e = (u8 *)exec_alloc_mem(0x924, COK_MEMF_CLEAR);
    g_geo_planes = (u8 *)exec_alloc_mem(0x400, COK_MEMF_CLEAR);

    allocate_gfx_record(8, 1, 1, 0, &g_gfx_3334);
    allocate_gfx_record(0x30, 3, 1, 0, &g_gfx_3d8a);
    allocate_gfx_record(0x18, 3, 0x28, 1, &g_gfx_332c);
    g_gfx_3d8e = NULL;
    prepare_display_resources();

    COK_PUT16(g_state_a + 0x3E8, 3);
    COK_PUT16(g_state_a + 0x1CC, 1);
    COK_PUT16(g_state_a + 0x1E4, 0);
    COK_PUT16(g_state_a + 0x3F2, 2);
    COK_PUT16(g_state_a + 0x3F4, 2);
    COK_PUT16(g_state_a + 0x3F6, 2);

    /* H006+$03E8: 29 coppie di set 24x24 a $3244. */
    for (s_i = 0; s_i <= 0x1C; ++s_i) {
        g_sprite_sets[s_i][0] = NULL;
        g_sprite_sets[s_i][1] = NULL;
    }
    /* H006+$041C: due voci da 6 byte a $27B0. */
    for (s_i = 1; s_i <= 2; ++s_i) {
        H005_B(0x27B0 + (s_i - 1) * 6) = 0xFF;
        g_gfx_27b0[s_i - 1] = NULL;      /* long a +2 */
    }
    g_pic_rec_27c2 = NULL;
    g_pic_rec_27c6 = NULL;
    /* H006+$0468 */
    for (s_i = 2; s_i <= 8; ++s_i) {
        H005_SET_W(0x27DA + (s_i - 2) * 2, 0);
        g_pic_buffers[s_i - 2] = NULL;
    }
    H005_SET_W(0x27BC, 0);
    g_gfx_2798 = NULL;
    H005_SET_L(0x2A3A, 0);

    h029_fill_bytes(7, &g_h005[0x281C], 7, 0);
    H005_SET_W(0x281C, 7);
    H005_SET_W(0x281E, 0x0D);
    H005_B(0x2820) = 0;
    h029_fill_bytes(2, &g_h005[0x24E4], 3, 1);

    /* H006+$04F8: stato dei tre insiemi di pareti. */
    H005_SET_W(0x2810, 0);
    H005_SET_W(0x2812, 1);
    for (s_i = 2; s_i <= 3; ++s_i) {
        H005_SET_W(0x2810 + (s_i - 1) * 4, 0xFFFF);
        H005_SET_W(0x2810 + (s_i - 1) * 4 + 2, 0xFFFF);
    }

    H005_B(0x24D4) = 1;
    H005_B(0x24D5) = 1;
    H005_B(0x24D2) = 0;
    H005_B(0x24CE) = 1;
    H005_B(0x24D1) = 0;
    H005_SET_W(0x3DDE, 0);
    g_party_head = NULL;
    g_current_char = NULL;
    H005_SET_W(0x3DEA, 0x3500);         /* PC logico ECL */
    H005_SET_W(0x3DF6, 4);
    G_DEMO_FLAG = 0;
    H005_B(0x246D) = 1;
    H005_B(0x2825) = 0;
    COK_PUT16(g_state_b + 0x67C, 0);
    H005_SET_W(0x2796, 1);
    H005_B(0x24C1) = 0;
    H005_B(0x24E2) = 0;
    H005_B(0x2497) = 0;
    H005_B(0x24BF) = 0;
    H005_B(0x24BE) = 0;
    H005_B(0x24BD) = 0;
    H005_B(0x24D0) = 0;
    H005_B(0x24A6) = 1;
    H005_B(0x24BA) = 0;
    H005_B(0x24A4) = 0;
    copy_dbeq((char *)&g_h005[0x27A6], "", 8);
    copy_dbeq((char *)&g_h005[0x279C], "", 8);
    H005_B(0x2486) = 0xFF;
    H005_B(0x2485) = 0xFF;
    H005_B(0x24A3) = 0;
    H005_B(0x247E) = 0xE8;
    H005_B(0x247F) = 0xDB;
    H005_B(0x24B4) = 0;
    H005_B(0x24D8) = 0;
    H005_B(0x24C6) = 1;
    H005_B(0x2484) = 0xFF;
    H005_B(0x24AD) = 0;
    H005_B(0x24CF) = 0;
    H005_B(0x2483) = 1;
    H005_B(0x3DE3) = 4;                 /* contesto nativo */
    H005_B(0x3DE2) = 0;
    H005_B(0x24A7) = 1;
    H005_B(0x24E0) = 0;
    H005_B(0x24AE) = 0;
    g_gfx_sky_280c = NULL;
    g_gfx_sky_2808 = NULL;
    g_gfx_sky_2804 = NULL;
    g_dropped_items = NULL;             /* $3360 */
    H005_B(0x24B1) = 0;
    H005_B(0x24CB) = 0;
    H005_B(0x24CC) = 0;
    H005_B(0x24B0) = 0;
    H005_B(0x249E) = 0;
    H005_B(0x24DA) = 0;

    h029_fill_bytes(0x4F, &g_h005[0x16], 0x50, 0);
    H005_SET_W(0x14, 0);
    load_gothic_font();
    clear_message_line();
    ui_draw_text(0, 0x18, 0x0A, 0, 0x15, "Loading...Please Wait");

    for (s_i = 0; s_i <= 4; ++s_i) {
        g_8x8_sets[s_i] = NULL;
    }
    load_8x8_set(0xCA, 4);
    load_8x8_set(0xCB, 0);
    merge_border_tiles();

    for (s_i = 0; s_i <= 0x0B; ++s_i) {
        load_sprite_set(6, "COMSPR", s_i, (u16)(s_i + 0x0D));
    }
    for (s_i = 0x19; s_i <= 0x1C; ++s_i) {
        load_sprite_set(6, "COMSPR", s_i, s_i);
    }
    load_indexed_gfx_record(3, "sky", 0xFA, 1, 0, &g_gfx_sky_280c);
    load_indexed_gfx_record(3, "sky", 0xFB, 1, 0, &g_gfx_sky_2808);
    load_indexed_gfx_record(3, "sky", 0xFC, 1, 0x0D, &g_gfx_sky_2804);

    load_items_table();
    install_effect_handlers();
    install_action_handlers();
}

/*
 * PORT H006+$0914: azzera lo stato per una nuova partita (dopo la fine
 * dell'avventura): stati A, B, C e programma ECL, posizione 7,13 verso
 * est, definizioni dei muri, party vuoto, PC dell'ECL a $3500, velocita'
 * 4, disco 1 e i flag del gioco; contesto 4.
 */
void reset_game_state(void)
{
    h029_fill_bytes(0x7FF, g_state_a, 0x800, 0);
    COK_PUT16(g_state_a + 0x3E8, 3);
    COK_PUT16(g_state_a + 0x1CC, 1);
    COK_PUT16(g_state_a + 0x1E4, 0);
    h029_fill_bytes(0x7FF, g_state_b, 0x800, 0);
    h029_fill_bytes(0x3FF, g_state_c, 0x400, 0);
    h029_fill_bytes(0x1DFF, g_ecl_buffer, 0x1DFF, 0);
    h029_fill_bytes(7, &H005_B(0x281C), 7, 0);
    H005_SET_W(0x281C, 7);
    H005_SET_W(0x281E, 0x0D);
    H005_B(0x2820) = 2;
    h029_fill_bytes(2, &H005_B(0x24E4), 3, 1);
    H005_B(0x24A2) = 1;
    H005_SET_W(0x2810, 0);
    H005_SET_W(0x2812, 1);
    for (s_i = 2; s_i <= 3; ++s_i) {
        H005_SET_W(0x2810 + (s_i - 1) * 4, 0xFFFF);
        H005_SET_W(0x2812 + (s_i - 1) * 4, 0xFFFF);
    }
    H005_B(0x24D2) = 0;
    COK_PUT16(g_state_a + 0x3F2, 2);
    COK_PUT16(g_state_a + 0x3F4, 2);
    COK_PUT16(g_state_a + 0x3F6, 2);
    H005_B(0x24CE) = 1;
    H005_B(0x24D1) = 0;
    H005_SET_W(0x3DDE, 0);
    g_party_head = NULL;
    g_current_char = NULL;
    H005_SET_W(0x3DEA, 0x3500);
    H005_SET_W(0x3DF6, 4);
    H005_B(0x246E) = 1;
    H005_B(0x246D) = 1;
    H005_B(0x2825) = 0;
    COK_PUT16(g_state_b + 0x67C, 0);
    H005_SET_W(0x2796, 1);
    H005_B(0x24C1) = 0;
    H005_B(0x24E2) = 0;
    H005_B(0x2497) = 0;
    H005_B(0x24BF) = 0;
    H005_B(0x24BE) = 0;
    H005_B(0x24BD) = 0;
    H005_B(0x24D0) = 0;
    H005_B(0x24A6) = 1;
    H005_B(0x24BA) = 0;
    H005_B(0x24A4) = 0;
    H005_B(0x27A6) = 0;                 /* stringa vuota (H006 -$A3) */
    H005_B(0x279C) = 0;                 /* stringa vuota (H006 -$A5) */
    H005_B(0x2486) = 0xFF;
    H005_B(0x2485) = 0xFF;
    H005_B(0x24A3) = 0;
    H005_B(0x247E) = 0xE8;
    H005_B(0x247F) = 0xDB;
    H005_B(0x24B4) = 0;
    H005_B(0x24C6) = 1;
    H005_B(0x2484) = 0xFF;
    H005_B(0x24AD) = 0;
    H005_B(0x24CF) = 0;
    clear_message_line();
    H005_B(0x2483) = 1;
    H005_B(0x3DE3) = 4;
    H005_B(0x3DE2) = 0;
    H005_B(0x24A7) = 1;
    H005_B(0x24E0) = 0;
    H005_B(0x24B1) = 0;
    g_dropped_items = NULL;
    H005_B(0x24CB) = 0;
    H005_B(0x24CC) = 0;
    H005_B(0x24B0) = 0;
    H005_B(0x249E) = 0;
    H005_B(0x24D8) = 0;
    H005_B(0x24DA) = 0;
    H005_B(0x24AE) = 0;
}
