/*
 * H006: setup of the environment, paths, state and shared resources.
 *
 * Module data (a4 = H006+$40):
 *   +$07 "df0:"       +$0C "df0:Save"    +$15 "Save"
 *   +$1A/$30/$46      Assign "Disk One:" / "Disk Two:" / "Disk Three:" ""
 *   +$5E "NormIsKing" +$69 ""  +$6B ""   +$6D "Loading...Please Wait"
 *   +$83/$8A "COMSPR" +$91/$95/$99 "sky" +$9D "ITEMS"
 *   -$2  word, loop counter (module data, not local)
 *   -$40 long, seconds of CurrentTime
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

extern u32 g_h023_0000;                 /* H023+$0000: microseconds */

/* PORT H006+$00EC: link/unlk, no effect. */
void h006_init(void)
{
}

/* move.b (a3)+,(a2)+ / dbeq dn: at most limit+1 bytes, NUL included. */
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
 * PORT H006+$00FA: loads record 99 of "border" (with mask, colour
 * 13) and copies its first 24x8 pixels, picture and mask, at x 160 of the
 * 8x8 set of slot 4 (H005+$3348); then frees it.
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

/* Reads the 129 $12-byte records of the ITEMS file into H005+$336C. */
static void load_items_table(void)
{
    cok_bptr file;

    file = dos_open("ITEMS", MODE_OLDFILE);
    if (file == 0) {
        return;
    }
    (void)dos_seek(file, 2, OFFSET_BEGINNING);
    for (s_i = 0; s_i <= 0x80; ++s_i) {
        /* $336C: table of the item types (item+$30), $12 bytes per type; off = field */
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
 * PORT H006+$01AE (Initialize_GameEnvironment): path of the saved games and
 * disk assignments, state blocks, graphic records, clearing of the
 * game state, shared resources and item table.
 */
void init_game_environment(void)
{
    G_RESOURCE_GROUP = 0; /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */

    /* Path of the saved games ($3CD4, dbeq with $50). */
    if (h026_compare_nocase(0x50, G_DATA_PREFIX, 4, "df0:") == 1) {
        /* $3CD4: path of the saved games ($50 bytes, e.g. "df0:Save") */
        copy_dbeq((char *)&g_h005[0x3CD4], "df0:Save", 0x50);
    } else {
        /* $3CD4: path of the saved games ($50 bytes, e.g. "df0:Save") */
        copy_dbeq((char *)&g_h005[0x3CD4], "Save", 0x50);
        (void)dos_execute("Assign \"Disk One:\" \"\"", 0, 0);
        (void)dos_execute("Assign \"Disk Two:\" \"\"", 0, 0);
        (void)dos_execute("Assign \"Disk Three:\" \"\"", 0, 0);
    }

    if (file_exists(0x0A, "NormIsKing") == 0) {
        intuition_current_time(&s_time_seconds, &g_h023_0000);
    }
    open_game_display();

    H005_B(0x24A2) = 1; /* $24A2: 1: clicking a party name selects the character */
    H005_B(0x2489) = 0; /* $2489: use: only cleared at start-up (H006) */
    /* $2356: mouse X (word, initial $A0) */
    H005_SET_W(0x2356, 0xA0);           /* mouse X */
    /* $2354: mouse Y (word, initial $64) */
    H005_SET_W(0x2354, 0x64);           /* mouse Y */
    H005_SET_W(0x2352, 0); /* $2352: use: word cleared at start-up next to the mouse coordinates */
    H005_SET_W(0x2350, 0); /* $2350: use: word cleared at start-up next to the mouse coordinates */

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

    COK_PUT16(g_state_a + 0x3E8, 3); /* A+$3E8: (word) difficulty level (1..5, initial 3) */
    COK_PUT16(g_state_a + 0x1CC, 1); /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
    COK_PUT16(g_state_a + 0x1E4, 0); /* A+$1E4: (word) number of the current ECL area (copy of $2498) */
    COK_PUT16(g_state_a + 0x3F2, 2); /* A+$3F2: (word) phase (0..3) of cycle 1: frame icon column 8 */
    COK_PUT16(g_state_a + 0x3F4, 2); /* A+$3F4: (word) phase (0..3) of cycle 2: frame icon column $13 */
    COK_PUT16(g_state_a + 0x3F6, 2); /* A+$3F6: (word) phase (0..3) of cycle 3: frame icon column $1E */

    /* H006+$03E8: 29 pairs of 24x24 sets at $3244. */
    for (s_i = 0; s_i <= 0x1C; ++s_i) {
        g_sprite_sets[s_i][0] = NULL;
        g_sprite_sets[s_i][1] = NULL;
    }
    /* H006+$041C: two 6-byte entries at $27B0. */
    for (s_i = 1; s_i <= 2; ++s_i) {
        /* $27B0: 2 entries of 6 bytes (id + long gfx at +2): loaded HEAD id, $FF none */
        H005_B(0x27B0 + (s_i - 1) * 6) = 0xFF;
        g_gfx_27b0[s_i - 1] = NULL;      /* long a +2 */
    }
    g_pic_rec_27c2 = NULL;
    g_pic_rec_27c6 = NULL;
    /* H006+$0468 */
    for (s_i = 2; s_i <= 8; ++s_i) {
        /* $27DA: tab. of 7 words: compressed size of frames 2..n (idx frame-2) */
        H005_SET_W(0x27DA + (s_i - 2) * 2, 0);
        g_pic_buffers[s_i - 2] = NULL;
    }
    H005_SET_W(0x27BC, 0); /* $27BC: (word) frames of the loaded sequence (max 6), base of the block */
    g_gfx_2798 = NULL;
    H005_SET_L(0x2A3A, 0); /* $2A3A: (long) pointer to the list of treasure items */

    h029_fill_bytes(7, &g_h005[0x281C], 7, 0); /* $281C: (word) party x on the 16x16 area map */
    H005_SET_W(0x281C, 7); /* $281C: (word) party x on the 16x16 area map */
    H005_SET_W(0x281E, 0x0D); /* $281E: (word) party y on the 16x16 area map */
    H005_B(0x2820) = 0; /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    h029_fill_bytes(2, &g_h005[0x24E4], 3, 1); /* $24E4: Bash option available in front of the locked door */

    /* H006+$04F8: state of the three wall sets. */
    H005_SET_W(0x2810, 0); /* $2810: tab. of 3 4-byte entries of the wall sets: word WALLDEF id, $FFFF empty */
    H005_SET_W(0x2812, 1); /* $2812: word +2 of the $2810 entries: position (slot 1..3), $FFFF empty */
    for (s_i = 2; s_i <= 3; ++s_i) {
        /* $2810: tab. of 3 4-byte entries of the wall sets: word WALLDEF id, $FFFF empty */
        H005_SET_W(0x2810 + (s_i - 1) * 4, 0xFFFF);
        /* $2812: word +2 of the $2810 entries: position (slot 1..3), $FFFF empty */
        H005_SET_W(0x2810 + (s_i - 1) * 4 + 2, 0xFFFF);
    }

    H005_B(0x24D4) = 1; /* $24D4: Animation on/off (Alter): more frames and "Loading..." */
    H005_B(0x24D5) = 1; /* $24D5: Pics on/off (Alter); saved with $24D4 in $3E04+$1FE */
    H005_B(0x24D2) = 0; /* $24D2: debug enabled ("*" in the status, extra values) */
    H005_B(0x24CE) = 1; /* $24CE: 1: per-character pause when writing text */
    H005_B(0x24D1) = 0; /* $24D1: 1 after Load Saved Game: the area does not clear its variables */
    H005_SET_W(0x3DDE, 0); /* $3DDE: (word) rest steps since the last encounter check */
    g_party_head = NULL;
    g_current_char = NULL;
    /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    H005_SET_W(0x3DEA, 0x3500);         /* ECL logical PC */
    H005_SET_W(0x3DF6, 4); /* $3DF6: (word) game speed 0..9 (message pause) */
    G_DEMO_FLAG = 0; /* $24D7: 1 if the demonstration (Demo) was chosen */
    H005_B(0x246D) = 1; /* $246D: previous data disk (copy of +$246E) */
    H005_B(0x2825) = 0; /* $2825: top-down map flag, active instead of the 3D view */
    COK_PUT16(g_state_b + 0x67C, 0); /* B+$67C: (word) number of party members (max 8) */
    H005_SET_W(0x2796, 1); /* $2796: (word) index of the first entry shown in the list menus */
    H005_B(0x24C1) = 0; /* $24C1: use: cleared at start-up; with 1 outcome and fallen handled differently */
    H005_B(0x24E2) = 0; /* $24E2: 1 while resting: wait pointer, messages from row $12 */
    H005_B(0x2497) = 0; /* $2497: copy of the Search bit ($3E00+$594) during entry $3DF2 */
    H005_B(0x24BF) = 0; /* $24BF: use: 1 after ECL command $3D (redraw), 0 after EXIT */
    H005_B(0x24BE) = 0; /* $24BE: use: cleared at start-up and by ECL command $33 (newline) */
    H005_B(0x24BD) = 0; /* $24BD: 1 if the event picture/portrait is on screen */
    H005_B(0x24D0) = 0; /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
    H005_B(0x24A6) = 1; /* $24A6: use: only set to 1 at start-up (H006) */
    H005_B(0x24BA) = 0; /* $24BA: 1 if the SPRIT sprite of the event is on screen */
    H005_B(0x24A4) = 0; /* $24A4: use: ignored argument of Open_ResourceFile; 1 when loading SPC */
    /* $27A6: name (8 chars) of the loaded picture sequence, empty if none */
    copy_dbeq((char *)&g_h005[0x27A6], "", 8);
    /* $279C: name (8 chars) of the sequence saved by Encamp to reload it */
    copy_dbeq((char *)&g_h005[0x279C], "", 8);
    H005_B(0x2486) = 0xFF; /* $2486: id of the sequence loaded at $27BC (name at $27A6), $FF none */
    H005_B(0x2485) = 0xFF; /* $2485: id of the sequence saved when entering the camp, reloaded on exit */
    H005_B(0x24A3) = 0; /* $24A3: 1 if the game is saved (warning on exit); read by eff. $36 */
    H005_B(0x247E) = 0xE8; /* $247E: use: $E8 at start-up, 9 when the area starts; written by ECL var $755F */
    H005_B(0x247F) = 0xDB; /* $247F: use: $DB at start-up, $41 when the area starts; written by ECL var $7559 */
    H005_B(0x24B4) = 0; /* $24B4: 1 during the ENCOUNTER command */
    H005_B(0x24D8) = 0; /* $24D8: member choice mode: the click goes to $2508 and not to the current one */
    H005_B(0x24C6) = 1; /* $24C6: 1 if the combatant's actions must be drawn (visible) */
    H005_B(0x2484) = 0xFF; /* $2484: id of the loaded BIGPIC big picture ($FF none) */
    H005_B(0x24AD) = 0; /* $24AD: use: only cleared at start-up (H006) */
    H005_B(0x24CF) = 0; /* $24CF: 1 during creation: Train without messages or questions */
    H005_B(0x2483) = 1; /* $2483: index of the selected option in the row menus (persistent) */
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    H005_B(0x3DE3) = 4;                 /* native context */
    H005_B(0x3DE2) = 0; /* $3DE2: previous game context (copy of $3DE3), saved */
    H005_B(0x24A7) = 1; /* $24A7: use: 1 stops the audio around the scenes, 0 restarts H043 */
    H005_B(0x24E0) = 0; /* $24E0: 1: the effects go to the handler $2A0E (magic items) */
    H005_B(0x24AE) = 0; /* $24AE: 1 with a full-screen big picture: no party list */
    g_gfx_sky_280c = NULL;
    g_gfx_sky_2808 = NULL;
    g_gfx_sky_2804 = NULL;
    g_dropped_items = NULL;             /* $3360 */
    H005_B(0x24B1) = 0; /* $24B1: use: only cleared at start-up (H006) */
    H005_B(0x24CB) = 0; /* $24CB: 1 in Move/Attack mode: cursor on the combat map */
    H005_B(0x24CC) = 0; /* $24CC: 1 in Manual mode: cursor on the combat map */
    H005_B(0x24B0) = 0; /* $24B0: Move mode of the exploration: click on the view as movement */
    H005_B(0x249E) = 0; /* $249E: 1 if the key comes from the mouse (click) */
    H005_B(0x24DA) = 0; /* $24DA: 1 in Modify Character: the click chooses the field ($2506) */

    /* $16: list of 20 pointers (long) to the characters on the ground, count +$14 */
    h029_fill_bytes(0x4F, &g_h005[0x16], 0x50, 0);
    H005_SET_W(0x14, 0); /* $14: number of characters on the ground in the list +$16 (word, max 20) */
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
 * PORT H006+$0914: clears the state for a new game (after the end
 * of the adventure): states A, B, C and ECL program, position 7,13 facing
 * east, wall definitions, empty party, ECL PC at $3500, speed
 * 4, disk 1 and the game flags; context 4.
 */
void reset_game_state(void)
{
    h029_fill_bytes(0x7FF, g_state_a, 0x800, 0);
    COK_PUT16(g_state_a + 0x3E8, 3); /* A+$3E8: (word) difficulty level (1..5, initial 3) */
    COK_PUT16(g_state_a + 0x1CC, 1); /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
    COK_PUT16(g_state_a + 0x1E4, 0); /* A+$1E4: (word) number of the current ECL area (copy of $2498) */
    h029_fill_bytes(0x7FF, g_state_b, 0x800, 0);
    h029_fill_bytes(0x3FF, g_state_c, 0x400, 0);
    h029_fill_bytes(0x1DFF, g_ecl_buffer, 0x1DFF, 0);
    h029_fill_bytes(7, &H005_B(0x281C), 7, 0); /* $281C: (word) party x on the 16x16 area map */
    H005_SET_W(0x281C, 7); /* $281C: (word) party x on the 16x16 area map */
    H005_SET_W(0x281E, 0x0D); /* $281E: (word) party y on the 16x16 area map */
    H005_B(0x2820) = 2; /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    h029_fill_bytes(2, &H005_B(0x24E4), 3, 1); /* $24E4: Bash option available in front of the locked door */
    H005_B(0x24A2) = 1; /* $24A2: 1: clicking a party name selects the character */
    H005_SET_W(0x2810, 0); /* $2810: tab. of 3 4-byte entries of the wall sets: word WALLDEF id, $FFFF empty */
    H005_SET_W(0x2812, 1); /* $2812: word +2 of the $2810 entries: position (slot 1..3), $FFFF empty */
    for (s_i = 2; s_i <= 3; ++s_i) {
        /* $2810: tab. of 3 4-byte entries of the wall sets: word WALLDEF id, $FFFF empty */
        H005_SET_W(0x2810 + (s_i - 1) * 4, 0xFFFF);
        /* $2812: word +2 of the $2810 entries: position (slot 1..3), $FFFF empty */
        H005_SET_W(0x2812 + (s_i - 1) * 4, 0xFFFF);
    }
    H005_B(0x24D2) = 0; /* $24D2: debug enabled ("*" in the status, extra values) */
    COK_PUT16(g_state_a + 0x3F2, 2); /* A+$3F2: (word) phase (0..3) of cycle 1: frame icon column 8 */
    COK_PUT16(g_state_a + 0x3F4, 2); /* A+$3F4: (word) phase (0..3) of cycle 2: frame icon column $13 */
    COK_PUT16(g_state_a + 0x3F6, 2); /* A+$3F6: (word) phase (0..3) of cycle 3: frame icon column $1E */
    H005_B(0x24CE) = 1; /* $24CE: 1: per-character pause when writing text */
    H005_B(0x24D1) = 0; /* $24D1: 1 after Load Saved Game: the area does not clear its variables */
    H005_SET_W(0x3DDE, 0); /* $3DDE: (word) rest steps since the last encounter check */
    g_party_head = NULL;
    g_current_char = NULL;
    H005_SET_W(0x3DEA, 0x3500); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    H005_SET_W(0x3DF6, 4); /* $3DF6: (word) game speed 0..9 (message pause) */
    H005_B(0x246E) = 1; /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
    H005_B(0x246D) = 1; /* $246D: previous data disk (copy of +$246E) */
    H005_B(0x2825) = 0; /* $2825: top-down map flag, active instead of the 3D view */
    COK_PUT16(g_state_b + 0x67C, 0); /* B+$67C: (word) number of party members (max 8) */
    H005_SET_W(0x2796, 1); /* $2796: (word) index of the first entry shown in the list menus */
    H005_B(0x24C1) = 0; /* $24C1: use: cleared at start-up; with 1 outcome and fallen handled differently */
    H005_B(0x24E2) = 0; /* $24E2: 1 while resting: wait pointer, messages from row $12 */
    H005_B(0x2497) = 0; /* $2497: copy of the Search bit ($3E00+$594) during entry $3DF2 */
    H005_B(0x24BF) = 0; /* $24BF: use: 1 after ECL command $3D (redraw), 0 after EXIT */
    H005_B(0x24BE) = 0; /* $24BE: use: cleared at start-up and by ECL command $33 (newline) */
    H005_B(0x24BD) = 0; /* $24BD: 1 if the event picture/portrait is on screen */
    H005_B(0x24D0) = 0; /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
    H005_B(0x24A6) = 1; /* $24A6: use: only set to 1 at start-up (H006) */
    H005_B(0x24BA) = 0; /* $24BA: 1 if the SPRIT sprite of the event is on screen */
    H005_B(0x24A4) = 0; /* $24A4: use: ignored argument of Open_ResourceFile; 1 when loading SPC */
    /* $27A6: name (8 chars) of the loaded picture sequence, empty if none */
    H005_B(0x27A6) = 0;                 /* empty string (H006 -$A3) */
    /* $279C: name (8 chars) of the sequence saved by Encamp to reload it */
    H005_B(0x279C) = 0;                 /* empty string (H006 -$A5) */
    H005_B(0x2486) = 0xFF; /* $2486: id of the sequence loaded at $27BC (name at $27A6), $FF none */
    H005_B(0x2485) = 0xFF; /* $2485: id of the sequence saved when entering the camp, reloaded on exit */
    H005_B(0x24A3) = 0; /* $24A3: 1 if the game is saved (warning on exit); read by eff. $36 */
    H005_B(0x247E) = 0xE8; /* $247E: use: $E8 at start-up, 9 when the area starts; written by ECL var $755F */
    H005_B(0x247F) = 0xDB; /* $247F: use: $DB at start-up, $41 when the area starts; written by ECL var $7559 */
    H005_B(0x24B4) = 0; /* $24B4: 1 during the ENCOUNTER command */
    H005_B(0x24C6) = 1; /* $24C6: 1 if the combatant's actions must be drawn (visible) */
    H005_B(0x2484) = 0xFF; /* $2484: id of the loaded BIGPIC big picture ($FF none) */
    H005_B(0x24AD) = 0; /* $24AD: use: only cleared at start-up (H006) */
    H005_B(0x24CF) = 0; /* $24CF: 1 during creation: Train without messages or questions */
    clear_message_line();
    H005_B(0x2483) = 1; /* $2483: index of the selected option in the row menus (persistent) */
    H005_B(0x3DE3) = 4; /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    H005_B(0x3DE2) = 0; /* $3DE2: previous game context (copy of $3DE3), saved */
    H005_B(0x24A7) = 1; /* $24A7: use: 1 stops the audio around the scenes, 0 restarts H043 */
    H005_B(0x24E0) = 0; /* $24E0: 1: the effects go to the handler $2A0E (magic items) */
    H005_B(0x24B1) = 0; /* $24B1: use: only cleared at start-up (H006) */
    g_dropped_items = NULL;
    H005_B(0x24CB) = 0; /* $24CB: 1 in Move/Attack mode: cursor on the combat map */
    H005_B(0x24CC) = 0; /* $24CC: 1 in Manual mode: cursor on the combat map */
    H005_B(0x24B0) = 0; /* $24B0: Move mode of the exploration: click on the view as movement */
    H005_B(0x249E) = 0; /* $249E: 1 if the key comes from the mouse (click) */
    H005_B(0x24D8) = 0; /* $24D8: member choice mode: the click goes to $2508 and not to the current one */
    H005_B(0x24DA) = 0; /* $24DA: 1 in Modify Character: the click chooses the field ($2506) */
    H005_B(0x24AE) = 0; /* $24AE: 1 with a full-screen big picture: no party list */
}
