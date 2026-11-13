/* H065: UI of characters, items, equipment and spells. */
#include "h065.h"
#include "h003_exec.h"
#include "h029_gfx.h"
#include "h033.h"
#include "h008.h"
#include "unported.h"
#include "character.h"
#include "h026_string.h"
#include "h030.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h062.h"
#include "h063.h"
#include "h073.h"
#include "globals.h"
#include "h067.h"
#include "h015_runtime.h"

/* PORT H065+$04AA: link/unlk, no effect. */
void h065_init(void)
{
}

/* Module data below a4. */
static Character *s_char;               /* -$4(a4): character shown */
static char s_text[0x56];               /* -$5a(a4) */

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

/*
 * PORT H065+$04B8: screen of the current character: frame, name,
 * status, sex and age, alignment, race, class (with deity,
 * knightly order), levels, experience, abilities, money,
 * combat values and items of slots 0 and 2.
 */
void draw_character_sheet(void)
{
    char line[0x51];                    /* -$5c(a5) */
    char num[0x51];                     /* -$ae(a5) */
    u8 sep;                             /* -$af(a5) */
    u16 pos;                            /* -$8(a5) */
    u8 k;                               /* -$a(a5) */
    u8 s;                               /* -$9(a5) */
    Character *c;

    s_char = g_current_char;
    c = s_char;
    draw_character_frame();
    draw_character_name(c, 1, 1, 0);
    ui_draw_text(0x14, 1, 0x0F, 0, 9, "Status : ");
    ui_draw_text(0x1B, 1, 0x0A, 0, 0x0C,
                 /* $4B00: names of the character status (+$197), $0E bytes; ECL var base; ch+$197: status: 0
                  * ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                 (const char *)&g_h005[0x4B00 + c->b[0x197] * 0x0E]);
    /* $4BD2: names of the sexes (+$10E), 8 bytes per entry; ch+$10E: sex (0 male, 1 female;
     * names H005+$4BD2) */
    h026_copy(0x50, line, 6, (const char *)&g_h005[0x4BD2 + c->b[0x10E] * 8]);
    ui_draw_text(1, 3, 0x0F, 0, 0x50, line);
    format_number(0x50, line, CH_W(c, 0x62), 0, 0x0A, 4, ' '); /* ch+$62: age (word) */
    h026_append(0x50, line, 6, " years");
    ui_draw_text(8, 3, 0x0F, 0, 0x50, line);
    h026_copy(0x50, line, 0x10,
              /* $4C62: names of the alignments (+$10F), $12 bytes per entry; ch+$10F: alignment
               * (0..8, evil 2/5/8; names H005+$4C62) */
              (const char *)&g_h005[0x4C62 + c->b[0x10F] * 0x12]);
    ui_draw_text(1, 4, 0x0F, 0, 0x50, line);
    h026_copy(0x50, line, 0x0F,
              /* $4D04: names of the races (+$5B), 16 bytes per entry; ch+$5B: race (0..6,
               * names H005+$4D04) */
              (const char *)&g_h005[0x4D04 + c->b[0x5B] * 16]);
    ui_draw_text(0x14, 4, 0x0F, 0, 0x50, line);
    h026_copy(0x50, line, 0x1A,
              /* $4D84: names of the classes (+$5C), $1C bytes per entry; ch+$5C: class or class
               * combination (0..16, names H005+$4D84) */
              (const char *)&g_h005[0x4D84 + c->b[0x5C] * 0x1C]);
    if (c->b[0xFE] > 0) { /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        h026_insert(0x50, line, 1, " ", 0);
        h026_insert(0x50, line, 0x0B,
                    /* $4C02: names of the deities (+$5E), $0C bytes per entry; ch+$5E: deity of
                     * the cleric (0 none, 1..7; 6 for races 3-4) */
                    (const char *)&g_h005[0x4C02 + c->b[0x5E] * 0x0C], 0);
    }
    if (c->b[0x103] > 0) { /* ch+$103: mage level */
        /* Before "Mage" (or at the end): the knightly order. */
        pos = 0;
        while (!(line[pos] == 'M' && line[pos + 2] == 'g') &&
               pos <= h026_strlen(0x50, line)) {
            ++pos;
        }
        h026_insert(0x50, line, 1, " ", pos);
        h026_insert(0x50, line, 6,
                    /* $4BE2: names of the knightly orders (+$5F), 8 bytes per entry; ch+$5F: mage order
                     * (1 alignm. 0/3/6, 2 for 1/4/7, 0 none) */
                    (const char *)&g_h005[0x4BE2 + c->b[0x5F] * 8], pos);
    }
    if (c->b[0x105] > 0) { /* ch+$105: knight level */
        switch (c->b[0x5D]) { /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
        case 1:
            h026_append(0x50, line, 0x0D, " of the Crown");
            break;
        case 2:
            h026_append(0x50, line, 0x0D, " of the Sword");
            break;
        case 3:
            h026_append(0x50, line, 0x0C, " of the Rose");
            break;
        default:
            break;
        }
    }
    ui_draw_text(1, 5, 0x0F, 0, 0x50, line);
    ui_draw_text(1, 7, 0x0F, 0, 5, "Level");

    sep = 0;
    copy_text(line, "", 0x50);
    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] > 0 || /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            /* ch+$106: levels of the previous class, 8 entries like +$FE; cleric */
            (c->b[0x106 + k] < h073_12c8(c) && c->b[0x106 + k] > 0)) {
            if (sep) {
                h026_append(0x50, line, 1, "/");
            }
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            format_number(0x50, num, c->b[0xFE + k], 0, 0x0A, 1, '0');
            h026_append(0x50, line, 0x50, num);
            sep = 1;
        }
    }
    ui_draw_text(7, 7, 0x0F, 0, 0x50, line);
    format_number(0x50, num, (s32)CH_L(c, 0x11E), 0, 0x0A, 6, ' '); /* ch+$11E: experience points (long) */
    h026_insert(0x50, num, 0x0B, "Experience ", 0);
    ui_draw_text(0x14, 7, 0x0F, 0, 0x50, num);

    for (s = 0; s <= 5; ++s) {
        static const char *const names[6] = {
            "STR ", "INT ", "WIS ", "DEX ", "CON ", "CHA "
        };

        copy_text(line, names[s], 0x50);
        ui_draw_text(1, (u16)(s + 9), 0x0A, 0, 0x50, line);
        draw_stat_value(s, 0);
    }
    draw_character_money();
    draw_combat_values();
    if (s_char->readied[0] != NULL) {
        build_item_name(s_char, s_char->readied[0], 1, 0x15, 0, 1);
    }
    if (s_char->readied[2] != NULL) {
        build_item_name(s_char, s_char->readied[2], 1, 0x16, 0, 1);
    }
}

/*
 * PORT H065+$0ADE: coins of the current character (+$F2..+$FC) in the
 * right column, one row per type owned (names H005+$4B7E).
 */
void draw_character_money(void)
{
    char text[0x29];                    /* -$2e(a5) */
    u16 row = 9;                        /* -$2(a5) */
    u8 i;                               /* -$3(a5) */

    clear_text_cells(0x14, 9, 0x26, 0x0F);
    for (i = 1; i <= 6; ++i) {
        /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
        u16 amount = CH_W(g_current_char, 0xF0 + i * 2);

        if (amount == 0) {
            continue;
        }
        /* $4B7E: names of the coin types, $0C bytes per type */
        h026_copy(0x28, text, 0x0A, (const char *)&g_h005[0x4B7E + i * 0x0C]);
        ui_draw_text(0x14, row, 0x0A, 0, 0x28, text);
        format_number(0x28, text, amount, 0, 0x0A, 4, ' ');
        ui_draw_text((u16)(0x26 - h026_strlen(0x28, text)), row, 0x0A, 0,
                     0x28, text);
        ++row;
    }
}

