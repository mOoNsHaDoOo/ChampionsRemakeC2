/* H068: Exploration, movement choices, doors and party actions. */
#include "cok.h"
#include "h068.h"
#include "globals.h"
#include "unported.h"
#include "h008.h"
#include "h011.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h036.h"
#include "h042_seq.h"
#include "h057.h"
#include "h058.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include "h069.h"
#include "h073.h"

#define DX(d) ((s16)H005_W(0x3EE2 + (d) * 2)) /* $3EE2: (word) x offset for direction d (step 2) */
#define DY(d) ((s16)H005_W(0x3ED0 + (d) * 2)) /* $3ED0: (word) y offset for direction d (step 2) */
#define POS_X ((s16)H005_W(0x281C)) /* $281C: (word) party x on the 16x16 area map */
#define POS_Y ((s16)H005_W(0x281E)) /* $281E: (word) party y on the 16x16 area map */
#define POS_DIR H005_B(0x2820) /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */

/* PORT H068+$00A4: link/unlk, no effect. */
void h068_init(void)
{
}

/*
 * PORT H068+$00B2: called when the locked door offers no actions
 * (only " Exit"); in the original the body is empty.
 */
static void locked_no_action(s16 x, s16 y, u8 dir)
{
    (void)x;
    (void)y;
    (void)dir;
}

/*
 * PORT H068+$00CA: opens the door on side dir of the square (x, y): the
 * pair of bits of the side in GEO plane 3 becomes 1.
 */
static void open_door(s16 x, s16 y, u8 dir)
{
    u8 *b;

    if (x < 0 || x > 0x0F || y < 0 || y > 0x0F) {
        return;
    }
    b = &g_geo_planes[0x300 + y * 16 + x];
    switch (dir) {
    case 0: *b = or_byte(mask_byte(*b, 0xFC), 0x01); break;
    case 2: *b = or_byte(mask_byte(*b, 0xF3), 0x04); break;
    case 4: *b = or_byte(mask_byte(*b, 0xCF), 0x10); break;
    case 6: *b = or_byte(mask_byte(*b, 0x3F), 0x40); break;
    default: break;
    }
}

/* Opens the door in front of the party from both sides. */
static void open_door_ahead(void)
{
    /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the 16x16 area map;
     * $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    open_door(POS_X, POS_Y, POS_DIR);
    /* $281C: (word) party x on the 16x16 area map; $3EE2: (word) x offset for direction d (step 2);
     * $2820: party direction (0 north, 2 east, 4 south, 6 west); $281E: (word) party y on the
     * 16x16 area map; $3ED0: (word) y offset for direction d (step 2) */
    open_door((s16)(POS_X + DX(POS_DIR)), (s16)(POS_Y + DY(POS_DIR)),
              (u8)((POS_DIR + 4) & 7)); /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
}

/*
 * PORT H068+$02B8: does someone in the party have levels in class cls (+$FE)
 * or, from the previous class (+$106), can use it (H073+$130A)?
 */
static u8 party_has_class(u8 cls)
{
    u8 found = 0;                       /* -$5(a5) */
    Character *p;                       /* -$4(a5) */

    for (p = g_party_head; p != NULL && !found; p = p->next) {
        /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        if (p->b[0xFE + cls] > 0) {
            found = 1;
        /* ch+$106: levels of the previous class, 8 entries like +$FE; cleric */
        } else if (p->b[0x106 + cls] > 0 && h073_130a(p)) {
            found = 1;
        }
    }
    return found;
}

/*
 * PORT H068+$0340 (Bash): every character tries to break the door
 * according to strength (+$11, exceptional +$1C); doors of type 3 only with
 * strength 18 and above, otherwise the option disappears ($24E4).
 */
