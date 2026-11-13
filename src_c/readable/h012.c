/* H012: exploration loop and ECL interpreter. */
#include <string.h>
#include "h012.h"
#include "globals.h"
#include "unported.h"
#include "h060.h"
#include "h069.h"
#include "h070.h"
#include "h068.h"
#include "h061.h"
#include "h064.h"
#include "h013.h"
#include "h042_seq.h"
#include "h003_exec.h"
#include "h008.h"
#include "h010_input.h"
#include "h011.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h031.h"
#include "h036.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h053.h"
#include "h056.h"
#include "h057.h"
#include "h066.h"
#include "h067.h"
#include "h071.h"
#include "h072.h"
#include "h058.h"
#include "h059.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"

/* PORT H012+$0178: link/unlk, no effect. */
void h012_init(void)
{
}

/* PORT H012+$0186: trampoline (bra.w) to H012+$2DF2, the routine below. */
/*
 * PORT H012+$2DF2 (reached from H012+$0186): runs the ECL command
 * $2493 with its handler (H064 or H012); the codes outside the table do
 * nothing.
 */
static void ecl_execute(void)
{
    switch (H005_B(0x2493)) { /* $2493: code of the ECL command being executed */
    case 0x00: ecl_exit(); break;
    case 0x01: ecl_goto(); break;
    case 0x02: ecl_gosub_cmd(); break;
    case 0x03: ecl_compare(); break;
    case 0x04: case 0x05: case 0x06: case 0x07: ecl_arithmetic(); break;
    case 0x08: ecl_random(); break;
    case 0x09: ecl_save(); break;
    case 0x0A: ecl_load_character(); break;
    case 0x0B: ecl_load_monster(); break;
    case 0x0C: ecl_approach(); break;
    case 0x0D: ecl_approach_step(); break;
    case 0x0E: ecl_picture(); break;
    case 0x0F: ecl_input_number(); break;
    case 0x10: ecl_input_string(); break;
    case 0x11: case 0x12: ecl_print(); break;
    case 0x13: ecl_return(); break;
    case 0x14: ecl_compare_and(); break;
    case 0x15: ecl_vertical_menu(); break;
    case 0x16: case 0x17: case 0x18: case 0x19: case 0x1A: case 0x1B:
        ecl_if(); break;
    case 0x1C: ecl_clear_monsters(); break;
    case 0x1D: ecl_party_strength(); break;
    case 0x1E: ecl_party_survey(); break;
    case 0x20: ecl_new_ecl(); break;
    case 0x21: case 0x37: ecl_load_files(); break;
    case 0x22: ecl_party_has_class(); break;
    case 0x23: ecl_surprise(); break;
    case 0x24: ecl_combat(); break;
    case 0x25: case 0x26: ecl_on_goto(); break;
    case 0x27: ecl_treasure(); break;
    case 0x28: ecl_rob(); break;
    case 0x29: ecl_encounter(); break;
    case 0x2A: ecl_get_table(); break;
    case 0x2B: ecl_horizontal_menu(); break;
    case 0x2C: ecl_parlay(); break;
    case 0x2D: ecl_special(); break;
    case 0x2E: ecl_damage(); break;
    case 0x2F: case 0x30: ecl_and_or(); break;
    case 0x31: ecl_clear_picture(); break;
    case 0x32: ecl_find_item(); break;
    case 0x33: ecl_new_line(); break;
    case 0x34: ecl_advance_time(); break;
    case 0x35: ecl_set_table(); break;
    case 0x36: ecl_add_npc(); break;
    case 0x38: ecl_party_menu(); break;
    case 0x39: ecl_who(); break;
    case 0x3A: ecl_delay(); break;
    case 0x3B: ecl_find_spell(); break;
    case 0x3C: ecl_nop_3c(); break;
    case 0x3D: ecl_redraw_screen(); break;
    case 0x3E: ecl_remove_character(); break;
    case 0x3F: ecl_has_effect(); break;
    case 0x40: ecl_remove_items(); break;
    case 0x41: ecl_experience(); break;
    default: break;
    }
}

/*
 * PORT H012+$018A: runs the ECL program from addr ($3DE8/$3DEA) until
 * a command stops it (H064+$B) or the area is left ($24D0);
 * $2494 keeps the previous command.
 */
void run_ecl(u16 addr)
{
    H005_SET_W(0x3DE8, addr); /* $3DE8: (word) start address of the current ECL execution */
    H005_SET_W(0x3DEA, addr); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    H064_B(0x0B) = 0; /* H064_data+$B: end of ECL execution flag (EXIT or NEWECL) */
    /* H064_data+$B: end of ECL execution flag (EXIT or NEWECL); $24D0: 1 party lost or gone
     * out: stops ECL and the exploration loop */
    while (!H064_B(0x0B) && !H005_B(0x24D0)) {
        /* $2494: code of the previous ECL command; $2493: code of the ECL command being executed */
        H005_B(0x2494) = H005_B(0x2493);
        /* $2493: code of the ECL command being executed; $3DEA: (word) logical PC of the ECL
         * program (base $3500) */
        H005_B(0x2493) = g_ecl_buffer[(u16)(H005_W(0x3DEA) - 0x3500)];
        ecl_execute();
    }
    H064_B(0x0B) = 0; /* H064_data+$B: end of ECL execution flag (EXIT or NEWECL) */
}

#define OPD(i)  operand_desc(i)
#define ADDR(i) decode_address(operand_lo(i), operand_hi(i))
#define TEXT64  ((char *)&g_h064_data[0x0C])    /* H064+$C */

/* Audio before and after the scenes: H043 (not ported, the commands are skipped). */
static void scene_audio(void)
{
    if (H005_B(0x24A7)) { /* $24A7: use: 1 stops the audio around the scenes, 0 restarts H043 */
        h043_190e(0xFF);
    }
    if (!H005_B(0x24A7)) { /* $24A7: use: 1 stops the audio around the scenes, 0 restarts H043 */
        h043_0584();
    }
}

/*
 * PORT H012+$0208 (nested in $01FA): writes minimum, maximum, average and
 * "found" into the variables of operands 3..6.
 */
typedef struct SurveyFrame {
    u8 found;                           /* -$D(a5) */
    u16 avg;                            /* -$14(a5) */
    u16 max;                            /* -$16(a5) */
    u16 min;                            /* -$18(a5) */
    u16 dst[4];                         /* -$1A..-$20(a5) */
} SurveyFrame;

static void survey_store(SurveyFrame *f)
{
    write_var(f->dst[0], f->min);
    write_var(f->dst[1], f->max);
    write_var(f->dst[2], f->avg);
    write_var(f->dst[3], f->found);
}

/*
 * PORT H012+$01FA (command $1E, PARTY SURVEY): for the character
 * variable given (or its value): effect present in someone,
 * level (+$1B), one of the values +$E0.. or the speed +$1A9: minimum,
 * maximum and average over the party.  For an unexpected variable the index is not
 * initialised in the original: here 0 (search for the effect).
 */
void ecl_party_survey(void)
{
    SurveyFrame f;
    Character *p;                       /* -$C(a5) */
    CokEffect *e;                       /* -$12(a5) */
    u16 addr;                           /* -$2(a5) */
    u16 kind = 0;                       /* -$4(a5) */
    u16 total = 0;                      /* -$6(a5) */
    u16 v8;                             /* -$8(a5) */
    u16 count = 0;                      /* -$22(a5) */
    u16 k;                              /* -$24(a5) */
    u8 v;

    read_operands(6);
    p = g_party_head;
    f.found = 0;
    if (OPD(1) == 1) {
        addr = ADDR(1);
    } else {
        addr = eval_operand(1);
    }
    v8 = eval_operand(2);
    f.dst[0] = ADDR(3);
    f.dst[1] = ADDR(4);
    f.dst[2] = ADDR(5);
    f.dst[3] = ADDR(6);
    f.min = 0xFF;
    f.max = 0;
    f.avg = 0;
    addr = (u16)(addr - 0x3100);
    if (addr == 0x8400) {
        kind = 0;
    } else if (addr == 0x19) {
        kind = 1;
    } else if (addr > 0xA4 && addr < 0xAD) {
        kind = (u16)(addr - 0xA3);
    } else if (addr == 0x9F) {
        kind = 0x0A;
    }
    switch (kind) {
    case 0:
        while (p != NULL && !f.found) {
            f.found = find_effect(p, v8, &e);
            p = p->next;
        }
        f.min = 0;
        f.max = 0;
        f.avg = 0;
        survey_store(&f);
        break;
    case 1:
        for (; p != NULL; p = p->next) {
            ++count;
            v = p->b[0x1B]; /* ch+$1B: current charisma */
            if (v > f.max) f.max = v;
            if (v < f.min) f.min = v;
            total = (u16)(total + v);
        }
        f.avg = (u16)(total / count);
        survey_store(&f);
        break;
    case 2: case 3: case 4: case 5: case 6: case 7: case 8: case 9:
        k = (u16)(addr - 0xA4);
        for (; p != NULL; p = p->next) {
            ++count;
            /* ch+$DF: undead type (0 = no); base -1 of the thief skills +$E0..+$E7 */
            v = p->b[0xE0 + k - 1];
            if (v < f.min) f.min = v;
            if (v > f.max) f.max = v;
            total = (u16)(total + v);
        }
        f.avg = (u16)(total / count);
        survey_store(&f);
        break;
    case 0x0A:
        for (; p != NULL; p = p->next) {
            ++count;
            v = p->b[0x1A9]; /* ch+$1A9: current movement (armour and encumbrance) */
            if (v < f.min) f.min = v;
            if (v > f.max) f.max = v;
            total = (u16)(total + v);
        }
        f.avg = (u16)(total / count);
        survey_store(&f);
        break;
    default:
        break;
    }
}

