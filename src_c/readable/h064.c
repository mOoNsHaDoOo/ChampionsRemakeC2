/* H064: native handlers of the ECL commands. */
#include "h064.h"
#include "globals.h"
#include "unported.h"
#include "h042_seq.h"
#include "h060.h"
#include "h011.h"
#include "h069.h"
#include "h003_exec.h"
#include "h008.h"
#include "h023_shared.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h035.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h053.h"
#include "h061.h"
#include "h063.h"
#include "h073.h"
#include <string.h>

/*
 * Data at the start of the module (H064+$0000..$005D): +$0 current character
 * saved, +$6..+$B ECL VM flags (+$B: end of the
 * program), +$C text.  g_h064_data[k] is H064+k.
 */
Character *g_h064_saved_char;           /* H064+$0000 */
u8 g_h064_data[0x5E];

/* PORT H064+$00EE: link/unlk, no effect. */
void h064_init(void)
{
}

/* Operands: raw bytes and address of operand i. */
#define OPD(i)  operand_desc(i)
#define ADDR(i) decode_address(operand_lo(i), operand_hi(i))

/*
 * PORT H064+$0156 (command $00, EXIT): end of the program: restores the
 * saved current character, stops the VM (+$B), empties the GOSUB stack
 * and moves the text back to the top left of the window.
 */
void ecl_exit(void)
{
    if (H005_B(0x24BB)) { /* $24BB: use: cleared when the area starts; with 1 EXIT redraws the frame */
        draw_explore_frame();
    }
    if (H064_B(9)) { /* H064_data+$9: LOAD CHARACTER flag: restore the saved character */
        g_current_char = g_h064_saved_char;
        H064_B(9) = 0; /* H064_data+$9: LOAD CHARACTER flag: restore the saved character */
    }
    /* $2378: flag: event sprite already shown (flags[0], 2 bytes with +$2379) */
    h029_fill_bytes(1, &H005_B(0x2378), 2, 0);
    H005_B(0x24BD) = 0; /* $24BD: 1 if the event picture/portrait is on screen */
    H005_B(0x24BB) = 0; /* $24BB: use: cleared when the area starts; with 1 EXIT redraws the frame */
    H064_B(0x0B) = 1; /* H064_data+$B: end of ECL execution flag (EXIT or NEWECL) */
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    while (g_ecl_stack != NULL) {
        g_ecl_stack_prev = g_ecl_stack->next;
        exec_free_mem(g_ecl_stack, sizeof(CokEclFrame));
        g_ecl_stack = g_ecl_stack_prev;
    }
    H005_SET_W(0x334C, 0x11); /* $334C: (word) text cursor: row */
    H005_SET_W(0x334E, 1); /* $334E: (word) text cursor: column */
    H005_B(0x24BF) = 0; /* $24BF: use: 1 after ECL command $3D (redraw), 0 after EXIT */
}

/* PORT H064+$0202 (command $01, GOTO). */
void ecl_goto(void)
{
    read_operands(1);
    H005_SET_W(0x3DEA, ADDR(1)); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
}

/* PORT H064+$0234 (command $02, GOSUB). */
void ecl_gosub_cmd(void)
{
    read_operands(1);
    ecl_gosub(1);
}

/* PORT H064+$0258 (command $03, COMPARE): strings if one of them is, otherwise values. */
void ecl_compare(void)
{
    char a[0x51];                       /* -$58(a5) */
    char b[0x51];                       /* -$AA(a5) */

    read_operands(2);
    if (OPD(1) >= 0x80 || OPD(2) >= 0x80) {
        h026_copy(0x50, a, 0xFF, ecl_string(1));
        h026_copy(0x50, b, 0xFF, ecl_string(2));
        compare_strings(0x50, a, 0x50, b);
    } else {
        compare_words(eval_operand(1), eval_operand(2));
    }
}

/*
 * PORT H064+$0306 (commands $04..$07: ADD, SUB, DIV, MUL): result in the
 * variable of the third operand; the remainder of the division in $3E00+$67E.
 * SUB does second - first, DIV first / second.  With divisor 0 the
 * 68000 would raise an exception: here result 0 and remainder unchanged.
 */
