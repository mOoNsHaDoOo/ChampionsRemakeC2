/* H013: Character creation/management and the party main menu. */
#include "h013.h"
#include "h008.h"
#include "h026_string.h"
#include "h044_tiles.h"
#include "globals.h"
#include "h010_input.h"
#include "unported.h"
#include "character.h"
#include "h003_exec.h"
#include "h023_shared.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h045.h"
#include "h053.h"
#include "h062.h"
#include "h073.h"
#include "h065.h"
#include "h028_files.h"
#include "h047.h"
#include "h066.h"
#include "h063.h"

/* PORT H013+$0506: link/unlk, no effect. */
void h013_init(void)
{
}

/* H013 -$52(a4): "Free training" message. */
static char s_message[0x52];

/* Entry of the main menu table (-$23A(a5), step $2C). */
typedef struct MainMenuEntry {
    char text[0x2A];
    u8 enabled;                 /* +$2A */
    u8 pad;
} MainMenuEntry;

enum {
    MM_CREATE, MM_DROP, MM_MODIFY, MM_TRAIN, MM_KNIGHT, MM_VIEW, MM_ADD,
    MM_REMOVE, MM_LOAD, MM_SAVE, MM_BEGIN, MM_EXIT, MM_COUNT
};

/* Copy with dbeq $28: at most 41 bytes, NUL included. */
static void copy_entry(MainMenuEntry *e, const char *text)
{
    unsigned i;

    for (i = 0; i <= 0x28; ++i) {
        e->text[i] = text[i];
        if (text[i] == 0) {
            break;
        }
    }
}

/* PORT H013+$4C0A: texts of the main menu and entries always present. */
static void init_main_menu(MainMenuEntry *items, char *keys)
{
    unsigned i;
    const char *letters = "C D M T K V A R L S B E J";

    for (i = 0; i <= 0x28; ++i) {
        keys[i] = letters[i];
        if (letters[i] == 0) {
            break;
        }
    }
    copy_entry(&items[MM_CREATE], "Create New Character");
    items[MM_CREATE].enabled = 1;
    copy_entry(&items[MM_DROP], "Drop Character");
    items[MM_DROP].enabled = 0;
    copy_entry(&items[MM_MODIFY], "Modify Character");
    items[MM_MODIFY].enabled = 0;
    copy_entry(&items[MM_TRAIN], "Train Character");
    items[MM_TRAIN].enabled = 0;
    copy_entry(&items[MM_KNIGHT], "Knight Change Classes");
    items[MM_KNIGHT].enabled = 0;
    copy_entry(&items[MM_VIEW], "View Character");
    items[MM_VIEW].enabled = 0;
    copy_entry(&items[MM_ADD], "Add Character to Party");
    items[MM_ADD].enabled = 1;
    copy_entry(&items[MM_REMOVE], "Remove Character from Party");
    items[MM_REMOVE].enabled = 0;
    copy_entry(&items[MM_LOAD], "Load Saved Game");
    items[MM_LOAD].enabled = 1;
    copy_entry(&items[MM_SAVE], "Save Current Game");
    items[MM_SAVE].enabled = 0;
    copy_entry(&items[MM_BEGIN], "BEGIN Adventuring");
    items[MM_BEGIN].enabled = 0;
    copy_entry(&items[MM_EXIT], "Exit to Workbench");
    items[MM_EXIT].enabled = 1;
}

/*
 * PORT H013+$4BFC: party main menu.  At every round it redraws the
 * frame and the current character, enables the entries according to party and
 * character, shows the menu (H008+$13C0) and runs the chosen function
 * (the initial letter of the entry).  It exits with "BEGIN Adventuring" (or with
 * the removal of the last character without a loaded party).
 */
static void copy_text(char *dst, const char *src, u16 max);
static s16 con_hp_bonus(Character *c, u8 cls);

/*
 * PORT H013+$2D76: hit point adjustment for constitution
 * (+$19): 3 -2, 4-6 -1, 7-14 0, 15 +1, 16 +2, 17-19 +2 (classes 2, 4, 7:
 * CON - 14).  For a constitution outside 3..19 the original returns
 * the uninitialised word of the frame; here 0.
 */
static s16 con_hp_adjust(u8 cls)
{
    s16 result = 0;                     /* -$2(a5) */
    u8 con = g_current_char->b[0x19]; /* ch+$19: current constitution */

    if (con == 3) {
        result = -2;
    } else if (con >= 4 && con <= 6) {
        result = -1;
    } else if (con >= 7 && con <= 14) {
        result = 0;
    } else if (con == 15) {
        result = 1;
    } else if (con == 16) {
        result = 2;
    } else if (con >= 17 && con <= 19) {
        if (cls == 2 || cls == 4 || cls == 7) {
            result = (s16)(con - 14);
        } else {
            result = 2;
        }
    }
    return result;
}

/*
 * PORT H013+$2E44: maximum possible hit points of c (average over the
 * classes of the character).
 */
static s16 max_hit_points(Character *c)
{
    s16 count = 0;                      /* -$2(a5) */
    s16 sum = 0;                        /* -$4(a5) */
    s16 adj;                            /* -$6(a5) */
    s16 extra;                          /* -$a(a5) */
    u8 k;                               /* -$7(a5) */
    u8 lvl;

    for (k = 0; k <= 7; ++k) {
        lvl = c->b[0xFE + k]; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        if (lvl == 0) {
            continue;
        }
        adj = con_hp_adjust(k);
        if (lvl < H005_B(0x5026 + k)) { /* $5026: maximum hit dice level per class (byte, 0..7) */
            ++count;
            switch (k) {
            case 0:
                /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
                if (c->b[0x5E] <= 4) {
                    sum = (s16)(sum + (adj + 8) * (lvl + 1));
                } else {
                    sum = (s16)(sum + (adj + 8) * lvl);
                }
                break;
            case 1:
                sum = (s16)(sum + (adj + 8) * lvl);
                break;
            case 2:
            case 3:
                sum = (s16)(sum + (adj + 10) * lvl);
                break;
            case 4:
                sum = (s16)(sum + (adj + 8) * (lvl + 1));
                break;
            case 5:
                sum = (s16)(sum + (adj + 4) * lvl);
                break;
            case 6:
                sum = (s16)(sum + (adj + 6) * lvl);
                break;
            case 7:
                sum = (s16)(sum + (adj + 10) * (lvl + 1));
                break;
            }
        } else {
            ++count;
            /* $5026: maximum hit dice level per class (byte, 0..7) */
            extra = (s16)(lvl - H005_B(0x5026 + k) + 1);
            switch (k) {
            case 0:
                sum = (s16)(extra * 2 + 0x48);
                break;
            case 1:
                sum = 0x70;
                break;
            case 2:
            case 3:
            case 7:
                sum = (s16)(extra * 3 + 0x5A);
                break;
            case 4:
                sum = (s16)(extra * 2 + 0x58);
                break;
            case 5:
                sum = (s16)(extra + 0x2C);
                break;
            case 6:
                sum = (s16)(extra * 2 + 0x3C);
                break;
            }
        }
    }
    return (s16)(sum / count);
}

/*
 * PORT H013+$30DA: minimum hit points of c: sum of the levels (+1 for
 * classes 4 and 7) plus the constitution bonus, divided by the number of classes.
 */
static s16 min_hit_points(Character *c)
{
    s16 count = 0;                      /* -$2(a5) */
    s16 bonus;                          /* -$4(a5) */
    s16 sum = 0;                        /* -$6(a5) */
    u8 k;                               /* -$7(a5) */

    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] > 0) { /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            sum = (s16)(sum + c->b[0xFE + k]);
            ++count;
            if (k == 4 || k == 7) {
                ++sum;
            }
        }
    }
    bonus = con_hp_bonus(c, k);         /* k = 8 at the end of the loop */
    if (bonus < 0) {
        if (sum > (s16)((bonus < 0 ? -bonus : bonus) + count)) {
            sum = (s16)((sum + bonus) / count);
        } else {
            sum = 1;
        }
    } else {
        sum = (s16)((sum + bonus) / count);
    }
    return sum;
}

/* Frame of Modify Character (H013+$31E0) for the nested procedure. */
typedef struct ModifyFrame {
    u16 field;                          /* -$40(a5): 0-5 ability, 6 name, 7 HP */
    u16 cursor;                         /* -$4c(a5): position in the name */
    char cell[2];                       /* -$4a(a5): character under the cursor */
} ModifyFrame;

/* $226C: ability limits per race ($20 bytes, min/max words); off = entry */
#define RACE_W(off)  H005_W(0x226C + c->b[0x5B] * 32 + (off))
/* $226C: limits per race like RACE_W, strength entry chosen by sex (pg+$10E) */
#define RACE_SW(off) H005_W(0x226C + c->b[0x5B] * 32 + c->b[0x10E] * 2 + (off))
/* $1F9A: ability minimums per class (12 bytes, 6 words); off = entry */
#define CLASS_W(off) H005_W(0x1F9A + c->b[0x5C] * 12 + (off))

/* PORT H013+$31EE: draws the field f->field (highlighted or not). */
static void modify_draw_field(ModifyFrame *f, u8 highlight)
{
    Character *c = g_current_char;

    switch (f->field) {
    case 0: case 1: case 2: case 3: case 4: case 5:
        draw_stat_value((u8)f->field, highlight);
        break;
    case 7:
        draw_hit_points(c, 0x1F, 3, highlight, 0);
        break;
    case 6:
        if (highlight) {
            fill_text_cells((u16)(h026_strlen(0x0F, (const char *)c->b) + 1),
                            1, 0, 1);
            ui_draw_text(1, 1, 0x0D, 0, 0x0F, (const char *)c->b);
            if (c->b[f->cursor] == ' ') {
                ui_draw_text((u16)(f->cursor + 1), 1, 0x0F, 0, 1, "_");
            } else {
                f->cell[1] = 0;
                f->cell[0] = (char)c->b[f->cursor];
                ui_draw_text((u16)(f->cursor + 1), 1, 0x0F, 0, 1, f->cell);
            }
        } else {
            ui_draw_text(1, 1, 0x0A, 0, 0x0F, (const char *)c->b);
        }
        break;
    default:
        break;
    }
}

/* Brings abilities, hit points and name back to the saved values. */
static void modify_restore(Character *c, const u16 *stats, u16 ext_str,
                           u16 hp, const char *name, u8 hp_first)
{
    u8 i;

    for (i = 0; i <= 5; ++i) {
        /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
        g_current_char->b[0x11 + i * 2] = (u8)stats[i];
    }
    g_current_char->b[0x1C] = (u8)ext_str; /* ch+$1C: current exceptional strength (18/xx, 1..100) */
    g_current_char->b[0x64] = (u8)hp; /* ch+$64: maximum hit points */
    if (hp_first) {
        /* ch+$1A8: current hit points; ch+$64: maximum hit points */
        g_current_char->b[0x1A8] = c->b[0x64];
    }
    h026_copy(0x0F, (char *)g_current_char->b, 0x28, name);
    if (!hp_first) {
        /* ch+$1A8: current hit points; ch+$64: maximum hit points */
        g_current_char->b[0x1A8] = c->b[0x64];
    }
    recompute_stats(g_current_char);
    H005_B(0x24DA) = 0; /* $24DA: 1 in Modify Character: the click chooses the field ($2506) */
}

/*
 * PORT H013+$31E0: Modify Character.  Only for newly created characters
 * (initial experience, +$DC = 0).  With Add/Subtract one changes the
 * abilities (within the limits of race and class), the hit points
 * (within $30DA..$2E44) and the name; Keep confirms, Exit or Esc restore.
 */