/* PORT H065+$0BF4: procedura annidata: spazi a sinistra fino a width. */
static void pad_left(char *s, u16 width)
{
    while (h026_strlen(0x28, s) < width) {
        h026_insert(0x28, s, 1, " ", 0);
    }
}

/*
 * PORT H065+$0BE6 (body at $0C34): recomputes the derived values and shows
 * hit points, armour class, encumbrance, THAC0, movement (doubled with
 * effect $27, halved with $2A) and damage "NdM+K".
 */
void draw_combat_values(void)
{
    char line[0x29];                    /* -$34(a5) */
    CokEffect *eff;                     /* -$38(a5) */
    Character *c = g_current_char;      /* -$4(a5) */
    u16 col;                            /* -$8(a5) */
    u16 move;                           /* -$a(a5) */
    u8 ac;

    recompute_stats(c);
    ui_draw_text(0x14, 3, 0x0F, 0, 0x0B, "Hit Points ");
    clear_text_cells(0x1F, 3, 0x25, 3);
    draw_hit_points(c, 0x1F, 3, 0, 1);
    ui_draw_text(1, 0x11, 0x0F, 0, 0x0B, "Armor Class");
    ac = g_current_char->b[0x19C]; /* ch+$19C: encoded current armour class (60 - AC) */
    if (ac >= 1 && ac <= 0x32) {
        col = 0x10;
    } else if (ac >= 0x33 && ac <= 0x3C) {
        col = 0x11;
    } else if (ac >= 0x3D && ac <= 0x45) {
        col = 0x10;
    } else {
        col = 0x0F;
    }
    clear_text_cells(0x0F, 0x11, 0x11, 0x11);
    draw_armor_class(c, col, 0x11);
    ui_draw_text(0x14, 0x11, 0x0F, 0, 0x0B, "Encumbrance");
    /* ch+$18C: encumbrance: weight of items and coins (word) */
    format_number(0x28, line, CH_W(c, 0x18C), 0, 0x0A, 5, ' ');
    ui_draw_text(0x21, 0x11, 0x0A, 0, 0x28, line);
    ui_draw_text(1, 0x12, 0x0F, 0, 8, "THAC0   ");
    /* ch+$19B: encoded current THAC0 (60 - THAC0) */
    format_number(0x28, line, (s32)(u16)(0x3C - c->b[0x19B]), 0, 0x0A, 2,
                  ' ');
    ui_draw_text(0x10, 0x12, 0x0A, 0, 0x28, line);
    move = c->b[0x1A9]; /* ch+$1A9: current movement (armour and encumbrance) */
    if (find_effect(c, 0x27, &eff)) {
        move = (u16)(move * 2);
    }
    if (find_effect(c, 0x2A, &eff)) {
        move = (u16)(move >> 1);
    }
    ui_draw_text(0x14, 0x12, 0x0F, 0, 8, "Movement");
    format_number(0x28, line, move, 0, 0x0A, 3, ' ');
    ui_draw_text(0x23, 0x12, 0x0A, 0, 0x28, line);

    /* ch+$1A0: number of dice of attack 1 (2 entries +$1A0..+$1A1) */
    format_number(0x28, line, c->b[0x1A0], 0, 0x0A, 2, ' ');
    /* ch+$1A2: sides of the die of attack 1 (2 entries +$1A2..+$1A3) */
    format_number(0x50, s_text, c->b[0x1A2], 0, 0x0A, 2, ' ');
    trim_leading_spaces(0x50, s_text);
    h026_append(0x28, line, 1, "d");
    h026_append(0x28, line, 0x50, s_text);
    if ((s16)CH_W(c, 0x1A4) > 0) { /* ch+$1A4: damage bonus, 2 words (attack 1 and 2) */
        /* ch+$1A4: damage bonus, 2 words (attack 1 and 2) */
        format_number(0x50, s_text, (s16)CH_W(c, 0x1A4), 0, 0x0A, 2, ' ');
        trim_leading_spaces(0x50, s_text);
        h026_append(0x28, line, 1, "+");
        h026_append(0x28, line, 0x50, s_text);
    }
    if ((s16)CH_W(c, 0x1A4) < 0) { /* ch+$1A4: damage bonus, 2 words (attack 1 and 2) */
        /* ch+$1A4: damage bonus, 2 words (attack 1 and 2) */
        format_number(0x50, s_text, -(s16)CH_W(c, 0x1A4), 0, 0x0A, 2, ' ');
        trim_leading_spaces(0x50, s_text);
        h026_append(0x28, line, 1, "-");
        h026_append(0x28, line, 0x50, s_text);
    }
    ui_draw_text(1, 0x13, 0x0F, 0, 6, "Damage");
    pad_left(line, 7);
    ui_draw_text(0x0B, 0x13, 0x0A, 0, 0x28, line);
}

/*
 * PORT H065+$10DE: value of ability stat (+$11 + 2*stat) at
 * row stat + 9; for strength 18 the percentage in brackets ("00" =
 * 100); "*" if the current value differs from the maximum.
 */
void draw_stat_value(u8 stat, u8 highlight)
{
    char text[0x29];                    /* -$2a(a5) */
    u16 pen = (u16)(highlight ? 0x0D : 0x0A);  /* -$2e(a5) */
    u16 col = 5;                        /* -$2c(a5) */
    Character *c = g_current_char;

    clear_text_cells(col, (u16)(stat + 9), 0x0B, (u16)(stat + 9));
    /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
    format_number(0x50, s_text, c->b[0x11 + stat * 2], 0, 0x0A, 2, ' ');
    ui_draw_text(col, (u16)(stat + 9), pen, 0, 0x50, s_text);
    /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength; ch+$1C:
     * current exceptional strength (18/xx, 1..100) */
    if (stat == 0 && c->b[0x11] == 0x12 && c->b[0x1C] > 0) {
        /* ch+$1C: current exceptional strength (18/xx, 1..100) */
        format_number(0x28, text, c->b[0x1C], 0, 0x0A, 2, '0');
        if (c->b[0x1C] == 0x64) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
            copy_text(text, "00", 0x28);
        }
        h026_insert(0x28, text, 1, "(", 0);
        h026_append(0x28, text, 1, ")");
        ui_draw_text(7, 9, pen, 0, 0x28, text);
    }
    /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength; pg+$10:
     * caratteristiche base, 6 voci passo 2 (FOR INT SAG DES COS CAR); FOR */
    if (c->b[0x11 + stat * 2] != c->b[0x10 + stat * 2] ||
        /* ch+$1D: base exceptional strength; ch+$1C: current exceptional strength (18/xx, 1..100) */
        (stat == 0 && c->b[0x1D] != c->b[0x1C])) {
        ui_draw_text(0x0C, (u16)(stat + 9), pen, 0, 1, "*");
    }
}

/* -$8(a4): character of the View Character screen. */
static Character *s_view_char;

/* PORT H065+$36A6: can the character cure?  Always 0. */
static u8 can_heal(Character *c)
{
    (void)c;
    return 0;
}

/* PORT H065+$36C0: can the character heal?  Always 0. */
static u8 can_cure(Character *c)
{
    (void)c;
    return 0;
}