void ecl_arithmetic(void)
{
    u16 v[2];                           /* -$6(a5), -$4(a5) */
    u16 dst;                            /* -$2(a5) */
    u16 r = 0;                          /* -$A(a5) */
    u16 i;                              /* -$8(a5) */

    read_operands(3);
    for (i = 1; i <= 2; ++i) {
        v[i - 1] = eval_operand(i);
    }
    dst = ADDR(3);
    switch (H005_B(0x2493)) { /* $2493: code of the ECL command being executed */
    case 4:
        r = (u16)(v[0] + v[1]);
        break;
    case 5:
        r = (u16)(v[1] - v[0]);
        break;
    case 6:
        if (v[1] != 0) {
            r = (u16)(v[0] / v[1]);
            /* B+$67E: (word) remainder of the division of the ECL commands ADD..MUL */
            COK_PUT16(g_state_b + 0x67E, (u16)(v[0] % v[1]));
        }
        break;
    case 7:
        r = (u16)((u32)v[0] * v[1]);
        break;
    default:
        break;
    }
    write_var(dst, r);
}

/* PORT H064+$03FC (command $08, RANDOM): random number from 0 to n (n < $FF). */
void ecl_random(void)
{
    u16 n;                              /* -$2(a5) */
    u16 dst;                            /* -$6(a5) */

    read_operands(2);
    n = eval_operand(1);
    if (n < 0xFF) {
        ++n;
    }
    dst = ADDR(2);
    write_var(dst, (u16)random_below(n));
}

/* PORT H064+$0468 (command $09, SAVE): value or string into the variable. */
void ecl_save(void)
{
    u16 dst;                            /* -$4(a5) */

    read_operands(2);
    dst = ADDR(2);
    if (OPD(1) < 0x80) {
        write_var(dst, eval_operand(1));
    } else {
        write_string_var(dst, 0xFF, ecl_string(1));
    }
}

/*
 * PORT H064+$04DC (command $0A, LOAD CHARACTER): party character n
 * becomes the current one ($24B3 if it is not there); with bit 7, if requested
 * ($24C4, $24C3), it leaves the party.
 */
void ecl_load_character(void)
{
    u16 i = 0;                          /* -$8(a5) */
    u8 v;                               /* -$9(a5) */
    u8 leave;                           /* -$A(a5) */
    Character *p;                       /* -$4(a5) */

    H064_B(9) = 1; /* H064_data+$9: LOAD CHARACTER flag: restore the saved character */
    read_operands(1);
    v = (u8)eval_operand(1);
    p = g_party_head;
    leave = mask_byte(v, 0x80);
    v = mask_byte(v, 0x7F);
    while (v > 0 && i < v && p != NULL) {
        p = p->next;
        ++i;
    }
    if (p != NULL) {
        g_current_char = p;
        H005_B(0x24B3) = 0; /* $24B3: 1 if LOAD CHARACTER did not find the character (var $1F = 0) */
    } else {
        H005_B(0x24B3) = 1; /* $24B3: 1 if LOAD CHARACTER did not find the character (var $1F = 0) */
    }
    /* $24C4: use: cleared; with $24C3 LOAD CHARACTER removes from the party; $24C3: use: 1
     * from an ECL write of state B to 0; with $24C4 it leaves */
    if (leave && H005_B(0x24C4) && H005_B(0x24C3)) {
        if (g_h064_saved_char == g_current_char) {
            H064_B(9) = 0; /* H064_data+$9: LOAD CHARACTER flag: restore the saved character */
        }
        remove_from_party(0, 1);
        draw_party(g_current_char);
        H005_B(0x24C4) = 0; /* $24C4: use: cleared; with $24C3 LOAD CHARACTER removes from the party */
        H005_B(0x24C3) = 0; /* $24C3: use: 1 from an ECL write of state B to 0; with $24C4 it leaves */
    }
}

/*
 * PORT H064+$06A0 (command $0B, LOAD MONSTER): adds n copies of
 * monster idx to the party (with items and effects, the latter in reverse order) and
 * its CPIC figure set spr in slot $248E; the enemies (side 1) have their
 * hit points scaled with the difficulty ($3E04+$3E8, 1..5).  At most
 * $3F monsters (H064+$5).
 */