static void modify_character(void)
{
    ModifyFrame f;
    Character *c;                       /* a3 */
    u16 saved_stats[6];                 /* -$c(a5) */
    u16 saved_ext;                      /* -$e(a5) */
    u16 saved_hp;                       /* -$10(a5), then sum */
    s16 sum;                            /* -$10(a5) */
    s16 count;                          /* -$4e(a5) */
    char saved_name[0x2A];              /* -$3a(a5) */
    u8 idx;                             /* -$3c(a5) */
    u8 k;                               /* -$3b(a5) */
    u8 key;                             /* -$3d(a5) */
    u8 special;                         /* -$3e(a5) */
    u32 xp;

    if (!pick_character()) {
        return;
    }
    xp = CH_L(g_current_char, 0x11E); /* ch+$11E: experience points (long) */
    if (!(xp == 0x5DC || xp == 0x4E3 || xp == 0x7D0 || xp == 0x7D1 ||
          xp == 0x8CB || xp == 0x9C4 || xp == 0x1388) ||
        /* ch+$DC: use: threshold for the levels +$106..+$10D and the HP; !=0 forbids Modify */
        g_current_char->b[0xDC] != 0) {
        h026_copy(0x50, s_message, 0x0F, (const char *)g_current_char->b);
        h026_append(0x50, s_message, 0x13, " can't be modified.");
        show_message(0x50, s_message, 0x0E, 0);
        return;
    }
    H005_SET_W(0x2506, 0xFF); /* $2506: (word) field clicked in Modify Character (0..7), $FF none */
    H005_B(0x24DA) = 1; /* $24DA: 1 in Modify Character: the click chooses the field ($2506) */
    draw_character_sheet();
    for (idx = 0; idx <= 5; ++idx) {
        /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
        saved_stats[idx] = g_current_char->b[0x11 + idx * 2];
    }
    saved_ext = g_current_char->b[0x1C]; /* ch+$1C: current exceptional strength (18/xx, 1..100) */
    saved_hp = g_current_char->b[0x64]; /* ch+$64: maximum hit points */
    h026_copy(0x28, saved_name, 0x0F, (const char *)g_current_char->b);
    f.cursor = 0;
    f.field = 7;
    modify_draw_field(&f, 0);
    f.field = 0;
    modify_draw_field(&f, 1);
    c = g_current_char;
    for (;;) {
        if (f.field == 6) {
            special = 0;
            wait_for_key();
            key = G_KEY; /* $5305: key/action pending from the input (G_KEY) */
            if (key > '0' && key <= '9') {
                key = H005_B(0x4F7C + key - '1'); /* $4F7C: translation of the digit keys 1..9 into action keys */
                special = 1;
            }
            if (key == 0) {
                wait_for_key();
                key = G_KEY; /* $5305: key/action pending from the input (G_KEY) */
                special = 1;
            }
            if (key == 0x1B) {
                key = 0;
            }
        } else {
            key = ui_request_choice(8, "Modify: ", 0x16,
                                    "Add Subtract Keep Exit", 0x0D, 0x0A,
                                    0x0F, 1, 0, &special);
        }
        modify_draw_field(&f, 0);
        if (special) {
            switch (key) {
            case 'S':                   /* $35C2 */
                if (f.field == 6 &&
                    h026_strlen(0x0F, (const char *)g_current_char->b) > 0) {
                    h026_delete(0x0F, (char *)g_current_char->b, f.cursor, 1);
                }
                break;
            case 'P':                   /* $3606 */
                ++f.field;
                if (f.field > 7) {
                    f.field = 0;
                }
                break;
            case 'H':                   /* $361A */
                if (f.field == 0) {
                    f.field = 7;
                } else {
                    --f.field;
                }
                break;
            case 'G':                   /* $3632 */
                /* $249E: 1 if the key comes from the mouse (click); $2506: (word) field
                 * clicked in Modify Character (0..7), $FF none */
                if (H005_B(0x249E) && H005_W(0x2506) != 0xFF) {
                    /* $2506: (word) field clicked in Modify Character (0..7), $FF none */
                    f.field = H005_W(0x2506);
                }
                break;
            default:
                break;
            }
        } else {
            switch (key) {
            case 'S':                   /* $3698: Subtract */
                if (f.field < 6) {
                    idx = (u8)f.field;
                    /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
                    add_to_byte(&c->b[0x11 + idx * 2], 0xFFFF);
                    switch (idx) {
                    case 0:             /* $36D2 */
                        if (c->b[0x1C] > 0) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
                            /* ch+$1C: current exceptional strength (18/xx, 1..100) */
                            add_to_byte(&c->b[0x1C], 0xFFFF);
                            /* ch+$11: current abilities, 6 entries step 2 from +$11; current
                             * strength */
                            add_to_byte(&c->b[0x11 + idx * 2], 1);
                        } else {
                            /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength; $226C: ability limits
                             * per race ($20 bytes): minimum strength per sex (word); ch+$5B:
                             * race (0..6, names H005+$4D04); ch+$10E: sex (0 male, 1 female;
                             * names H005+$4BD2) */
                            if (c->b[0x11] < RACE_SW(0)) {
                                /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength; $226C: ability limits
                                 * per race ($20 bytes): minimum strength per sex (word); ch+$5B:
                                 * race (0..6, names H005+$4D04); ch+$10E: sex (0 male, 1 female;
                                 * names H005+$4BD2) */
                                c->b[0x11] = (u8)RACE_SW(0);
                            }
                            /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength; $1F9A: ability minimums
                             * per class (12 bytes, 6 words): +0 strength; ch+$5C: class or class
                             * combination (0..16, names H005+$4D84) */
                            if (c->b[0x11] < CLASS_W(0)) {
                                /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength; $1F9A: ability minimums
                                 * per class (12 bytes, 6 words): +0 strength; ch+$5C: class or
                                 * class combination (0..16, names H005+$4D84) */
                                c->b[0x11] = (u8)CLASS_W(0);
                            }
                        }
                        break;
                    case 1:             /* $37C4 */
                        /* ch+$13: current intelligence; $2278: limits per race +$C: minimum intelligence
                         * (word); ch+$5B: race (0..6, names H005+$4D04) */
                        if (c->b[0x13] < RACE_W(0x0C)) {
                            /* ch+$13: current intelligence; $2278: limits per race +$C: minimum intelligence (word); ch+$5B:
                             * race (0..6, names H005+$4D04) */
                            c->b[0x13] = (u8)RACE_W(0x0C);
                        }
                        /* ch+$13: current intelligence; $1F9C: minimums per class +2: intelligence (word); ch+$5C: class or
                         * class combination (0..16, names H005+$4D84) */
                        if (c->b[0x13] < CLASS_W(2)) {
                            /* ch+$13: current intelligence; $1F9C: minimums per class +2: intelligence (word); ch+$5C: class
                             * or class combination (0..16, names H005+$4D84) */
                            c->b[0x13] = (u8)CLASS_W(2);
                        }
                        break;
                    case 2:             /* $385E */
                        /* ch+$15: current wisdom; $227C: limits per race +$10: minimum wisdom
                         * (word); ch+$5B: race (0..6, names H005+$4D04) */
                        if (c->b[0x15] < RACE_W(0x10)) {
                            /* ch+$15: current wisdom; $227C: limits per race +$10: minimum wisdom (word); ch+$5B:
                             * race (0..6, names H005+$4D04) */
                            c->b[0x15] = (u8)RACE_W(0x10);
                        }
                        /* ch+$15: current wisdom; $1F9E: minimums per class +4: wisdom (word); ch+$5C: class or class
                         * combination (0..16, names H005+$4D84) */
                        if (c->b[0x15] < CLASS_W(4)) {
                            /* ch+$15: current wisdom; $1F9E: minimums per class +4: wisdom (word); ch+$5C: class or
                             * class combination (0..16, names H005+$4D84) */
                            c->b[0x15] = (u8)CLASS_W(4);
                        }
                        /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
                        if (c->b[0x124] > 0) {
                            /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
                            c->b[0x124] = 1;
                        }
                        break;
                    case 3:             /* $390A */
                        /* ch+$17: current dexterity; $2280: limits per race +$14: minimum dexterity
                         * (word); ch+$5B: race (0..6, names H005+$4D04) */
                        if (c->b[0x17] < RACE_W(0x14)) {
                            /* ch+$17: current dexterity; $2280: limits per race +$14: minimum dexterity (word);
                             * ch+$5B: race (0..6, names H005+$4D04) */
                            c->b[0x17] = (u8)RACE_W(0x14);
                        }
                        /* ch+$17: current dexterity; $1FA0: minimums per class +6: dexterity (word); ch+$5C: class or class
                         * combination (0..16, names H005+$4D84) */
                        if (c->b[0x17] < CLASS_W(6)) {
                            /* ch+$17: current dexterity; $1FA0: minimums per class +6: dexterity (word); ch+$5C: class
                             * or class combination (0..16, names H005+$4D84) */
                            c->b[0x17] = (u8)CLASS_W(6);
                        }
                        break;
                    case 4:             /* $39A4 */
                        /* ch+$19: current constitution; $2284: limits per race +$18: minimum constitution
                         * (word); ch+$5B: race (0..6, names H005+$4D04) */
                        if (c->b[0x19] < RACE_W(0x18)) {
                            /* ch+$19: current constitution; $2284: limits per race +$18: minimum constitution (word); ch+$5B:
                             * race (0..6, names H005+$4D04) */
                            c->b[0x19] = (u8)RACE_W(0x18);
                        }
                        /* ch+$19: current constitution; $1FA2: minimums per class +8: constitution (word); ch+$5C: class or
                         * class combination (0..16, names H005+$4D84) */
                        if (c->b[0x19] < CLASS_W(8)) {
                            /* ch+$19: current constitution; $1FA2: minimums per class +8: constitution (word); ch+$5C: class
                             * or class combination (0..16, names H005+$4D84) */
                            c->b[0x19] = (u8)CLASS_W(8);
                        }
                        /* ch+$64: maximum hit points */
                        if (c->b[0x64] > (u16)max_hit_points(g_current_char)) {
                            /* ch+$64: maximum hit points */
                            c->b[0x64] = (u8)max_hit_points(g_current_char);
                        }
                        /* ch+$1A8: current hit points; ch+$64: maximum hit points */
                        c->b[0x1A8] = c->b[0x64];
                        f.field = 6;
                        modify_draw_field(&f, 0);
                        f.field = 4;
                        break;
                    case 5:             /* $3A8E */
                        /* ch+$1B: current charisma; $2288: limits per race +$1C: minimum charisma
                         * (word); ch+$5B: race (0..6, names H005+$4D04) */
                        if (c->b[0x1B] < RACE_W(0x1C)) {
                            /* ch+$1B: current charisma; $2288: limits per race +$1C: minimum charisma (word);
                             * ch+$5B: race (0..6, names H005+$4D04) */
                            c->b[0x1B] = (u8)RACE_W(0x1C);
                        }
                        /* ch+$1B: current charisma; $1FA4: minimums per class +$A: charisma (word); ch+$5C: class or
                         * class combination (0..16, names H005+$4D84) */
                        if (c->b[0x1B] < CLASS_W(0x0A)) {
                            /* ch+$1B: current charisma; $1FA4: minimums per class +$A: charisma (word); ch+$5C: class
                             * or class combination (0..16, names H005+$4D84) */
                            c->b[0x1B] = (u8)CLASS_W(0x0A);
                        }
                        break;
                    }
                } else if (f.field == 7) {
                    add_to_byte(&c->b[0x64], 0xFFFF); /* ch+$64: maximum hit points */
                    if (c->b[0x64] < (u16)min_hit_points(g_current_char)) { /* ch+$64: maximum hit points */
                        c->b[0x64] = (u8)min_hit_points(g_current_char); /* ch+$64: maximum hit points */
                    }
                    /* ch+$1A8: current hit points; ch+$64: maximum hit points */
                    c->b[0x1A8] = c->b[0x64];
                } else if (f.cursor == 0) {
                    f.cursor = (u16)(h026_strlen(0x0F,
                                     (const char *)g_current_char->b) - 1);
                } else {
                    --f.cursor;
                }
                break;
            case 'A':                   /* $3BD8: Add */
                if (f.field < 6) {
                    idx = (u8)f.field;
                    /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
                    add_to_byte(&c->b[0x11 + idx * 2], 1);
                    switch (idx) {
                    case 0:             /* $3C12 */
                        /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength; $2270: limits per race
                         * +4: maximum strength per sex (word); ch+$5B: race (0..6, names
                         * H005+$4D04); ch+$10E: sex (0 male, 1 female; names H005+$4BD2) */
                        if (c->b[0x11] > RACE_SW(4)) {
                            /* ch+$11: current abilities, 6 entries step 2 from +$11; current
                             * strength */
                            if (c->b[0x11] > 0x12 &&
                                /* ch+$100: fighter level; ch+$105: knight level */
                                (c->b[0x100] > 0 || c->b[0x105] > 0 ||
                                 c->b[0x102] > 0) && /* ch+$102: ranger level */
                                /* ch+$1C: current exceptional strength (18/xx, 1..100); $2274: limits per race +8: maximum
                                 * exceptional strength per sex (word); ch+$5B: race (0..6, names
                                 * H005+$4D04); ch+$10E: sex (0 male, 1 female; names H005+$4BD2) */
                                c->b[0x1C] < RACE_SW(8)) {
                                /* ch+$1C: current exceptional strength (18/xx, 1..100) */
                                add_to_byte(&c->b[0x1C], 1);
                            }
                            /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength; $2270: limits per race
                             * +4: maximum strength per sex (word); ch+$5B: race (0..6, names
                             * H005+$4D04); ch+$10E: sex (0 male, 1 female; names H005+$4BD2) */
                            c->b[0x11] = (u8)RACE_SW(4);
                        }
                        break;
                    case 1:             /* $3CE2 */
                        /* ch+$13: current intelligence; $227A: limits per race +$E: maximum intelligence
                         * (word); ch+$5B: race (0..6, names H005+$4D04) */
                        if (c->b[0x13] > RACE_W(0x0E)) {
                            /* ch+$13: current intelligence; $227A: limits per race +$E: maximum intelligence (word); ch+$5B:
                             * race (0..6, names H005+$4D04) */
                            c->b[0x13] = (u8)RACE_W(0x0E);
                        }
                        break;
                    case 2:             /* $3D2E */
                        /* ch+$15: current wisdom; $227E: limits per race +$12: maximum wisdom
                         * (word); ch+$5B: race (0..6, names H005+$4D04) */
                        if (c->b[0x15] > RACE_W(0x12)) {
                            /* ch+$15: current wisdom; $227E: limits per race +$12: maximum wisdom (word); ch+$5B:
                             * race (0..6, names H005+$4D04) */
                            c->b[0x15] = (u8)RACE_W(0x12);
                        }
                        /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
                        if (c->b[0x124] > 0) {
                            /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
                            c->b[0x124] = 1;
                        }
                        break;
                    case 3:             /* $3D8C */
                        /* ch+$17: current dexterity; $2282: limits per race +$16: maximum dexterity
                         * (word); ch+$5B: race (0..6, names H005+$4D04) */
                        if (c->b[0x17] > RACE_W(0x16)) {
                            /* ch+$17: current dexterity; $2282: limits per race +$16: maximum dexterity (word);
                             * ch+$5B: race (0..6, names H005+$4D04) */
                            c->b[0x17] = (u8)RACE_W(0x16);
                        }
                        break;
                    case 4:             /* $3DD8 */
                        /* ch+$19: current constitution; $2286: limits per race +$1A: maximum constitution
                         * (word); ch+$5B: race (0..6, names H005+$4D04) */
                        if (c->b[0x19] > RACE_W(0x1A)) {
                            /* ch+$19: current constitution; $2286: limits per race +$1A: maximum constitution (word); ch+$5B:
                             * race (0..6, names H005+$4D04) */
                            c->b[0x19] = (u8)RACE_W(0x1A);
                        }
                        /* ch+$64: maximum hit points */
                        if (c->b[0x64] < (u16)min_hit_points(g_current_char)) {
                            /* ch+$64: maximum hit points */
                            c->b[0x64] = (u8)min_hit_points(g_current_char);
                        }
                        /* ch+$1A8: current hit points; ch+$64: maximum hit points */
                        c->b[0x1A8] = c->b[0x64];
                        f.field = 6;
                        modify_draw_field(&f, 0);
                        f.field = 4;
                        break;
                    case 5:             /* $3E74 */
                        /* ch+$1B: current charisma; $228A: limits per race +$1E: maximum charisma
                         * (word); ch+$5B: race (0..6, names H005+$4D04) */
                        if (c->b[0x1B] > RACE_W(0x1E)) {
                            /* ch+$1B: current charisma; $228A: limits per race +$1E: maximum charisma (word);
                             * ch+$5B: race (0..6, names H005+$4D04) */
                            c->b[0x1B] = (u8)RACE_W(0x1E);
                        }
                        break;
                    }
                } else if (f.field == 7) {
                    add_to_byte(&c->b[0x64], 1); /* ch+$64: maximum hit points */
                    if (c->b[0x64] > (u16)max_hit_points(g_current_char)) { /* ch+$64: maximum hit points */
                        c->b[0x64] = (u8)max_hit_points(g_current_char); /* ch+$64: maximum hit points */
                    }
                    /* ch+$1A8: current hit points; ch+$64: maximum hit points */
                    c->b[0x1A8] = c->b[0x64];
                } else if (f.cursor == (u16)(h026_strlen(0x0F,
                               (const char *)g_current_char->b) - 1)) {
                    f.cursor = 0;
                } else {
                    ++f.cursor;
                }
                break;
            case '\r':                  /* $3F72 */
                ++f.field;
                if (f.field > 7) {
                    f.field = 0;
                }
                break;
            case 0x08:                  /* $3F86 */
                if (f.field == 6 && f.cursor > 0) {
                    h026_delete(0x0F, (char *)g_current_char->b,
                                (u16)(f.cursor - 1), 1);
                    --f.cursor;
                    if (f.cursor > h026_strlen(0x0F,
                                               (const char *)g_current_char->b)) {
                        f.cursor = h026_strlen(0x0F,
                                               (const char *)g_current_char->b);
                    }
                }
                break;
            case 0:                     /* $3FF6 */
                modify_restore(c, saved_stats, saved_ext, saved_hp,
                               saved_name, 0);
                return;
            default:                    /* $4090 */
                if (f.field == 6) {
                    if (f.cursor < 0x0F && key >= 0x20 && key <= 0x7A) {
                        g_current_char->b[f.cursor] = key;
                        ++f.cursor;
                    }
                } else if (key == 'E') {
                    modify_restore(c, saved_stats, saved_ext, saved_hp,
                                   saved_name, 1);
                    return;
                }
                break;
            }
        }
        recompute_stats(g_current_char);
        draw_combat_values();
        modify_draw_field(&f, 1);
        if (!special && key == 'K') {
            break;
        }
    }
    cleric_spell_slots(g_current_char);
    c = g_current_char;
    c->b[0xED] = 1; /* ch+$ED: share of the NPC in the division (bits 0-2); 1 after Modify */
    sum = 0;
    count = 0;
    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] > 0) { /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; $5026:
             * maximum hit dice level per class (byte, 0..7) */
            if (c->b[0xFE + k] < H005_B(0x5026 + k)) {
                if (k == 4) {
                    /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
                    sum = (s16)(sum + con_hp_adjust(k) * (c->b[0xFE + k] + 1));
                } else {
                    /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
                    sum = (s16)(sum + con_hp_adjust(k) * c->b[0xFE + k]);
                }
            } else {
                /* $5026: maximum hit dice level per class (byte, 0..7) */
                sum = (s16)(sum + (H005_B(0x5026 + k) - 1) * con_hp_adjust(k));
            }
            ++count;
        }
    }
    sum = (s16)(sum / count);
    /* ch+$123: maximum HP without constitution; base -1 of the spell slots +$124; ch+$64: maximum
     * hit points */
    c->b[0x123] = (u8)(c->b[0x64] - sum);
    for (idx = 0; idx <= 5; ++idx) {
        /* pg+$10: caratteristiche base, 6 voci passo 2 (FOR INT SAG DES COS CAR); FOR; ch+$11:
         * current abilities, 6 entries step 2 from +$11; current strength */
        g_current_char->b[0x10 + idx * 2] = g_current_char->b[0x11 + idx * 2];
    }
    /* ch+$1D: base exceptional strength; ch+$1C: current exceptional strength (18/xx, 1..100) */
    g_current_char->b[0x1D] = g_current_char->b[0x1C];
    H005_B(0x24DA) = 0; /* $24DA: 1 in Modify Character: the click chooses the field ($2506) */
    (void)saved_hp;
}