static u8 bash_door(void)
{
    u8 ok = 0;                          /* -$5(a5) */
    Character *p;                       /* -$4(a5) */

    for (p = g_party_head; p != NULL && !ok; p = p->next) {
        /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the
         * 16x16 area map; $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        if (map_door(POS_X, POS_Y, POS_DIR) == 3) {
            /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
            switch (p->b[0x11]) {
            case 0x12:
                if (p->b[0x1C] < 0x5B) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
                    H005_B(0x24E4) = 0; /* $24E4: Bash option available in front of the locked door */
                } else if (p->b[0x1C] < 0x64) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
                    if (roll_dice(1, 6) == 1) ok = 1;
                } else {
                    if (roll_dice(1, 6) <= 2) ok = 1;
                }
                break;
            case 0x13: case 0x14:
                if (roll_dice(1, 6) <= 3) ok = 1;
                break;
            case 0x15: case 0x16:
                if (roll_dice(1, 6) <= 4) ok = 1;
                break;
            case 0x17:
                if (roll_dice(1, 6) <= 5) ok = 1;
                break;
            case 0x18:
                if (roll_dice(1, 8) <= 7) ok = 1;
                break;
            case 0x19:
                ok = 1;
                break;
            default:
                H005_B(0x24E4) = 0; /* $24E4: Bash option available in front of the locked door */
                break;
            }
        } else {
            /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
            switch (p->b[0x11]) {
            case 3: case 4: case 5: case 6: case 7:
                if (roll_dice(1, 6) == 1) ok = 1;
                break;
            case 8: case 9: case 0x0A: case 0x0B: case 0x0C: case 0x0D:
            case 0x0E: case 0x0F:
                if (roll_dice(1, 6) <= 2) ok = 1;
                break;
            case 0x10: case 0x11:
                if (roll_dice(1, 6) <= 3) ok = 1;
                break;
            case 0x12:
                if (p->b[0x1C] < 0x33) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
                    if (roll_dice(1, 6) <= 3) ok = 1;
                } else if (p->b[0x1C] < 0x64) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
                    if (roll_dice(1, 6) <= 4) ok = 1;
                } else {
                    if (roll_dice(1, 6) <= 5) ok = 1;
                }
                break;
            case 0x13: case 0x14:
                if (roll_dice(1, 8) <= 7) ok = 1;
                break;
            case 0x15:
                if (roll_dice(1, 0x0A) <= 9) ok = 1;
                break;
            case 0x16: case 0x17:
                if (roll_dice(1, 0x0C) <= 0x0B) ok = 1;
                break;
            case 0x18:
                if (roll_dice(1, 0x14) <= 0x13) ok = 1;
                break;
            case 0x19:
                ok = 1;
                break;
            default:
                break;
            }
        }
    }
    if (ok) {
        open_door_ahead();
    }
    return ok;
}

/*
 * PORT H068+$0748 (Pick): whoever rolls 1d100 <= +$E1 (open locks) and
 * has no +$197 succeeds; the option disappears anyway ($24E5).
 */
static u8 pick_lock(void)
{
    u8 ok = 0;                          /* -$5(a5) */
    Character *p;                       /* -$4(a5) */

    for (p = g_party_head; p != NULL && !ok; p = p->next) {
        /* ch+$E1: thief skill 2: open locks (Pick, 1d100 <= value); ch+$197: status: 0 ok, 4
         * unconscious, 5 dying, 6-8 dead, $0A down */
        if (roll_dice(1, 0x64) <= p->b[0xE1] && !p->b[0x197]) {
            ok = 1;
        }
    }
    H005_B(0x24E5) = 0; /* $24E5: Pick option available in front of the locked door */
    if (ok) {
        open_door_ahead();
    }
    return ok;
}

/* PORT H068+$082A: position of spell s among the memorised ones of c, $FF if missing. */
static u8 memorized_spell_index(u8 spell, Character *c)
{
    u16 k = 0;                          /* -$2(a5) */

    /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
    while (k <= 0x39 && c->b[0x1E + k] != spell) {
        ++k;
    }
    if (k <= 0x39) {
        return (u8)k;
    }
    return 0xFF;
}