/*
 * PORT H065+$3390: special keys of the character choice: 'H' the
 * previous one in the party (from the first one it goes to the last), 'P' the next one
 * (from the last to the first); any other key chooses the first.  Nothing with
 * a mouse click.
 */
void select_party_member(u8 key)
{
    Character *m;                       /* -$4(a5) */

    if (G_MOUSE_CLICK) { /* $249E: 1 if the key comes from the mouse (click) */
        return;
    }
    m = g_party_head;
    if (m != NULL) {
        switch (key) {
        case 'H':
            if (m == g_current_char) {
                while (m->next != NULL) {
                    m = m->next;
                }
            } else {
                while (m != NULL && m->next != g_current_char) {
                    m = m->next;
                }
            }
            break;
        case 'P':
            m = g_current_char->next != NULL ? g_current_char->next :
                                               g_party_head;
            break;
        default:
            break;
        }
    }
    g_current_char = m;
}

/*
 * PORT H065+$3702: "Pick Character": chooses the current character with the
 * keys (or a click on a name, H008+$01FC with $24A2 = 1) updating
 * the party list.  1 if chosen with Select.
 */
u8 pick_character(void)
{
    /* $24A2: 1: clicking a party name selects the character */
    u8 saved = H005_B(0x24A2);          /* -$3(a5) */
    u8 key;                             /* -$1(a5) */
    u8 special;                         /* -$2(a5) */

    H005_B(0x24A2) = 1; /* $24A2: 1: clicking a party name selects the character */
    do {
        key = ui_request_choice(0x0F, "Pick Character ", 0x0B, "Select Exit",
                                0x0D, 0x0A, 0x0F, 1, 0, &special);
        if (special) {
            select_party_member(key);
            draw_party(g_current_char);
        }
    } while (special || !(key == 'S' || key == 'E' || key == 0));
    draw_party(g_current_char);
    H005_B(0x24A2) = saved; /* $24A2: 1: clicking a party name selects the character */
    return (u8)(key == 'S');
}

/* Row of the coin menu: name, spaces up to pad and quantity. */
static CokMenuItem *coin_line(CokMenuItem *list, u8 k, u8 drop)
{
    CokMenuItem *node;
    CokMenuItem *prev;
    char number[0x10];                  /* -$3e / -$28(a5) */
    char spaces[0x10];                  /* -$2e / -$38(a5) */
    s16 pad;
    s16 i;
    /* $4B7E: names of the coin types, $0C bytes per type */
    const char *name = (const char *)&H005_B(0x4B7E + k * 0x0C);

    if (list == NULL) {
        node = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                             COK_MEMF_CLEAR);
        node->next = NULL;
    } else {
        prev = list;
        node = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                             COK_MEMF_CLEAR);
        node->next = prev;
    }
    /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
    format_number(0x0F, number, CH_W(g_current_char, 0xF0 + k * 2), 0, 0x0A,
                  4, ' ');
    if (drop) {
        pad = (s16)(0x12 - h026_strlen(0x0A, name) -
                    h026_strlen(0x0F, number));
    } else {
        pad = (s16)(0x0E - h026_strlen(0x0A, name));
    }
    spaces[0] = 0;
    for (i = 1; i <= pad; ++i) {
        h026_append(0x0F, spaces, 1, " ");
    }
    h026_copy(0x28, node->text, 0x0A, name);
    h026_append(0x28, node->text, 0x0F, spaces);
    h026_append(0x28, node->text, 0x0F, number);
    node->header = 0;
    return node;
}

/* True if the current character has no more coins (types 1..6). */
static u8 no_coins_left(void)
{
    u8 k;
    u8 none = 1;

    for (k = 1; k <= 6; ++k) {
        /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
        if (CH_W(g_current_char, 0xF0 + k * 2) > 0) {
            none = 0;
        }
    }
    return none;
}

/*
 * PORT H065+$12D6: View, Trade: chooses who to give the money to, then the coin
 * type and quantity while some remains or until exit.
 */
static void view_trade(void)
{
    Character *target;                  /* -$4(a5) */
    Character *saved_char;              /* -$8(a5) */
    CokMenuItem *list;                  /* -$12(a5) */
    CokMenuItem *chosen;                /* -$16(a5) */
    CokMenuItem *saved;                 /* -$1a(a5) */
    char text[0x52];                    /* -$90(a5) */
    u16 count;                          /* -$1c(a5) */
    u16 index;                          /* -$1e(a5) */
    u16 amount;                         /* -$94(a5) */
    u8 k;                               /* -$9(a5) */
    u8 coin;                            /* -$a(a5) */
    u8 done_outer = 0;                  /* -$95(a5) */
    u8 done_inner = 0;                  /* -$96(a5) */
    u8 redraw;                          /* -$97(a5) */

    do {
        target = s_view_char;
        redraw_game_screen();
        choose_party_member(9, "Trade to?", 1, 1, &target);
        if (target == NULL) {
            done_outer = 1;
            break;
        }
        draw_character_sheet();
        do {
            draw_character_money();
            s_view_char = target;
            list = NULL;
            chosen = NULL;
            saved = NULL;
            count = 0;
            for (k = 6; k >= 1; --k) {
                /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
                if (CH_W(g_current_char, 0xF0 + k * 2) != 0) {
                    ++count;
                    list = coin_line(list, k, 0);
                }
            }
            saved = list;
            index = 0;
            redraw = 1;
            saved_char = g_current_char;
            (void)list_menu(0x14, "Select type of coin ", 7, " Select", 0x0D,
                            0x0A, 0x0F, 0x14, 9, 0x26, 0x0F, list, 1, &redraw,
                            &index, &chosen);
            g_current_char = saved_char;
            if (chosen == NULL) {
                done_inner = 1;
            } else {
                text[0] = 0;
                coin = coin_type(0x28, chosen->text, 0x50, text);
                h026_insert(0x50, text, 9, "How much ", 0);
                h026_append(0x50, text, 0x10, "will you trade? ");
                /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
                amount = input_amount(CH_W(g_current_char, 0xF0 + coin * 2),
                                      0x50, text, 0x0A);
                transfer_money(coin, amount, &target, &g_current_char);
                done_inner = 1;
                done_outer = 1;
                if (!no_coins_left()) {
                    done_outer = 0;
                    done_inner = 0;
                }
            }
            if (saved != NULL) {
                menu_free(&saved);
            }
            (void)count;
        } while (!done_inner);
    } while (!done_outer);
}

/*
 * PORT H065+$1636: View, Drop: coin type and quantity to drop,
 * while some remains or until exit.
 */