/*
 * PORT H013+$43E8: promotes c to the next knightly order (+$5D):
 * the knight level (+$105) drops by 1 if the experience is not enough,
 * and the hit points of that level (+$123 / (level + 1) plus the
 * constitution bonus) are removed.
 */
static void promote_knight(Character *c)
{
    /* ch+$105: knight level */
    u8 level = c->b[0x105];             /* -$1(a5) */
    u8 order;                           /* -$2(a5) */
    u16 part;                           /* -$4(a5) */
    s16 adj;                            /* -$6(a5) */

    if (c->b[0x5D] == 1) { /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
        order = 4;
    } else {
        order = 5;
    }
    if ((s32)CH_L(c, 0x11E) < /* ch+$11E: experience points (long) */
        /* $1946: per-class tables ($9A bytes): 11 long XP thresholds, then slots per lvl. */
        (s32)H005_L(0x1946 + order * 0x9A + (level - 2) * 4)) {
        add_to_byte(&c->b[0x105], 0xFFFF); /* ch+$105: knight level */
    }
    /* ch+$123: maximum HP without constitution; base -1 of the spell slots +$124 */
    part = (u16)(c->b[0x123] / (u16)(level + 1));
    /* ch+$123: maximum HP without constitution; base -1 of the spell slots +$124 */
    add_to_byte(&c->b[0x123], (u16)-(s16)part);
    adj = con_hp_adjust(7);
    add_to_byte(&c->b[0x64], (u16)-(s16)(part + adj)); /* ch+$64: maximum hit points */
    if (c->b[0x1A8] >= c->b[0x64]) { /* ch+$1A8: current hit points; ch+$64: maximum hit points */
        c->b[0x1A8] = c->b[0x64]; /* ch+$1A8: current hit points; ch+$64: maximum hit points */
    }
    add_to_byte(&c->b[0x5D], 1); /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
    level_derived_values(c);
}

/* Row "name + text" centred at col on row 9. */
static void knight_line(Character *c, u16 col, u16 len, const char *text)
{
    h026_copy(0x50, s_message, 0x0F, (const char *)c->b);
    h026_append(0x50, s_message, len, text);
    ui_draw_text(col, 9, 0x0A, 0, 0x50, s_message);
}

/*
 * PORT H013+$4508: Knight Change Classes: a Knight of the Crown
 * (+$5D = 1) can become one of the Sword, one of the Sword (2) one of the Rose,
 * if it has enough level and experience and the minimum abilities.
 */
static void knight_change(void)
{
    static const u16 sword_min[6] = { 0x0C, 9, 0x0D, 9, 0x0A, 3 };   /* -$2a(a5) */
    static const u16 rose_min[6] = { 0x0F, 0x0A, 0x0D, 0x0C, 0x0F, 3 }; /* -$36(a5) */
    Character *c;                       /* -$1e(a5), a3 */
    char options[0x0E];                 /* -$12(a5) */
    char order[6];                      /* -$6(a5) */
    u16 col;                            /* -$1a(a5) */
    u8 done;                            /* -$16(a5) */
    u8 key;                             /* -$15(a5) */
    u8 ok;                              /* -$14(a5) */
    u8 i;                               /* -$13(a5) */
    u8 special;                         /* -$17(a5) */
    u16 len;

    if (!pick_character()) {
        return;
    }
    c = g_current_char;
    draw_screen_frame(1);
    /* ch+$105: knight level; ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
    if (c->b[0x105] == 0 || c->b[0x5D] == 3) {
        return;
    }
    done = 0;
    copy_text(options, "Exit", 0x0B);
    len = h026_strlen(0x0F, (const char *)c->b);
    col = (u16)(0x13 - (len >> 1));
    ui_draw_text(col, 3, 0x0A, 0, 0x0F, (const char *)c->b);
    ui_draw_text(7, 5, 0x0A, 0, 0x1A, "is petitioning to become a");
    /*
     * With +$5D other than 1 and 2 the original uses the uninitialised
     * string of the frame; here it is empty.
     */
    order[0] = 0;
    if (c->b[0x5D] == 1) { /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
        copy_text(order, "sword", 5);
    } else if (c->b[0x5D] == 2) { /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
        copy_text(order, "rose", 5);
    }
    copy_text(s_message, "Knight Of The ", 0x50);
    h026_append(0x50, s_message, 5, order);
    ui_draw_text(0x0A, 7, 0x0A, 0, 0x50, s_message);
    /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
    if (c->b[0x5D] == 1) {                         /* $46C6 */
        col = (u16)(0x13 - ((u16)(h026_strlen(0x0F, (const char *)c->b) +
                                  0x15) >> 1));
        if (c->b[0x105] < 2 || /* ch+$105: knight level */
            /* ch+$11E: experience points (long); $1BAE: XP threshold (long) class 4, level
             * 2: Knight of the Sword requirement */
            (s32)CH_L(c, 0x11E) < (s32)H005_L(0x1BAE)) {
            knight_line(c, col, 0x16, " is too inExperienced.");
        } else {
            col = (u16)(0x13 - ((u16)(h026_strlen(0x0F,
                                     (const char *)c->b) + 0x12) >> 1));
            ok = 1;
            for (i = 0; i <= 5; ++i) {
                /* pg+$10: caratteristiche base, 6 voci passo 2 (FOR INT SAG DES COS CAR); FOR */
                if (c->b[0x10 + i * 2] < sword_min[i]) {
                    ok = 0;
                }
            }
            if (!ok) {
                knight_line(c, col, 0x12, " does not qualify.");
            } else {
                col = (u16)(0x13 - ((u16)(h026_strlen(0x0F,
                                         (const char *)c->b) + 0x0D) >> 1));
                knight_line(c, col, 0x0D, " may become a");
                ui_draw_text(0x0A, 0x0B, 0x0A, 0, 0x13, "Knight Of The Sword");
                copy_text(options, "Change Exit", 0x0B);
            }
        }
    /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
    } else if (c->b[0x5D] == 2) {                  /* $48CC */
        col = (u16)(0x14 - ((u16)(h026_strlen(0x0F, (const char *)c->b) +
                                  0x15) >> 1));
        if (c->b[0x105] < 4 || /* ch+$105: knight level */
            /* ch+$11E: experience points (long); $1C50: XP threshold (long) class 5, third
             * entry: Knight of the Rose requirement */
            (s32)CH_L(c, 0x11E) < (s32)H005_L(0x1C50)) {
            knight_line(c, col, 0x15, " is too inexperienced");
        } else {
            col = (u16)(0x14 - ((u16)(h026_strlen(0x0F,
                                     (const char *)c->b) + 0x12) >> 1));
            ok = 1;
            for (i = 0; i <= 5; ++i) {
                /* pg+$10: caratteristiche base, 6 voci passo 2 (FOR INT SAG DES COS CAR); FOR */
                if (c->b[0x10 + i * 2] < rose_min[i]) {
                    ok = 0;
                }
            }
            if (!ok) {
                knight_line(c, col, 0x12, " does not qualify.");
            } else {
                col = (u16)(0x13 - ((u16)(h026_strlen(0x0F,
                                         (const char *)c->b) + 0x0D) >> 1));
                knight_line(c, col, 0x0D, " may become a");
                ui_draw_text(0x0A, 0x0B, 0x0A, 0, 0x12, "Knight Of The Rose");
                copy_text(options, "Change Exit", 0x0B);
            }
        }
    }
    do {
        key = ui_request_choice(0, "", 0x0B, options, 0x0D, 0x0A, 0x0F, 0, 0,
                                &special);
        switch (key) {
        case 'C':
            promote_knight(c);
            done = 1;
            break;
        case 0:
        case 'E':
            done = 1;
            break;
        default:
            break;
        }
    } while (!done);
}

/*
 * PORT H013+$2B9A: Drop Character: chooses the character and, once confirmed
 * twice, deletes its files and removes it from the party.
 */
static void drop_character(void)
{
    Character *c;                       /* a3 */

    if (!pick_character()) {
        return;
    }
    if (g_current_char != NULL) {
        c = g_current_char;
        copy_text(s_message, "Drop ", 0x50);
        h026_append(0x50, s_message, 0x0F, (const char *)c->b);
        h026_append(0x50, s_message, 9, " forever?");
        if (ask_yes_no(0x50, s_message, 0x0E, 0x0A, 0x0F) == 'Y' &&
            ask_yes_no(0x0E, "Are you sure? ", 0x0E, 0x0A, 0x0F) == 'Y') {
            if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
                copy_text(s_message, "You dump ", 0x50);
                h026_append(0x50, s_message, 0x0F, (const char *)c->b);
                h026_append(0x50, s_message, 0x0A, " out back.");
                show_message_line(0x50, s_message);
            } else {
                h026_copy(0x50, s_message, 0x0F, (const char *)c->b);
                h026_append(0x50, s_message, 0x13, " bids you farewell.");
                show_message_line(0x50, s_message);
            }
            delete_character_files(g_current_char);
            remove_from_party(0, 1);
        } else {
            h026_copy(0x50, s_message, 0x0F, (const char *)c->b);
            h026_append(0x50, s_message, 0x1B,
                        " breathes a sigh of relief.");
            show_message_line(0x50, s_message);
        }
    }
    draw_party(g_current_char);
}