/* PORT H068+$0890: the first character that has memorised the spell. */
static Character *who_has_spell(u8 spell)
{
    Character *p;                       /* -$4(a5) */

    p = g_party_head;
    while (p != NULL && memorized_spell_index(spell, p) == 0xFF) {
        p = p->next;
    }
    return p;
}

/*
 * PORT H068+$08E2 (Knock): uses up spell $1F of the first one that has
 * memorised it.  In the original the door is not opened here.
 */
static u8 cast_knock(void)
{
    Character *p;                       /* -$4(a5) */

    p = who_has_spell(0x1F);
    if (p != NULL) {
        /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
        p->b[0x1E + memorized_spell_index(0x1F, p)] = 0;
        return 1;
    }
    return 0;
}

/*
 * PORT H068+$0932: if there is no wall in front and the step would leave the
 * 16x16 map, the position is held at the edge and $3E00+$5AA = 1
 * (exit from the area).
 */
static void check_area_edge(void)
{
    /* $281C: (word) party x on the 16x16 area map */
    s16 x = POS_X;                      /* -$2(a5) */
    /* $281E: (word) party y on the 16x16 area map */
    s16 y = POS_Y;                      /* -$4(a5) */
    /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    u16 dir = POS_DIR;                  /* -$6(a5) */

    /* B+$5AA: (word) 1 if the step leaves the 16x16 map (exit from the area) */
    COK_PUT16(g_state_b + 0x5AA, 0);
    if (map_door(x, y, dir) == 0) {
        return;
    }
    x = (s16)(x + DX(dir)); /* $3EE2: (word) x offset for direction d (step 2) */
    y = (s16)(y + DY(dir)); /* $3ED0: (word) y offset for direction d (step 2) */
    if (x > 0x0F) {
        H005_SET_W(0x281C, 0x0F); /* $281C: (word) party x on the 16x16 area map */
        /* B+$5AA: (word) 1 if the step leaves the 16x16 map (exit from the area) */
        COK_PUT16(g_state_b + 0x5AA, 1);
    }
    if (x < 0) {
        H005_SET_W(0x281C, 0); /* $281C: (word) party x on the 16x16 area map */
        /* B+$5AA: (word) 1 if the step leaves the 16x16 map (exit from the area) */
        COK_PUT16(g_state_b + 0x5AA, 1);
    }
    if (y > 0x0F) {
        H005_SET_W(0x281E, 0x0F); /* $281E: (word) party y on the 16x16 area map */
        /* B+$5AA: (word) 1 if the step leaves the 16x16 map (exit from the area) */
        COK_PUT16(g_state_b + 0x5AA, 1);
    }
    if (y < 0) {
        H005_SET_W(0x281E, 0); /* $281E: (word) party y on the 16x16 area map */
        /* B+$5AA: (word) 1 if the step leaves the 16x16 map (exit from the area) */
        COK_PUT16(g_state_b + 0x5AA, 1);
    }
}

/*
 * PORT H068+$0A1A: one step forward in the dungeon (the map wraps),
 * wall and flags of the new square, door options restored and
 * one turn (or 2 when searching).
 */