static void view_drop(void)
{
    CokMenuItem *list;                  /* -$e(a5) */
    CokMenuItem *chosen;                /* -$12(a5) */
    CokMenuItem *saved;                 /* -$16(a5) */
    char text[0x52];                    /* -$8a(a5) */
    u16 count;                          /* -$8(a5) */
    u16 index;                          /* -$a(a5) */
    u16 amount;                         /* -$8e(a5) */
    u8 k;                               /* -$1(a5) */
    u8 coin;                            /* -$2(a5) */
    u8 done;                            /* -$17(a5) */
    u8 redraw;                          /* -$18(a5) */

    do {
        draw_character_money();
        list = NULL;
        chosen = NULL;
        saved = NULL;
        count = 0;
        for (k = 6; k >= 1; --k) {
            /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
            if (CH_W(g_current_char, 0xF0 + k * 2) != 0) {
                ++count;
                list = coin_line(list, k, 1);
            }
        }
        saved = list;
        index = 0;
        redraw = 1;
        (void)list_menu(0x14, "Select type of coin ", 7, " Select", 0x0D,
                        0x0A, 0x0F, 0x14, 9, 0x26, 0x0F, list, 1, &redraw,
                        &index, &chosen);
        if (chosen == NULL) {
            done = 1;
        } else {
            text[0] = 0;
            coin = coin_type(0x28, chosen->text, 0x50, text);
            if (coin == 5) {
                h026_insert(0x50, text, 9, "How many ", 0);
            } else {
                h026_insert(0x50, text, 9, "How much ", 0);
            }
            h026_append(0x50, text, 0x0F, "will you drop? ");
            /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
            amount = input_amount(CH_W(g_current_char, 0xF0 + coin * 2),
                                  0x50, text, 0x0A);
            drop_money(coin, amount, g_current_char);
            draw_combat_values();
            done = no_coins_left();
        }
        if (saved != NULL) {
            menu_free(&saved);
        }
        (void)count;
    } while (!done);
}

/*
 * PORT H065+$196E: View Character: sheet of the current character and menu
 * with the available functions (Items if it has items, Spells if it has
 * memorised spells +$1E.., Trade and Drop with some money, Heal and
 * Cure, Exit).  *redraw = 1 from Items closes the screen.  At the end the
 * game screen is redrawn (H063+$321A).
 */
void view_character(u8 *redraw)
{
    char menu[0x2A];                    /* -$2c(a5) */
    u8 key = ' ';                       /* -$1(a5) */
    u8 has_spells;                      /* -$2e(a5) */
    u8 has_money;                       /* -$2d(a5) */
    u8 special;                         /* -$2f(a5) */
    s16 spell;                          /* -$36(a5) */
    u16 i;                              /* -$32(a5) */
    u8 saved_choice;                    /* -$37(a5) */
    Character *c;

    *redraw = 0;
    s_view_char = g_current_char;
    draw_character_sheet();
    while (key != 'E' && key != 0 && !*redraw) {
        c = s_char;
        copy_text(menu, "", 0x28);
        has_spells = 0;
        has_money = 0;
        for (i = 0; i <= 0x39; ++i) {
            /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
            if (c->b[0x1E + i] > 0) {
                has_spells = 1;
            }
        }
        for (i = 1; i <= 6; ++i) {
            /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
            if (CH_W(c, 0xF0 + i * 2) > 0) {
                has_money = 1;
            }
        }
        if (c->items != NULL) {
            h026_append(0x28, menu, 6, "Items ");
        }
        if (has_spells) {
            h026_append(0x28, menu, 7, "Spells ");
        }
        /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused); ch+$198: active/standing (0
         * down or out of the combat); ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A
         * down */
        if ((c->b[0xEC] < 0x80 || (c->b[0x198] != 0 && c->b[0x197] == 1)) &&
            /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
            has_money && H005_B(0x3DE3) != 5) {
            h026_append(0x28, menu, 6, "Trade ");
        }
        if (has_money) {
            h026_append(0x28, menu, 5, "Drop ");
        }
        if (can_heal(g_current_char)) {
            h026_append(0x28, menu, 5, "Heal ");
        }
        if (can_cure(g_current_char)) {
            h026_append(0x28, menu, 5, "Cure ");
        }
        h026_append(0x28, menu, 4, "Exit");
        key = ui_request_choice(0, "", 0x28, menu, 0x0D, 0x0A, 0x0F, 0, 0,
                                &special);
        spell = -1;                     /* $FFFF */
        /* $2483: index of the selected option in the row menus (persistent) */
        saved_choice = H005_B(0x2483);
        switch (key) {
        case 'I':                       /* H065+$1B8C */
            show_items(redraw);
            break;
        case 'S':                       /* H065+$1B98 */
            i = choose_spell_of_kind(0, 0, &spell, &has_spells);
            break;
        case 'T':                       /* H065+$1BB0 */
            view_trade();
            break;
        case 'D':                       /* H065+$1BB6 */
            view_drop();
            draw_character_money();
            break;
        default:
            break;
        }
        /* $2483: index of the selected option in the row menus (persistent) */
        H005_B(0x2483) = saved_choice;
        if (!*redraw && (key == 'I' || key == 'T' || key == 'S')) {
            draw_character_sheet();
        }
    }
    redraw_game_screen();
}

/* Row of the item type table H005+$336C ($12 bytes). */
/* $336C: table of the item types (item+$30), $12 bytes per type; off = field */
#define ITEM_TYPE(t, off) H005_B(0x336C + (t) * 0x12 + (off))

/*
 * PORT H065+$1C48: can the item be given away?  Not if it is readied ("Must be
 * unreadied"); for magic scrolls it asks for confirmation ("... was going
 * to scribe from that scroll / is it Okay to lose it?").
 */
static u8 can_give_away(CokItem *it)
{
    u8 ok = 0;                          /* -$1(a5) */

    if (it->b[0x3A]) { /* item+$3A: item readied flag (Ready) */
        show_message_line(0x11, "Must be unreadied");
    } else if (!is_scroll(it)) {
        ok = 1;
    /* item+$44: charges of the magic item; spell 1 of the scroll; item+$45:
     * spell/parameter of the magic item (bit 7 excluded) */
    } else if (it->b[0x44] > 0x7F || it->b[0x45] > 0x7F ||
               /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type */
               it->b[0x46] > 0x7F) {
        draw_character_name(g_current_char, 1, 0x15, 0);
        H005_SET_W(0x334E, (u16)(h026_strlen(0x0F, /* $334E: (word) text cursor: column */
                   (const char *)g_current_char->b) + 2));
        H005_SET_W(0x334C, 0x15); /* $334C: (word) text cursor: row */
        word_wrap_text(1, 0x15, 0x26, 0x16, 0x0E, 0, 0, 0x25,
                       " was going to scribe from that scroll");
        if (ask_yes_no(0x17, "is it Okay to lose it? ", 0x0D, 0x0A, 0x0F) ==
            'Y') {
            ok = 1;
        }
    } else {
        ok = 1;
    }
    clear_text_cells(1, 0x15, 0x26, 0x16);
    return ok;
}

/* PORT H065+$1D80: does nothing. */
static void h065_1d80(CokItem *it)
{
    (void)it;
}

/*
 * PORT H065+$1E2C: halves the quantity (+$40) into a new
 * unreadied item inserted after it ("Can't halve that" if < 2).
 */
static void halve_item(CokItem *it)
{
    CokItem *n;                         /* -$4(a5) */
    /* item+$40: quantity (identical pieces grouped, max 255) */
    u16 half = (u16)(it->b[0x40] >> 1); /* -$6(a5) */
    u16 rest;                           /* -$8(a5) */

    if (half == 0) {
        show_message_line(0x10, "Can't halve that");
        return;
    }
    rest = (u16)(it->b[0x40] - half); /* item+$40: quantity (identical pieces grouped, max 255) */
    n = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
    memcpy(n->b, it->b, 0x48);
    n->b[0x40] = (u8)half; /* item+$40: quantity (identical pieces grouped, max 255) */
    n->b[0x3A] = 0; /* item+$3A: item readied flag (Ready) */
    n->next = it->next;
    it->b[0x40] = (u8)rest; /* item+$40: quantity (identical pieces grouped, max 255) */
    it->next = n;
}

/*
 * PORT H065+$1EE4: gathers into it the quantities of the identical items of the
 * current character (at most 255 per item: the excess stays
 * in the other one, which becomes the one to fill).
 */