void main_menu(void)
{
    MainMenuEntry items[MM_COUNT];      /* -$23A(a5) */
    char keys[0x2A];                    /* -$2A(a5) */
    CokMenuItem *list = NULL;              /* -$250(a5) */
    CokMenuItem *node;                     /* -$25C(a5) */
    CokMenuItem *chosen = NULL;            /* -$258(a5) */
    u16 index;                          /* -$262(a5) */
    u16 count;                          /* -$248(a5) */
    u16 i;                              /* -$23C(a5) */
    u8 saved_context;                   /* -$24A(a5) */
    u8 rebuild;                         /* -$249(a5) */
    u8 redraw;                          /* -$23F(a5) */
    u8 key;                             /* -$23D(a5) */

    init_main_menu(items, keys);
    H005_B(0x24A2) = 0; /* $24A2: 1: clicking a party name selects the character */
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    saved_context = H005_B(0x3DE3);
    H005_B(0x3DE3) = 0; /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    rebuild = 1;
    H005_B(0x24DE) = 0; /* $24DE: free training (cheat "Free training") */
    index = 0;

    for (;;) {
        if (rebuild) {
            draw_screen_frame(1);
            if (g_current_char != NULL) {
                draw_party(g_current_char);
                items[MM_DROP].enabled = 1;
                items[MM_MODIFY].enabled = 1;
                items[MM_TRAIN].enabled =
                    /* B+$550: (word) mask of the classes that can be trained here (0 none);
                     * $24DE: free training (cheat "Free training") */
                    (u8)(COK_GET16(g_state_b + 0x550) > 0 || H005_B(0x24DE));
                items[MM_KNIGHT].enabled = items[MM_TRAIN].enabled;
                items[MM_VIEW].enabled = 1;
                items[MM_REMOVE].enabled = 1;
                items[MM_LOAD].enabled = 0;
                items[MM_SAVE].enabled = 1;
                items[MM_BEGIN].enabled = 1;
            } else {
                items[MM_DROP].enabled = 0;
                items[MM_MODIFY].enabled = 0;
                items[MM_TRAIN].enabled = 0;
                items[MM_KNIGHT].enabled = 0;
                items[MM_VIEW].enabled = 0;
                items[MM_REMOVE].enabled = 0;
                items[MM_LOAD].enabled = 1;
                items[MM_SAVE].enabled = 0;
                items[MM_BEGIN].enabled = 0;
            }
            count = 0;
            for (i = 0; i <= 0x0B; ++i) {
                if (items[i].enabled) {
                    ++count;
                }
            }
            menu_alloc(count, &list);
            node = list;
            for (i = 0; i <= 0x0B; ++i) {
                if (items[i].enabled) {
                    memcpy(node->text, items[i].text, 0x2A);
                    node = node->next;
                }
            }
        }
        redraw = 1;
        (void)list_menu(0x12, "Choose a function ", 7, "Select ", 0x0D, 0x0A,
                        0x0F, 9, 0x0C, 0x26, 0x16, list, 0, &redraw, &index,
                        &chosen);
        /*
         * The function is the initial letter of the chosen entry.  With Esc
         * (null entry) the original reads the byte at address 0; here 0.
         */
        key = chosen != NULL ? (u8)chosen->text[0] : 0;
        if (rebuild) {
            menu_free(&list);
        }
        if (key != 'S' && key != 'E') {
            H005_B(0x24A3) = 0; /* $24A3: 1 if the game is saved (warning on exit); read by eff. $36 */
        }
        switch (key) {
        case 'C':
            if (items[MM_CREATE].enabled) {
                create_character();
            }
            break;
        case 'D':
            if (items[MM_DROP].enabled) {
                drop_character();
            }
            break;
        case 'M':
            if (items[MM_MODIFY].enabled) {
                modify_character();
            }
            break;
        case 'T':
            if (items[MM_TRAIN].enabled) {
                train_character();
            }
            break;
        case 'K':
            if (items[MM_KNIGHT].enabled) {
                knight_change();
            }
            break;
        case 'V':
            if (items[MM_VIEW].enabled && pick_character()) {
                view_character(&redraw);
            }
            break;
        case 'A':
            if (items[MM_ADD].enabled) {
                add_character_to_party();
            }
            break;
        case 'R':
            if (items[MM_REMOVE].enabled && g_current_char != NULL &&
                pick_character()) {
                /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
                if (g_current_char->b[0xEC] < 0x80) {
                    save_character(g_current_char, 0, "");
                    remove_from_party(0, 1);
                } else {
                    drop_character();
                }
                /* $249C: 0 during the party menu from ECL $38: Drop does not lose the party */
                if (g_current_char == NULL && !H005_B(0x249C)) {
                    /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
                    H005_B(0x24D0) = 1;
                    return;
                }
            }
            break;
        case 'L':
            if (items[MM_LOAD].enabled) {
                load_game();
            }
            break;
        case 'S':
            if (items[MM_SAVE].enabled && g_party_head != NULL) {
                save_game();
            }
            break;
        case 'B':
            if (items[MM_BEGIN].enabled) {
                H005_B(0x24A2) = 1; /* $24A2: 1: clicking a party name selects the character */
                /* $24D7: 1 if the demonstration (Demo) was chosen */
                if (g_party_head != NULL || G_DEMO_FLAG) {
                    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
                    H005_B(0x3DE3) = saved_context;
                    /* $24D1: 1 after Load Saved Game: the area does not clear its variables; $2486: id of
                     * the sequence loaded at $27BC (name at $27A6), $FF none */
                    if (!H005_B(0x24D1) && H005_B(0x2486) != 9) {
                        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
                        if (H005_B(0x3DE3) == 3 &&
                            /* A+$270: (word) town area: no view redraw nor EXIT from the camp */
                            COK_GET16(g_state_a + 0x270) == 0) {
                            draw_wild_frame();
                        } else {
                            draw_explore_frame();
                        }
                        draw_party(g_current_char);
                    /* A+$1E4: (word) number of the current ECL area (copy of $2498) */
                    } else if (COK_GET16(g_state_a + 0x1E4) == 0 ||
                               /* A+$270: (word) town area: no view redraw nor EXIT from the camp */
                               COK_GET16(g_state_a + 0x270) != 0) {
                        draw_explore_frame();
                        draw_party(g_current_char);
                    }
                    clear_message_line();
                    /* B+$550: (word) mask of the classes that can be trained here (0 none) */
                    COK_PUT16(g_state_b + 0x550, 0);
                    free_char_screens();
                    return;
                }
            }
            break;
        case 'E':
            if (items[MM_EXIT].enabled) {
                key = ask_yes_no(0x12, "Quit to workbench ", 0x0E, 0x0A, 0x0F);
                if (key == 'Y') {
                    /* $24A3: 1 if the game is saved (warning on exit); read by eff. $36 */
                    if (g_party_head != NULL && !H005_B(0x24A3)) {
                        key = ask_yes_no(0x1E, "Game not saved.  Quit anyway? ",
                                         0x0E, 0x0A, 0x0F);
                        if (key == 'N') {
                            save_game();
                        }
                    }
                    if (key == 'Y') {
                        menu_free(&list);
                        h043_0840();
                        quit_game();
                    }
                }
            }
            break;
        case 'J':
            /*
             * Cheat: if the third command line argument is the
             * word of H005+$2358, toggles "Free training".
             * The original reads argv[2] in any case; here only if it exists.
             */
            if (g_argc > 2 &&
                h026_compare_nocase(0xFF, g_argv[2], 0x14,
                                    /* $2358: cheat password (string compared with argv[2]) */
                                    (const char *)&g_h005[0x2358]) == 1) {
                /* $24DE: free training (cheat "Free training") */
                H005_B(0x24DE) = (u8)(H005_B(0x24DE) == 0);
                h026_copy(0x50, s_message, 0x0E, "Free training ");
                if (H005_B(0x24DE)) { /* $24DE: free training (cheat "Free training") */
                    h026_append(0x50, s_message, 2, "on");
                } else {
                    h026_append(0x50, s_message, 3, "off");
                }
                show_message_line(0x50, s_message);
            }
            break;
        default:
            break;
        }
    }
}

/* Copy with dbeq: at most max + 1 bytes, NUL included. */
static void copy_text(char *dst, const char *src, u16 max)
{
    u16 i;

    for (i = 0; i <= max; ++i) {
        dst[i] = src[i];
        if (src[i] == 0) {
            break;
        }
    }
}

/* PORT H013+$0520: trampoline (bra.w) to H013+$56CE, the routine below. */
/*
 * PORT H013+$56CE (trampoline H013+$0520): hit point bonus for
 * constitution (+$19) from the table H005+$1F4A; classes 2, 4 and 7 have
 * an extra bonus beyond 16.
 */
static s16 con_hp_bonus(Character *c, u8 cls)
{
    s16 bonus = 0;

    /* $1F4A: HP bonus by constitution (word), index constitution-3; ch+$19: current constitution */
    bonus = (s16)(bonus + (s16)H005_W((u16)(0x1F4A +
                                            ((s16)c->b[0x19] - 3) * 2)));
    if (cls == 2 || cls == 7 || cls == 4) {
        switch (c->b[0x19]) { /* ch+$19: current constitution */
        case 17:
            bonus += 1;
            break;
        case 18:
            bonus += 2;
            break;
        case 19: case 20:
            bonus += 3;
            break;
        case 21: case 22: case 23:
            bonus += 4;
            break;
        case 24: case 25:
            bonus += 5;
            break;
        default:
            break;
        }
    }
    return bonus;
}

/*
 * PORT H013+$0524: initial hit points.  For every class of the character
 * selected by mask (H005+$5038): below the maximum hit dice level
 * (H005+$5026) the best of two rolls and the constitution bonus, above it a
 * fixed value (assigned, not added, as in the original).  The total and
 * the bonus are divided by the number of classes; +$123 gets the dice, +$64
 * dice and bonus, +$1A8 keeps the difference with +$64.
 */
static void roll_hit_points(Character *c, u16 mask, u16 nclasses)
{
    static const u16 dice[8] = { 2, 1, 1, 1, 2, 1, 1, 2 };     /* -$1C */
    static const u16 sides[8] = { 8, 8, 10, 10, 8, 4, 6, 10 }; /* -$2C */
    s16 hp = 0;                         /* -$6(a5) */
    s16 bonus = 0;                      /* -$a(a5) */
    s16 n = 0;                          /* -$8(a5) */
    s16 r1;                             /* -$2(a5) */
    s16 r2;                             /* -$4(a5) */
    s16 diff;
    u8 k;                               /* -$b(a5) */

    for (k = 0; k <= 7; ++k) {
        /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        if (c->b[0xFE + k] == 0 ||
            /* $5038: bit of class k (0..7) in the class mask */
            mask_byte((u8)mask, H005_B(0x5038 + k)) == 0) {
            continue;
        }
        /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; $5026: maximum hit
         * dice level per class (byte, 0..7) */
        if (c->b[0xFE + k] < H005_B(0x5026 + k)) {
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            if (c->b[0xFE + k] > 1) {
                n = 1;
            /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
            } else if (k == 0 && c->b[0x5E] > 4) {
                n = 1;
            } else {
                n = (s16)dice[k];
            }
            r1 = (s16)roll_dice((u16)n, sides[k]);
            r2 = (s16)roll_dice((u16)n, sides[k]);
            if (r2 > r1) {
                r1 = r2;
            }
            hp = (s16)(hp + r1);
            bonus = (s16)(bonus + con_hp_bonus(c, k) * n);
        } else {
            switch (k) {
            case 2: case 7:
                hp = 3;
                break;
            case 0: case 4: case 6:
                hp = 2;
                break;
            case 5:
                hp = 1;
                break;
            default:
                break;
            }
        }
    }
    hp = (s16)(hp / (s16)nclasses);
    if (hp < 1) {
        hp = 1;
    }
    /* ch+$123: maximum HP without constitution; base -1 of the spell slots +$124 */
    add_to_byte(&c->b[0x123], (u16)hp);
    bonus = (s16)(bonus / (s16)nclasses);
    diff = (s16)(c->b[0x64] - c->b[0x1A8]); /* ch+$64: maximum hit points; ch+$1A8: current hit points */
    add_to_byte(&c->b[0x64], (u16)(hp + bonus)); /* ch+$64: maximum hit points */
    c->b[0x1A8] = (u8)(c->b[0x64] - diff); /* ch+$1A8: current hit points; ch+$64: maximum hit points */
}

/*
 * PORT H013+$07B2: three initial items ($48 bytes) inserted after the first one
 * of the list +$150; +$14F = 3.
 */
static void add_starting_items(Character *c)
{
    u16 i;                              /* -$6(a5) */

    for (i = 1; i <= 3; ++i) {
        CokItem *it = (CokItem *)exec_alloc_mem(sizeof(CokItem),
                                                COK_MEMF_CLEAR);

        it->next = NULL;
        it->b[0x2A] = 0; /* ogg+$2A: header flag: copied into the header of the menu entry */
        it->b[0x3A] = 0; /* item+$3A: item readied flag (Ready) */
        it->b[0x3C] = 0; /* item+$3C: cursed item flag */
        switch (i) {
        case 1:
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            it->b[0x30] = 0x24;
            it->b[0x34] = 0x24; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
            it->b[0x33] = 0x2F; /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes) */
            COK_PUT16(it->b + 0x3E, 0x1C2); /* item+$3E: (word) unit weight of the item */
            COK_PUT16(it->b + 0x42, 0); /* item+$42: (word) value in coins (Sell offers half) */
            break;
        case 2:
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            it->b[0x30] = 0x12;
            it->b[0x34] = 0x12; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
            COK_PUT16(it->b + 0x3E, 0x32); /* item+$3E: (word) unit weight of the item */
            COK_PUT16(it->b + 0x42, 0); /* item+$42: (word) value in coins (Sell offers half) */
            break;
        case 3:
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            it->b[0x30] = 0x25;
            it->b[0x34] = 0x25; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
            COK_PUT16(it->b + 0x3E, 0x3C); /* item+$3E: (word) unit weight of the item */
            COK_PUT16(it->b + 0x42, 0); /* item+$42: (word) value in coins (Sell offers half) */
            break;
        default:
            break;
        }
        if (c->items == NULL) {
            c->items = it;
        } else {
            it->next = c->items->next;
            c->items->next = it;
        }
    }
    c->b[0x14F] = 3; /* ch+$14F: number of items owned (max 16) */
}