/* PORT H012+$05D6 (command $22): 1 if there is a ranger/healer in the party (+$5C 4 or $A). */
void ecl_party_has_class(void)
{
    Character *p;                       /* -$4(a5) */
    u16 r = 0;                          /* -$6(a5) */
    u16 zero = 0;                       /* -$8(a5) */

    read_operands(2);
    for (p = g_party_head; p != NULL; p = p->next) {
        /* ch+$5C: class or class combination (0..16, names H005+$4D84) */
        if (p->b[0x5C] == 4 || p->b[0x5C] == 0x0A) {
            r = 1;
        }
    }
    write_var(ADDR(1), r);
    write_var(ADDR(2), zero);
}

/*
 * PORT H012+$0688 (command $23, SURPRISE): two d6 against the values of the
 * operands; the result (0 none, 1 or 2 one side surprised) goes into $2CB.
 */
void ecl_surprise(void)
{
    u16 v[4];                           /* -$10(a5)..-$A(a5) */
    u16 i;                              /* -$6(a5) */
    s16 a;                              /* -$12(a5) */
    s16 b;                              /* -$14(a5) */
    s16 r1;                             /* -$2(a5) */
    s16 r2;                             /* -$4(a5) */
    u16 res = 0;                        /* -$8(a5) */

    read_operands(4);
    for (i = 1; i <= 4; ++i) {
        v[i - 1] = eval_operand(i);
    }
    a = (s16)(v[3] + 2 - v[0]);
    b = (s16)(v[1] + 2 - v[2]);
    r1 = (s16)roll_dice(1, 6);
    r2 = (s16)roll_dice(1, 6);
    if (r1 <= a) {
        if (r2 > b) {
            res = 1;
        } else {
            res = 3;
        }
    }
    if (r2 <= b) {
        res = 2;
    }
    write_var(0x2CB, res);
}

/*
 * PORT H012+$0766 (command $24, COMBAT): without monsters loaded a
 * scene (H071+$092C, H072+$120C or H070+$1958 depending on $3E00+$6D8/$5C4);
 * otherwise the combat (H059+$1782), after which H070+$1958 and,
 * outdoors, picture $79.  Then context 3/4 and redraw.
 */
void ecl_combat(void)
{
    u8 save;                            /* -$8(a5) */
    u8 redraw = 1;                      /* -$7(a5) */
    u16 steps;                          /* -$2(a5) */

    H005_B(0x24AE) = 0; /* $24AE: 1 with a full-screen big picture: no party list */
    save = H005_B(0x24B0); /* $24B0: Move mode of the exploration: click on the view as movement */
    H005_B(0x24B0) = 0; /* $24B0: Move mode of the exploration: click on the view as movement */
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    if (!H005_B(0x24B6)) { /* $24B6: 1 if there are monsters loaded (LOAD MONSTER) for COMBAT */
        /* B+$6D8: (word) 1: the next COMBAT opens the shop (then 0) */
        if (COK_GET16(g_state_b + 0x6D8) == 1) {
            /* B+$6D8: (word) 1: the next COMBAT opens the shop (then 0) */
            COK_PUT16(g_state_b + 0x6D8, 0);
            scene_audio();
            shop();
            /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
            if (COK_GET16(g_state_a + 0x1CC) == 0) {
                redraw = 0;
            }
            scene_audio();
        /* B+$5C4: (word) 1: the next COMBAT opens the temple (then 0) */
        } else if (COK_GET16(g_state_b + 0x5C4) == 1) {
            COK_PUT16(g_state_b + 0x5C4, 0); /* B+$5C4: (word) 1: the next COMBAT opens the temple (then 0) */
            scene_audio();
            temple();
            /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
            if (COK_GET16(g_state_a + 0x1CC) == 0) {
                redraw = 0;
            }
            scene_audio();
        } else {
            scene_audio();
            combat_end();
            scene_audio();
        }
    } else {
        scene_audio();
        /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the 16x16 area
         * map */
        steps = free_steps((s16)H005_W(0x281C), (s16)H005_W(0x281E),
                           H005_B(0x2820)); /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        /* B+$582: (word) current distance of the enemies, limited to the free squares */
        if (steps < COK_GET16(g_state_b + 0x582)) {
            /* B+$582: (word) current distance of the enemies, limited to the free squares */
            COK_PUT16(g_state_b + 0x582, steps);
        }
        release_picture_set();
        combat_main_loop();
        if (H005_B(0x24A7)) { /* $24A7: use: 1 stops the audio around the scenes, 0 restarts H043 */
            h043_190e(0xFF);
        }
        combat_end();
        if (!H005_B(0x24A7)) { /* $24A7: use: 1 stops the audio around the scenes, 0 restarts H043 */
            h043_0584();
        }
        /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        if (COK_GET16(g_state_a + 0x1CC) == 0) {
            scene_audio();
            load_big_picture(0x79);
        } else {
            scene_audio();
        }
    }
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat); A+$1CC: (word) 1 3D area
     * (16x16 map), 0 outdoor map */
    H005_B(0x3DE3) = (u8)(COK_GET16(g_state_a + 0x1CC) ? 4 : 3);
    COK_PUT16(g_state_b + 0x594, /* B+$594: (word) bit 0 search mode, bit 1 Look in progress */
              mask_byte((u8)COK_GET16(g_state_b + 0x594), 1));
    /* $2378: flag: event sprite already shown (flags[0], 2 bytes with +$2379) */
    h029_fill_bytes(1, &H005_B(0x2378), 2, 0);
    H005_B(0x24BD) = 0; /* $24BD: 1 if the event picture/portrait is on screen */
    if (redraw) {
        redraw_game_screen();
        /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map; $24D0: 1 party lost or gone
         * out: stops ECL and the exploration loop */
        if (COK_GET16(g_state_a + 0x1CC) == 0 && !H005_B(0x24D0) &&
            /* A+$270: (word) town area: no view redraw nor EXIT from the camp */
            COK_GET16(g_state_a + 0x270) == 0) {
            h069_draw_marker();
        }
    }
    H005_B(0x24B0) = save; /* $24B0: Move mode of the exploration: click on the view as movement */
}