static void join_items(CokItem *it)
{
    CokItem *target = it;               /* -$c(a5) */
    CokItem *p;                         /* -$4(a5) */
    CokItem *next;                      /* -$8(a5) */
    /* item+$40: quantity (identical pieces grouped, max 255) */
    u16 total = it->b[0x40];            /* -$e(a5) */

    for (p = g_current_char->items; p != NULL; p = next) {
        next = p->next;
        if (p == target || p->b[0x40] == 0 || /* item+$40: quantity (identical pieces grouped, max 255) */
            /* item+$32: name word 1 (1-based index into H005+$406E, $16 bytes); item+$33: name
             * word 2 (1-based index into H005+$406E, $16 bytes) */
            p->b[0x32] != target->b[0x32] || p->b[0x33] != target->b[0x33] ||
            /* item+$34: name word 3 (index into H005+$406E); base name of the type; ogg+$30: type
             * of the item (index into the table H005+$336C, $12 bytes per entry) */
            p->b[0x34] != target->b[0x34] || p->b[0x30] != target->b[0x30] ||
            /* item+$36: (word) magic bonus (+n) of the item, signed */
            COK_GET16(p->b + 0x36) != COK_GET16(target->b + 0x36) ||
            /* item+$38: (word) second bonus, added to CH +$18A when readied */
            COK_GET16(p->b + 0x38) != COK_GET16(target->b + 0x38) ||
            p->b[0x3C] != target->b[0x3C] || /* item+$3C: cursed item flag */
            /* item+$3E: (word) unit weight of the item */
            COK_GET16(p->b + 0x3E) != COK_GET16(target->b + 0x3E) ||
            /* item+$44: charges of the magic item; spell 1 of the scroll */
            p->b[0x44] != target->b[0x44] || p->b[0x44] >= 2 ||
            /* item+$45: spell/parameter of the magic item (bit 7 excluded); item+$46: type of
             * the magic effect: bit7 = passive effect, bits 0..6 type */
            p->b[0x45] != target->b[0x45] || p->b[0x46] != target->b[0x46]) {
            continue;
        }
        if (p->b[0x40] + total <= 0xFF) { /* item+$40: quantity (identical pieces grouped, max 255) */
            total = (u16)(total + p->b[0x40]); /* item+$40: quantity (identical pieces grouped, max 255) */
            delete_item(g_current_char, p);
        } else {
            target->b[0x40] = 0xFF; /* item+$40: quantity (identical pieces grouped, max 255) */
            /* item+$40: quantity (identical pieces grouped, max 255) */
            p->b[0x40] = (u8)(p->b[0x40] - (0xFF - total));
            total = p->b[0x40]; /* item+$40: quantity (identical pieces grouped, max 255) */
            target = p;
        }
    }
    target->b[0x40] = (u8)total; /* item+$40: quantity (identical pieces grouped, max 255) */
}

/*
 * PORT H065+$2B2E: effect of the magic items (+$46 with bit 7) when
 * they are readied (readying) or not, according to the type (bits 0..6).
 */
static void magic_item_ready(CokItem *it, u8 readying)
{
    Character *c = g_current_char;      /* -$a(a5) */

    /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type */
    switch (mask_byte(it->b[0x46], 0x7F)) {
    case 0: case 2:
        H005_B(0x24E0) = 1; /* $24E0: 1: the effects go to the handler $2A0E (magic items) */
        /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type */
        call_effect_handler(it->b[0x46], &c, it, (u8)(readying == 0));
        break;
    case 3: case 5:
        recompute_stat(c, 0);
        break;
    case 9:
        if (!readying) {
            remove_effect(c, 0x17, NULL);
        }
        break;
    default:
        break;
    }
}

/*
 * PORT H065+$2C04: readies the item or removes it (not if cursed).
 * Obstacles: class, slot already in use ("already using ..."), hands
 * full, magic order of the scrolls ($27), kender only ($43).
 */
void ready_item(CokItem *it)
{
    Character *c = g_current_char;      /* -$a(a5) */
    /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type */
    u8 magic = (u8)(it->b[0x46] > 0x7F);        /* -$1(a5) */
    u16 status = 0;                     /* -$4(a5) */
    u16 slot;                           /* -$6(a5) */

    if (it->b[0x3A]) { /* item+$3A: item readied flag (Ready) */
        if (it->b[0x3C]) { /* item+$3C: cursed item flag */
            show_message_line(0x0B, "It's Cursed");
        } else {
            it->b[0x3A] = 0; /* item+$3A: item readied flag (Ready) */
            if (magic) {
                magic_item_ready(it, 0);
            }
        }
        return;
    }
    /* ch+$188: hands used by the readied items (max 2); $336D: item types +1: hands used (added to
     * +$188, max 2); ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per
     * entry) */
    if (c->b[0x188] + ITEM_TYPE(it->b[0x30], 1) > 2) {
        status = 3;
    }
    /* $336C: item types, $12 bytes per type (+$30): +0 slot/kind; ogg+$30: type of the item (index
     * into the table H005+$336C, $12 bytes per entry) */
    slot = ITEM_TYPE(it->b[0x30], 0);
    if (slot <= 8) {
        if (c->readied[slot] != NULL) {
            status = 2;
        }
    } else if (slot == 9) {
        if (c->readied[10] != NULL) {
            status = 2;
        }
    }
    if (it->b[0x30] == 0x27 && /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
        /* ch+$5F: mage order (1 alignm. 0/3/6, 2 for 1/4/7, 0 none); item+$3B: bits 0..2
         * unidentified name words; bit 5/4 scroll cl.1/2 */
        !(g_current_char->b[0x5F] == 1 && mask_byte(it->b[0x3B], 0x20)) &&
        /* ch+$5F: mage order (1 alignm. 0/3/6, 2 for 1/4/7, 0 none); item+$3B: bits 0..2
         * unidentified name words; bit 5/4 scroll cl.1/2 */
        !(g_current_char->b[0x5F] == 2 && mask_byte(it->b[0x3B], 0x10))) {
        status = 4;
    }
    /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry);
     * ch+$5B: race (0..6, names H005+$4D04) */
    if (it->b[0x30] == 0x43 && g_current_char->b[0x5B] != 5) {
        status = 5;
    }
    /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    if (it->b[0x30] == 0x1E && c->readied[11] != NULL) {
        status = 2;
        slot = 0x0B;
    }
    /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    if (it->b[0x30] == 0x0C && c->readied[12] != NULL) {
        status = 2;
        slot = 0x0C;
    }
    /* $337B: item types +$F: mask of the allowed classes (vs +$122); ogg+$30: type of the item
     * (index into the table H005+$336C, $12 bytes per entry); ch+$122: mask of the usable
     * weapons (sum of H005+$5040 per class) */
    if (!mask_byte(ITEM_TYPE(it->b[0x30], 0x0F), c->b[0x122])) {
        status = 1;
    }
    switch (status) {
    case 0:
        it->b[0x3A] = 1; /* item+$3A: item readied flag (Ready) */
        if (magic) {
            magic_item_ready(it, 1);
        }
        break;
    case 1:
        show_message_line(0x0B, "Wrong Class");
        break;
    case 2:
        build_item_name(c, c->readied[slot & 0xFF], 0, 0, 0, 0);
        copy_text(s_text, "already using ", 0x50);
        h026_append(0x50, s_text, 0x28,
                    (const char *)c->readied[slot & 0xFF]->b);
        show_message_line(0x50, s_text);
        break;
    case 3:
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat); ch+$19A: automatic
         * control in combat (1 = AI) */
        if (!(H005_B(0x3DE3) == 5 && c->b[0x19A])) {
            show_message_line(0x14, "Your hands are full!");
        }
        break;
    case 4:
        show_message_line(0x13, "Wrong Magical Order");
        break;
    case 5:
        show_message_line(0x15, "Usable Only By Kender");
        break;
    default:
        break;
    }
}