static void explore_step(void)
{
    s16 x;
    s16 y;

    h043_190e(0x11);
    dos_delay(2);
    /* $281C: (word) party x on the 16x16 area map; $3EE2: (word) x offset for direction d
     * (step 2); $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    x = (s16)(POS_X + DX(POS_DIR));
    /* $281E: (word) party y on the 16x16 area map; $3ED0: (word) y offset for direction d
     * (step 2); $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    y = (s16)(POS_Y + DY(POS_DIR));
    if (x < 0) x = 0x0F;
    if (x > 0x0F) x = 0;
    if (y < 0) y = 0x0F;
    if (y > 0x0F) y = 0;
    H005_SET_W(0x281C, (u16)x); /* $281C: (word) party x on the 16x16 area map */
    H005_SET_W(0x281E, (u16)y); /* $281E: (word) party y on the 16x16 area map */
    /* $2821: wall in front of the party (map_wall on the square and direction); $2820: party
     * direction (0 north, 2 east, 4 south, 6 west) */
    H005_B(0x2821) = (u8)map_wall(x, y, POS_DIR);
    h029_fill_bytes(2, &H005_B(0x24E4), 3, 1); /* $24E4: Bash option available in front of the locked door */
    /* $2822: flags of the party square (map_flags); bit 7 picks the sky */
    H005_B(0x2822) = map_flags(x, y);
    /* B+$594: (word) bit 0 search mode, bit 1 Look in progress */
    if (mask_byte((u8)COK_GET16(g_state_b + 0x594), 1) > 0) {
        advance_time(1, 2);
    } else {
        advance_time(1, 1);
    }
}

/*
 * PORT H068+$0B2C: one step on the outdoor map (38x15 squares, without
 * wrapping): restores the background under the party marker, moves and
 * redraws the marker, then advance_time($C, 3).
 */
static void wild_step(void)
{
    s16 x;                              /* -$4(a5) */
    s16 y;                              /* -$6(a5) */

    h069_restore_marker();
    /* A+$186: (word) party x on the outdoor map (38x15); A+$1E0: (word) party x before the step
     * (to detect the movement) */
    COK_PUT16(g_state_a + 0x1E0, COK_GET16(g_state_a + 0x186));
    /* A+$188: (word) party y on the outdoor map (38x15); A+$1E2: (word) party y before the step
     * (to detect the movement) */
    COK_PUT16(g_state_a + 0x1E2, COK_GET16(g_state_a + 0x188));
    /* A+$186: (word) party x on the outdoor map (38x15); $3EE2: (word) x offset for direction d
     * (step 2); $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    x = (s16)((s16)COK_GET16(g_state_a + 0x186) + DX(POS_DIR));
    /* A+$188: (word) party y on the outdoor map (38x15); $3ED0: (word) y offset for direction d
     * (step 2); $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    y = (s16)((s16)COK_GET16(g_state_a + 0x188) + DY(POS_DIR));
    if (x < 0) x = 0;
    if (x > 0x25) x = 0x25;
    if (y < 0) y = 0;
    if (y > 0x0E) y = 0x0E;
    COK_PUT16(g_state_a + 0x186, (u16)x); /* A+$186: (word) party x on the outdoor map (38x15) */
    COK_PUT16(g_state_a + 0x188, (u16)y); /* A+$188: (word) party y on the outdoor map (38x15) */
    h069_draw_marker();
    advance_time(0x0C, 3);
}