/* PORT H012+$0B18 (comandi $25 ON GOTO e $26 ON GOSUB). */
void ecl_on_goto(void)
{
    u8 done = 0;                        /* -$9(a5) */
    u16 v;                              /* -$2(a5) */
    u16 n;                              /* -$4(a5) */
    u16 i = 0;                          /* -$8(a5) */

    read_operands(2);
    v = eval_operand(1);
    n = eval_operand(2);
    H005_SET_W(0x3DEA, H005_W(0x3DEA) - 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    read_operands(n);
    while (i < n && !done) {
        if (v == i) {
            if (H005_B(0x2493) == 0x25) { /* $2493: code of the ECL command being executed */
                H005_SET_W(0x3DEA, ADDR(i + 1)); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
            } else {
                ecl_gosub((u16)(i + 1));
            }
            done = 1;
        } else {
            ++i;
        }
    }
}

/* Type of the random treasure item (the tables of H012+$0BEA). */
static u16 random_treasure_type(void)
{
    u16 r;                              /* -$72(a5) */
    u16 r2;                             /* -$74(a5) */
    u16 cat;                            /* -$88(a5) */
    u16 sub;                            /* -$86(a5) */
    u16 t = 0;                          /* -$78(a5) */

    r = roll_dice(1, 0x64);
    if (r < 0x15) cat = 0;
    else if (r < 0x42) cat = 1;
    else if (r < 0x47) cat = 2;
    else if (r < 0x51) cat = 3;
    else if (r < 0x56) cat = 4;
    else if (r < 0x60) cat = 5;
    else cat = 6;
    switch (cat) {
    case 0:
        r2 = roll_dice(1, 0x64);
        sub = (u16)(r2 < 0x0B ? 0 : (r2 < 0x1A ? 1 : 2));
        switch (sub) {
        case 0:
            r2 = roll_dice(1, 0x0A);
            if (r2 <= 2) t = 6;
            else if (r2 <= 6) t = 8;
            else if (r2 <= 8) t = 0x46;
            else if (r2 == 9) t = 0x0F;
            else if (r2 == 0x0A) t = 0x1D;
            break;
        case 1:
            r2 = roll_dice(1, 0x14);
            if (r2 >= 1 && r2 <= 3) t = 5;
            else if (r2 <= 5) t = 7;
            else if (r2 <= 8) t = 0x18;
            else if (r2 <= 0x0A) t = 0x16;
            else if (r2 <= 0x0C) t = 0x19;
            else if (r2 <= 0x0E) t = 0x17;
            else if (r2 <= 0x10) t = 0x1C;
            else if (r2 <= 0x12) t = 0x1D;
            else if (r2 <= 0x14) t = 0x1E;
            break;
        default:
            r2 = roll_dice(1, 4);
            if (r2 < 4) {
                r2 = roll_dice(1, 0x14);
                if (r2 >= 1 && r2 <= 8) t = 0x12;
                else if (r2 <= 0x0D) t = 0x11;
                else if (r2 == 0x0E) t = 0x0D;
                else if (r2 == 0x0F) t = 0x10;
                else if (r2 <= 0x12) t = 0x13;
                else if (r2 <= 0x14) t = 0x14;
            } else {
                r2 = roll_dice(1, 8);
                if (r2 == 1) t = 1;
                else if (r2 <= 3) t = 4;
                else if (r2 <= 5) t = 8;
                else if (r2 == 6) t = 0x0A;
                else if (r2 == 7) t = 0x0E;
                else if (r2 == 8) t = 0x47;
            }
            break;
        }
        break;
    case 1: t = 0x27; break;
    case 2: t = 0x28; break;
    case 3: t = 0x25; break;
    case 4: t = 0x3B; break;
    case 5:
        r2 = roll_dice(1, 0x14);
        if (r2 >= 1 && r2 <= 3) t = 0x1F;
        else if (r2 <= 0x0B) t = 0x23;
        else if (r2 <= 0x10) t = 0x24;
        else if (r2 == 0x11) t = 0x20;
        else if (r2 == 0x12) t = 0x21;
        else if (r2 <= 0x14) t = 0x22;
        break;
    default:
        r2 = roll_dice(1, 6);
        if (r2 >= 1 && r2 <= 2) t = 0x32;
        else if (r2 <= 4) t = 0x30;
        else if (r2 == 5) t = 0x34;
        else if (r2 == 6) t = 0x35;
        break;
    }
    return t;
}

/* Puts a copy of it at the head of the treasure list ($2A3A). */
static void push_treasure(const CokItem *it)
{
    CokItem *old = g_treasure_items;

    g_treasure_items = (CokItem *)exec_alloc_mem(sizeof(CokItem),
                                                 COK_MEMF_CLEAR);
    memcpy(g_treasure_items->b, it->b, 0x48);
    g_treasure_items->next = old;
}

/*
 * PORT H012+$0BEA (command $27, TREASURE): coins ($2A1E, 7 longs) and
 * items: with k < $80 all those of block k of ITEMn.DAX (records of
 * $3F bytes), with $80+n n random items (H067+$1292); the names are
 * built for the current character.
 */
void ecl_treasure(void)
{
    u16 i;                              /* -$2(a5) */
    u16 k;                              /* -$4(a5) */
    u16 j;                              /* -$6(a5) */
    u16 pos;                            /* -$7A(a5) */
    u16 size = 0;                       /* -$7C(a5) */
    u8 *buf = NULL;                     /* -$82(a5) */
    char num[2];                        /* -$7E(a5) */
    CokItem it;                         /* -$66(a5) */
    CokItem *p;                         /* -$6E(a5) */
    u8 len;                             /* -$83(a5) */

    read_operands(8);
    for (i = 0; i <= 6; ++i) {
        /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
        H005_SET_L(0x2A1E + i * 4, (u32)eval_operand((u16)(i + 1)));
    }
    k = eval_operand(8);
    if (k < 0x80) {
        /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
        format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
        strcpy(TEXT64, "ITEM"); /* H064_data+$C: TEXT64 text buffer ($50 bytes): file names and messages */
        /* H064_data+$C: TEXT64 text buffer ($50 bytes): file names and messages */
        h026_append(0x50, TEXT64, 1, num);
        /* H064_data+$C: TEXT64 text buffer ($50 bytes): file names and messages */
        dax_load_block(0x50, TEXT64, 4, ".DAX", k, &size, &buf);
        if (size == 0) {
            show_message_wait(0x0F, 0, 0x18, "Unable to find item file");
            quit_game();
        }
        pos = 0;
        do {
            memset(&it, 0, sizeof it);
            len = buf[pos];
            exec_copy_mem(buf + pos + 1, it.b, 0x28);
            it.b[len] = 0;
            /* ogg+$2A: header flag: copied into the header of the menu entry */
            it.b[0x2A] = buf[pos + 0x29];
            it.next = NULL;
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            it.b[0x30] = buf[pos + 0x2E];
            for (j = 1; j <= 3; ++j) {
                /* item+$31: base of the table of 3 name words +$32..+$34 (index 1..3) */
                it.b[0x32 + j - 1] = buf[pos + 0x2E + j];
            }
            /* item+$36: (word) magic bonus (+n) of the item, signed */
            COK_PUT16(&it.b[0x36], (u16)h031_signed_byte(buf[pos + 0x32]));
            /* item+$38: (word) second bonus, added to CH +$18A when readied */
            COK_PUT16(&it.b[0x38], (u16)h031_signed_byte(buf[pos + 0x33]));
            it.b[0x3A] = buf[pos + 0x34]; /* item+$3A: item readied flag (Ready) */
            /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
            it.b[0x3B] = buf[pos + 0x35];
            it.b[0x3C] = buf[pos + 0x36]; /* item+$3C: cursed item flag */
            exec_copy_mem(buf + pos + 0x37, &it.b[0x3E], 2); /* item+$3E: (word) unit weight of the item */
            h031_swap_word(&it.b[0x3E]); /* item+$3E: (word) unit weight of the item */
            it.b[0x40] = buf[pos + 0x39]; /* item+$40: quantity (identical pieces grouped, max 255) */
            /* item+$42: (word) value in coins (Sell offers half) */
            exec_copy_mem(buf + pos + 0x3A, &it.b[0x42], 2);
            h031_swap_word(&it.b[0x42]); /* item+$42: (word) value in coins (Sell offers half) */
            for (j = 1; j <= 3; ++j) {
                /* item+$43: base of the table of 3 spells +$44..+$46 (index 1..3, bit7=to be scribed) */
                it.b[0x44 + j - 1] = buf[pos + 0x3B + j];
            }
            pos = (u16)(pos + 0x3F);
            push_treasure(&it);
        } while (pos < (u16)(size - 0x100));
        exec_free_mem(buf, size);
    } else if (k != 0xFF) {
        k = (u16)(k - 0x80);
        for (j = 1; j <= k; ++j) {
            memset(&it, 0, sizeof it);
            random_item(random_treasure_type(), &it);
            push_treasure(&it);
        }
        for (p = g_treasure_items; p != NULL; p = p->next) {
            build_item_name(g_current_char, p, 0, 0, 0, 0);
        }
    }
}

/*
 * PORT H012+$15AE (command $29, ENCOUNTER): encounter at distance
 * $3E00+$580 with COMBAT/WAIT/FLEE/ADVANCE (or PARLAY when close or
 * outdoors); for every choice the action of operand 5..9 decides the
 * result (variable of operand 4: 0 the monsters flee, 1
 * combat, 2 flight, 3 talk) or an approach and a new round.
 * Texts 1..3 apply to distances 0..2.
 */
void ecl_encounter(void)
{
    u16 act[5];                         /* -$C(a5) */
    char texts[3][0x100];               /* -$30C(a5) */
    char text[0x100];                   /* -$40C(a5) */
    char title[2];                      /* -$446(a5) */
    char opts[0x29];                    /* -$444(a5) */
    u16 near_speed;                     /* -$40E(a5) */
    u16 flee_speed;                     /* -$410(a5) */
    u16 maxv = 0;                       /* -$414(a5) */
    u16 minv = 0;                       /* -$416(a5) */
    u16 dst;                            /* -$44C(a5) */
    u16 k;                              /* -$44A(a5) */
    u16 i;                              /* -$412(a5) */
    u16 choice;                         /* -$2(a5) */
    u16 a;                              /* -$448(a5) */
    u8 again;                           /* -$417(a5) */
    u8 clear;                           /* -$418(a5) */
    u8 animate;                         /* -$419(a5) */

    H005_B(0x24B4) = 1; /* $24B4: 1 during the ENCOUNTER command */
    H005_B(0x24B9) = 0; /* $24B9: 0 after ECL text; the command menu clears rows $11..$16 and sets 1 */
    H005_B(0x24CE) = 1; /* $24CE: 1: per-character pause when writing text */
    party_speed_range(&maxv, &minv);
    title[0] = '\0';
    title[1] = '\0';
    text[0] = '\0';
    read_operands(0x0E);
    H005_B(0x2491) = (u8)eval_operand(1); /* $2491: SPRIT sprite of the encounter (ENCOUNTER/APPROACH) */
    /* B+$580: (word) requested distance of the encounter (ENCOUNTER/APPROACH) */
    COK_PUT16(g_state_b + 0x580, eval_operand(2));
    H005_B(0x2490) = (u8)eval_operand(3); /* $2490: PIC portrait of the encounter (ENCOUNTER/APPROACH) */
    dst = ADDR(4);
    for (i = 0; i <= 4; ++i) {
        act[i] = eval_operand((u16)(i + 5));
    }
    for (i = 1; i <= 3; ++i) {
        memcpy(texts[i - 1], ecl_string(i), 0x100);
    }
    near_speed = eval_operand(0x0D);
    flee_speed = eval_operand(0x0E);
    /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the 16x16 area map;
     * $2820: party direction (0 north, 2 east, 4 south, 6 west); B+$582: (word) current distance
     * of the enemies, limited to the free squares */
    COK_PUT16(g_state_b + 0x582,
              free_steps((s16)H005_W(0x281C), (s16)H005_W(0x281E),
                         H005_B(0x2820)));
    /* B+$580: (word) requested distance of the encounter (ENCOUNTER/APPROACH); B+$582: (word)
     * current distance of the enemies, limited to the free squares */
    if (COK_GET16(g_state_b + 0x580) < COK_GET16(g_state_b + 0x582)) {
        /* B+$580: (word) requested distance of the encounter (ENCOUNTER/APPROACH); B+$582:
         * (word) current distance of the enemies, limited to the free squares */
        COK_PUT16(g_state_b + 0x582, COK_GET16(g_state_b + 0x580));
    }
    /* $2491: SPRIT sprite of the encounter (ENCOUNTER/APPROACH); $2490: PIC portrait of the
     * encounter (ENCOUNTER/APPROACH) */
    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                       /* B+$582: (word) current distance of the enemies, limited to the free squares; $2378: flag:
                        * event sprite already shown (flags[0], 2 bytes with +$2379) */
                       (u8)COK_GET16(g_state_b + 0x582), &H005_B(0x2378));
    do {
        /* $24BD: 1 if the event picture/portrait is on screen; $24BC: 1 if the event
         * picture can be animated (not head+body) */
        animate = (u8)(H005_B(0x24BD) && H005_B(0x24BC) &&
                       /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map; $2486: id of the sequence loaded
                        * at $27BC (name at $27A6), $FF none */
                       COK_GET16(g_state_a + 0x1CC) && H005_B(0x2486) != 9);
        /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        clear = (u8)(COK_GET16(g_state_a + 0x1CC) != 0);
        again = 0;
        H005_SET_W(0x334E, 1); /* $334E: (word) text cursor: column */
        H005_SET_W(0x334C, 0x11); /* $334C: (word) text cursor: row */
        /* B+$582: (word) current distance of the enemies, limited to the free squares */
        switch (COK_GET16(g_state_b + 0x582)) {
        case 0:
            k = 1;
            do {
                memcpy(text, texts[k - 1], 0x100);
                ++k;
            } while (text[0] == '\0' && k <= 3);
            break;
        case 1:
            k = 2;
            do {
                memcpy(text, texts[k - 1], 0x100);
                ++k;
                if (k > 3) k = 1;
            } while (text[0] == '\0' && k != 2);
            break;
        case 2:
            k = 3;
            do {
                memcpy(text, texts[k - 1], 0x100);
                ++k;
                if (k > 3) k = 1;
            } while (text[0] == '\0' && k != 3);
            break;
        default:
            break;
        }
        if (text[0] == '\0') {
            clear = 0;
        }
        word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, clear, 0xFF, text);
        /* B+$582: (word) current distance of the enemies, limited to the free squares */
        if (COK_GET16(g_state_b + 0x582) == 0 ||
            /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
            COK_GET16(g_state_a + 0x1CC) == 0) {
            strcpy(opts, "~COMBAT ~WAIT ~FLEE ~PARLAY");
        } else {
            strcpy(opts, "~COMBAT ~WAIT ~FLEE ~ADVANCE");
        }
        choice = ecl_menu(1, title, 0x28, opts, 0x0D, 0x0A, 0x0F, 0, animate);
        /* B+$582: (word) current distance of the enemies, limited to the free squares */
        if ((COK_GET16(g_state_b + 0x582) == 0 ||
             /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
             COK_GET16(g_state_a + 0x1CC) == 0) && choice == 3) {
            choice = 4;
        }
        a = (choice <= 4) ? act[choice] : 0;
        switch (a) {
        case 0:
            if (choice != 2) {
                write_var(dst, 1);
            } else if (minv >= near_speed) {
                write_var(dst, 2);
            } else {
                write_var(dst, 1);
            }
            break;
        case 1:
            switch (choice) {
            case 0: write_var(dst, 1); break;
            case 1:
                again = 1;
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x10,
                               "Both sides wait.");
                break;
            case 2: write_var(dst, 2); break;
            case 3:
                /* B+$582: (word) current distance of the enemies, limited to the free squares */
                if (COK_GET16(g_state_b + 0x582) != 0) {
                    /* B+$582: (word) current distance of the enemies, limited to the free squares */
                    COK_PUT16(g_state_b + 0x582,
                              COK_GET16(g_state_b + 0x582) - 1);
                    /* $2491: SPRIT sprite of the encounter (ENCOUNTER/APPROACH); $2490: PIC
                     * portrait of the encounter (ENCOUNTER/APPROACH) */
                    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                                       /* B+$582: (word) current distance of the enemies, limited
                                        * to the free
                                        * squares */
                                       (u8)COK_GET16(g_state_b + 0x582),
                                       /* $2378: flag: event sprite already shown (flags[0], 2 bytes
                                        * with +$2379) */
                                       &H005_B(0x2378));
                } else {
                    word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x10,
                                   "Both sides wait.");
                    again = 1;
                }
                break;
            case 4:
                /* B+$582: (word) current distance of the enemies, limited to the free squares */
                if (COK_GET16(g_state_b + 0x582) == 0) {
                    write_var(dst, 3);
                } else {
                    /* B+$582: (word) current distance of the enemies, limited to the free squares */
                    COK_PUT16(g_state_b + 0x582,
                              COK_GET16(g_state_b + 0x582) - 1);
                    /* $2491: SPRIT sprite of the encounter (ENCOUNTER/APPROACH); $2490: PIC
                     * portrait of the encounter (ENCOUNTER/APPROACH) */
                    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                                       /* B+$582: (word) current distance of the enemies, limited
                                        * to the free
                                        * squares */
                                       (u8)COK_GET16(g_state_b + 0x582),
                                       /* $2378: flag: event sprite already shown (flags[0], 2 bytes
                                        * with +$2379) */
                                       &H005_B(0x2378));
                    again = 1;
                }
                break;
            default: break;
            }
            break;
        case 2:
            if (choice == 0 && !(flee_speed > maxv)) {
                write_var(dst, 1);
            } else if (choice <= 4) {
                write_var(dst, 0);
                H005_SET_W(0x334E, 1); /* $334E: (word) text cursor: column */
                H005_SET_W(0x334C, 0x11); /* $334C: (word) text cursor: row */
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x12,
                               "The monsters flee.");
            }
            break;
        case 3:
            switch (choice) {
            case 0: write_var(dst, 1); break;
            case 1:
            case 3:
                /* B+$582: (word) current distance of the enemies, limited to the free squares */
                if (COK_GET16(g_state_b + 0x582) != 0) {
                    /* B+$582: (word) current distance of the enemies, limited to the free squares */
                    COK_PUT16(g_state_b + 0x582,
                              COK_GET16(g_state_b + 0x582) - 1);
                    /* $2491: SPRIT sprite of the encounter (ENCOUNTER/APPROACH); $2490: PIC
                     * portrait of the encounter (ENCOUNTER/APPROACH) */
                    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                                       /* B+$582: (word) current distance of the enemies, limited
                                        * to the free
                                        * squares */
                                       (u8)COK_GET16(g_state_b + 0x582),
                                       /* $2378: flag: event sprite already shown (flags[0], 2 bytes
                                        * with +$2379) */
                                       &H005_B(0x2378));
                } else {
                    word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x10,
                                   "Both sides wait.");
                }
                again = 1;
                break;
            case 2: write_var(dst, 2); break;
            case 4:
                /* B+$582: (word) current distance of the enemies, limited to the free squares */
                if (COK_GET16(g_state_b + 0x582) == 0) {
                    write_var(dst, 3);
                } else {
                    /* B+$582: (word) current distance of the enemies, limited to the free squares */
                    COK_PUT16(g_state_b + 0x582,
                              COK_GET16(g_state_b + 0x582) - 1);
                    /* $2491: SPRIT sprite of the encounter (ENCOUNTER/APPROACH); $2490: PIC
                     * portrait of the encounter (ENCOUNTER/APPROACH) */
                    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                                       /* B+$582: (word) current distance of the enemies, limited
                                        * to the free
                                        * squares */
                                       (u8)COK_GET16(g_state_b + 0x582),
                                       /* $2378: flag: event sprite already shown (flags[0], 2 bytes
                                        * with +$2379) */
                                       &H005_B(0x2378));
                    again = 1;
                }
                break;
            default: break;
            }
            break;
        case 4:
            switch (choice) {
            case 0: write_var(dst, 1); break;
            case 1:
            case 3:
            case 4:
                /* B+$582: (word) current distance of the enemies, limited to the free squares */
                if (COK_GET16(g_state_b + 0x582) == 0) {
                    write_var(dst, 3);
                } else {
                    /* B+$582: (word) current distance of the enemies, limited to the free squares */
                    COK_PUT16(g_state_b + 0x582,
                              COK_GET16(g_state_b + 0x582) - 1);
                    /* $2491: SPRIT sprite of the encounter (ENCOUNTER/APPROACH); $2490: PIC
                     * portrait of the encounter (ENCOUNTER/APPROACH) */
                    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                                       /* B+$582: (word) current distance of the enemies, limited
                                        * to the free
                                        * squares */
                                       (u8)COK_GET16(g_state_b + 0x582),
                                       /* $2378: flag: event sprite already shown (flags[0], 2 bytes
                                        * with +$2379) */
                                       &H005_B(0x2378));
                    again = 1;
                }
                break;
            case 2: write_var(dst, 2); break;
            default: break;
            }
            break;
        default:
            break;
        }
    } while (again);
    clear_message_line();
    H005_B(0x24CE) = 0; /* $24CE: 1: per-character pause when writing text */
    H005_B(0x24B4) = 0; /* $24B4: 1 during the ENCOUNTER command */
}