void ecl_load_monster(void)
{
    Character *save;                    /* -$16(a5) */
    Character *mon = NULL;              /* -$12(a5) */
    Character *p;                       /* -$A(a5) */
    Character *q;                       /* -$E(a5) */
    Character tmpl;                     /* -$1C0(a5) */
    CokItem *items = NULL;              /* -$1D2(a5) */
    CokItem *items0;                    /* -$1DA(a5) */
    CokEffect *effects = NULL;          /* -$1DE(a5) */
    CokEffect *effects0;                /* -$1E6(a5) */
    CokItem *it;
    CokEffect *ef;
    u16 count = 1;                      /* -$6(a5) */
    u8 idx;                             /* -$1(a5) */
    u8 n;                               /* -$2(a5) */
    u8 spr;                             /* -$3(a5) */
    u16 diff;

    save = g_current_char;
    read_operands(3);
    if (H064_B(5) >= 0x3F) { /* H064_data+$5: number of monsters loaded with LOAD MONSTER (max $3F) */
        g_current_char = save;
        return;
    }
    idx = (u8)eval_operand(1);
    load_monster(idx, &mon, &items, &effects);
    diff = COK_GET16(g_state_a + 0x3E8); /* A+$3E8: (word) difficulty level (1..5, initial 3) */
    /* ch+$199: side in combat (0 party, 1 opponents) */
    if (mon->b[0x199] == 1 && diff > 0 && diff < 6) {
        mon->b[0x1A8] = (u8)((u16)(mon->b[0x1A8] * (diff + 1)) >> 2); /* ch+$1A8: current hit points */
        mon->b[0x64] = (u8)((u16)(mon->b[0x64] * (diff + 1)) >> 2); /* ch+$64: maximum hit points */
        /* ch+$1A8: current hit points; ch+$64: maximum hit points */
        if (mon->b[0x1A8] == 0 || mon->b[0x64] == 0) {
            mon->b[0x1A8] = 1; /* ch+$1A8: current hit points */
            mon->b[0x64] = 1; /* ch+$64: maximum hit points */
        }
    }
    if (mon->b[0xDF]) { /* ch+$DF: undead type (0 = no); base -1 of the thief skills +$E0..+$E7 */
        /* $248F: monsters loaded with +$DF: Turn Undead limit (turn +$13) */
        add_to_byte(&H005_B(0x248F), 1);
    }
    tmpl = *mon;
    items0 = items;
    effects0 = effects;
    n = (u8)eval_operand(2);
    if (n == 0) {
        n = 1;
    }
    spr = (u8)eval_operand(3);
    p = g_party_head;
    /* $248E: next slot of the CPIC figure set for the monsters (from 8) */
    load_sprite_set(0x0C, "CPIC", spr, H005_B(0x248E));
    while (p->next != NULL) {
        p = p->next;
    }
    p->next = mon;
    p = p->next;
    /* ch+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor); $248E: next
     * slot of the CPIC figure set for the monsters (from 8) */
    p->b[0x143] = H005_B(0x248E);
    p->next = NULL;
    add_to_byte(&H064_B(5), 1); /* H064_data+$5: number of monsters loaded with LOAD MONSTER (max $3F) */
    ++count;
    /* H064_data+$5: number of monsters loaded with LOAD MONSTER (max $3F) */
    while (count <= n && H064_B(5) < 0x3F) {
        q = (Character *)exec_alloc_mem(sizeof(Character), COK_MEMF_CLEAR);
        p->next = q;
        p = p->next;
        *p = tmpl;                      /* copy of the $1AA bytes */
        /* ch+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor);
         * $248E: next slot of the CPIC figure set for the monsters (from 8) */
        p->b[0x143] = H005_B(0x248E);
        p->next = NULL;
        p->effects = NULL;
        p->items = NULL;
        ++count;
        add_to_byte(&H064_B(5), 1); /* H064_data+$5: number of monsters loaded with LOAD MONSTER (max $3F) */
        for (it = items; it != NULL; it = it->next) {
            CokItem *old = p->items;

            p->items = (CokItem *)exec_alloc_mem(sizeof(CokItem),
                                                 COK_MEMF_CLEAR);
            memcpy(p->items->b, it->b, 0x48);
            p->items->next = old;
        }
        items = items0;
        for (ef = effects; ef != NULL; ef = ef->next) {
            CokEffect *old = p->effects;

            p->effects = (CokEffect *)exec_alloc_mem(sizeof(CokEffect),
                                                     COK_MEMF_CLEAR);
            memcpy(p->effects->b, ef->b, 0x0A);
            p->effects->next = old;
        }
        effects = effects0;
    }
    add_to_byte(&H005_B(0x248E), 1); /* $248E: next slot of the CPIC figure set for the monsters (from 8) */
    H005_B(0x24B6) = 1; /* $24B6: 1 if there are monsters loaded (LOAD MONSTER) for COMBAT */
    g_current_char = save;
}

/*
 * PORT H064+$05E2 (command $0C, APPROACH): sprite spr ($2491) and portrait
 * pic ($2490) of the encounter at distance d ($3E00+$580), limited by the
 * free squares in front ($3E00+$582).
 */