/* Menu entries in the dungeon (H068+$0C2E). */
static void dungeon_menu(u8 *key, u8 *done, u8 *special)
{
    u8 redraw;                          /* -$2(a5) */
    Character *c;

    *done = 0;
    *key = 0;
    if (!H005_B(0x24B0)) { /* $24B0: Move mode of the exploration: click on the view as movement */
        *key = ui_request_choice(0, "", 0x26,
                                 "Move Area Cast View Encamp Search Look",
                                 0x0D, 0x0A, 0x0F, 1, 0, special);
        if (*special) {
            select_party_member(*key);
            draw_party(g_current_char);
            draw_status_line();
            return;
        }
        switch (*key) {
        case 'A':
            /* A+$1F6: (word) area without a map: coordinates hidden, map "Not Here" */
            if (COK_GET16(g_state_a + 0x1F6) == 0 ||
                (g_argc > 2 &&
                 h026_compare_nocase(0xFF, g_argv[2], 0x14,
                                     /* $2358: cheat password (string compared with argv[2]) */
                                     (const char *)&g_h005[0x2358]) == 1)) {
                /* $2825: top-down map flag, active instead of the 3D view */
                H005_B(0x2825) = (u8)(H005_B(0x2825) == 0);
                /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the 16x16 area map; $2820:
                 * party direction (0 north, 2 east, 4 south, 6 west) */
                draw_3d_view(POS_X, POS_Y, POS_DIR);
            } else {
                show_message(8, "Not Here", 0x0E, 0);
            }
            break;
        case 'C':
            c = g_current_char;
            if (!c->b[0x197]) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                H005_B(0x2483) = 1; /* $2483: index of the selected option in the row menus (persistent) */
                cast_spells();
            }
            break;
        case 'E':
            *done = 1;
            H005_B(0x2483) = 1; /* $2483: index of the selected option in the row menus (persistent) */
            break;
        case 'L':
            COK_PUT16(g_state_b + 0x594, /* B+$594: (word) bit 0 search mode, bit 1 Look in progress */
                      or_byte((u8)COK_GET16(g_state_b + 0x594), 2));
            draw_status_line();
            advance_time(1, 2);
            /* $3DF2: (word) ECL entry after $3DF4; PC brought back here by the outdoor step;
             * $3DEA: (word) logical PC of the ECL program (base $3500) */
            H005_SET_W(0x3DEA, H005_W(0x3DF2));
            *done = 1;
            break;
        case 'M':
            clear_message_line();
            H005_B(0x24B0) = 1; /* $24B0: Move mode of the exploration: click on the view as movement */
            break;
        case 'S':
            COK_PUT16(g_state_b + 0x594, /* B+$594: (word) bit 0 search mode, bit 1 Look in progress */
                      xor_byte((u8)COK_GET16(g_state_b + 0x594), 1));
            draw_status_line();
            break;
        case 'V':
            H005_B(0x2483) = 1; /* $2483: index of the selected option in the row menus (persistent) */
            view_character(&redraw);
            break;
        default:
            break;
        }
        return;
    }
    *key = ui_request_choice(0, "", 4, "Exit", 0x0D, 0x0A, 0x0F, 1, 0,
                             special);
    if (!*special) {
        if (*key == 'E') {
            H005_B(0x24B0) = 0; /* $24B0: Move mode of the exploration: click on the view as movement */
        }
        return;
    }
    switch (*key) {
    case 0x48:                          /* up arrow */
        check_area_edge();
        *done = 1;
        draw_status_line();
        *key = 0;
        break;
    case 0x50:                          /* down arrow: about-turn */
        POS_DIR = (u8)((POS_DIR + 4) & 7); /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        /* $2821: wall in front of the party (map_wall on the square and direction); $281C: (word) party x
         * on the 16x16 area map; $281E: (word) party y on the 16x16 area map; $2820: party
         * direction (0 north, 2 east, 4 south, 6 west) */
        H005_B(0x2821) = (u8)map_wall(POS_X, POS_Y, POS_DIR);
        /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the
         * 16x16 area map; $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        draw_3d_view(POS_X, POS_Y, POS_DIR);
        draw_status_line();
        *key = 0;
        break;
    case 0x4B:                          /* left arrow */
        POS_DIR = (u8)((POS_DIR + 6) & 7); /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        h043_190e(0x11);
        /* $2821: wall in front of the party (map_wall on the square and direction); $281C: (word) party x
         * on the 16x16 area map; $281E: (word) party y on the 16x16 area map; $2820: party
         * direction (0 north, 2 east, 4 south, 6 west) */
        H005_B(0x2821) = (u8)map_wall(POS_X, POS_Y, POS_DIR);
        /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the
         * 16x16 area map; $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        draw_3d_view(POS_X, POS_Y, POS_DIR);
        draw_status_line();
        *key = 0;
        break;
    case 0x4D:                          /* right arrow */
        POS_DIR = (u8)((POS_DIR + 2) & 7); /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        h043_190e(0x11);
        /* $2821: wall in front of the party (map_wall on the square and direction); $281C: (word) party x
         * on the 16x16 area map; $281E: (word) party y on the 16x16 area map; $2820: party
         * direction (0 north, 2 east, 4 south, 6 west) */
        H005_B(0x2821) = (u8)map_wall(POS_X, POS_Y, POS_DIR);
        /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the
         * 16x16 area map; $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        draw_3d_view(POS_X, POS_Y, POS_DIR);
        draw_status_line();
        *key = 0;
        break;
    default:
        break;
    }
}