/*
 * PORT H012+$1DDE (command $2C, PARLAY): HAUGHTY/SLY/NICE/MEEK/ABUSIVE;
 * the value of the chosen operand goes into the variable of the sixth.  Without a
 * valid choice the original reads outside the five values: here 0.
 */
void ecl_parlay(void)
{
    u16 v[5];                           /* -$10(a5) */
    u16 i;                              /* -$6(a5) */
    u16 k;                              /* -$2(a5) */

    read_operands(6);
    for (i = 0; i <= 4; ++i) {
        v[i] = eval_operand((u16)(i + 1));
    }
    k = ecl_menu(0, "", 0x22, "~HAUGHTY ~SLY ~NICE ~MEEK ~ABUSIVE", 0x0D,
                 0x0A, 0x0F, 0, 0);
    write_var(ADDR(6), (k <= 4) ? v[k] : 0);
}

/* PORT H012+$1E90 (command $32): does someone carry an item of type t (+$30)? */
void ecl_find_item(void)
{
    u8 found = 0;                       /* -$D(a5) */
    u16 t;                              /* -$2(a5) */
    Character *p;                       /* -$8(a5) */
    CokItem *it;                        /* -$C(a5) */

    read_operands(1);
    t = eval_operand(1);
    /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    H005_B(0x237F) = 1; /* $237F: comparison results +1: not equal */
    for (p = g_party_head; p != NULL && !found; p = p->next) {
        for (it = p->items; it != NULL && !found; it = it->next) {
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            if (it->b[0x30] == t) {
                H005_B(0x237E) = 1; /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
                H005_B(0x237F) = 0; /* $237F: comparison results +1: not equal */
                found = 1;
            }
        }
    }
}