void ecl_approach(void)
{
    read_operands(3);
    H005_B(0x2491) = (u8)eval_operand(1); /* $2491: SPRIT sprite of the encounter (ENCOUNTER/APPROACH) */
    /* B+$580: (word) requested distance of the encounter (ENCOUNTER/APPROACH) */
    COK_PUT16(g_state_b + 0x580, eval_operand(2));
    H005_B(0x2490) = (u8)eval_operand(3); /* $2490: PIC portrait of the encounter (ENCOUNTER/APPROACH) */
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
}

/* PORT H064+$0ABE (command $0D): the encounter comes one square closer. */
void ecl_approach_step(void)
{
    /* B+$582: (word) current distance of the enemies, limited to the free squares */
    if (COK_GET16(g_state_b + 0x582) > 0) {
        /* B+$582: (word) current distance of the enemies, limited to the free squares */
        COK_PUT16(g_state_b + 0x582, COK_GET16(g_state_b + 0x582) - 1);
        /* $2491: SPRIT sprite of the encounter (ENCOUNTER/APPROACH); $2490: PIC portrait of the
         * encounter (ENCOUNTER/APPROACH) */
        show_event_picture(H005_B(0x2491), H005_B(0x2490),
                           /* B+$582: (word) current distance of the enemies, limited to the free squares; $2378: flag:
                            * event sprite already shown (flags[0], 2 bytes with +$2379) */
                           (u8)COK_GET16(g_state_b + 0x582), &H005_B(0x2378));
    }
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
}

/*
 * PORT H064+$0B10 (command $0E, PICTURE): shows picture n: from $70
 * a big picture ($79 with H069+$0012), below that a PIC in the
 * window, with a head+body portrait if set; $FF closes the
 * pictures and redraws the view.
 */
void ecl_picture(void)
{
    u16 n;                              /* -$2(a5) */
    char name[0x51];                    /* -$54(a5) */

    read_operands(1);
    n = eval_operand(1);
    if (n != 0xFF) {
        H005_B(0x2379) = 1; /* $2379: flag: event portrait already shown (flags[1]) */
        H005_B(0x24BD) = 1; /* $24BD: 1 if the event picture/portrait is on screen */
        /* B+$5C2: (word) head of the event portrait, $FF PIC picture */
        if (COK_GET16(g_state_b + 0x5C2) == 0xFF) {
            H005_B(0x24BC) = 1; /* $24BC: 1 if the event picture can be animated (not head+body) */
            if (n >= 0x70) {
                load_big_picture(n);
                show_big_picture();
                if (n == 0x79) {
                    h069_draw_marker();
                } else {
                    /* $24AE: 1 with a full-screen big picture: no party list */
                    H005_B(0x24AE) = 1;
                }
                H005_B(0x24E1) = 0; /* $24E1: 1: exploration picture/view to be redrawn */
            } else {
                strcpy(name, "PIC");
                load_sequence(0x50, name, n, 0);
                show_picture(3, 3, 1, g_pic_rec_27c2);
            }
        } else {
            /* B+$5C2: (word) head of the event portrait, $FF PIC picture */
            show_head_body(COK_GET16(g_state_b + 0x5C2), n);
        }
        return;
    }
    /* $3DE2: previous game context (copy of $3DE3), saved; $3DE3: current game mode/context (0
     * menu, 1 view, 5 combat) */
    if ((H005_B(0x3DE2) != 4 || H005_B(0x3DE3) == 4) &&
        /* $24BD: 1 if the event picture/portrait is on screen; $24BA: 1 if the SPRIT sprite of
         * the event is on screen */
        (H005_B(0x24BD) || H005_B(0x24BA))) {
        H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
        refresh_view();
        H005_B(0x24BD) = 0; /* $24BD: 1 if the event picture/portrait is on screen */
        H005_B(0x24BA) = 0; /* $24BA: 1 if the SPRIT sprite of the event is on screen */
        H005_B(0x24BC) = 1; /* $24BC: 1 if the event picture can be animated (not head+body) */
    }
    H005_B(0x2378) = 0; /* $2378: flag: event sprite already shown (flags[0], 2 bytes with +$2379) */
    H005_B(0x2379) = 0; /* $2379: flag: event portrait already shown (flags[1]) */
}