/*
 * PORT H013+$08C2 (body at H013+$097C): default figure of the current
 * character: +$141 according to race, sex and +$10E, +$142 according to the class.
 */
static void set_default_figure(void)
{
    Character *c = g_current_char;

    if (c->b[0x5B] == 5) { /* ch+$5B: race (0..6, names H005+$4D04) */
        c->b[0x141] = 3; /* ch+$141: head part of the icon (0..$0B) */
    } else if (c->b[0x10E] == 1) { /* ch+$10E: sex (0 male, 1 female; names H005+$4BD2) */
        if (c->b[0x144] == 2) { /* ch+$144: icon size (1 small, 2 large) */
            c->b[0x141] = 9; /* ch+$141: head part of the icon (0..$0B) */
        } else {
            c->b[0x141] = 7; /* ch+$141: head part of the icon (0..$0B) */
        }
    } else if (c->b[0x144] == 2) { /* ch+$144: icon size (1 small, 2 large) */
        c->b[0x141] = 5; /* ch+$141: head part of the icon (0..$0B) */
    }
    if (c->b[0xFE] > 0) { /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        c->b[0x142] = 0x17; /* ch+$142: body figure of the icon (>31: special icons) */
    } else if (c->b[0x102] > 0) { /* ch+$102: ranger level */
        c->b[0x142] = 1; /* ch+$142: body figure of the icon (>31: special icons) */
    /* ch+$105: knight level; ch+$100: fighter level */
    } else if (c->b[0x105] > 0 || c->b[0x100] > 0) {
        c->b[0x142] = 0x18; /* ch+$142: body figure of the icon (>31: special icons) */
    } else if (c->b[0x103] > 0) { /* ch+$103: mage level */
        c->b[0x142] = 0x1D; /* ch+$142: body figure of the icon (>31: special icons) */
    } else {
        c->b[0x142] = 5; /* ch+$142: body figure of the icon (>31: special icons) */
    }
}

/*
 * PORT H013+$0990: nested procedure of Create_Character: maximum age
 * of the race for row cls of the table H005+$20AC ($30 bytes per
 * race, 6 per row): base + dice * sides.
 */
static u16 max_age(u8 race, u8 cls)
{
    u16 row = (u16)(0x20AC + race * 0x30 + cls * 6);

    /* row: age row $20AC: +0 base, +2 dice, +4 sides (word) */
    return (u16)(H005_W(row + 4) * H005_W(row + 2) + H005_W(row));
}

/* List menu of Create_Character (H008+$13C0), with the same arguments. */
static u8 create_menu(CokMenuItem *list, u8 with_exit, u8 *redraw, u16 *index,
                      CokMenuItem **chosen)
{
    return list_menu(0, "", 6, "Select", 0x0D, 0x0A, 0x0F, 1, 2, 0x26, 0x16,
                     list, with_exit, redraw, index, chosen);
}

/* Age limits of the race (H005+$2066, 5 words per race). */
static u16 age_limit(const Character *c, u16 n)
{
    /* $2066: age limits per race: 5 words ($A bytes) per race; ch+$5B: race (0..6, names
     * H005+$4D04) */
    return H005_W(0x2066 + c->b[0x5B] * 0x0A + n * 2);
}

/* Ability limits of the race (H005+$226C, $20 bytes). */
static u16 race_limit(const Character *c, u16 off)
{
    /* $226C: ability limits per race ($20 bytes): minimum strength per sex (word); ch+$5B:
     * race (0..6, names H005+$4D04) */
    return H005_W(0x226C + c->b[0x5B] * 0x20 + off);
}

/* Class minimum for ability s (H005+$1F9A, 12 bytes). */
static u16 class_min(const Character *c, u8 s)
{
    /* $1F9A: ability minimums per class (12 bytes, 6 words): +0 strength; ch+$5C: class or
     * class combination (0..16, names H005+$4D84) */
    return H005_W(0x1F9A + c->b[0x5C] * 0x0C + s * 2);
}

/* Brings *v between the race minimum and maximum and the class minimum. */
static void clamp_stat(Character *c, u8 s, u8 *v, u16 min_off, u16 max_off)
{
    if (*v < race_limit(c, min_off)) {
        *v = (u8)race_limit(c, min_off);
    }
    if (*v > race_limit(c, max_off)) {
        *v = (u8)race_limit(c, max_off);
    }
    if (*v < class_min(c, s)) {
        *v = (u8)class_min(c, s);
    }
}

/*
 * Nested procedures H013+$1B2E, $1E28, $1F98, $21DA, $234A, $24F4:
 * adjustments for age (+$62) and race/sex/class limits of the
 * ability s just rolled (+$11 + 2s).
 */
static void adjust_stat(Character *c, u8 s)
{
    /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
    u8 *v = &c->b[0x11 + s * 2];
    u16 age = CH_W(c, 0x62); /* ch+$62: age (word) */
    u16 g = (u16)(c->b[0x10E] * 2); /* ch+$10E: sex (0 male, 1 female; names H005+$4BD2) */

    switch (s) {
    case 0:                     /* H013+$1B2E: strength */
        if (*v > 0 && age > age_limit(c, 0)) {
            add_to_byte(v, 1);
        }
        if (*v > 0 && age > age_limit(c, 1)) {
            add_to_byte(v, 0xFFFF);
        }
        if (*v > 0 && age > age_limit(c, 2)) {
            add_to_byte(v, 0xFFFE);
        }
        if (*v > 0 && age > age_limit(c, 3)) {
            add_to_byte(v, 0xFFFF);
        }
        clamp_stat(c, s, v, g, (u16)(4 + g));
        if (c->b[0x11] == 18 && /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
            /* ch+$100: fighter level; ch+$102: ranger level; ch+$105: knight level */
            (c->b[0x100] > 0 || c->b[0x102] > 0 || c->b[0x105] > 0)) {
            /* ch+$1C: current exceptional strength (18/xx, 1..100) */
            c->b[0x1C] = (u8)(random_below(0x64) + 1);
            /* ch+$1C: current exceptional strength (18/xx, 1..100) */
            if (c->b[0x1C] > race_limit(c, (u16)(8 + g))) {
                /* ch+$1C: current exceptional strength (18/xx, 1..100) */
                c->b[0x1C] = (u8)race_limit(c, (u16)(8 + g));
            }
        }
        break;
    case 1:                     /* H013+$1E28 */
        if (age > age_limit(c, 1)) {
            add_to_byte(v, 1);
        }
        if (age > age_limit(c, 3)) {
            add_to_byte(v, 1);
        }
        clamp_stat(c, s, v, 0x0C, 0x0E);
        break;
    case 2:                     /* H013+$1F98 */
        if (age <= age_limit(c, 0)) {
            add_to_byte(v, 0xFFFF);
        }
        if (age > age_limit(c, 1)) {
            add_to_byte(v, 1);
        }
        if (age > age_limit(c, 2)) {
            add_to_byte(v, 1);
        }
        if (age > age_limit(c, 3)) {
            add_to_byte(v, 1);
        }
        clamp_stat(c, s, v, 0x10, 0x12);
        /* ch+$5C: class or class combination (0..16, names H005+$4D84) */
        if (*v < 13 && c->b[0x5C] >= 8 && c->b[0x5C] <= 12) {
            *v = 13;
        }
        break;
    case 3:                     /* H013+$21DA */
        if (age > age_limit(c, 2)) {
            add_to_byte(v, 0xFFFE);
        }
        if (age > age_limit(c, 3)) {
            add_to_byte(v, 0xFFFF);
        }
        clamp_stat(c, s, v, 0x14, 0x16);
        break;
    case 4:                     /* H013+$234A */
        if (age > age_limit(c, 1)) {
            add_to_byte(v, 0xFFFF);
        }
        if (age > age_limit(c, 2)) {
            add_to_byte(v, 0xFFFF);
        }
        if (age > age_limit(c, 3)) {
            add_to_byte(v, 0xFFFF);
        }
        clamp_stat(c, s, v, 0x18, 0x1A);
        break;
    case 5:                     /* H013+$24F4 */
        clamp_stat(c, s, v, 0x1C, 0x1E);
        break;
    default:
        break;
    }
}

/*
 * PORT H013+$0982: Create New Character.  Menus of race, sex, class,
 * deity (clerics only) and alignment, then age, abilities
 * (with a reroll on request), hit points, money, name, figure and
 * saving to disk (H066+$1640).  Esc in a menu cancels everything.
 */