/*
 * In the original the item list is passed directly to the list
 * menu: the first $30 bytes of an item have the shape of an entry (name
 * at +$00, header flag at +$2A, next at +$2C).  In C the two
 * structures are different: a list of entries is built with the same
 * names and flags, and the chosen entry matches the item in the same
 * position.
 */
static CokMenuItem *s_object_menu;

static void free_object_menu(void)
{
    menu_free(&s_object_menu);
}

static CokMenuItem *items_as_menu(Character *c)
{
    CokItem *it;
    CokMenuItem *tail = NULL;

    free_object_menu();
    for (it = c->items; it != NULL; it = it->next) {
        CokMenuItem *n = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                       COK_MEMF_CLEAR);

        memcpy(n->text, it->b, 0x2A);
        n->header = it->b[0x2A]; /* ogg+$2A: header flag: copied into the header of the menu entry */
        n->next = NULL;
        if (tail == NULL) {
            s_object_menu = n;
        } else {
            tail->next = n;
        }
        tail = n;
    }
    return s_object_menu;
}

static CokItem *menu_item_object(Character *c, CokMenuItem *node)
{
    CokMenuItem *m = s_object_menu;
    CokItem *it = c->items;

    while (m != NULL && it != NULL) {
        if (m == node) {
            return it;
        }
        m = m->next;
        it = it->next;
    }
    return NULL;
}

/*
 * PORT H065+$32F6: would giving it to c overload it (or does it already have 16
 * items)?
 */
u8 item_overloads(Character *c, CokItem *it)
{
    u16 weight;                         /* -$4(a5) */
    u8 over = 0;                        /* -$1(a5) */

    recompute_stats(c);
    if (c->b[0x14F] > 0x0F) { /* ch+$14F: number of items owned (max 16) */
        over = 1;
    }
    weight = COK_GET16(&it->b[0x3E]); /* item+$3E: (word) unit weight of the item */
    if (it->b[0x40] > 0) { /* item+$40: quantity (identical pieces grouped, max 255) */
        weight = (u16)(it->b[0x40] * weight); /* item+$40: quantity (identical pieces grouped, max 255) */
    }
    if ((s16)(CH_W(c, 0x18C) + weight) > /* ch+$18C: encumbrance: weight of items and coins (word) */
        (s16)(str_weight_allowance(c) + 0x5DC)) {
        over = 1;
    }
    return over;
}

/*
 * PORT H065+$347E: wealth of c in steel (coins 0..4 times the values
 * H005+$0.., divided by H005+$10).
 */
u32 wealth_in_steel(Character *c)
{
    u32 sum = 0;                        /* -$4(a5) */
    u8 k;                               /* -$5(a5) */

    for (k = 0; k <= 4; ++k) {
        /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
        sum += h015_mulu32(H005_L(k * 4), CH_W(c, 0xF0 + k * 2));
    }
    /* $10: value of coin 5 (long, 50): divisor for the wealth in steel */
    return (u32)h015_divs32((s32)sum, (s32)H005_L(0x10), NULL);
}

/*
 * PORT H065+$1D94: Items, Trade: gives the item to another member of the
 * party if it does not overload them.
 */
static void trade_item(CokItem *it)
{
    Character *target = s_view_char;    /* -$4(a5) */

    redraw_game_screen();
    choose_party_member(0x10, "Trade with whom?", 1, 1, &target);
    if (target == NULL) {
        return;
    }
    s_view_char = target;
    if (item_overloads(target, it)) {
        show_message_line(0x0A, "Overloaded");
        return;
    }
    give_item_copy(target, it);
    delete_item(g_current_char, it);
    recompute_stats(target);
}

/*
 * PORT H065+$20EC: Items, Sell: offers half the value (+$42), for
 * the set of +$40 pieces value * pieces / 20; the proceeds in steel go
 * to the character or, if too heavy, partly into the pool.
 */
static void sell_item(CokItem *it)
{
    u16 price = 0;                      /* -$2(a5) */
    u16 amount;                         /* -$4(a5) */
    u16 room;                           /* -$6(a5) */

    if (COK_GET16(&it->b[0x42]) > 0) { /* item+$42: (word) value in coins (Sell offers half) */
        /* item+$42: (word) value in coins (Sell offers half) */
        price = (u16)(COK_GET16(&it->b[0x42]) >> 1);
    }
    if (it->b[0x40] > 1) { /* item+$40: quantity (identical pieces grouped, max 255) */
        /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
        if (it->b[0x30] != 0x1E || it->b[0x30] != 0x0C) {
            /* item+$40: quantity (identical pieces grouped, max 255) */
            price = (u16)((u32)(it->b[0x40] * price) / 0x14);
        } else {
            price = (u16)(it->b[0x40] * price); /* item+$40: quantity (identical pieces grouped, max 255) */
        }
    }
    build_item_name(s_char, it, 0, 0, 0, 0);
    format_number(0x50, s_text, price, 0, 0x0A, 4, ' ');
    h026_insert(0x50, s_text, 0x0E, "I'll give you ", 0);
    h026_append(0x50, s_text, 0x17, " steel pieces for your ");
    h026_append(0x50, s_text, 0x28, (const char *)it->b);
    word_wrap_text(1, 0x15, 0x26, 0x16, 0x0E, 0, 1, 0x50, s_text);
    if (ask_yes_no(0x0E, "Is It a Deal? ", 0x0D, 0x0A, 0x0F) == 'Y') {
        show_message_line(5, "Sold!");
        delete_item(g_current_char, it);
        amount = price;
        if (would_overload(g_current_char, amount, &room)) {
            show_message_line(0x27, "Overloaded.  Money will be put in pool.");
            if (room > amount) {
                CH_PUTW(g_current_char, 0xF8, /* ch+$F8: steel pieces (coin type 4) (word) */
                        (u16)(CH_W(g_current_char, 0xF8) + amount));
            } else {
                CH_PUTW(g_current_char, 0xF8, /* ch+$F8: steel pieces (coin type 4) (word) */
                        (u16)(CH_W(g_current_char, 0xF8) + room));
                /* $2A2E: (long) pool, steel pieces (type 4; xp: amount x 2) */
                H005_SET_L(0x2A2E, H005_L(0x2A2E) + (u16)(amount - room));
            }
        } else {
            CH_PUTW(g_current_char, 0xF8, /* ch+$F8: steel pieces (coin type 4) (word) */
                    (u16)(CH_W(g_current_char, 0xF8) + amount));
        }
    }
    clear_text_cells(1, 0x15, 0x26, 0x16);
}

/*
 * PORT H065+$2308: Items, Id: for 100 steel pieces (of the character or
 * of the pool) reveals the item (clears bits 0-2 of +$3B).
 */