/* Menu entries outdoors (H068+$1036); returns 0 if there is no menu. */
static u8 wild_menu(u8 *key, u8 *done, u8 *special)
{
    if (COK_GET16(g_state_a + 0x3EE) == 0) { /* A+$3EE: (word) if zero no command menu outdoors */
        return 0;
    }
    *done = 0;
    if (!H005_B(0x24B0)) { /* $24B0: Move mode of the exploration: click on the view as movement */
        *key = ui_request_choice(0, "", 0x0B, "Move Encamp", 0x0D, 0x0A,
                                 0x0F, 1, 0, special);
        if (!*special) {
            if (*key == 'E') {
                *done = 1;
                H005_B(0x2483) = 1; /* $2483: index of the selected option in the row menus (persistent) */
            } else if (*key == 'M') {
                clear_message_line();
                H005_B(0x24B0) = 1; /* $24B0: Move mode of the exploration: click on the view as movement */
            }
        }
        return 1;
    }
    *key = 0;
    if (*key == 0) {
        *key = ui_request_choice(0, "", 4, "Exit", 0x0D, 0x0A, 0x0F, 1, 0,
                                 special);
    }
    if (!*special) {
        if (*key == 'E') {
            H005_B(0x24B0) = 0; /* $24B0: Move mode of the exploration: click on the view as movement */
        }
        return 1;
    }
    *done = 1;
    switch (*key) {                     /* keypad: 8 directions */
    case 0x48: POS_DIR = 0; break; /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    case 0x49: POS_DIR = 1; break; /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    case 0x4D: POS_DIR = 2; break; /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    case 0x51: POS_DIR = 3; break; /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    case 0x50: POS_DIR = 4; break; /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    case 0x4F: POS_DIR = 5; break; /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    case 0x4B: POS_DIR = 6; break; /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    case 0x47: POS_DIR = 7; break; /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    default: break;
    }
    draw_status_line();
    return 1;
}

/*
 * PORT H068+$0C0E (Exploration_CommandMenu): the command menu of the
 * exploration, in the dungeon (context 4) or outdoors (3), repeated
 * until a command ends the turn; returns the key.
 * Outdoors without a menu ($3E04+$3EE zero) the original returns an
 * uninitialised byte: here 0.
 */
u8 explore_command_menu(void)
{
    u8 key = 0;                         /* -$1(a5) */
    u8 done = 0;                        /* -$3(a5) */
    u8 special = 0;                     /* -$4(a5) */

    /* B+$592: use: if >= $FF the exploration step is cancelled (then 0) */
    COK_PUT16(g_state_b + 0x592, 0);
    switch (H005_B(0x3DE3)) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    case 3:
        do {
            if (!wild_menu(&key, &done, &special)) {
                break;
            }
        } while (!done);
        break;
    case 4:
        do {
            dungeon_menu(&key, &done, &special);
        } while (!done);
        break;
    default:
        break;
    }
    if (!H005_B(0x24B9)) { /* $24B9: 0 after ECL text; the command menu clears rows $11..$16 and sets 1 */
        clear_text_cells(1, 0x11, 0x26, 0x16);
        H005_B(0x24B9) = 1; /* $24B9: 0 after ECL text; the command menu clears rows $11..$16 and sets 1 */
    }
    return key;
}