void create_character(void)
{
    static const u8 align_values[6] = { 0, 1, 3, 4, 6, 7 };    /* -$6 */
    Character *ch;                      /* -$a(a5) */
    Character *saved;                   /* -$e(a5) */
    CokMenuItem *list = NULL;              /* -$12(a5) */
    CokMenuItem *node;                     /* -$16(a5) */
    u16 index;                          /* -$18(a5) */
    u16 i;                              /* -$1a(a5) */
    u16 j;                              /* -$1c(a5) */
    u16 roll;                           /* -$1e(a5) */
    u8 key;                             /* -$1f(a5) */
    u8 race_i;                          /* -$20(a5) */
    u8 g;                               /* -$21(a5) */
    u8 k;                               /* -$22(a5) */
    u8 s;                               /* -$23(a5) */
    u16 class_count;                    /* -$26(a5) */
    u16 nclasses;                       /* -$2c(a5) */
    u8 with_exit;                       /* -$2f(a5) */
    u8 redraw;                          /* -$30(a5) */
    u8 sep;                             /* -$32(a5) */
    char line[0x29];                    /* -$5c(a5) */
    u16 saved_550;                      /* -$5e(a5) */
    u8 align_ids[6];                    /* -$64(a5) */
    u16 god_mask;                       /* -$66(a5) */
    u16 bits;                           /* -$68(a5) */
    u16 gold;                           /* -$6a(a5) */
    u8 race;

    ch = (Character *)exec_alloc_mem(sizeof(Character), COK_MEMF_CLEAR);
    ch->items = NULL;
    ch->effects = NULL;
    for (i = 1; i <= 6; ++i) {
        u8 v = H005_B(0x5228 + i - 1); /* $5227: i-1 base of the 6 colour registers of the icons ($5228) */

        ch->b[0x146 + i - 1] = (u8)(v + ((v + 8) << 4)); /* ch+$145: base -1 of the icon colours +$146..+$14B */
    }
    ch->b[0x11A] = 0x32; /* ch+$11A: encoded base armour class (50 = AC 10) */
    ch->b[0x5A] = 0x28; /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
    ch->b[0x197] = 0; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    ch->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
    ch->b[0xD3] = 1; /* ch+$D3: shape/size on the combat map (bits 0-2, >1 large) */
    /* ch+$11C: identifier: random for PCs, NPC number (CPIC icons) */
    ch->b[0x11C] = (u8)random_below(0x100);
    ch->b[0x143] = 0x0A; /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */

    /* Razza. */
    menu_alloc(8, &list);
    list->header = 1;
    copy_text(list->text, "Pick Race", 0x28);
    for (race_i = 0; race_i <= 6; ++race_i) {
        node = menu_nth(list, (u16)(race_i + 1));
        copy_text(node->text, "  ", 0x28);
        h026_append(0x28, node->text, 0x0F,
                    /* $4D04: names of the races (+$5B), 16 bytes per entry */
                    (const char *)&g_h005[0x4D04 + race_i * 16]);
    }
    node = list;
    index = 1;
    redraw = 1;
    with_exit = 1;
    do {
        key = create_menu(list, with_exit, &redraw, &index, &node);
        if (key == 0) {
            menu_free(&list);
            free_character(&ch);
            return;
        }
    } while (key != 'S');
    ch->b[0x5B] = (u8)(index - 1); /* ch+$5B: race (0..6, names H005+$4D04) */
    switch (ch->b[0x5B]) { /* ch+$5B: race (0..6, names H005+$4D04) */
    case 5:                     /* H013+$0C0A */
        ch->b[0x144] = 1; /* ch+$144: icon size (1 small, 2 large) */
        add_effect(ch, 0x5C, 0, 0xFF, 0);
        add_effect(ch, 0x5E, 0, 0xFF, 0);
        break;
    case 3: case 4:             /* H013+$0C46 */
        ch->b[0x144] = 1; /* ch+$144: icon size (1 small, 2 large) */
        add_effect(ch, 0x5E, 0, 0xFF, 0);
        add_effect(ch, 0x1A, 0, 0xFF, 0);
        add_effect(ch, 0x2F, 0, 0xFF, 0);
        break;
    case 0: case 1:             /* H013+$0C9C */
        ch->b[0x144] = 2; /* ch+$144: icon size (1 small, 2 large) */
        add_effect(ch, 0x5F, 0, 0xFF, 0);
        break;
    case 2:                     /* H013+$0CBE */
        ch->b[0x144] = 2; /* ch+$144: icon size (1 small, 2 large) */
        add_effect(ch, 0x12, 0, 0xFF, 0);
        break;
    default:                    /* H013+$0CE0 */
        ch->b[0x144] = 2; /* ch+$144: icon size (1 small, 2 large) */
        break;
    }
    menu_free(&list);

    /* Sesso. */
    menu_alloc(3, &list);
    list->header = 1;
    copy_text(list->text, "Pick Gender", 0x28);
    for (g = 0; g <= 1; ++g) {
        node = menu_nth(list, (u16)(g + 1));
        copy_text(node->text, "  ", 0x28);
        h026_append(0x28, node->text, 6,
                    /* $4BD2: names of the sexes (+$10E), 8 bytes per entry */
                    (const char *)&g_h005[0x4BD2 + g * 8]);
    }
    node = list;
    index = 1;
    with_exit = 1;
    redraw = 1;
    do {
        key = create_menu(list, with_exit, &redraw, &index, &node);
        if (key == 0) {
            menu_free(&list);
            free_character(&ch);
            return;
        }
    } while (key != 'S');
    ch->b[0x10E] = (u8)(index - 1); /* ch+$10E: sex (0 male, 1 female; names H005+$4BD2) */
    menu_free(&list);

    /* Class: the classes allowed by the race (H005+$21FC). */
    race = ch->b[0x5B]; /* ch+$5B: race (0..6, names H005+$4D04) */
    /* $21FC: classes allowed per race (16 bytes): word number of classes */
    class_count = H005_W(0x21FC + race * 16);
    menu_alloc((u16)(class_count + 1), &list);
    list->header = 1;
    copy_text(list->text, "Pick Class", 0x28);
    for (i = 1; i <= class_count; ++i) {
        node = menu_nth(list, i);
        copy_text(node->text, "  ", 0x28);
        /* $4D84: names of the classes (+$5C), $1C bytes per entry */
        h026_append(0x28, node->text, 0x1A, (const char *)&g_h005[0x4D84 +
                    /* $21FD: classes allowed per race: from byte +2 the class numbers */
                    H005_B(0x21FC + race * 16 + 2 + i - 1) * 0x1C]);
        if (i == 0xFFFF) {
            break;
        }
    }
    node = list;
    index = 1;
    with_exit = 1;
    redraw = 1;
    do {
        key = create_menu(list, with_exit, &redraw, &index, &node);
        if (key == 0) {
            menu_free(&list);
            free_character(&ch);
            return;
        }
    } while (key != 'S');
    CH_PUTL(ch, 0x11E, 0); /* ch+$11E: experience points (long) */
    /* ch+$5C: class or class combination (0..16, names H005+$4D84); $21FD: classes allowed per
     * race: from byte +2 the class numbers; ch+$5B: race (0..6, names H005+$4D04) */
    ch->b[0x5C] = H005_B(0x21FC + ch->b[0x5B] * 16 + 2 + index - 1);
    /* ch+$5C: class or class combination (0..16, names H005+$4D84) */
    switch (ch->b[0x5C]) {      /* initial levels and experience */
    case 0:                     /* H013+$0FBC */
        ch->b[0xFE] = 1; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        break;
    case 6:                     /* H013+$0FC4 */
        ch->b[0x104] = 2; /* ch+$104: thief level */
        CH_PUTL(ch, 0x11E, 0x4E3); /* ch+$11E: experience points (long) */
        break;
    case 2:                     /* H013+$0FD6 */
        ch->b[0x100] = 2; /* ch+$100: fighter level */
        CH_PUTL(ch, 0x11E, 0x7D1); /* ch+$11E: experience points (long) */
        break;
    case 5:                     /* H013+$0FE8 */
        ch->b[0x103] = 2; /* ch+$103: mage level */
        CH_PUTL(ch, 0x11E, 0x1388); /* ch+$11E: experience points (long) */
        break;
    case 4:                     /* H013+$0FFA */
        ch->b[0x102] = 2; /* ch+$102: ranger level */
        CH_PUTL(ch, 0x11E, 0x8CB); /* ch+$11E: experience points (long) */
        add_effect(ch, 0x69, 0, 0xFF, 0);
        break;
    case 7:                     /* H013+$1026 */
        ch->b[0x105] = 1; /* ch+$105: knight level */
        CH_PUTL(ch, 0x11E, 0x9C4); /* ch+$11E: experience points (long) */
        ch->b[0x5D] = 1; /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
        break;
    case 8:                     /* H013+$103E */
        ch->b[0xFE] = 1; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        ch->b[0x100] = 1; /* ch+$100: fighter level */
        CH_PUTL(ch, 0x11E, 0x7D1); /* ch+$11E: experience points (long) */
        break;
    case 9:                     /* H013+$1056 */
        ch->b[0xFE] = 1; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        ch->b[0x100] = 1; /* ch+$100: fighter level */
        ch->b[0x103] = 1; /* ch+$103: mage level */
        CH_PUTL(ch, 0x11E, 0x1388); /* ch+$11E: experience points (long) */
        break;
    case 10:                    /* H013+$1074 */
        ch->b[0xFE] = 1; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        ch->b[0x102] = 1; /* ch+$102: ranger level */
        add_effect(ch, 0x69, 0, 0xFF, 0);
        CH_PUTL(ch, 0x11E, 0x8CB); /* ch+$11E: experience points (long) */
        break;
    case 11:                    /* H013+$10A6 */
        ch->b[0xFE] = 1; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        ch->b[0x103] = 1; /* ch+$103: mage level */
        CH_PUTL(ch, 0x11E, 0x1388); /* ch+$11E: experience points (long) */
        break;
    case 12:                    /* H013+$10BE */
        ch->b[0xFE] = 1; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        ch->b[0x104] = 1; /* ch+$104: thief level */
        break;
    case 13:                    /* H013+$10CC */
        ch->b[0x100] = 1; /* ch+$100: fighter level */
        ch->b[0x103] = 1; /* ch+$103: mage level */
        CH_PUTL(ch, 0x11E, 0x1388); /* ch+$11E: experience points (long) */
        break;
    case 14:                    /* H013+$10E4 */
        ch->b[0x100] = 1; /* ch+$100: fighter level */
        ch->b[0x104] = 1; /* ch+$104: thief level */
        CH_PUTL(ch, 0x11E, 0x7D1); /* ch+$11E: experience points (long) */
        break;
    case 15:                    /* H013+$10FC */
        ch->b[0x100] = 1; /* ch+$100: fighter level */
        ch->b[0x103] = 1; /* ch+$103: mage level */
        ch->b[0x104] = 1; /* ch+$104: thief level */
        CH_PUTL(ch, 0x11E, 0x1388); /* ch+$11E: experience points (long) */
        break;
    case 16:                    /* H013+$111A */
        ch->b[0x103] = 1; /* ch+$103: mage level */
        ch->b[0x104] = 1; /* ch+$104: thief level */
        CH_PUTL(ch, 0x11E, 0x1388); /* ch+$11E: experience points (long) */
        break;
    default:
        break;
    }
    if (ch->b[0x104] > 0) { /* ch+$104: thief level */
        thief_skills(ch);
    }
    ch->b[0x122] = 0; /* ch+$122: mask of the usable weapons (sum of H005+$5040 per class) */
    ch->b[0x5A] = 0; /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
    for (k = 0; k <= 7; ++k) {
        /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        if (ch->b[0xFE + k] > 0) {
            /* $5158: (word) +$5A value per class and level, $1A bytes per class; ch+$FE: levels
             * per class, 8 entries (0 cleric..7 knight); cleric */
            u16 t = H005_W(0x5158 + k * 0x1A + ch->b[0xFE + k] * 2);

            if (t > ch->b[0x5A]) { /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
                /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
                ch->b[0x5A] = (u8)t;
            }
            /* ch+$122: mask of the usable weapons (sum of H005+$5040 per class); $5040:
             * per-class bits added into +$122 (classes for the items) */
            add_to_byte(&ch->b[0x122], H005_B(0x5040 + k));
        }
    }
    saving_throws(ch);

    /* Deity (only with cleric levels). */
    if (ch->b[0xFE] > 0) { /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        menu_free(&list);
        if (ch->b[0x5B] == 3 || ch->b[0x5B] == 4) { /* ch+$5B: race (0..6, names H005+$4D04) */
            menu_alloc(2, &list);
            list->header = 1;
            copy_text(list->text, "Pick God", 0x28);
            node = menu_nth(list, 1);
            copy_text(node->text, "  ", 0x28);
            h026_append(0x28, node->text, 0x0B,
                        /* $4C4A: deity 6 (the only choice for races 3 and 4) */
                        (const char *)&g_h005[0x4C4A]);
        } else {
            menu_alloc(8, &list);
            list->header = 1;
            copy_text(list->text, "Pick God", 0x28);
            for (i = 1; i <= 7; ++i) {
                node = menu_nth(list, i);
                copy_text(node->text, "  ", 0x28);
                h026_append(0x28, node->text, 0x0B,
                            /* $4C02: names of the deities (+$5E), $0C bytes per entry */
                            (const char *)&g_h005[0x4C02 + (i & 0xFF) * 0x0C]);
            }
        }
        node = list;
        index = 1;
        with_exit = 1;
        redraw = 1;
        do {
            key = create_menu(list, with_exit, &redraw, &index, &node);
            if (key == 0) {
                menu_free(&list);
                free_character(&ch);
                return;
            }
        } while (key != 'S');
        if (ch->b[0x5B] == 3 || ch->b[0x5B] == 4) { /* ch+$5B: race (0..6, names H005+$4D04) */
            ch->b[0x5E] = 6; /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
        } else {
            /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
            ch->b[0x5E] = (u8)index;
        }
        /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
        switch (ch->b[0x5E]) {  /* allowed alignments and powers */
        case 1:                 /* H013+$1430 */
            god_mask = 0x15;
            ch->b[0xCA] = 1; /* ch+$CA: known spell no.101 (Prot. Evil 10'), power of deity 1 */
            break;
        case 2:                 /* H013+$1442 */
            god_mask = 0x15;
            ch->b[0xCB] = 1; /* ch+$CB: known spell no.102 (Silence 15'), power of deity 2 */
            break;
        case 3:                 /* H013+$1454 */
            god_mask = 0x15;
            ch->b[0xCC] = 1; /* ch+$CC: known spell no.103 (Detect Magic), power of deity 3 */
            /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
            add_to_byte(&ch->b[0x5A], 1);
            break;
        case 4:                 /* H013+$1478 */
            god_mask = 0x15;
            ch->b[0xCD] = 1; /* ch+$CD: known spell no.104 (Remove Curse), power of deity 4 */
            ch->b[0xCE] = 1; /* ch+$CE: known spell no.105 (Bless), power of deity 4 */
            ch->b[0xCF] = 1; /* ch+$CF: known spell no.106 (Charm Person), deities 4 and 7 */
            break;
        case 5:                 /* H013+$149E */
            god_mask = 0x2E;
            ch->b[0xD0] = 1; /* ch+$D0: known spell no.107 (Burning Hands), power of deity 5 */
            break;
        case 6:                 /* H013+$14B0 */
            god_mask = 0x2E;
            if (ch->b[0x5B] == 3 || ch->b[0x5B] == 4) { /* ch+$5B: race (0..6, names H005+$4D04) */
                /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
                add_to_byte(&ch->b[0x5A], 1);
            }
            break;
        case 7:                 /* H013+$14E6 */
            god_mask = 0x2E;
            ch->b[0xCF] = 1; /* ch+$CF: known spell no.106 (Charm Person), deities 4 and 7 */
            break;
        default:
            /*
             * Unexpected value: the original leaves -$66(a5) as it was
             * on the stack.  Here 0 (no alignment allowed).
             */
            god_mask = 0;
            break;
        }
    } else {
        ch->b[0x5E] = 0; /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
        god_mask = 0xFF;
    }
    menu_free(&list);

    /* Alignment: those allowed by class (H005+$1F78) and deity. */
    list = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem), COK_MEMF_CLEAR);
    list->next = NULL;
    list->header = 1;
    copy_text(list->text, "Pick Alignment", 0x28);
    node = list;
    j = 0;
    for (i = 0; i <= 5; ++i) {
        bits = (u16)(u8)(mask_byte((u8)god_mask,
                                   /* $1F78: alignments allowed per class (word, 6-bit mask); ch+$5C: class or class combination
                                    * (0..16, names H005+$4D84) */
                                   H005_W(0x1F78 + ch->b[0x5C] * 2)) >> i);
        if (mask_byte((u8)bits, 1)) {
            node->next = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                    COK_MEMF_CLEAR);
            node = node->next;
            node->next = NULL;
            node->header = 0;
            copy_text(node->text, "  ", 0x28);
            /* $4C62: names of the alignments (+$10F), $12 bytes per entry */
            h026_append(0x28, node->text, 0x10, (const char *)&g_h005[0x4C62 +
                        align_values[i] * 0x12]);
            align_ids[j] = align_values[i];
            ++j;
        }
    }
    node = list;
    index = 1;
    with_exit = 1;
    redraw = 1;
    do {
        key = create_menu(list, with_exit, &redraw, &index, &node);
        if (key == 0) {
            menu_free(&list);
            free_character(&ch);
            return;
        }
    } while (key != 'S');
    ch->b[0x10F] = align_ids[index - 1]; /* ch+$10F: alignment (0..8, evil 2/5/8; names H005+$4C62) */
    switch (ch->b[0x10F]) { /* ch+$10F: alignment (0..8, evil 2/5/8; names H005+$4C62) */
    case 0: case 3: case 6:     /* H013+$171E */
        /* ch+$11E: experience points (long); ch+$FE: levels per class, 8 entries (0 cleric..7
         * knight); cleric */
        if (CH_L(ch, 0x11E) == 0 && ch->b[0xFE] > 0) {
            CH_PUTL(ch, 0x11E, 0x7D0); /* ch+$11E: experience points (long) */
        }
        if (ch->b[0x103] > 0) { /* ch+$103: mage level */
            ch->b[0x5F] = 1; /* ch+$5F: mage order (1 alignm. 0/3/6, 2 for 1/4/7, 0 none) */
        }
        break;
    case 1: case 4: case 7:     /* H013+$175C */
        /* ch+$11E: experience points (long); ch+$FE: levels per class, 8 entries (0 cleric..7
         * knight); cleric */
        if (CH_L(ch, 0x11E) == 0 && ch->b[0xFE] > 0) {
            CH_PUTL(ch, 0x11E, 0x5DC); /* ch+$11E: experience points (long) */
        }
        if (ch->b[0x103] > 0) { /* ch+$103: mage level */
            ch->b[0x5F] = 2; /* ch+$5F: mage order (1 alignm. 0/3/6, 2 for 1/4/7, 0 none) */
        }
        break;
    default:
        break;
    }
    menu_free(&list);

    /* Age (+$62): rolled for one class, the maximum for multi-class characters. */
    if (ch->b[0x5C] <= 7) { /* ch+$5C: class or class combination (0..16, names H005+$4D84) */
        /* ch+$5B: race (0..6, names H005+$4D04); ch+$5C: class or class combination (0..16,
         * names H005+$4D84) */
        u16 row = (u16)(0x20AC + ch->b[0x5B] * 0x30 + ch->b[0x5C] * 6);

        /* ch+$62: age (word); row: age row $20AC: +0 base, +2 dice, +4 sides */
        CH_PUTW(ch, 0x62, roll_dice(H005_W(row + 2), H005_W(row + 4)) +
                          H005_W(row));
    } else {
        switch (ch->b[0x5C]) { /* ch+$5C: class or class combination (0..16, names H005+$4D84) */
        case 8: case 9: case 10: case 11: case 12:
            /* ch+$5B: race (0..6, names H005+$4D04); ch+$62: age (word) */
            CH_PUTW(ch, 0x62, max_age(ch->b[0x5B], 0));
            break;
        case 13: case 15: case 16:
            /* ch+$5B: race (0..6, names H005+$4D04); ch+$62: age (word) */
            CH_PUTW(ch, 0x62, max_age(ch->b[0x5B], 5));
            break;
        case 14:
            /* ch+$5B: race (0..6, names H005+$4D04); ch+$62: age (word) */
            CH_PUTW(ch, 0x62, max_age(ch->b[0x5B], 2));
            break;
        default:
            break;
        }
    }

    saved = g_current_char;
    g_current_char = ch;
    draw_character_sheet();
    do {
        for (k = 0; k <= 7; ++k) {
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            if (g_current_char->b[0xFE + k] > 0) {
                /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
                g_current_char->b[0xFE + k] = 1;
            }
        }
        ch->b[0x1C] = 0; /* ch+$1C: current exceptional strength (18/xx, 1..100) */

        /*
         * Abilities: the best of 6 rolls of 3d6+1 for each one.  The
         * race adjustments depend on -$20(a5), which is always 7 here
         * (the counter of the race menu): in the original they are never
         * applied.
         */
        for (s = 0; s <= 5; ++s) {
            /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
            ch->b[0x10 + s * 2 + 1] = 0;
            for (j = 1; j <= 6; ++j) {
                roll = (u16)(roll_dice(3, 6) + 1);
                switch (race_i) {
                case 0: case 1:
                    if (s == 3) {
                        ++roll;
                    } else if (s == 4) {
                        --roll;
                    }
                    break;
                case 2:
                    if (s == 3) {
                        roll = (u16)(roll + 2);
                    }
                    break;
                case 3: case 4:
                    if (s == 4) {
                        ++roll;
                    } else if (s == 5) {
                        --roll;
                    }
                    break;
                case 5:
                    if (s == 0) {
                        --roll;
                    } else if (s == 3) {
                        roll = (u16)(roll + 2);
                    }
                    break;
                default:
                    break;
                }
                /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
                if (ch->b[0x11 + s * 2] < roll) {
                    /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
                    ch->b[0x11 + s * 2] = (u8)roll;
                }
            }
            adjust_stat(ch, s);
            /* pg+$10: caratteristiche base, 6 voci passo 2 (FOR INT SAG DES COS CAR); FOR; ch+$11:
             * current abilities, 6 entries step 2 from +$11; current strength */
            ch->b[0x10 + s * 2] = ch->b[0x11 + s * 2];
            if (s == 0) {
                /* ch+$1D: base exceptional strength; ch+$1C: current exceptional strength
                 * (18/xx, 1..100) */
                ch->b[0x1D] = ch->b[0x1C];
            }
            draw_stat_value(s, 0);
        }

        ch->b[0x1A8] = ch->b[0x64]; /* ch+$1A8: current hit points; ch+$64: maximum hit points */
        ch->b[0x110] = 2; /* ch+$110: attacks every 2 rounds of attack 1 (2 = 1/round, 3 = 3/2) */
        ch->b[0x112] = 1; /* ch+$112: number of base dice of attack 1 (2 entries +$112..+$113) */
        ch->b[0x114] = 2; /* ch+$114: sides of the base die of attack 1 (2 entries +$114..+$115) */
        ch->b[0x11B] = 1; /* ch+$11B: applies the strength bonuses to hit and to damage (1 for PCs) */
        ch->b[0xDA] = 0x0C; /* ch+$DA: base movement (12 at creation) */
        nclasses = 0;           /* -$2e(a5) is cleared but not used */
        gold = 0;
        /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
        h029_fill_bytes(0x17, &ch->b[0x124], 0x17, 0);
        for (k = 0; k <= 7; ++k) {
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            if (ch->b[0xFE + k] == 0) {
                continue;
            }
            switch (k) {
            case 0:             /* H013+$26DC */
                /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1; ch+$5E: deity
                 * of the cleric (0 none, 1..7; 6 for races 3-4) */
                ch->b[0x124] = (u8)(ch->b[0x5E] <= 4 ? 1 : 2);
                break;
            case 5:             /* H013+$26FC */
                ch->b[0x136] = 1; /* ch+$136: level 1 mage spell slots */
                break;
            default:
                break;
            }
            switch (k) {        /* initial money */
            case 0:             /* H013+$2766 */
                gold = (u16)(gold + roll_dice(3, 6));
                cleric_spell_slots(ch);
                i = 1;
                j = 0xFF;
                while (i <= 0x0A && j != 0) {
                    /* $1476: inc. per class/level: 3x4 rows of 10 words ($14), 0 = end */
                    j = H005_W(0x1476 + (i - 1) * 2);
                    if (j != 0) {
                        /* ch+$65: base -1 of the known spells +$66+s-1 (s = 1..$6B, flag
                         * per spell) */
                        ch->b[0x66 + j - 1] = 1;
                    }
                    ++i;
                }
                break;
            case 2: case 4:     /* H013+$274C */
                gold = (u16)(gold + roll_dice(5, 4));
                break;
            case 5:             /* H013+$27DE */
                gold = (u16)(gold + roll_dice(2, 4));
                ch->b[0x70] = 1; /* ch+$70: known spell no.11 (Detect Magic), initial for the mage */
                ch->b[0x77] = 1; /* ch+$77: known spell no.18 (Read Magic), initial for the mage */
                ch->b[0x71] = 1; /* ch+$71: known spell no.12 (Enlarge), initial for the mage */
                ch->b[0x74] = 1; /* ch+$74: known spell no.15 (Magic Missile), initial mage/level 2 */
                ch->b[0x7A] = 1; /* ch+$7A: known spell no.21 (Sleep), initial for the mage */
                break;
            case 6:             /* H013+$2816 */
                gold = (u16)(gold + roll_dice(2, 6));
                break;
            case 7:             /* H013+$2734 */
                gold = roll_dice(1, 4);
                break;
            default:
                break;
            }
            ++nclasses;
        }
        /* On loop exit k is 8: the division is always done. */
        if (k != 7) {
            gold = (u16)((gold / nclasses) * 5);
        }
        CH_PUTW(ch, 0xF8, gold); /* ch+$F8: steel pieces (coin type 4) (word) */
        ch->b[0x64] = 0; /* ch+$64: maximum hit points */
        ch->b[0x123] = 0; /* ch+$123: maximum HP without constitution; base -1 of the spell slots +$124 */
        ch->b[0x1A8] = 0; /* ch+$1A8: current hit points */
        roll_hit_points(ch, 0xFF, nclasses);

        /* B+$550: (word) mask of the classes that can be trained here (0 none) */
        saved_550 = COK_GET16(g_state_b + 0x550);
        /* B+$550: (word) mask of the classes that can be trained here (0 none) */
        COK_PUT16(g_state_b + 0x550, 0xFF);
        H005_B(0x24DF) = 0; /* $24DF: 1 when Train has no more classes to raise */
        H005_B(0x24CF) = 1; /* $24CF: 1 during creation: Train without messages or questions */
        do {
            train_character();
        } while (!H005_B(0x24DF)); /* $24DF: 1 when Train has no more classes to raise */
        /* B+$550: (word) mask of the classes that can be trained here (0 none) */
        COK_PUT16(g_state_b + 0x550, saved_550);
        H005_B(0x24CF) = 0; /* $24CF: 1 during creation: Train without messages or questions */

        /* Levels per class, "n/n/n", on row 7. */
        sep = 0;
        copy_text(line, "", 0x28);
        for (k = 0; k <= 7; ++k) {
            Character *c = g_current_char;

            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            if (c->b[0xFE + k] > 0 ||
                /* ch+$106: levels of the previous class, 8 entries like +$FE; cleric */
                (c->b[0x106 + k] < h073_12c8(c) && c->b[0x106 + k] > 0)) {
                if (sep) {
                    h026_append(0x28, line, 1, "/");
                }
                format_number(0x50, s_message,
                              /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; ch+$106: levels of the
                               * previous class, 8 entries like +$FE; cleric */
                              (s32)(u16)(c->b[0xFE + k] + c->b[0x106 + k]),
                              0, 0x0A, 2, ' ');
                h026_append(0x28, line, 0x50, s_message);
                sep = 1;
            }
        }
        ui_draw_text(7, 7, 0x0F, 0, 0x28, line);
        draw_combat_values();
        draw_character_money();
        key = ask_yes_no(0x0E, "Reroll stats? ", 0x0D, 0x0A, 0x0F);
    } while (key != 'N');

    draw_character_sheet();
    do {
        input_line(0x10, "Character name: ", 0x0D, 0, 0x0F, 0x0F,
                   (char *)ch->b);
    } while (ch->b[0] == 0); /* ch+$0: name of the character (15 characters, terminated at +$0F) */
    load_char_screens();
    set_default_figure();
    edit_character_icon();
    for (s = 0; s <= 5; ++s) {
        /* pg+$10: caratteristiche base, 6 voci passo 2 (FOR INT SAG DES COS CAR); FOR; ch+$11:
         * current abilities, 6 entries step 2 from +$11; current strength */
        ch->b[0x10 + s * 2] = ch->b[0x11 + s * 2];
    }
    /* ch+$1D: base exceptional strength; ch+$1C: current exceptional strength (18/xx, 1..100) */
    ch->b[0x1D] = ch->b[0x1C];
    copy_text(s_message, "Save ", 0x50);
    h026_append(0x50, s_message, 0x0F, (const char *)ch->b);
    h026_append(0x50, s_message, 2, "? ");
    key = ask_yes_no(0x50, s_message, 0x0D, 0x0A, 0x0F);
    if (key == 'N') {
        free_character(&ch);
        g_current_char = saved;
        return;
    }
    if (ch->b[0x105] > 0) { /* ch+$105: knight level */
        add_starting_items(ch);
    }
    save_character(ch, 0, "");
    free_character(&ch);
    g_current_char = saved;
}