static void identify_item(CokItem *it, u8 *relist)
{
    s32 money;                          /* -$4(a5) */
    s32 pool;                           /* -$8(a5) */
    u8 paid = 0;                        /* -$9(a5) */

    build_item_name(s_char, it, 0, 0, 0, 0);
    copy_text(s_text, "For 100 steel pieces I'll identify your ", 0x50);
    h026_append(0x50, s_text, 0x28, (const char *)it->b);
    word_wrap_text(1, 0x15, 0x26, 0x16, 0x0E, 0, 1, 0x50, s_text);
    if (ask_yes_no(0x0E, "Is It a Deal? ", 0x0D, 0x0A, 0x0F) == 'Y') {
        money = (s32)wealth_in_steel(g_current_char);
        if ((u32)money >= 0x64) {
            paid = 1;
            money -= 0x64;
            set_steel_only((u16)money);
        } else {
            pool = (s32)pool_value();
            if ((u32)pool >= 0x64) {
                paid = 1;
                pool -= 0x64;
                set_pool_steel((u16)pool);
            } else {
                show_message_line(0x10, "NOT Enough Money");
            }
        }
    }
    if (paid) {
        /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
        if (mask_byte(it->b[0x3B], 7) == 0) {
            copy_text(s_text, "I can't tell anything new about your ", 0x50);
            h026_append(0x50, s_text, 0x28, (const char *)it->b);
            word_wrap_text(1, 0x15, 0x26, 0x16, 0x0E, 0, 1, 0x50, s_text);
        } else {
            /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
            it->b[0x3B] = mask_byte(it->b[0x3B], 0xF8);
            build_item_name(s_char, it, 0, 0, 0, 0);
            copy_text(s_text, "It looks like some sort of ", 0x50);
            h026_append(0x50, s_text, 0x28, (const char *)it->b);
            word_wrap_text(1, 0x15, 0x26, 0x16, 0x0E, 0, 1, 0x50, s_text);
            *relist = 1;
        }
    }
    if (paid) {
        message_delay();
    }
    clear_text_cells(1, 0x15, 0x26, 0x16);
}

/*
 * PORT H065+$255A: item screen of the current character:
 * list (" Yes"/" No" readied and name) and commands Ready (or View Ready in
 * debug), Use, Trade, Drop, Halve (fewer than 16 items), Join, Sell and Id
 * (in town).  Until Exit, *redraw or no items left.
 */
void show_items(u8 *redraw)
{
    Character *c = g_current_char;      /* -$46(a5) */
    char menu[0x2A];                    /* -$2c(a5) */
    CokMenuItem *chosen;                /* -$38(a5) */
    CokItem *it;                        /* -$34(a5) */
    u16 index = 0;                      /* -$3a(a5) */
    u16 count;                          /* -$48(a5) */
    u8 key = ' ';                       /* -$1(a5) */
    u8 relist = 1;                      /* -$2f(a5) */
    u8 first = 1;                       /* -$2e(a5) */
    u8 saved_choice;                    /* -$4b(a5) */

    chosen = NULL;
    /* ch+$14F: number of items owned (max 16) */
    while (key != 'E' && key != 0 && !*redraw && c->b[0x14F] > 0) {
        count = c->b[0x14F]; /* ch+$14F: number of items owned (max 16) */
        if (c->items != NULL) {
            /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            u8 trade_ok = (u8)(c->b[0xEC] < 0x80 ||
                               /* ch+$198: active/standing (0 down or out of the combat); ch+$197: status: 0 ok, 4 unconscious, 5
                                * dying, 6-8 dead, $0A down */
                               (c->b[0x198] != 0 && c->b[0x197] == 1));

            if (H005_B(0x24D2)) { /* $24D2: debug enabled ("*" in the status, extra values) */
                h026_copy(0x28, menu, 0x0A, "View Ready");
            } else {
                h026_copy(0x28, menu, 5, "Ready");
            }
            /*
             * With $3DE3 = 5 the original reads byte +2 of the block +$192
             * even if it is null; here a null block counts as 0.
             */
            /* ch+$198: active/standing (0 down or out of the combat); A+$1CA: (word) if not
             * zero no spells can be cast in the area */
            if (c->b[0x198] && COK_GET16(g_state_a + 0x1CA) == 0 &&
                /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
                (H005_B(0x3DE3) == 2 || H005_B(0x3DE3) == 3 ||
                 /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
                 H005_B(0x3DE3) == 4 ||
                 /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
                 (H005_B(0x3DE3) == 5 && c->block_192 != NULL &&
                  /* turn+$2: can use items flag (cleared by coughing in the cloud) */
                  (c->block_192->b)[2] != 0))) {
                h026_append(0x28, menu, 4, " Use");
            }
            /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
            if (trade_ok && H005_B(0x3DE3) != 5) {
                h026_append(0x28, menu, 6, " Trade");
            }
            h026_append(0x28, menu, 5, " Drop");
            if (c->b[0x14F] < 0x10) { /* ch+$14F: number of items owned (max 16) */
                h026_append(0x28, menu, 6, " Halve");
            }
            h026_append(0x28, menu, 5, " Join");
            /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
            if (trade_ok && H005_B(0x3DE3) == 1) {
                h026_append(0x28, menu, 5, " Sell");
            }
            /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
            if (H005_B(0x3DE3) == 1) {
                h026_append(0x28, menu, 3, " Id");
            }
            for (it = c->items; it != NULL; it = it->next) {
                build_item_name(c, it, 0, 0, 1, 0);
            }
            /* $24A8: 1: the item screen must be redrawn in full */
            if (first || H005_B(0x24A8)) {
                draw_items_frame();
                draw_character_name(c, 1, 1, 1);
                ui_draw_text((u16)(h026_strlen(0x0F, (const char *)c->b) + 4),
                             1, 0x0A, 0, 5, "Items");
                ui_draw_text(1, 3, 0x0F, 0, 0x0A, "Ready Item");
                relist = 1;
                first = 0;
                H005_B(0x24A8) = 0; /* $24A8: 1: the item screen must be redrawn in full */
            }
            key = list_menu(0, "", 0x28, menu, 0x0D, 0x0A, 0x0F, 1, 5, 0x26,
                            0x16, items_as_menu(c), 1, &relist, &index,
                            &chosen);
            it = menu_item_object(c, chosen);
            if (chosen != NULL) {
                /* $2483: index of the selected option in the row menus (persistent) */
                saved_choice = H005_B(0x2483);
                switch (key) {
                case 'D':               /* H065+$2986 */
                    if (can_give_away(it)) {
                        build_item_name(c, it, 0, 0, 0, 0);
                        copy_text(s_text, "Your ", 0x50);
                        h026_append(0x50, s_text, 0x28, (const char *)it->b);
                        h026_append(0x50, s_text, 0x14,
                                    "will be gone forever");
                        word_wrap_text(1, 0x15, 0x26, 0x16, 0x0E, 0, 1, 0x50,
                                       s_text);
                        if (ask_yes_no(9, "Drop It? ", 0x0D, 0x0A, 0x0F) ==
                            'Y') {
                            delete_item(g_current_char, it);
                            relist = 1;
                        }
                        clear_text_cells(1, 0x15, 0x26, 0x16);
                    } else {
                        key = ' ';
                    }
                    break;
                case 'H':               /* H065+$2A6C */
                    halve_item(it);
                    break;
                case 'I':               /* H065+$2AA4 */
                    identify_item(it, &relist);
                    break;
                case 'J':               /* H065+$2A76 */
                    join_items(it);
                    break;
                case 'R':               /* H065+$28C6 */
                    ready_item(it);
                    break;
                case 'S':               /* H065+$2A80 */
                    if (can_give_away(it)) {
                        sell_item(it);
                    } else {
                        key = ' ';
                    }
                    break;
                case 'T':               /* H065+$295C */
                    if (can_give_away(it)) {
                        trade_item(it);
                    } else {
                        key = ' ';
                    }
                    first = 1;
                    break;
                case 'U':               /* H065+$28D2 */
                    if (!it->b[0x3A]) { /* item+$3A: item readied flag (Ready) */
                        show_message_line(0x0F, "Must be Readied");
                        key = ' ';
                    } else if (is_scroll(it) ||
                               /* item+$45: spell/parameter of the magic item (bit 7 excluded); item+$46: type of the magic
                                * effect: bit7 = passive effect, bits 0..6 type */
                               (it->b[0x45] > 0 && it->b[0x46] < 0x80)) {
                        use_item(it, redraw);
                        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
                        if (H005_B(0x3DE3) != 5) {
                            *redraw = 0;
                        }
                        if (!*redraw) {
                            first = 1;
                        }
                    }
                    break;
                case 'V':               /* H065+$28B0 */
                    h065_1d80(it);
                    relist = 1;
                    first = 1;
                    break;
                default:
                    break;
                }
                /* $2483: index of the selected option in the row menus (persistent) */
                H005_B(0x2483) = saved_choice;
                recompute_stats(c);
            }
            free_object_menu();
        }
        if (c->b[0x14F] != count) { /* ch+$14F: number of items owned (max 16) */
            relist = 1;
        }
    }
}