/*
 * Locked door in front (H068+$128C for type 2, $1428 for type 3):
 * "Locked." with Bash, Pick (a thief), Knock (spell $1F) and Exit.
 * For type 3 Pick only removes the option.
 */
static u8 locked_door_menu(u8 wizard)
{
    char text[0x29];                    /* -$2C(a5) */
    u8 special;                         /* -$2(a5) */
    u8 choice;                          /* -$2D(a5) */
    u8 moved = 0;

    text[0] = '\0';
    if (H005_B(0x24E4)) { /* $24E4: Bash option available in front of the locked door */
        strcpy(text, "Bash");
    }
    /* $24E5: Pick option available in front of the locked door */
    if (H005_B(0x24E5) && party_has_class(6)) {
        h026_append(0x28, text, 5, " Pick");
    }
    /* $24E6: Knock option available in front of the locked door */
    if (H005_B(0x24E6) && who_has_spell(0x1F) != NULL) {
        h026_append(0x28, text, 6, " Knock");
    }
    h026_append(0x28, text, 5, " Exit");
    if (h026_compare_nocase(0x28, text, 5, " Exit") == 1) {
        /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the
         * 16x16 area map; $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        locked_no_action(POS_X, POS_Y, POS_DIR);
        return 0;
    }
    choice = ui_request_choice(8, "Locked. ", 0x28, text, 0x0D, 0x0A, 0x0F,
                               0, 0, &special);
    switch (choice) {
    case 'B':
        moved = bash_door();
        break;
    case 'K':
        moved = cast_knock();
        break;
    case 'P':
        if (wizard) {
            H005_B(0x24E5) = 0; /* $24E5: Pick option available in front of the locked door */
        } else {
            moved = pick_lock();
        }
        break;
    default:
        break;
    }
    return moved;
}

/*
 * PORT H068+$122E (Exploration_MoveOrDoor): performs the chosen step: in the
 * dungeon according to the door in front (1 free passage, 2 and 3 locked),
 * outdoors on the big map; with $3E00+$592 >= $FF the step is
 * cancelled.  Then frees the event pictures.
 */
void explore_move_or_door(void)
{
    u8 moved = 0;                       /* -$1(a5) */

    switch (H005_B(0x3DE3)) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    case 3:
        /* B+$592: use: if >= $FF the exploration step is cancelled (then 0) */
        if (COK_GET16(g_state_b + 0x592) < 0xFF) {
            wild_step();
            draw_status_line();
        } else {
            /* B+$592: use: if >= $FF the exploration step is cancelled (then 0) */
            COK_PUT16(g_state_b + 0x592, 0);
        }
        break;
    case 4:
        /* B+$592: use: if >= $FF the exploration step is cancelled (then 0) */
        if (COK_GET16(g_state_b + 0x592) < 0xFF) {
            H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
            /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the 16x16 area map;
             * $2820: party direction (0 north, 2 east, 4 south, 6 west) */
            switch (map_door(POS_X, POS_Y, POS_DIR)) {
            case 1: moved = 1; break;
            case 2: moved = locked_door_menu(0); break;
            case 3: moved = locked_door_menu(1); break;
            default: break;
            }
            if (moved) {
                explore_step();
            }
            draw_status_line();
        } else {
            /* B+$592: use: if >= $FF the exploration step is cancelled (then 0) */
            COK_PUT16(g_state_b + 0x592, 0);
        }
        break;
    default:
        break;
    }
    release_picture_set();
    free_gfx_record(&g_gfx_27b0[0]);
    free_gfx_record(&g_gfx_27b0[1]);
    H005_B(0x27B0) = 0xFF; /* $27B0: 2 entries of 6 bytes (id + long gfx at +2): loaded HEAD id, $FF none */
    H005_B(0x27B6) = 0xFF; /* $27B6: id of the loaded BODY (2nd 6-byte entry of $27B0), $FF none */
}