/* PORT H064+$0C62 (command $0F, INPUT NUMBER). */
void ecl_input_number(void)
{
    u16 dst;                            /* -$6(a5) */

    read_operands(2);
    dst = ADDR(2);
    write_var(dst, input_number(1, "", 0x0A, 0));
}

/* PORT H064+$0CC4 (command $10, INPUT STRING): an empty string becomes " ". */
void ecl_input_string(void)
{
    char buf[0x51];                     /* -$56(a5) */
    u16 dst;                            /* -$4(a5) */

    read_operands(2);
    dst = ADDR(2);
    input_line(1, "", 0x0A, 0, 0x28, 0x50, buf);
    if (buf[0] == '\0') {
        strcpy(buf, " ");
    }
    write_string_var(dst, 0x50, buf);
}

/*
 * PORT H064+$0D4A (commands $11 PRINT and $12 PRINTCLEAR): text (or number)
 * in the text window; $12 starts again from the top and clears it.
 */
void ecl_print(void)
{
    read_operands(1);
    H005_B(0x24B9) = 0; /* $24B9: 0 after ECL text; the command menu clears rows $11..$16 and sets 1 */
    H005_B(0x24CE) = 1; /* $24CE: 1: per-character pause when writing text */
    if (OPD(1) < 0x80) {
        format_number(0xFF, ecl_string(1), (s32)eval_operand(1), 0, 0x0A, 4,
                      ' ');
        trim_leading_spaces(0xFF, ecl_string(1));
    }
    if (H005_B(0x2493) == 0x11) { /* $2493: code of the ECL command being executed */
        word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 0, 0xFF, ecl_string(1));
    } else {
        H005_SET_W(0x334C, 0x11); /* $334C: (word) text cursor: row */
        H005_SET_W(0x334E, 1); /* $334E: (word) text cursor: column */
        word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0xFF, ecl_string(1));
    }
    H005_B(0x24CE) = 0; /* $24CE: 1: per-character pause when writing text */
}

/* PORT H064+$0E40 (command $13, RETURN): returns from GOSUB; without a stack it is EXIT. */
void ecl_return(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    if (g_ecl_stack != NULL) {
        H005_SET_W(0x3DEA, g_ecl_stack->pc); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
        g_ecl_stack_prev = g_ecl_stack->next;
        exec_free_mem(g_ecl_stack, sizeof(CokEclFrame));
        g_ecl_stack = g_ecl_stack_prev;
    } else {
        ecl_exit();
    }
}

/* PORT H064+$0E9C (comando $14, COMPARE AND): (a = b) e (c = d). */
void ecl_compare_and(void)
{
    u16 v[4];                           /* -$8(a5) */
    u16 i;                              /* -$A(a5) */

    /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    read_operands(4);
    for (i = 1; i <= 4; ++i) {
        v[i - 1] = eval_operand(i);
    }
    if (v[0] == v[1] && v[2] == v[3]) {
        H005_B(0x237E) = 1; /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
    } else {
        H005_B(0x237F) = 1; /* $237F: comparison results +1: not equal */
    }
}

/*
 * PORT H064+$0F30 (commands $16..$1B, IF =, <>, <, >, <=, >=): if the
 * result of the last comparison is false it skips the next command.
 */
void ecl_if(void)
{
    u16 i;                              /* -$2(a5) */

    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    for (i = 1; i <= 6; ++i) {
        if (H005_B(0x2493) == i + 0x15) { /* $2493: code of the ECL command being executed */
            /* $237D: use: computed base $237E+i-1 with i>=1; see the results at +$237E */
            if (!H005_B(0x237E + i - 1)) {
                ecl_skip_command();
                return;
            }
        }
    }
}

/*
 * PORT H064+$0F90 (command $20, NEWECL): loads the program of area n
 * (the previous one in $3E04+$1E4) and restarts it from the beginning.
 */
void ecl_new_ecl(void)
{
    u8 n;                               /* -$1(a5) */

    read_operands(1);
    /* $2498: id of the ECL program of the current area ($24 initial, $39 demo); A+$1E4:
     * (word) number of the current ECL area (copy of $2498) */
    COK_PUT16(g_state_a + 0x1E4, H005_B(0x2498));
    n = (u8)eval_operand(1);
    H005_B(0x2498) = n; /* $2498: id of the ECL program of the current area ($24 initial, $39 demo) */
    load_ecl_program(n);
    ecl_start_area();
    H064_B(0x0B) = 1; /* H064_data+$B: end of ECL execution flag (EXIT or NEWECL) */
    H064_B(0x0A) = 1; /* H064_data+$A: NEWECL flag: new program loaded, the entry restarts */
    /* $2378: flag: event sprite already shown (flags[0], 2 bytes with +$2379) */
    h029_fill_bytes(1, &H005_B(0x2378), 2, 0);
}