/* Experience (long) of the table H005+$1946 for row row and index i. */
static s32 xp_table(u8 row, s16 i)
{
    /* $1946: per-class tables ($9A bytes): 11 long XP thresholds, then slots per lvl. */
    return (s32)H005_L((u16)(0x1946 + row * 0x9A + i * 4));
}

/* PORT H013+$051C: trampoline (bra.w) to H013+$58DC, the routine below. */
/*
 * PORT H013+$58DC (trampoline H013+$051C): Train Character.  The classes
 * with enough experience (H005+$1946) and trainable here (mask
 * of state B +$550) go up one level after confirmation; then derived
 * values, new mage spell and hit points.  During
 * creation ($24CF) there are no messages or questions and, when no
 * class can go up, $24DF = 1.  With free training ($24DE) no
 * experience is needed.
 */
void train_character(void)
{
    Character *c;                       /* a3 */
    s32 next_xp;                        /* -$6(a5) */
    s32 xp;                             /* -$a(a5) */
    s32 best;                           /* -$2e(a5) */
    u16 eligible = 0;                   /* -$c(a5) */
    u16 classes = 0;                    /* -$e(a5) */
    u16 train = 0;                      /* -$10(a5) */
    u16 nclasses;                       /* -$12(a5) */
    u16 row;                            /* -$1e(a5) */
    u16 spell;                          /* -$24(a5) */
    s16 spell_value;                    /* -$26(a5) */
    u16 allowed;                        /* -$2a(a5) */
    u8 again = 0;                       /* -$27(a5) */
    u8 blocked;                         /* -$1(a5) */
    u8 k;                               /* -$19(a5) */
    u8 old_103;                         /* -$1f(a5) */
    u8 old_102;                         /* -$20(a5) */
    u8 lvl = 0;                         /* -$21(a5) */
    u8 best_k = 0;                      /* -$2f(a5) */
    u8 xp_row = 0;                      /* -$30(a5) */

    /* $24CF: 1 during creation: Train without messages or questions */
    if (!H005_B(0x24CF) && !pick_character()) {
        return;
    }
    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down; $24DE: free training
     * (cheat "Free training") */
    if (g_current_char->b[0x197] != 0 && !H005_B(0x24DE)) {
        show_message(0x1E, "we only train conscious people", 0x0E, 0);
        return;
    }
    /* B+$550: (word) mask of the classes that can be trained here (0 none) */
    allowed = COK_GET16(g_state_b + 0x550);
    c = g_current_char;
    next_xp = 0;
    for (k = 0; k <= 7; ++k) {
        s32 need;

        /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        if (c->b[0xFE + k] == 0) {
            continue;
        }
        /* $5038: bit of class k (0..7) in the class mask */
        classes = (u16)(classes + H005_B(0x5038 + k));
        blocked = 0;
        lvl = c->b[0xFE + k]; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        if (c->b[0x5B] == 5 && (k == 2 || k == 4)) { /* ch+$5B: race (0..6, names H005+$4D04) */
            /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
            if (lvl == 7 || (lvl == 6 && c->b[0x11] == 0x11) ||
                /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
                (lvl == 5 && c->b[0x11] < 0x11)) {
                blocked = 1;
            }
        }
        xp_row = class_xp_row(g_current_char, k);
        if (blocked) {
            continue;
        }
        need = xp_table(xp_row, (s16)((u8)(lvl + 1) - 2));
        /* ch+$11E: experience points (long); $24DE: free training (cheat "Free training") */
        if (!((s32)CH_L(c, 0x11E) >= need || H005_B(0x24DE)) || need <= 0) {
            continue;
        }
        /* $24DE: free training (cheat "Free training"); ch+$11E: experience points (long) */
        if (H005_B(0x24DE) && (u16)need != 0 && (s32)CH_L(c, 0x11E) < need) {
            CH_PUTL(c, 0x11E, need); /* ch+$11E: experience points (long) */
        }
        /* $5038: bit of class k (0..7) in the class mask */
        eligible = (u16)(eligible + H005_B(0x5038 + k));
        xp = xp_table(xp_row, (s16)((u8)(lvl + 2) - 2));
        if (xp > 0 && (s32)CH_L(c, 0x11E) >= xp && xp > next_xp) { /* ch+$11E: experience points (long) */
            next_xp = xp - 1;
        }
    }
    if (!H005_B(0x24CF)) { /* $24CF: 1 during creation: Train without messages or questions */
        /*
         * As in the original the row and the level are the ones left
         * from the last class of the previous loop.
         */
        best = 0;
        for (k = 0; k <= 7; ++k) {
            /* $5038: bit of class k (0..7) in the class mask */
            if (mask_byte((u8)eligible, H005_B(0x5038 + k)) &&
                best < xp_table(xp_row, (s16)((u8)(lvl + 1) - 2))) {
                best = xp_table(xp_row, (s16)((u8)(lvl + 1) - 2));
                best_k = k;
            }
            if (best > 0) {
                /* $5038: bit of class k (0..7) in the class mask */
                eligible = or_byte(H005_B(0x5038 + best_k), eligible);
                xp = xp_table(xp_row, (s16)((u8)(lvl + 2) - 2));
                /* ch+$11E: experience points (long) */
                if (xp > 0 && (s32)CH_L(c, 0x11E) >= xp && xp > next_xp) {
                    next_xp = xp - 1;
                }
            }
        }
    }
    /* $24CF: 1 during creation: Train without messages or questions */
    if (next_xp > 0 && !H005_B(0x24CF)) {
        CH_PUTL(c, 0x11E, next_xp); /* ch+$11E: experience points (long) */
    }
    if (!H005_B(0x24DE)) { /* $24DE: free training (cheat "Free training") */
        /* $24CF: 1 during creation: Train without messages or questions */
        if (!mask_byte((u8)classes, allowed) && !H005_B(0x24CF)) {
            show_message(0x1E, "We don't train that class here", 0x0E, 0);
            return;
        }
        if (!mask_byte((u8)eligible, allowed)) {
            H005_B(0x24DF) = 1; /* $24DF: 1 when Train has no more classes to raise */
            if (!H005_B(0x24CF)) { /* $24CF: 1 during creation: Train without messages or questions */
                show_message(0x15, "Not Enough Experience", 0x0E, 0);
            }
            return;
        }
        train = mask_byte((u8)eligible, allowed);
    } else {
        train = eligible;
    }
    if (!H005_B(0x24CF)) { /* $24CF: 1 during creation: Train without messages or questions */
        clear_text_cells(1, 1, 0x26, 0x16);
        row = 4;
        draw_character_name(g_current_char, 4, row, 0);
        ui_draw_text((u16)(h026_strlen(0x0F, (const char *)c->b) + 4), row,
                     0x0A, 0, 0x0D, " will become:");
        for (k = 0; k <= 7; ++k) {
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            if (c->b[0xFE + k] == 0 ||
                /* $5038: bit of class k (0..7) in the class mask */
                !mask_byte(H005_B(0x5038 + k), train)) {
                continue;
            }
            ++row;
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            format_number(0x50, s_message, (s32)(u16)(c->b[0xFE + k] + 1), 0,
                          0x0A, 1, ' ');
            if (row == 5) {
                h026_insert(0x50, s_message, 0x0C, "    a level ", 0);
            } else {
                h026_insert(0x50, s_message, 0x0C, "and a level ", 0);
            }
            h026_append(0x50, s_message, 1, " ");
            h026_append(0x50, s_message, 0x1A,
                        /* $4D84: names of the classes (+$5C), $1C bytes per entry */
                        (const char *)&g_h005[0x4D84 + k * 0x1C]);
            ui_draw_text(6, row, 0x0A, 0, 0x50, s_message);
        }
        if (ask_yes_no(0x16, "Do you wish to train? ", 0x0D, 0x0A, 0x0F) !=
            'Y') {
            return;
        }
        show_message_line(0x12, "Congratulations...");
    }

    nclasses = 0;
    old_103 = c->b[0x103]; /* ch+$103: mage level */
    old_102 = c->b[0x102]; /* ch+$102: ranger level */
    c->b[0x122] = 0; /* ch+$122: mask of the usable weapons (sum of H005+$5040 per class) */
    for (k = 0; k <= 7; ++k) {
        /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        if (c->b[0xFE + k] == 0) {
            continue;
        }
        ++nclasses;
        /* $5038: bit of class k (0..7) in the class mask */
        if (mask_byte(H005_B(0x5038 + k), train)) {
            ++c->b[0xFE + k]; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            /* ch+$DD: use: counter decremented at every level in Train (divisor of +$DE) */
            if (c->b[0xDD] > 0) {
                /* ch+$DE: use: in Train it loses +$DE/+$DD at every level gained */
                add_to_byte(&c->b[0xDE], (u16)-(s16)((s16)c->b[0xDE] /
                                                     /* ch+$DD: use: counter decremented at every level in Train (divisor of +$DE) */
                                                     (s16)c->b[0xDD]));
                /* ch+$DD: use: counter decremented at every level in Train (divisor of +$DE) */
                add_to_byte(&c->b[0xDD], 0xFFFF);
            }
        }
    }
    level_derived_values(g_current_char);
    /* $24CF: 1 during creation: Train without messages or questions; ch+$103: mage level;
     * ch+$102: ranger level */
    if (!H005_B(0x24CF) && (c->b[0x103] > old_103 || c->b[0x102] > 8)) {
        spell_value = -1;               /* $FFFF */
        do {
            spell = choose_spell_of_kind(4, 4, &spell_value, &again);
        } while (spell == 0 && again);
        if (spell > 0) {
            /* ch+$65: base -1 of the known spells +$66+s-1 (s = 1..$6B, flag per spell) */
            c->b[0x66 + spell - 1] = 1;
        }
    }
    (void)old_102;
    if (H005_B(0x24CF)) { /* $24CF: 1 during creation: Train without messages or questions */
        /* ch+$103: mage level */
        switch (c->b[0x103]) {  /* mage spells per level */
        case 2:
            c->b[0x74] = 1; /* ch+$74: known spell no.15 (Magic Missile), initial mage/level 2 */
            break;
        case 3:
            c->b[0x87] = 1; /* ch+$87: known spell no.34 (Stinking Cloud), level 3 mage */
            c->b[0x6F] = 1; /* ch+$6F: known spell no.10 (Charm Person), given to the level 3 mage */
            break;
        case 4:
            c->b[0x84] = 1; /* ch+$84: known spell no.31 (Knock), given to the level 4 mage */
            break;
        case 5:
            c->b[0x94] = 1; /* ch+$94: known spell no.47 (Fireball), given to the level 5 mage */
            break;
        default:
            break;
        }
    }
    /* ch+$DB: highest level among the classes (also used as hit dice); ch+$DC: use: threshold for
     * the levels +$106..+$10D and the HP; !=0 forbids Modify */
    if (c->b[0xDB] > c->b[0xDC]) {
        roll_hit_points(g_current_char, train, nclasses);
    }
    c = g_current_char;
    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] > 1) { /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            s32 v;

            xp_row = class_xp_row(g_current_char, k);
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            v = xp_table(xp_row, (s16)(c->b[0xFE + k] - 2));
            if (v > (s32)CH_L(c, 0x11E)) { /* ch+$11E: experience points (long) */
                CH_PUTL(c, 0x11E, v); /* ch+$11E: experience points (long) */
            }
        }
    }
}