/* PORT H012+$1F4C (command $3A, DELAY): pause. */
void ecl_delay(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    message_delay();
}

/*
 * PORT H012+$14C8 (command $28, ROB): the current character (first
 * operand 0) or the whole party loses the second operand per cent of
 * coins, gems and jewellery (H061+$3C4C, with (100 - p) / 100 in FFP:
 * SPFlt and SPDiv) and every item has the third operand per cent chance of
 * being destroyed (H061+$3DBE).
 */
void ecl_rob(void)
{
    u16 who;                            /* -$2(a5) */
    u16 percent;                        /* -$4(a5) */
    u16 chance;                         /* -$6(a5) */
    Character *p;                       /* -$A(a5) */
    CokReal keep;                       /* -$12(a5) */

    read_operands(3);
    who = eval_operand(1);
    percent = eval_operand(2);
    keep = h015_spdiv(h015_spflt((s32)(u16)(0x64 - percent)),
                      h015_spflt(0x64));
    chance = eval_operand(3);
    if (who == 0) {
        scale_money(keep, g_current_char);
        destroy_items(chance, g_current_char);
    } else {
        for (p = g_party_head; p != NULL; p = p->next) {
            scale_money(keep, p);
            destroy_items(chance, p);
        }
    }
}

/*
 * PORT H012+$1F68 (command $2E, DAMAGE): damage nd(s)+b to one or to all
 * (bit 6), with a saving throw (bit 7: type from the 5th operand, full damage
 * anyway with bit 4), or to flags random targets with a to-hit
 * roll (H062+$126C).  If everyone falls "The entire party is killed!".
 */
void ecl_damage(void)
{
    Character *save;                    /* -$22(a5) */
    Character *p;                       /* -$1A(a5) */
    u8 group = 0;                       /* -$24(a5) */
    u8 full;                            /* -$25(a5) */
    u16 flags;                          /* -$2(a5) */
    u16 n;                              /* -$4(a5) */
    u16 sides;                          /* -$6(a5) */
    u16 bonus;                          /* -$E(a5) */
    u16 save_t;                         /* -$C(a5) */
    u16 dmg;                            /* -$16(a5) */
    u16 victim = 0;                     /* -$10(a5) */
    u16 kind;                           /* -$A(a5) */
    u16 st;                             /* -$12(a5) */
    u16 i;                              /* -$8(a5) */
    u16 j;                              /* -$14(a5) */

    save = g_current_char;
    p = g_party_head;
    read_operands(5);
    flags = eval_operand(1);
    n = eval_operand(2);
    sides = eval_operand(3);
    bonus = eval_operand(4);
    save_t = eval_operand(5);
    dmg = (u16)(roll_dice(n, sides) + bonus);
    full = mask_byte((u8)flags, 0x10);
    if (mask_byte((u8)flags, 0x40)) {
        group = 1;
    } else {
        /* B+$67C: (word) number of party members (max 8) */
        victim = roll_dice(1, COK_GET16(g_state_b + 0x67C));
    }
    if (mask_byte((u8)flags, 0x80)) {
        kind = mask_byte((u8)flags, 0x1F);
        st = mask_byte((u8)save_t, 7);
        if (group) {
            for (; p != NULL; p = p->next) {
                if (mask_byte((u8)flags, 0x20)) {
                    ecl_damage_message(p, dmg);
                } else if (!saving_throw_roll(p, (u8)st, (s16)kind)) {
                    ecl_damage_message(p, dmg);
                } else if (full) {
                    ecl_damage_message(p, dmg);
                }
            }
        } else if (mask_byte((u8)save_t, 0x80)) {
            if (st == 0 ||
                !saving_throw_roll(g_current_char, (u8)(st - 1), (s16)kind)) {
                ecl_damage_message(g_current_char, dmg);
            } else if (full) {
                ecl_damage_message(g_current_char, dmg);
            }
        } else {
            for (i = 2; i <= victim; ++i) {
                p = p->next;
            }
            if (!saving_throw_roll(p, (u8)st, (s16)kind)) {
                ecl_damage_message(p, dmg);
            } else if (full) {
                ecl_damage_message(p, dmg);
            }
        }
    } else {
        for (i = 1; i <= flags; ++i) {
            p = g_party_head;
            /* B+$67C: (word) number of party members (max 8) */
            victim = roll_dice(1, COK_GET16(g_state_b + 0x67C));
            for (j = 1; j < victim; ++j) {
                p = p->next;
            }
            if (ecl_attack_hits(p, save_t)) {
                ecl_damage_message(p, dmg);
            }
            dmg = (u16)(roll_dice(n, sides) + bonus);
        }
    }
    H005_B(0x24D0) = 1; /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
            H005_B(0x24D0) = 0; /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
        }
    }
    if (H005_B(0x24D0)) { /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
        draw_screen_frame(1);
        H005_SET_W(0x334E, 2); /* $334E: (word) text cursor: column */
        H005_SET_W(0x334C, 2); /* $334C: (word) text cursor: row */
        word_wrap_text(1, 1, 0x26, 0x16, 0x0A, 0, 1, 0x1B,
                       "The entire party is killed!");
        dos_delay(0x96);
    }
    g_current_char = save;
    show_message_wait(0x0F, 0, 0x22, "press <enter>/<return> to continue");
}

/* PORT H012+$2358 (command $31): closes the event pictures. */
void ecl_clear_picture(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    if (H005_B(0x24BA)) { /* $24BA: 1 if the SPRIT sprite of the event is on screen */
        H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
        refresh_view();
        H005_B(0x24BA) = 0; /* $24BA: 1 if the SPRIT sprite of the event is on screen */
        H005_B(0x24BD) = 0; /* $24BD: 1 if the event picture/portrait is on screen */
    }
}