/*
 * PORT H064+$1004 (commands $21 LOAD FILES and $37 LOAD PIECES): GEO map
 * of the dungeon ($21) or wall definitions of the three sets ($37, $FF none,
 * $7F all removed); if both change in the dungeon the frame
 * is redrawn.
 */
void ecl_load_files(void)
{
    u16 v[3];                           /* -$6(a5)..-$2(a5) */
    u16 i;                              /* -$8(a5) */

    read_operands(3);
    H064_B(8) = 1; /* H064_data+$8: LOAD FILES/PIECES done flag: redraws the view */
    for (i = 1; i <= 3; ++i) {
        v[i - 1] = eval_operand(i);
    }
    if (H005_B(0x2493) == 0x21) { /* $2493: code of the ECL command being executed */
        H064_B(6) = 1; /* H064_data+$6: GEO map loaded flag (LOAD FILES $21) in the program */
        /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        if (v[0] != 0xFF && v[0] != 0x7F && COK_GET16(g_state_a + 0x1CC)) {
            /* A+$18A: (word) id of the loaded GEO map (reloaded on Load) */
            COK_PUT16(g_state_a + 0x18A, v[0]);
            load_geo_map(v[0]);
            /* B+$592: use: if >= $FF the exploration step is cancelled (then 0) */
            COK_PUT16(g_state_b + 0x592, 0);
        }
    } else {
        H064_B(7) = 1; /* H064_data+$7: walls loaded flag (LOAD PIECES $37) in the program */
        if (v[0] == 0x7F) {
            load_wall_defs(0, 1);
        /* A+$1CE: use: with +$1D0 not zero LOAD FILES loads only walls 1 and 3; A+$1D0: use:
         * with +$1CE not zero LOAD FILES loads only walls 1 and 3 */
        } else if (COK_GET16(g_state_a + 0x1CE) && COK_GET16(g_state_a + 0x1D0)) {
            if (v[0] != 0xFF) {
                load_wall_defs(v[0], 1);
            } else {
                /* $2810: tab. of 3 4-byte entries of the wall sets: word WALLDEF id, $FFFF empty */
                H005_SET_W(0x2810, 0xFFFF);
                /* $2812: word +2 of the $2810 entries: position (slot 1..3), $FFFF empty */
                H005_SET_W(0x2812, 0xFFFF);
            }
            if (v[2] != 0xFF && v[2] != 0x7F) {
                load_wall_defs(v[2], 3);
            } else {
                H005_SET_W(0x2818, 0xFFFF); /* $2818: WALLDEF id word of the 3rd entry of $2810 ($FFFF empty) */
                H005_SET_W(0x281A, 0xFFFF); /* $281A: position word of the 3rd entry of $2810 ($FFFF empty) */
            }
        } else {
            for (i = 1; i <= 3; ++i) {
                if (v[i - 1] != 0xFF) {
                    load_wall_defs(v[i - 1], i);
                } else {
                    /* $2810: tab. of 3 4-byte entries of the wall sets: word WALLDEF id, $FFFF empty */
                    H005_SET_W(0x2810 + (i - 1) * 4, 0xFFFF);
                    /* $2812: word +2 of the $2810 entries: position (slot 1..3), $FFFF empty */
                    H005_SET_W(0x2810 + (i - 1) * 4 + 2, 0xFFFF);
                }
            }
        }
    }
    /* H064_data+$7: walls loaded flag (LOAD PIECES $37) in the program; H064_data+$6: GEO map
     * loaded flag (LOAD FILES $21) in the program; $3DE2: previous game context (copy of
     * $3DE3), saved */
    if (H064_B(7) && H064_B(6) && H005_B(0x3DE2) == 3) {
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat); $24B2: 1: exploration
         * frame to be redrawn (after LOAD FILES) */
        if (H005_B(0x3DE3) != 3 && H005_B(0x24B2)) {
            draw_explore_frame();
            draw_party(g_current_char);
            draw_status_line();
        }
        H005_B(0x24B2) = 0; /* $24B2: 1: exploration frame to be redrawn (after LOAD FILES) */
    }
}