/* Evil alignment: (alignment + 1) multiple of 3 (2, 5, 8). */
static u8 is_evil(const Character *c)
{
    /* ch+$10F: alignment (0..8, evil 2/5/8; names H005+$4C62) */
    return (u8)((u16)(c->b[0x10F] + 1) % 3 == 0);
}

/* PORT H013+$0518: trampoline (bra.w) to H013+$52E0, the routine below. */
/*
 * PORT H013+$52E0 (trampoline H013+$0518): Add Character to Party.
 * List of the saved characters (H066+$03D0); the chosen one is loaded,
 * marked with "* " and added if it is not already in the party, if the party is not
 * full (6 player characters, 8 in all) and if paladins, rangers
 * (at most 3) and evil alignments are compatible; otherwise the
 * mark is removed, with the message giving the reason.  Until Esc/Exit or a full
 * party.  The rejected character frees only the record, as
 * in the original (the loaded items and effects stay allocated).
 */
void add_character_to_party(void)
{
    CokMenuItem *names = NULL;          /* -$4(a5) */
    CokMenuItem *files = NULL;          /* -$8(a5) */
    CokMenuItem *chosen;                /* -$c(a5) */
    CokMenuItem *file_node;             /* -$10(a5) */
    Character *c;                       /* -$14(a5) */
    Character *m;                       /* -$18(a5) */
    char paladin_name[0x2A];            /* -$4e(a5) */
    u16 index;                          /* -$1a(a5) */
    u16 members = 0;                    /* -$22(a5): in the original not
                                         * initialised before the first
                                         * choice; here 0 */
    u16 rangers = 0;                    /* -$24(a5) */
    u8 key;                             /* -$1b(a5) */
    u8 has_evil = 0;                    /* -$1c(a5) */
    u8 has_paladin = 0;                 /* -$1d(a5) */
    u8 with_exit = 0;                   /* -$1e(a5): not initialised
                                         * in the original; here 0 */
    u8 redraw;                          /* -$20(a5) */

    paladin_name[0] = 0;
    H005_B(0x24E9) = 0; /* $24E9: type of the saved characters (0: $1AA record); 0 skips the disk */
    list_saved_characters(&names, &files);
    if (names == NULL) {
        return;
    }
    index = 0;
    chosen = names;
    redraw = 1;
    do {
        key = list_menu(0x11, "Add a character: ", 4, "Add ", 0x0D, 0x0A,
                        0x0F, 1, 2, 0x26, 0x16, names, with_exit, &redraw,
                        &index, &chosen);
        if ((key == 0x0D || key == 'A') && chosen->text[0] != '#') {
            clear_message_line();
            c = (Character *)exec_alloc_mem(sizeof(Character),
                                            COK_MEMF_CLEAR);
            file_node = menu_nth(files, index);
            load_character(0x28, file_node->text, c, 0, 1);
            h026_insert(0x28, chosen->text, 2, "* ", 0);
            members = 0;
            if (g_party_head == NULL) {
                COK_PUT16(g_state_b + 0x67C, 0); /* B+$67C: (word) number of party members (max 8) */
                add_to_party(c);
                build_char_icon(1);
            } else {
                rangers = 0;
                for (m = g_party_head; m != NULL; m = m->next) {
                    if (h026_compare_nocase(0x0F, (const char *)m->b, 0x0F,
                                            (const char *)c->b) == 1 &&
                        /* ch+$11C: identifier: random for PCs, NPC number (CPIC icons) */
                        m->b[0x11C] == c->b[0x11C]) {
                        break;          /* already in the party */
                    }
                    /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
                    if (m->b[0xEC] < 0x80) {
                        ++members;
                    }
                    if (m->b[0x102] > 0) { /* ch+$102: ranger level */
                        ++rangers;
                    }
                    if (is_evil(m)) {
                        has_evil = 1;
                    }
                    if (m->b[0x101] > 0) { /* ch+$101: paladin level */
                        has_paladin = 1;
                        h026_copy(0x28, paladin_name, 0x0F,
                                  (const char *)m->b);
                    }
                }
                if (m == NULL &&
                    /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
                    ((c->b[0xEC] < 0x80 && members < 6) ||
                     /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
                     (c->b[0xEC] > 0x7F &&
                      /* B+$67C: (word) number of party members (max 8) */
                      COK_GET16(g_state_b + 0x67C) < 8)) &&
                    !(c->b[0x101] != 0 && has_evil) && /* ch+$101: paladin level */
                    !(c->b[0x102] != 0 && rangers >= 3) && /* ch+$102: ranger level */
                    !(is_evil(c) && has_paladin)) {
                    add_to_party(c);
                    build_char_icon(1);
                    /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
                    if (c->b[0xEC] < 0x80) {
                        ++members;
                    }
                } else {
                    h026_delete(0x28, chosen->text, 0, 2);
                    if (c->b[0x101] > 0 && has_evil) { /* ch+$101: paladin level */
                        show_message_line(0x23,
                            "paladins do not join with evil scum");
                        message_delay();
                    } else if (c->b[0x102] > 0 && rangers > 2) { /* ch+$102: ranger level */
                        show_message_line(0x19, "too many rangers in party");
                    } else if (is_evil(c) && has_paladin) {
                        h026_copy(0x50, s_message, 0x28, paladin_name);
                        h026_append(0x50, s_message, 0x17,
                                    " will tolerate no evil!");
                        show_message_line(0x50, s_message);
                    }
                    exec_free_mem(c, sizeof(Character));
                }
            }
        }
    } while (key != 'E' && key != 0 && members <= 5 &&
             COK_GET16(g_state_b + 0x67C) <= 7); /* B+$67C: (word) number of party members (max 8) */
    menu_free(&names);
    menu_free(&files);
}