/* PORT H012+$2392 (command $34): advances the time by n units u. */
void ecl_advance_time(void)
{
    u16 n;                              /* -$2(a5) */
    u8 u;                               /* -$3(a5) */

    read_operands(2);
    n = eval_operand(1);
    u = (u8)eval_operand(2);
    advance_time(n, u);
}

/* PORT H012+$23D6 (command $33): newline in the text window. */
void ecl_new_line(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    if (H005_B(0x24BE)) { /* $24BE: use: cleared at start-up and by ECL command $33 (newline) */
        H005_SET_W(0x334E, 1); /* $334E: (word) text cursor: column */
        H005_SET_W(0x334C, H005_W(0x334C) + 1); /* $334C: (word) text cursor: row */
        H005_B(0x24BE) = 0; /* $24BE: use: cleared at start-up and by ECL command $33 (newline) */
    } else {
        H005_SET_W(0x334E, 1); /* $334E: (word) text cursor: column */
        H005_SET_W(0x334C, H005_W(0x334C) + 1); /* $334C: (word) text cursor: row */
    }
}

/* PORT H012+$241C (command $3D): redraws the exploration screen. */
void ecl_redraw_screen(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    H005_B(0x24AE) = 0; /* $24AE: 1 with a full-screen big picture: no party list */
    draw_explore_frame();
    draw_party(g_current_char);
    draw_status_line();
    if (!H005_B(0x24D7)) { /* $24D7: 1 if the demonstration (Demo) was chosen */
        show_picture(3, 3, 1, g_pic_rec_27c2);
    }
    draw_status_line();
    H005_B(0x24B2) = 0; /* $24B2: 1: exploration frame to be redrawn (after LOAD FILES) */
    H005_B(0x24BF) = 1; /* $24BF: use: 1 after ECL command $3D (redraw), 0 after EXIT */
}

/* PORT H012+$2486 (command $39): chooses the current character with the given text. */
void ecl_who(void)
{
    u8 save;                            /* -$53(a5) */
    char prompt[0x51];                  /* -$52(a5) */

    save = H005_B(0x24B0); /* $24B0: Move mode of the exploration: click on the view as movement */
    H005_B(0x24B0) = 0; /* $24B0: Move mode of the exploration: click on the view as movement */
    H005_B(0x24B3) = 0; /* $24B3: 1 if LOAD CHARACTER did not find the character (var $1F = 0) */
    read_operands(1);
    clear_text_cells(1, 0x11, 0x26, 0x16);
    h026_copy(0x50, prompt, 0xFF, ecl_string(1));
    choose_party_member(0x50, prompt, 0, 0, &g_current_char);
    H005_B(0x24B0) = save; /* $24B0: Move mode of the exploration: click on the view as movement */
}

/* PORT H012+$2502 (command $36): adds an NPC (H066+$276E) with the given AI. */
void ecl_add_npc(void)
{
    u16 v;                              /* -$C(a5) */

    read_operands(2);
    add_npc(eval_operand(1));
    v = (u16)(eval_operand(2) >> 1);
    v = or_byte((u8)v, 0x80);
    g_current_char->b[0xEC] = (u8)v; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    recompute_stats(g_current_char);
    draw_party(g_current_char);
}

/*
 * PORT H012+$2596 (command $3B): looks for spell s among those
 * memorised (+$1F..) by the characters: position ($FF if not) and number
 * of the character into the variables; then the debug trace H056+$0886.
 */
void ecl_find_spell(void)
{
    u8 found = 0;                       /* -$B(a5) */
    u8 stop = 0;                        /* -$C(a5) */
    u16 s;                              /* -$2(a5) */
    u16 dst1;                           /* -$E(a5) */
    u16 dst2;                           /* -$10(a5) */
    u16 k = 1;                          /* -$4(a5) */
    u16 idx = 0;                        /* -$6(a5) */
    Character *p;                       /* -$A(a5) */

    read_operands(3);
    s = eval_operand(1);
    dst1 = ADDR(2);
    dst2 = ADDR(3);
    p = g_party_head;
    while (p != NULL && !found) {
        k = 1;
        do {
            /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
            if (p->b[0x1E + k] == s) {
                found = 1;
            } else if (k <= 0x39) {
                ++k;
            } else {
                stop = 1;
            }
        } while (!stop && !found);
        stop = 0;
        p = p->next;
        if (p != NULL && !found) {
            ++idx;
        }
    }
    if (k > 0x39) {
        k = 0xFF;
    }
    write_var(dst1, k);
    write_var(dst2, idx);
    debug_trace(5, "spell", (u8)k, (u8)idx, (u8)s);
}

/*
 * PORT H012+$2AAE (command $3C): no effect.  The original does not advance
 * the PC (the command would repeat forever); the same here.
 */
void ecl_nop_3c(void)
{
}

/* PORT H012+$2ABE (command $3E): the current character leaves the party. */
void ecl_remove_character(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    remove_from_party(0, 1);
    g_h064_saved_char = g_current_char;
    draw_party(g_current_char);
}

/* PORT H012+$2AF6 (command $3F): does the current character have effect t? */
void ecl_has_effect(void)
{
    CokEffect *e;                       /* -$4(a5) */

    /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    read_operands(1);
    if (find_effect(g_current_char, eval_operand(1), &e)) {
        H005_B(0x237E) = 1; /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
    } else {
        H005_B(0x237F) = 1; /* $237F: comparison results +1: not equal */
    }
}

/* PORT H012+$2B64 (command $40): removes the items of type t from everyone. */
void ecl_remove_items(void)
{
    u16 t;                              /* -$2(a5) */
    Character *save;                    /* -$A(a5) */
    Character *p;                       /* -$6(a5) */
    CokItem *it;                        /* -$E(a5) */
    CokItem *next;                      /* -$12(a5) */

    read_operands(1);
    t = eval_operand(1);
    save = g_current_char;
    for (p = g_party_head; p != NULL; p = p->next) {
        it = p->items;
        while (it != NULL) {
            next = it->next;
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            if (it->b[0x30] == t) {
                g_current_char = p;
                if (it->b[0x3A]) { /* item+$3A: item readied flag (Ready) */
                    ready_item(it);
                }
                delete_item(p, it);
            }
            it = next;
        }
        recompute_stats(p);
    }
    g_current_char = save;
}

/*
 * PORT H012+$2C28 (command $41, EXPERIENCE): experience points to the party (or
 * to the current one), divided by the classes of each one (+$FE..+$105 not zero);
 * only to those standing.  Without classes the original divides by 0
 * (68000 exception): here no points.
 */
static void give_xp(Character *p, u16 xp)
{
    u16 classes = 0;                    /* -$C(a5) */
    u8 i;                               /* -$9(a5) */
    u16 share;                          /* -$E(a5) */

    for (i = 0; i <= 7; ++i) {
        if (p->b[0xFE + i] > 0) { /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            ++classes;
        }
    }
    if (classes == 0) {
        return;
    }
    share = (u16)(xp / classes);
    if (p->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        COK_PUT32(&p->b[0x11E], COK_GET32(&p->b[0x11E]) + share); /* ch+$11E: experience points (long) */
    }
}

void ecl_experience(void)
{
    u16 xp;                             /* -$2(a5) */
    u8 all;                             /* -$3(a5) */
    Character *p;                       /* -$8(a5) */

    read_operands(2);
    xp = eval_operand(2);
    all = (u8)eval_operand(1);
    H005_SET_W(0x334C, 0x11); /* $334C: (word) text cursor: row */
    H005_SET_W(0x334E, 1); /* $334E: (word) text cursor: column */
    if (all) {
        word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x2B,
                       "Congratulations the party gains experience!");
        message_delay();
        for (p = g_party_head; p != NULL; p = p->next) {
            give_xp(p, xp);
        }
    } else {
        p = g_current_char;
        /* H064_data+$C: TEXT64 text buffer ($50 bytes): file names and messages */
        strcpy(TEXT64, "Congratulations ");
        /* H064_data+$C: TEXT64 text buffer ($50 bytes): file names and messages */
        h026_append(0x50, TEXT64, 0x0F, (const char *)p->b);
        /* H064_data+$C: TEXT64 text buffer ($50 bytes): file names and messages */
        h026_append(0x50, TEXT64, 0x12, " gains experience!");
        /* H064_data+$C: TEXT64 text buffer ($50 bytes): file names and messages */
        word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x50, TEXT64);
        message_delay();
        give_xp(p, xp);
    }
}

/*
 * PORT H012+$26D6 (command $2D): special actions by code: $2E10
 * redraws the view if changed, $6803 animates the set $27BC, $B203
 * sound, $C018 wall in front, $C01E one step forward.
 */