/* PORT H064+$121C (commands $2F AND and $30 OR): bitwise, comparison with 0. */
void ecl_and_or(void)
{
    u16 a;                              /* -$6(a5) */
    u16 b;                              /* -$4(a5) */
    u16 dst;                            /* -$2(a5) */
    u16 r;                              /* -$8(a5) */

    read_operands(3);
    a = eval_operand(1);
    b = eval_operand(2);
    dst = ADDR(3);
    if (H005_B(0x2493) == 0x2F) { /* $2493: code of the ECL command being executed */
        r = mask_byte((u8)a, b);
    } else {
        r = or_byte((u8)a, b);
    }
    compare_words(0, r);
    write_var(dst, r);
}

/* PORT H064+$12CA (command $2A, GETTABLE): dst = base[i]. */
void ecl_get_table(void)
{
    u16 base;                           /* -$2(a5) */
    u16 i;                              /* -$A(a5) */
    u16 dst;                            /* -$4(a5) */

    read_operands(3);
    base = ADDR(1);
    i = eval_operand(2);
    dst = ADDR(3);
    write_var(dst, read_var((u16)(base + i)));
}

/* PORT H064+$1346 (command $35, SETTABLE): base[i] = value. */
void ecl_set_table(void)
{
    u16 val;                            /* -$6(a5) */
    u16 base;                           /* -$4(a5) */
    u16 i;                              /* -$2(a5) */

    read_operands(3);
    val = eval_operand(1);
    base = ADDR(2);
    i = eval_operand(3);
    write_var((u16)(base + i), val);
}

/*
 * PORT H064+$13AC (command $15, VERTICAL MENU): text in the window,
 * then a list of n entries (the following operands); the choice goes into the
 * variable of the first operand.
 */
void ecl_vertical_menu(void)
{
    u8 redraw = 1;                      /* -$111(a5) */
    char title[2];                      /* -$10E(a5) */
    u16 k = 1;                          /* -$4(a5) */
    u16 dst;                            /* -$114(a5) */
    char text[0x100];                   /* -$104(a5) */
    u16 n;                              /* -$2(a5) */
    CokMenuItem *list;                  /* -$108(a5) */
    CokMenuItem *head;                  /* -$10C(a5) */
    u16 sel;                            /* -$110(a5) */

    H005_B(0x2483) = 1; /* $2483: index of the selected option in the row menus (persistent) */
    H005_B(0x24B9) = 0; /* $24B9: 0 after ECL text; the command menu clears rows $11..$16 and sets 1 */
    title[0] = '\0';
    title[1] = '\0';
    read_operands(3);
    dst = ADDR(1);
    memcpy(text, ecl_string(1), 0x100);
    n = eval_operand(3);
    H005_SET_W(0x3DEA, H005_W(0x3DEA) - 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    read_operands(n);
    menu_alloc(n, &list);
    head = list;
    H005_SET_W(0x334E, 1); /* $334E: (word) text cursor: column */
    H005_SET_W(0x334C, 0x11); /* $334C: (word) text cursor: row */
    word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0xFF, text);
    while (list != NULL) {
        h026_copy(0x28, list->text, 0xFF, ecl_string(k));
        list->header = 0;
        list = list->next;
        ++k;
    }
    list = head;
    sel = 0;
    (void)ecl_list_menu(1, title, 1, title, 0x0D, 0x0A, 0x0F, 1,
                        /* $334C: (word) text cursor: row */
                        (u16)(H005_W(0x334C) + 1), 0x26, 0x16, list, 0,
                        &redraw, &sel, &list);
    write_var(dst, sel);
    menu_free(&list);
    clear_text_cells(1, 0x11, 0x26, 0x16);
}

/*
 * PORT H064+$1544 (command $2B, HORIZONTAL MENU): options with the
 * '~' shortcuts on the message row; with a single option Enter
 * confirms it (and "PRESS BUTTON OR RETURN..." becomes the
 * keyboard version).  The choice goes into the variable of the first operand.
 */