/*
 * PORT H065+$2F82: Use of an item: casts the spell of the scroll
 * (chosen from the menu) or that of the magic item (+$45, if +$46 < $80).
 * Scrolls are read successfully according to the class (otherwise
 * "oops!"); then the spell is removed from the scroll, or a charge
 * (+$40, then +$44) of the item is used up.
 */
void use_item(CokItem *it, u8 *redraw)
{
    Character *c;
    s16 index = -1;                     /* -$4(a5) */
    u8 found;                           /* -$5(a5) */
    u16 spell;                          /* -$2(a5) */

    H005_B(0x24D9) = 0; /* $24D9: 1 if the spell comes from an item (it is not forgotten) */
    spell = 0;
    if (is_scroll(it)) {
        g_scroll_item = it;
        spell = choose_spell_of_kind(2, 1, &index, &found);
    /* item+$45: spell/parameter of the magic item (bit 7 excluded); item+$46: type of
     * the magic effect: bit7 = passive effect, bits 0..6 type */
    } else if (it->b[0x45] > 0 && it->b[0x46] < 0x80) {
        H005_B(0x24D9) = 1; /* $24D9: 1 if the spell comes from an item (it is not forgotten) */
        /* item+$45: spell/parameter of the magic item (bit 7 excluded) */
        spell = mask_byte(it->b[0x45], 0x7F);
    }
    if (spell == 0) {
        *redraw = 0;
        return;
    }
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat); ch+$19A: automatic control in
     * combat (1 = AI) */
    if (H005_B(0x3DE3) == 5 && !g_current_char->b[0x19A]) {
        redraw_combat_screen();
    }
    if (H005_B(0x24D9)) { /* $24D9: 1 if the spell comes from an item (it is not forgotten) */
        show_char_message(g_current_char, 0x0C, "uses an item", 0x0A, 0);
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        if (H005_B(0x3DE3) == 5) {
            ui_draw_text(0, 0x17, 0x0A, 0, 7, "Item : ");
            build_item_name(g_current_char, it, 5, 0x17, 0, 1);
        } else {
            build_item_name(g_current_char, it, 1, 0x16, 0, 1);
        }
        message_delay();
        clear_message_area();
    }
    H005_B(0x24D9) = 1; /* $24D9: 1 if the spell comes from an item (it is not forgotten) */
    c = g_current_char;
    if (is_scroll(it)) {
        if (h073_1294(c) == 5 || h073_12ae(c) == 5 ||
            (h073_1294(c) && h073_12ae(c) &&
             /* ch+$103: mage level; ch+$FE: levels per class, 8 entries (0 cleric..7
              * knight); cleric */
             (c->b[0x103] > 0 || c->b[0xFE] > 0))) {
            /* ch+$19A: automatic control in combat (1 = AI) */
            cast_spell(spell, c->b[0x19A], 0, redraw);
        } else if (c->b[0x104] > 9 && roll_dice(1, 0x64) <= 0x4B) { /* ch+$104: thief level */
            /* ch+$19A: automatic control in combat (1 = AI) */
            cast_spell(spell, c->b[0x19A], 0, redraw);
        } else {
            /* $334C: (word) text cursor: row */
            show_char_message(c, 5, "oops!", (u16)(H005_W(0x334C) + 1), 1);
        }
    } else {
        /* ch+$19A: automatic control in combat (1 = AI) */
        cast_spell(spell, g_current_char->b[0x19A], 0, redraw);
    }
    H005_B(0x24D9) = 0; /* $24D9: 1 if the spell comes from an item (it is not forgotten) */
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    if (H005_B(0x3DE3) == 5 && H005_B(0x66 + (spell - 1) * 16 + 0x0B)) {
        *redraw = end_combat_turn(g_current_char);
    }
    if (*redraw) {
        if (is_scroll(it)) {
            remove_scroll_spell(g_current_char, it, spell);
        /* item+$44: charges of the magic item; spell 1 of the scroll */
        } else if (it->b[0x44] > 0) {
            if (it->b[0x40] > 1) { /* item+$40: quantity (identical pieces grouped, max 255) */
                /* item+$40: quantity (identical pieces grouped, max 255) */
                it->b[0x40] = (u8)(it->b[0x40] - 1);
            } else {
                /* item+$44: charges of the magic item; spell 1 of the scroll */
                it->b[0x44] = (u8)(it->b[0x44] - 1);
                /* item+$44: charges of the magic item; spell 1 of the scroll */
                if (it->b[0x44] == 0) {
                    delete_item(g_current_char, it);
                }
            }
        }
    }
}

/*
 * PORT H065+$34FC: "Spells <kind>": builds the spell list
 * (H033+$0D7C; *found = not empty) and shows it (H033+$00EE).  The frame
 * is redrawn with *spell < 0 or mode 1.  Returns the chosen spell.
 */
u16 choose_spell_of_kind(u16 kind, u16 mode, s16 *spell, u8 *found)
{
    char title[0x2A];                   /* -$2a(a5) */
    u16 result;                         /* -$2c(a5) */

    switch (kind) {
    case 0:  strcpy(title, "in Memory");   break;
    case 1:  strcpy(title, "in Grimoire"); break;
    case 2:  strcpy(title, "on Scroll");   break;
    case 3:  strcpy(title, "on Scrolls");  break;
    case 4:  strcpy(title, "to Choose");   break;
    case 5:  strcpy(title, "to Memorize"); break;
    case 6:  strcpy(title, "to Scribe");   break;
    default: strcpy(title, "");            break;
    }
    *found = build_spell_list(kind);
    if (*found) {
        if (*spell < 0 || mode == 1) {
            if (mode == 2) {
                draw_memorize_frame();
            } else {
                draw_items_frame();
            }
        }
        draw_character_name(g_current_char, 1, 1, 1);
        copy_text(s_text, "Spells ", 0x50);
        h026_append(0x50, s_text, 0x28, title);
        ui_draw_text((u16)(h026_strlen(0x0F, (const char *)g_current_char->b)
                           + 4), 1, 0x0A, 0, 0x50, s_text);
        result = choose_spell(mode, spell);
    } else {
        result = 0;
    }
    return result;
}