void ecl_special(void)
{
    u16 w;                              /* -$2(a5) */
    u8 *set = &g_h005[0x27BC]; /* $27BC: (word) frames of the loaded sequence (max 6), base of the block */

    read_operands(1);
    w = make_word(operand_lo(1), operand_hi(1));
    if (w == 0x2E10) w = 0;
    else if (w == 0x6803) w = 1;
    else if (w == 0xB203) w = 2;
    else if (w == 0xC018) w = 3;
    else if (w == 0xC01E) w = 4;
    switch (w) {
    case 0:
        /* $2822: flags of the party square (map_flags); bit 7 picks the sky; $281C: (word) party x
         * on the 16x16 area map; $281E: (word) party y on the 16x16 area
         * map */
        H005_B(0x2822) = map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E));
        /* $24BD: 1 if the event picture/portrait is on screen; $24BA: 1 if the SPRIT sprite of the
         * event is on screen; $24B8: 1 if $247E/$247F changed: view to be redrawn */
        if (H005_B(0x24BD) || H005_B(0x24BA) || H005_B(0x24B8) ||
            /* $24B7: 1 if the party position/direction changed: view to be redrawn; $24B5: 1 if ECL
             * wrote vars $FD/$FE: view to be redrawn */
            H005_B(0x24B7) || H005_B(0x24B5)) {
            /* $2378: flag: event sprite already shown (flags[0], 2 bytes with +$2379) */
            h029_fill_bytes(1, &H005_B(0x2378), 2, 0);
            H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
            refresh_view();
            draw_status_line();
            H005_B(0x24B5) = 0; /* $24B5: 1 if ECL wrote vars $FD/$FE: view to be redrawn */
            H005_B(0x24B8) = 0; /* $24B8: 1 if $247E/$247F changed: view to be redrawn */
            H005_B(0x24B7) = 0; /* $24B7: 1 if the party position/direction changed: view to be redrawn */
            H005_B(0x24BD) = 0; /* $24BD: 1 if the event picture/portrait is on screen */
            H005_B(0x24BA) = 0; /* $24BA: 1 if the SPRIT sprite of the event is on screen */
            /* $2821: wall in front of the party (map_wall on the square and direction); $281C:
             * (word) party x on the 16x16 area map */
            H005_B(0x2821) = (u8)map_wall((s16)H005_W(0x281C),
                                          /* $281E: (word) party y on the 16x16 area map */
                                          (s16)H005_W(0x281E),
                                          /* $2820: party direction (0 north, 2 east, 4 south, 6
                                           * west) */
                                          H005_B(0x2820));
        }
        break;
    case 1:
        show_picture(3, 3, 1, sequence_frame(COK_GET16(set + 2)));
        COK_PUT16(set + 2, COK_GET16(set + 2) + 1);
        if (COK_GET16(set + 2) > COK_GET16(set)) {
            COK_PUT16(set + 2, 1);
        }
        message_delay();
        break;
    case 2:
        /* $2376: use: code (word) read by ECL command $2D, action 2 ($A or other) */
        switch (H005_W(0x2376)) {
        case 0x0A: h043_190e(0x13); break;
        default: h043_190e(0x11); break;
        }
        break;
    case 3:
        /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        if (COK_GET16(g_state_a + 0x1CC) == 0) {
            /* $2821: wall in front of the party (map_wall on the square and direction); $281C:
             * (word) party x on the 16x16 area map */
            H005_B(0x2821) = (u8)map_wall((s16)H005_W(0x281C),
                                          /* $281E: (word) party y on the 16x16 area map */
                                          (s16)H005_W(0x281E),
                                          /* $2820: party direction (0 north, 2 east, 4 south, 6
                                           * west) */
                                          H005_B(0x2820));
        }
        break;
    case 4:
        step_forward();
        break;
    default:
        break;
    }
}

/*
 * PORT H012+$2922: rest/camp of the area: runs the entry
 * $3DF0, then H057+$2F3A; if requested redraws and runs $3DEE; finally
 * redraws the view (and outdoors the picture).
 */
void ecl_camp_entry(void)
{
    u8 r = 0;                           /* -$1(a5) */

    run_ecl(H005_W(0x3DF0)); /* $3DF0: (word) ECL entry address of the area's rest/camp */
    encamp(&r);
    if (r) {
        redraw_game_screen();
        run_ecl(H005_W(0x3DEE)); /* $3DEE: (word) ECL entry address after resting/camp */
    }
    H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
    /* A+$270: (word) town area: no view redraw nor EXIT from the camp */
    if (COK_GET16(g_state_a + 0x270) == 0) {
        refresh_view();
    }
    H005_B(0x24A3) = 0; /* $24A3: 1 if the game is saved (warning on exit); read by eff. $36 */
    /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map; A+$270: (word) town area: no view
     * redraw nor EXIT from the camp */
    if (COK_GET16(g_state_a + 0x1CC) == 0 && COK_GET16(g_state_a + 0x270) == 0) {
        h069_draw_marker();
    }
}

/*
 * PORT H012+$29A6 (command $38): 0 the party menu (H013+$4BFC), 9 the
 * camp ($2922) and, outside the town, EXIT.
 */
void ecl_party_menu(void)
{
    u8 save;                            /* -$A(a5) */
    u16 pc;                             /* -$4(a5) */
    u16 v;                              /* -$2(a5) */

    save = H005_B(0x24B0); /* $24B0: Move mode of the exploration: click on the view as movement */
    H005_B(0x24B0) = 0; /* $24B0: Move mode of the exploration: click on the view as movement */
    if (H064_B(9)) { /* H064_data+$9: LOAD CHARACTER flag: restore the saved character */
        g_current_char = g_h064_saved_char;
        H064_B(9) = 0; /* H064_data+$9: LOAD CHARACTER flag: restore the saved character */
    }
    pc = H005_W(0x3DEA); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    read_operands(1);
    v = eval_operand(1);
    switch (v) {
    case 0:
        H005_B(0x249C) = 0; /* $249C: 0 during the party menu from ECL $38: Drop does not lose the party */
        main_menu();
        H005_B(0x249C) = 1; /* $249C: 0 during the party menu from ECL $38: Drop does not lose the party */
        /* $2486: id of the sequence loaded at $27BC (name at $27A6), $FF none; A+$270: (word)
         * town area: no view redraw nor EXIT from the camp */
        if (H005_B(0x2486) != 9 && COK_GET16(g_state_a + 0x270) == 0 &&
            /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
            COK_GET16(g_state_a + 0x1CC) == 0) {
            redraw_game_screen();
        }
        break;
    case 9:
        pc = H005_W(0x3DEA); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
        ecl_camp_entry();
        H005_SET_W(0x3DEA, pc); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
        /* A+$270: (word) town area: no view redraw nor EXIT from the camp */
        if (COK_GET16(g_state_a + 0x270) == 0) {
            ecl_exit();
        }
        break;
    default:
        break;
    }
    (void)pc;
    H005_B(0x24B0) = save; /* $24B0: Move mode of the exploration: click on the view as movement */
}

/*
 * PORT H012+$3020: entry into a new area (after NEWECL or an exit):
 * frees the pictures, runs the entries $3DEC, $3DF4 and $3DF2 of the
 * ECL program and redraws, repeating while a command asks for
 * another area (H064+$A).
 */
static void enter_area(void)
{
    do {
        release_picture_set();
        /* $279C: name (8 chars) of the sequence saved by Encamp to reload it */
        H005_B(0x279C) = 0;             /* empty string of H012+$16F */
        H005_B(0x2485) = 0xFF; /* $2485: id of the sequence saved when entering the camp, reloaded on exit */
        H064_B(0x0A) = 0; /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
        /* $2822: flags of the party square (map_flags); bit 7 picks the sky; $281C: (word) party x
         * on the 16x16 area map; $281E: (word) party y on the 16x16 area
         * map */
        H005_B(0x2822) = map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E));
        /* B+$5AA: (word) 1 if the step leaves the 16x16 map (exit from the area) */
        COK_PUT16(g_state_b + 0x5AA, 0);
        g_h064_saved_char = g_current_char;
        run_ecl(H005_W(0x3DEC)); /* $3DEC: (word) first ECL entry address of the area (on entry) */
        if (!H064_B(0x0A)) { /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
            /* $2498: id of the ECL program of the current area ($24 initial, $39 demo);
             * A+$1E4: (word) number of the current ECL area (copy of $2498) */
            COK_PUT16(g_state_a + 0x1E4, H005_B(0x2498));
        }
        if (!H064_B(0x0A)) { /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
            /* $3DE2: previous game context (copy of $3DE3), saved; $3DE3: current game
             * mode/context (0 menu, 1 view, 5 combat) */
            if ((H005_B(0x3DE2) == 4 && H005_B(0x3DE3) == 4) ||
                /* $3DE2: previous game context (copy of $3DE3), saved; H064_data+$8: LOAD
                 * FILES/PIECES done flag: redraws the view */
                (H005_B(0x3DE2) != 4 && H064_B(8))) {
                refresh_view();
            }
            H064_B(0x0A) = 0; /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
            /* $3DF4: (word) ECL entry run after $3DEC and in the exploration loop */
            run_ecl(H005_W(0x3DF4));
            if (!H064_B(0x0A)) { /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
                /* $3DF2: (word) ECL entry after $3DF4; PC brought back here by the outdoor step */
                run_ecl(H005_W(0x3DF2));
                /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
                if (!H064_B(0x0A)) {
                    g_current_char = g_h064_saved_char;
                    draw_party(g_current_char);
                }
            }
        }
    } while (H064_B(0x0A)); /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
    /* $3DE2: previous game context (copy of $3DE3), saved; $3DE3: current game mode/context (0
     * menu, 1 view, 5 combat) */
    H005_B(0x3DE2) = H005_B(0x3DE3);
}