void ecl_horizontal_menu(void)
{
    char title[2];                      /* -$8(a5) */
    char opts[0x33];                    /* -$3C(a5) */
    u16 dst;                            /* -$3E(a5) */
    u16 n;                              /* -$2(a5) */
    u16 k;                              /* -$6(a5) */
    u8 allow_enter;                     /* -$3F(a5) */
    u8 animate;                         /* -$40(a5) */
    u16 pen3;                           /* -$42(a5) */
    u16 pen2;                           /* -$44(a5) */

    H005_B(0x2483) = 1; /* $2483: index of the selected option in the row menus (persistent) */
    title[0] = '\0';
    title[1] = '\0';
    opts[0] = '\0';
    read_operands(2);
    dst = ADDR(1);
    n = eval_operand(2);
    H005_SET_W(0x3DEA, H005_W(0x3DEA) - 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    read_operands(n);
    opts[0] = '\0';
    if (n == 1) {
        allow_enter = 1;
        pen3 = 0x0F;
        pen2 = 0x0F;
        if (h026_compare_nocase(0xFF, ecl_string(1), 0x23,
                                "PRESS BUTTON OR RETURN TO CONTINUE.") == 1) {
            h026_copy(0xFF, ecl_string(1), 0x22,
                      "PRESS <ENTER>/<RETURN> TO CONTINUE");
        }
    } else {
        allow_enter = 0;
        pen3 = 0x0F;
        pen2 = 0x0A;
    }
    /* $24BD: 1 if the event picture/portrait is on screen; $24BC: 1 if the event picture can be
     * animated (not head+body) */
    animate = (u8)(H005_B(0x24BD) && H005_B(0x24BC));
    for (k = 1; k <= (u16)(n - 1); ++k) {
        h026_append(0x32, opts, 1, "~");
        h026_append(0x32, opts, 0xFF, ecl_string(k));
        h026_append(0x32, opts, 1, " ");
    }
    h026_append(0x32, opts, 1, "~");
    h026_append(0x32, opts, 0xFF, ecl_string(n));
    write_var(dst, ecl_menu(1, title, 0x32, opts, 0x0D, pen2, pen3,
                            allow_enter, animate));
    clear_text_cells(0, 0x18, 0x27, 0x18);
}

/*
 * PORT H064+$1748 (command $1C, CLEAR MONSTERS): no monster loaded,
 * figure slots from 8, treasure ($2A1E..$2A39 and the list $2A3A) empty.
 */
void ecl_clear_monsters(void)
{
    CokItem *next;                      /* -$4(a5) */

    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    H005_B(0x248F) = 0; /* $248F: monsters loaded with +$DF: Turn Undead limit (turn +$13) */
    H064_B(5) = 0; /* H064_data+$5: number of monsters loaded with LOAD MONSTER (max $3F) */
    H005_B(0x24B6) = 0; /* $24B6: 1 if there are monsters loaded (LOAD MONSTER) for COMBAT */
    H005_B(0x248E) = 8; /* $248E: next slot of the CPIC figure set for the monsters (from 8) */
    /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
    h029_fill_bytes(0x1B, &H005_B(0x2A1E), 0x1C, 0);
    while (g_treasure_items != NULL) {
        next = g_treasure_items->next;
        exec_free_mem(g_treasure_items, sizeof(CokItem));
        g_treasure_items = next;
    }
}

/*
 * PORT H064+$17BC (command $1D, PARTY STRENGTH): per character sum of
 * (HP + AC*5 + THAC0*5 + level*8 + level2*4) / 10 (byte, AC beyond
 * $3C and THAC0 beyond $27), into the variable of the operand.
 */
void ecl_party_strength(void)
{
    u8 total = 0;                       /* -$6(a5) */
    Character *p;                       /* -$C(a5) */
    u8 hp;                              /* -$1(a5) */
    u8 ac;                              /* -$5(a5) */
    u8 thac0;                           /* -$2(a5) */
    u8 lvl;                             /* -$3(a5) */
    u8 lvl2;                            /* -$4(a5) */

    read_operands(1);
    for (p = g_party_head; p != NULL; p = p->next) {
        hp = p->b[0x1A8]; /* ch+$1A8: current hit points */
        ac = p->b[0x19C]; /* ch+$19C: encoded current armour class (60 - AC) */
        thac0 = p->b[0x19B]; /* ch+$19B: encoded current THAC0 (60 - THAC0) */
        /* ch+$103: mage level; ch+$10B: previous mage level */
        lvl = (u8)(p->b[0x103] + p->b[0x10B] * h073_130a(p));
        /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; ch+$106: levels of the
         * previous class, 8 entries like +$FE; cleric */
        lvl2 = (u8)(p->b[0xFE] + p->b[0x106] * h073_130a(p));
        ac = (u8)(ac > 0x3C ? ac - 0x3C : 0);
        thac0 = (u8)(thac0 > 0x27 ? thac0 - 0x27 : 0);
        add_to_byte(&total, (u16)((u16)(hp + ac * 5 + thac0 * 5 + lvl * 8 +
                                        lvl2 * 4) / 10));
    }
    write_var(ADDR(1), total);
}