/* Upper case as in the original (a..z with andi #$5F). */
static u8 key_upper(u8 k)
{
    if (k >= 'a' && k <= 'z') {
        k = (u8)(k & 0x5F);
    }
    return k;
}

/* Removes all the characters from the party (H012+$3248 and $34CE). */
static void dismiss_party(u8 keep)
{
    Character *p;                       /* -$6(a5) */

    p = g_party_head;
    while (p != NULL) {
        g_current_char = p;
        p = p->next;
        remove_from_party(keep, 1);
    }
}

/*
 * PORT H012+$3150: exploration loop.  Loads the ECL program
 * of the area ($3E04+$1E4, or $24 at the start, $39 in the demonstration), runs
 * its entry and then repeats: command menu (H068+$0C0E) with
 * Encamp, search and look, and once the step is done (H068+$122E) the
 * entries $3DF2/$3DF4; until the party is lost ($24D0).
 */
void explore_loop(void)
{
    u8 key;                             /* -$1(a5) */

    g_h064_saved_char = g_current_char;
    H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
    H005_B(0x24BB) = 0; /* $24BB: use: cleared when the area starts; with 1 EXIT redraws the frame */
    H064_B(7) = 0; /* H064_data+$7: walls loaded flag (LOAD PIECES $37) in the program */
    H064_B(6) = 0; /* H064_data+$6: GEO map loaded flag (LOAD FILES $21) in the program */
    H064_B(9) = 0; /* H064_data+$9: LOAD CHARACTER flag: restore the saved character */
    H064_B(8) = 0; /* H064_data+$8: LOAD FILES/PIECES done flag: redraws the view */
    H005_B(0x24B2) = 1; /* $24B2: 1: exploration frame to be redrawn (after LOAD FILES) */
    H005_B(0x3DE3) = 4; /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    H064_B(0x0A) = 0; /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
    /* A+$1E4: (word) number of the current ECL area (copy of $2498) */
    if (COK_GET16(g_state_a + 0x1E4) == 0) {
        H005_B(0x24B2) = 0; /* $24B2: 1: exploration frame to be redrawn (after LOAD FILES) */
        if (H005_B(0x24D7)) { /* $24D7: 1 if the demonstration (Demo) was chosen */
            /* $2498: id of the ECL program of the current area ($24 initial, $39 demo) */
            H005_B(0x2498) = 0x39;
        } else {
            /* $2498: id of the ECL program of the current area ($24 initial, $39 demo) */
            H005_B(0x2498) = 0x24;
            draw_party(g_current_char);
        }
    } else {
        /* $2498: id of the ECL program of the current area ($24 initial, $39 demo); A+$1E4:
         * (word) number of the current ECL area (copy of $2498) */
        H005_B(0x2498) = (u8)COK_GET16(g_state_a + 0x1E4);
    }
    if (COK_GET16(g_state_a + 0x1CC) == 0) { /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        H005_B(0x3DE3) = 3; /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    }
    /* $2498: id of the ECL program of the current area ($24 initial, $39 demo) */
    load_ecl_program(H005_B(0x2498));
    /* H064_data+$C: TEXT64 text buffer ($50 bytes): file names and messages */
    ui_draw_text(0, 0, 0x0B, 0, 0x50, TEXT64);
    ecl_start_area();
    run_ecl(H005_W(0x3DEC)); /* $3DEC: (word) first ECL entry address of the area (on entry) */
    if (H005_B(0x24D7)) { /* $24D7: 1 if the demonstration (Demo) was chosen */
        dismiss_party(1);
        return;
    }
    if (!H064_B(0x0A)) { /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
        /* $2498: id of the ECL program of the current area ($24 initial, $39 demo); A+$1E4:
         * (word) number of the current ECL area (copy of $2498) */
        COK_PUT16(g_state_a + 0x1E4, H005_B(0x2498));
    } else {
        enter_area();
    }
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat); $24D1: 1 after Load Saved Game:
     * the area does not clear its variables */
    if (H005_B(0x3DE3) != 3 && H005_B(0x24D1)) {
        if (H005_B(0x24B2) == 1) { /* $24B2: 1: exploration frame to be redrawn (after LOAD FILES) */
            redraw_game_screen();
        }
        H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
        refresh_view();
    }
    H005_B(0x24D1) = 0; /* $24D1: 1 after Load Saved Game: the area does not clear its variables */
    H005_B(0x24B0) = 0; /* $24B0: Move mode of the exploration: click on the view as movement */
    do {
        /* $3DE8: (word) start address of the current ECL execution; $3DF4: (word) ECL entry run
         * after $3DEC and in the exploration loop; H064_data+$A: NEWECL flag: new program
         * loaded, the entry restarts */
        if (H005_W(0x3DE8) != H005_W(0x3DF4) && !H064_B(0x0A)) {
            key = explore_command_menu();
            g_h064_saved_char = g_current_char;
            if (!H064_B(0x0A)) { /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
                /* $2498: id of the ECL program of the current area ($24 initial, $39 demo);
                 * A+$1E4: (word) number of the current ECL area (copy of $2498) */
                COK_PUT16(g_state_a + 0x1E4, H005_B(0x2498));
            }
            /* B+$594: (word) bit 0 search mode, bit 1 Look in progress */
            while ((COK_GET16(g_state_b + 0x594) > 1 ||
                    /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
                    key_upper(key) == 'E') && !H005_B(0x24D0)) {
                if (key_upper(key) == 'E') {
                    ecl_camp_entry();
                } else {
                    /* $2497: copy of the Search bit ($3E00+$594) during entry $3DF2; B+$594:
                     * (word) bit 0 search mode, bit 1 Look in progress */
                    H005_B(0x2497) = mask_byte((u8)COK_GET16(g_state_b + 0x594), 1);
                    /* B+$594: (word) bit 0 search mode, bit 1 Look in progress */
                    COK_PUT16(g_state_b + 0x594, 1);
                    H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
                    refresh_view();
                    /* $3DF2: (word) ECL entry after $3DF4; PC brought back here by the outdoor step */
                    run_ecl(H005_W(0x3DF2));
                    /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
                    if (H064_B(0x0A)) {
                        enter_area();
                    }
                    /* $2497: copy of the Search bit ($3E00+$594) during entry $3DF2; B+$594:
                     * (word) bit 0 search mode, bit 1 Look in progress */
                    COK_PUT16(g_state_b + 0x594, H005_B(0x2497));
                }
                /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
                if (!H005_B(0x24D0)) {
                    key = explore_command_menu();
                    g_h064_saved_char = g_current_char;
                }
            }
            if (!H005_B(0x24D0)) { /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
                /* $3DF4: (word) ECL entry run after $3DEC and in the exploration loop */
                run_ecl(H005_W(0x3DF4));
            }
        /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
        } else if (H064_B(0x0A)) {
            enter_area();
        /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
        } else if (!H005_B(0x24D0)) {
            /* $281C: (word) party x on the 16x16 area map; A+$1E0: (word) party x before the
             * step (to detect the movement) */
            COK_PUT16(g_state_a + 0x1E0, H005_W(0x281C));
            /* $281E: (word) party y on the 16x16 area map; A+$1E2: (word) party y before the
             * step (to detect the movement) */
            COK_PUT16(g_state_a + 0x1E2, H005_W(0x281E));
            explore_move_or_door();
            refresh_view();
            /* $281C: (word) party x on the 16x16 area map; A+$1E0: (word) party x before the
             * step (to detect the movement) */
            if (H005_W(0x281C) != COK_GET16(g_state_a + 0x1E0) ||
                /* $281E: (word) party y on the 16x16 area map; A+$1E2: (word) party y before the
                 * step (to detect the movement) */
                H005_W(0x281E) != COK_GET16(g_state_a + 0x1E2)) {
                h043_190e(0x11);
            }
            H005_B(0x24BD) = 0; /* $24BD: 1 if the event picture/portrait is on screen */
            H005_B(0x24BC) = 1; /* $24BC: 1 if the event picture can be animated (not head+body) */
            /* $3DF2: (word) ECL entry after $3DF4; PC brought back here by the outdoor step */
            run_ecl(H005_W(0x3DF2));
            if (H064_B(0x0A)) { /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
                enter_area();
            }
        }
    } while (!H005_B(0x24D0)); /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
    H005_B(0x24D0) = 0; /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
    dismiss_party(0);
}
