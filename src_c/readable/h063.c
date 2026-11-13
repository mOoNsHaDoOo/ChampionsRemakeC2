/* H063: Helpers for characters, inventory and UI update; partial map. */
#include <string.h>

#include "h063.h"
#include "h008.h"
#include "h003_exec.h"
#include "h056.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h045.h"
#include "h073.h"
#include "globals.h"
#include "h044_tiles.h"
#include "unported.h"
#include "h042_seq.h"
#include "h060.h"
#include "h016_gfx.h"
#include "h049.h"
#include "h077.h"
#include "h048.h"
#include "h036.h"

/* PORT H063+$0104: link/unlk, no effect. */
void h063_init(void)
{
}

/* -$2(a4): weight of the readied items (H063+$13BE). */
static u16 s_ready_weight;

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

/* Row of the item type table H005+$336C ($12 bytes). */
/* $336C: table of the item types (item+$30), $12 bytes per type; off = field */
#define ITEM_TYPE(t, off) H005_B(0x336C + (t) * 0x12 + (off))
#define ITEM_W(it, off)   ((s16)COK_GET16((it)->b + (off)))

/* PORT H063+$0112: removes the leading spaces (in place). */
void trim_leading_spaces(u16 len, char *s)
{
    u16 i;

    (void)len;
    while (s[0] == ' ') {
        for (i = 0; s[i] != 0; ++i) {
            s[i] = s[i + 1];
        }
    }
}

/* PORT H063+$016A: dexterity adjustment (+$17) for missile weapons. */
s16 dex_missile_adj(Character *c)
{
    /* ch+$17: current dexterity */
    s16 dex = c->b[0x17];               /* -$2(a5) */

    switch (dex) {
    case 0: case 1: case 2:
        return -4;
    case 3: case 4: case 5:
        return (s16)(dex - 6);
    case 16: case 17: case 18:
        return (s16)(dex - 0x0F);
    case 19: case 20:
        return 3;
    case 21: case 22: case 23:
        return 4;
    case 24: case 25:
        return 5;
    default:
        return 0;
    }
}

/*
 * PORT H063+$0228: effective strength: 0..17 as it is, 18 according to the
 * percentage (+$1C) in 18..23, 19..25 plus 5.  Beyond 25 the original
 * returns an uninitialised value; here 0.
 */
static s16 effective_strength(Character *c)
{
    u8 s = c->b[0x11]; /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */

    if (s <= 17) {
        return s;
    }
    if (s == 18) {
        if (c->b[0x1C] == 0) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
            return 0x12;
        }
        if (c->b[0x1C] < 0x33) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
            return 0x13;
        }
        if (c->b[0x1C] < 0x4C) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
            return 0x14;
        }
        if (c->b[0x1C] < 0x5B) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
            return 0x15;
        }
        if (c->b[0x1C] < 0x64) { /* ch+$1C: current exceptional strength (18/xx, 1..100) */
            return 0x16;
        }
        return 0x17;
    }
    if (s <= 25) {
        return (s16)(s + 5);
    }
    return 0;
}

/* PORT H063+$0354: strength bonus to hit (with +$11B). */
s16 str_hit_bonus(Character *c)
{
    s16 bonus = 0;                      /* -$4(a5) */
    s16 s = effective_strength(c);      /* -$2(a5) */

    if (!c->b[0x11B]) { /* ch+$11B: applies the strength bonuses to hit and to damage (1 for PCs) */
        return bonus;
    }
    switch (s) {
    case 1: case 2: case 3:
        bonus = -3;
        break;
    case 4: case 5:
        bonus = -2;
        break;
    case 6: case 7:
        bonus = -1;
        break;
    case 17: case 18: case 19:
        bonus = 1;
        break;
    case 20: case 21: case 22:
        bonus = 2;
        break;
    case 23: case 24: case 25:
        bonus = 3;
        break;
    case 26: case 27:
        bonus = 4;
        break;
    case 28: case 29: case 30:
        bonus = (s16)(s - 0x17);
        break;
    default:
        break;
    }
    return bonus;
}

/* PORT H063+$18F8: dexterity adjustment to the armour class. */
static s16 dex_ac_adj(Character *c)
{
    /* ch+$17: current dexterity */
    s16 dex = c->b[0x17];               /* -$2(a5) */

    switch (dex) {
    case 1: case 2: case 3:
        return -4;
    case 4: case 5: case 6:
        return (s16)(dex - 7);
    case 15: case 16: case 17: case 18:
        return (s16)(dex - 0x0E);
    case 19: case 20:
        return 4;
    case 21: case 22: case 23:
        return 5;
    case 24: case 25:
        return 6;
    default:
        return 0;
    }
}

/* PORT H063+$19B6: strength bonus to damage (with +$11B). */
s16 str_damage_bonus(Character *c)
{
    s16 bonus = 0;                      /* -$2(a5) */
    s16 s = effective_strength(c);      /* -$4(a5) */

    if (!c->b[0x11B]) { /* ch+$11B: applies the strength bonuses to hit and to damage (1 for PCs) */
        return bonus;
    }
    switch (s) {
    case 1: case 2:
        bonus = -2;
        break;
    case 3: case 4: case 5:
        bonus = -1;
        break;
    case 16:
        bonus = 1;
        break;
    case 17: case 18: case 19:
        bonus = (s16)(s - 0x10);
        break;
    case 20: case 21: case 22: case 23: case 24:
    case 25: case 26: case 27: case 28: case 29:
        bonus = (s16)(s - 0x11);
        break;
    case 30:
        bonus = 0x0E;
        break;
    default:
        break;
    }
    return bonus;
}

/* PORT H063+$1A8A: extra carrying weight for strength. */
s16 str_weight_allowance(Character *c)
{
    s16 s = effective_strength(c);      /* -$4(a5) */

    switch (s) {
    case 1: case 2: case 3:
        return -350;
    case 4: case 5:
        return -250;
    case 6: case 7:
        return -150;
    case 12: case 13:
        return 100;
    case 14: case 15:
        return 200;
    case 16:
        return 350;
    case 17: case 18: case 19: case 20: case 21:
        return (s16)((s - 0x11) * 0xFA + 0x1F4);
    case 22: case 23: case 24: case 25: case 26:
        return (s16)((s - 0x16) * 0x3E8 + 0x7D0);
    case 27:
        return 0x1D4C;
    case 28: case 29: case 30:
        return (s16)((s - 0x1C) * 0xBB8 + 0x2328);
    default:
        return 0;
    }
}

/*
 * PORT H063+$0432: values of the readied weapon (slot 0): base THAC0 (+$19B from
 * +$5A) with dexterity or strength according to the bits of H005+$336C+$10, damage
 * (+$1A0, +$1A2, +$1A4) and magic bonuses, including those of the items
 * of slots 11 and 12 and of the race.
 */
static void weapon_stats(Character *c)
{
    CokItem *w = c->readied[0];         /* -$4(a5) */
    u16 t;                              /* -$6(a5) */
    s16 bonus;                          /* -$8(a5) */

    if (w == NULL) {
        return;
    }
    t = w->b[0x30]; /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    /* ch+$19B: encoded current THAC0 (60 - THAC0); ch+$5A: encoded base THAC0 (60 - THAC0) from
     * the per-level table */
    c->b[0x19B] = c->b[0x5A];
    /* $337C: item types +$10: weapon flags (dex/str, ammunition, melee) */
    if (mask_byte(ITEM_TYPE(t, 0x10), 2)) {
        /* ch+$19B: encoded current THAC0 (60 - THAC0) */
        c->b[0x19B] = (u8)(c->b[0x19B] + dex_missile_adj(c));
    }
    /* $3378: item types +$C: (word) damage bonus, into +$1A4; ch+$1A4: damage bonus, 2 words
     * (attack 1 and 2) */
    CH_PUTW(c, 0x1A4, COK_GET16(&g_h005[0x336C + t * 0x12 + 0x0C]));
    /* $337C: item types +$10: weapon flags (dex/str, ammunition, melee) */
    if (mask_byte(ITEM_TYPE(t, 0x10), 4)) {
        /* ch+$19B: encoded current THAC0 (60 - THAC0) */
        c->b[0x19B] = (u8)(c->b[0x19B] + str_hit_bonus(c));
        /* ch+$1A4: damage bonus, 2 words (attack 1 and 2) */
        CH_PUTW(c, 0x1A4, (u16)(str_damage_bonus(c) + CH_W(c, 0x1A4)));
    }
    bonus = ITEM_W(w, 0x36); /* item+$36: (word) magic bonus (+n) of the item, signed */
    /* $337C: item types +$10: weapon flags (dex/str, ammunition, melee) */
    if (ITEM_TYPE(t, 0x10) > 0x7F && c->readied[12] != NULL) {
        /* item+$36: (word) magic bonus (+n) of the item, signed */
        bonus = (s16)(bonus + ITEM_W(c->readied[12], 0x36));
    }
    /* $337C: item types +$10: weapon flags (dex/str, ammunition, melee) */
    if (mask_byte(ITEM_TYPE(t, 0x10), 1) && c->readied[11] != NULL) {
        /* item+$36: (word) magic bonus (+n) of the item, signed */
        bonus = (s16)(bonus + ITEM_W(c->readied[11], 0x36));
    }
    CH_PUTW(c, 0x1A4, (u16)(CH_W(c, 0x1A4) + bonus)); /* ch+$1A4: damage bonus, 2 words (attack 1 and 2) */
    if (c->b[0x5B] == 0 || c->b[0x5B] == 1) { /* ch+$5B: race (0..6, names H005+$4D04) */
        /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
        if ((w->b[0x30] > 0x15 && w->b[0x30] < 0x1B) || w->b[0x30] == 0x13 ||
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            w->b[0x30] == 0x12) {
            ++bonus;
        }
    }
    /* ch+$5B: race (0..6, names H005+$4D04); ogg+$30: type of the item (index into the table
     * H005+$336C, $12 bytes per entry) */
    if (c->b[0x5B] == 5 && w->b[0x30] == 0x43) {
        bonus = (s16)(bonus + 2);
    }
    c->b[0x19B] = (u8)(c->b[0x19B] + bonus); /* ch+$19B: encoded current THAC0 (60 - THAC0) */
    /* ch+$1A0: number of dice of attack 1 (2 entries +$1A0..+$1A1); $3376: item types +$A:
     * damage die copied into +$1A0 */
    c->b[0x1A0] = ITEM_TYPE(t, 0x0A);
    /* ch+$1A2: sides of the die of attack 1 (2 entries +$1A2..+$1A3); $3377: item types +$B:
     * damage die copied into +$1A2 */
    c->b[0x1A2] = ITEM_TYPE(t, 0x0B);
}

/* PORT H063+$06AE: movement (+$1A9) with the armour worn. */
static void armor_movement(Character *c, CokItem *it)
{
    /* $336C: item types, $12 bytes per type (+$30): +0 slot/kind; ogg+$30: type of the item (index
     * into the table H005+$336C, $12 bytes per entry) */
    if (ITEM_TYPE(it->b[0x30], 0) != 2) {
        return;
    }
    if (COK_GET16(it->b + 0x3E) < 0x97) { /* item+$3E: (word) unit weight of the item */
        /* ch+$1A9: current movement (armour and encumbrance); ch+$DA: base movement (12 at
         * creation) */
        c->b[0x1A9] = c->b[0xDA];
    } else if (COK_GET16(it->b + 0x3E) < 0x190) { /* item+$3E: (word) unit weight of the item */
        c->b[0x1A9] = 9; /* ch+$1A9: current movement (armour and encumbrance) */
    } else {
        c->b[0x1A9] = 6; /* ch+$1A9: current movement (armour and encumbrance) */
    }
    /* item+$36: (word) magic bonus (+n) of the item, signed; ch+$1A9: current movement
     * (armour and encumbrance) */
    if (COK_GET16(it->b + 0x36) != 0 && c->b[0x1A9] <= 9) {
        c->b[0x1A9] = (u8)(c->b[0x1A9] + 3); /* ch+$1A9: current movement (armour and encumbrance) */
    }
}

/*
 * PORT H063+$0758: contribution of the readied item to the armour class
 * (array ac[0..4] of H063+$13BE) and to the weight +$18A.
 */
static void armor_class_part(Character *c, CokItem *it, s16 *ac, u8 *flag)
{
    /* $3373: item types +7: AC of the item (bit 7 = it provides it); ogg+$30: type of the item
     * (index into the table H005+$336C, $12 bytes per entry) */
    u16 v = ITEM_TYPE(it->b[0x30], 7); /* -$2(a5) */
    u8 kind;                            /* -$3(a5) */

    if (v <= 0x7F) {
        return;
    }
    v = mask_byte((u8)v, 0x7F);
    /* $336C: item types, $12 bytes per type (+$30): +0 slot/kind; ogg+$30: type of the item (index
     * into the table H005+$336C, $12 bytes per entry) */
    kind = ITEM_TYPE(it->b[0x30], 0);
    if (kind == 1) {
        ac[1] = (s16)(v + ITEM_W(it, 0x36)); /* item+$36: (word) magic bonus (+n) of the item, signed */
    } else if (v == 0) {
        if (kind == 9) {
            if (ITEM_W(it, 0x36) > ac[3]) { /* item+$36: (word) magic bonus (+n) of the item, signed */
                ac[3] = ITEM_W(it, 0x36); /* item+$36: (word) magic bonus (+n) of the item, signed */
            }
        } else {
            /* item+$36: (word) magic bonus (+n) of the item, signed */
            ac[2] = (s16)(ac[2] + ITEM_W(it, 0x36));
        }
        /* ch+$18A: saving throw bonus from the readied items (word, +$38); item+$38: (word)
         * second bonus, added to CH +$18A when readied */
        CH_PUTW(c, 0x18A, (u16)(CH_W(c, 0x18A) + ITEM_W(it, 0x38)));
    /* item+$36: (word) magic bonus (+n) of the item, signed */
    } else if ((s16)(v + ITEM_W(it, 0x36)) > ac[4]) {
        ac[4] = (s16)(v + ITEM_W(it, 0x36)); /* item+$36: (word) magic bonus (+n) of the item, signed */
        /* item+$36: (word) magic bonus (+n) of the item, signed */
        if (ITEM_W(it, 0x36) > 0 && kind == 2) {
            *flag = 1;
        }
    }
}

/* PORT H063+$08A2: movement reduced by encumbrance (+$18C). */
static void encumbrance_movement(Character *c)
{
    /* ch+$18C: encumbrance: weight of items and coins (word) */
    s16 extra = (s16)(CH_W(c, 0x18C) - str_weight_allowance(c));
    u16 move;                           /* -$4(a5) */

    if (extra < 0) {
        extra = 0;
    }
    if (extra < 0x201) {
        move = c->b[0x1A9]; /* ch+$1A9: current movement (armour and encumbrance) */
    } else if (extra < 0x301) {
        move = 9;
    } else if (extra < 0x401) {
        move = 6;
    } else {
        move = 3;
    }
    if (move < c->b[0x1A9]) { /* ch+$1A9: current movement (armour and encumbrance) */
        c->b[0x1A9] = (u8)move; /* ch+$1A9: current movement (armour and encumbrance) */
    }
}

/* PORT H063+$0946: looks in the list +$E8 for an effect of type type. */
u8 find_effect(Character *c, u16 type, CokEffect **out)
{
    u8 found = 0;                       /* -$1(a5) */

    *out = c->effects;
    while (*out != NULL && !found) {
        if ((*out)->b[0] == type) { /* eff+$0: type of the effect (code of the handler) */
            found = 1;
        } else {
            *out = (*out)->next;
        }
    }
    return found;
}

/*
 * PORT H063+$09B2: builds in it->b[0..] the name of the item (" Yes"/
 * " No" if readied, "* " for magic items when a party member
 * has effect 5, quantity, name parts from H005+$406E with the possible
 * plural) and, with draw, writes it at (col, row).  c is not used.
 */
void build_item_name(Character *c, CokItem *it, u16 col, u16 row,
                     u8 ready_mark, u8 draw)
{
    char tmp[0x51];                     /* -$60(a5) */
    Character *m;                       /* -$e(a5) */
    CokEffect *eff;                     /* -$8(a5) */
    u8 found = 0;                       /* -$9(a5) */
    u8 plural;                          /* -$a(a5) */
    u16 mask = 0;                       /* -$4(a5) */
    u16 i;                              /* -$2(a5) */
    char *name = (char *)it->b;

    (void)c;
    copy_text(name, "", 0x28);
    if (ready_mark) {
        /* item+$3A: item readied flag (Ready) */
        copy_text(name, it->b[0x3A] ? " Yes  " : " No   ", 0x28);
    }
    for (m = g_party_head; m != NULL && !found; m = m->next) {
        if (find_effect(m, 5, &eff)) {
            found = 1;
        }
    }
    /* item+$36: (word) magic bonus (+n) of the item, signed; item+$38: (word) second bonus,
     * added to CH +$18A when readied */
    if (found && (ITEM_W(it, 0x36) > 0 || ITEM_W(it, 0x38) > 0 ||
                  it->b[0x3C] != 0)) { /* item+$3C: cursed item flag */
        h026_append(0x28, name, 2, "* ");
    }
    if (it->b[0x40] > 0) { /* item+$40: quantity (identical pieces grouped, max 255) */
        /* item+$40: quantity (identical pieces grouped, max 255) */
        format_number(0x50, tmp, it->b[0x40], 0, 0x0A, 4, ' ');
        for (i = 0; i <= 2; ++i) {
            if (tmp[0] == ' ') {
                h026_delete(0x50, tmp, 0, 1);
            }
        }
        h026_append(0x28, name, 0x50, tmp);
        h026_append(0x28, name, 1, " ");
    }
    for (i = 1; i <= 3; ++i) {
        if (it->b[0x32 + i - 1] != 0 && /* item+$31: base of the table of 3 name words +$32..+$34 (index 1..3) */
            /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
            !mask_byte((u8)(it->b[0x3B] >> (3 - i)), 1)) {
            mask = (u16)(mask + (u8)(1 << (i - 1)));
        }
    }
    plural = 0;
    for (i = 3; i >= 1; --i) {
        if (!mask_byte((u8)(mask >> (i - 1)), 1)) {
            continue;
        }
        /* $406E: parts of the item names, $16 bytes per entry (from 1) */
        h026_append(0x28, name, 0x14, (const char *)&g_h005[0x406E +
                    /* item+$31: base of the table of 3 name words +$32..+$34 (index 1..3) */
                    ((s16)it->b[0x32 + i - 1] - 1) * 0x16]);
        if (it->b[0x40] < 2 || plural) { /* item+$40: quantity (identical pieces grouped, max 255) */
            h026_append(0x28, name, 1, " ");
            continue;
        }
        if ((u16)(u8)(1 << (i - 1)) == mask ||
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            (i == 1 && mask > 4 && it->b[0x30] != 0x37) ||
            (i == 2 && (mask & 1) == 0) ||
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            (i == 3 && it->b[0x30] == 0x37) ||
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            ((it->b[0x30] == 0x1E || it->b[0x30] == 5 ||
              /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry);
               * item+$34: name word 3 (index into H005+$406E); base name of the type */
              it->b[0x30] == 0x0C) && it->b[0x34] != 0x5D)) {
            h026_append(0x28, name, 2, "s ");
            plural = 1;
        } else {
            h026_append(0x28, name, 1, " ");
        }
    }
    if (draw) {
        ui_draw_text(col, row, 0x0A, 0, 0x28, name);
    }
}

/* PORT H063+$0FA0: armour class 60 - +$19C (negative with "-"). */
void draw_armor_class(Character *c, u16 col, u16 row)
{
    char text[0x51];                    /* -$52(a5) */
    s16 v = (s16)(c->b[0x19C] - 0x3C); /* ch+$19C: encoded current armour class (60 - AC) */

    format_number(0x50, text, v < 0 ? -v : v, 0, 0x0A, 3, ' ');
    trim_leading_spaces(0x50, text);
    if (c->b[0x19C] > 0x3C) { /* ch+$19C: encoded current armour class (60 - AC) */
        h026_insert(0x50, text, 1, "-", 0);
    }
    ui_draw_text(col, row, 0x0A, 0, 0x50, text);
}

/*
 * PORT H063+$103A: current hit points (+$1A8; colour $0E if wounded, $0D
 * with highlight) and, with with_max, "/maximum" (+$64).
 */
void draw_hit_points(Character *c, u16 col, u16 row, u8 highlight,
                     u8 with_max)
{
    char text[0x51];                    /* -$52(a5) */
    u16 pen;                            /* -$54(a5) */
    u16 n;                              /* -$56(a5) */

    /* ch+$1A8: current hit points; ch+$64: maximum hit points */
    pen = (u16)(c->b[0x1A8] < c->b[0x64] ? 0x0E : 0x0A);
    if (highlight) {
        pen = 0x0D;
    }
    format_number(0x50, text, c->b[0x1A8], 0, 0x0A, 6, ' '); /* ch+$1A8: current hit points */
    trim_leading_spaces(0x50, text);
    ui_draw_text(col, row, pen, 0, 0x50, text);
    if (with_max) {
        n = h026_strlen(0x50, text);
        format_number(0x50, text, c->b[0x64], 0, 0x0A, 6, ' '); /* ch+$64: maximum hit points */
        trim_leading_spaces(0x50, text);
        h026_insert(0x50, text, 1, "/", 0);
        ui_draw_text((u16)(col + n), row, 0x0A, 0, 0x50, text);
    }
}

/*
 * PORT H063+$13BE: recomputes the derived values: readied items per slot
 * (H005+$336C), number of items +$14F, encumbrance +$18C, damage, THAC0
 * +$19B, armour class +$19C/+$19D, movement +$1A9 and +$D2.
 */
void recompute_stats(Character *c)
{
    s16 ac[5];                          /* -$14(a5) */
    CokItem *it;                        /* -$8(a5) */
    u16 w;                              /* -$1a(a5) */
    u16 slot;                           /* -$1c(a5) */
    u8 flag9 = 0;                       /* -$9(a5) */
    u8 flag_a = 0;                      /* -$a(a5): never set */
    u8 i;

    for (i = 0; i <= 0x0C; ++i) {
        c->readied[i] = NULL;
    }
    c->b[0x14F] = 0; /* ch+$14F: number of items owned (max 16) */
    it = c->items;
    c->b[0x188] = 0; /* ch+$188: hands used by the readied items (max 2) */
    CH_PUTW(c, 0x18C, 0); /* ch+$18C: encumbrance: weight of items and coins (word) */
    s_ready_weight = 0;
    while (it != NULL) {
        add_to_byte(&c->b[0x14F], 1); /* ch+$14F: number of items owned (max 16) */
        w = COK_GET16(it->b + 0x3E); /* item+$3E: (word) unit weight of the item */
        if (it->b[0x40] > 0) { /* item+$40: quantity (identical pieces grouped, max 255) */
            w = (u16)(it->b[0x40] * w); /* item+$40: quantity (identical pieces grouped, max 255) */
        }
        CH_PUTW(c, 0x18C, (u16)(CH_W(c, 0x18C) + w)); /* ch+$18C: encumbrance: weight of items and coins (word) */
        if (it->b[0x3A]) { /* item+$3A: item readied flag (Ready) */
            s_ready_weight = (u16)(s_ready_weight + w);
            /* $336C: item types, $12 bytes per type (+$30): +0 slot/kind; ogg+$30: type of
             * the item (index into the table H005+$336C, $12 bytes per entry) */
            slot = ITEM_TYPE(it->b[0x30], 0);
            if (slot <= 8) {
                c->readied[slot] = it;
            } else if (slot == 9) {
                if (c->readied[9] != NULL) {
                    if (c->readied[10] == NULL) {
                        c->readied[10] = it;
                    }
                } else {
                    c->readied[9] = it;
                }
            }
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            if (it->b[0x30] == 0x1E) {
                c->readied[11] = it;
            }
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            if (it->b[0x30] == 0x0C) {
                c->readied[12] = it;
            }
            /* ch+$188: hands used by the readied items (max 2); $336D: item types +1: hands used (added
             * to +$188, max 2); ogg+$30: type of the item (index into the table H005+$336C,
             * $12 bytes per entry) */
            c->b[0x188] = (u8)(c->b[0x188] + ITEM_TYPE(it->b[0x30], 1));
        }
        it = it->next;
    }
    for (i = 1; i <= 6; ++i) {
        /* ch+$18C: encumbrance: weight of items and coins (word); ch+$F0: coins, 7 words step 2
         * (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
        CH_PUTW(c, 0x18C, (u16)(CH_W(c, 0x18C) + CH_W(c, 0xF0 + i * 2)));
    }
    for (i = 1; i <= 2; ++i) {
        /* ch+$19F: attacks of the round, attack 2; base -1 of the dice +$1A0..; ch+$111: attacks
         * every 2 rounds of attack 2; base -1 of the dice +$112.. */
        c->b[0x1A0 + i - 1] = c->b[0x112 + i - 1];
        /* ch+$1A1: number of dice of attack 2; base -1 of the sides +$1A2..; ch+$113: number of
         * dice of attack 2; base -1 of the sides +$114.. */
        c->b[0x1A2 + i - 1] = c->b[0x114 + i - 1];
        /* ch+$116: base damage bonus, 2 words (attack 1 and 2); ch+$1A4: damage bonus, 2 words
         * (attack 1 and 2) */
        CH_PUTW(c, 0x1A4 + (i - 1) * 2, CH_W(c, 0x116 + (i - 1) * 2));
    }
    for (i = 0; i <= 4; ++i) {
        ac[i] = 0;
    }
    CH_PUTW(c, 0x18A, 0); /* ch+$18A: saving throw bonus from the readied items (word, +$38) */
    /* ch+$19C: encoded current armour class (60 - AC); ch+$11A: encoded base armour class (50 =
     * AC 10) */
    c->b[0x19C] = c->b[0x11A];
    /* ch+$1A9: current movement (armour and encumbrance); ch+$DA: base movement (12 at creation) */
    c->b[0x1A9] = c->b[0xDA];
    /* ch+$19B: encoded current THAC0 (60 - THAC0); ch+$5A: encoded base THAC0 (60 - THAC0) from
     * the per-level table */
    c->b[0x19B] = c->b[0x5A];
    ac[0] = dex_ac_adj(c);
    if (c->readied[0] == NULL) {
        /* ch+$19B: encoded current THAC0 (60 - THAC0) */
        c->b[0x19B] = (u8)(c->b[0x19B] + str_hit_bonus(c));
        /* ch+$1A4: damage bonus, 2 words (attack 1 and 2) */
        CH_PUTW(c, 0x1A4, (u16)(str_damage_bonus(c) + CH_W(c, 0x1A4)));
    }
    weapon_stats(c);
    for (it = c->items; it != NULL; it = it->next) {
        if (it->b[0x3A]) { /* item+$3A: item readied flag (Ready) */
            armor_movement(c, it);
            armor_class_part(c, it, ac, &flag9);
        }
    }
    if (flag9) {
        ac[3] = 0;
    }
    if (flag_a) {
        if (CH_W(c, 0x18C) < 0x1388) { /* ch+$18C: encumbrance: weight of items and coins (word) */
            CH_PUTW(c, 0x18C, 0); /* ch+$18C: encumbrance: weight of items and coins (word) */
        } else {
            /* ch+$18C: encumbrance: weight of items and coins (word) */
            CH_PUTW(c, 0x18C, (u16)(CH_W(c, 0x18C) - 0x1388));
        }
        if (CH_W(c, 0x18C) < s_ready_weight) { /* ch+$18C: encumbrance: weight of items and coins (word) */
            CH_PUTW(c, 0x18C, s_ready_weight); /* ch+$18C: encumbrance: weight of items and coins (word) */
        }
    }
    encumbrance_movement(c);
    if (ac[4] < (s16)c->b[0x19C]) { /* ch+$19C: encoded current armour class (60 - AC) */
        ac[4] = c->b[0x19C]; /* ch+$19C: encoded current armour class (60 - AC) */
    }
    c->b[0x19C] = 0; /* ch+$19C: encoded current armour class (60 - AC) */
    for (i = 0; i <= 4; ++i) {
        /* ch+$19C: encoded current armour class (60 - AC) */
        c->b[0x19C] = (u8)(c->b[0x19C] + ac[i]);
    }
    /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
    c->b[0x19D] = (u8)(ac[4] + ac[2] + ac[3] - 2);
    /* ch+$100: fighter level; ch+$108: previous fighter level */
    if ((c->b[0x100] > 0 || (c->b[0x108] > 0 && h073_130a(c)) ||
         /* ch+$105: knight level; ch+$102: ranger level; ch+$5B: race (0..6, names H005+$4D04) */
         c->b[0x105] > 0 || c->b[0x102] > 0) && c->b[0x5B] < 7) {
        /* ch+$D2: fighting level (max +$100/+$105/+$102, or 1): sweeps; ch+$100: fighter level */
        c->b[0xD2] = c->b[0x100];
        /* ch+$105: knight level; ch+$D2: fighting level (max +$100/+$105/+$102, or 1): sweeps */
        if (c->b[0x105] > c->b[0xD2]) {
            /* ch+$D2: fighting level (max +$100/+$105/+$102, or 1): sweeps; ch+$105: knight
             * level */
            c->b[0xD2] = c->b[0x105];
        }
        /* ch+$102: ranger level; ch+$D2: fighting level (max +$100/+$105/+$102, or 1): sweeps */
        if (c->b[0x102] > c->b[0xD2]) {
            /* ch+$D2: fighting level (max +$100/+$105/+$102, or 1): sweeps; ch+$102: ranger
             * level */
            c->b[0xD2] = c->b[0x102];
        }
    } else {
        c->b[0xD2] = 1; /* ch+$D2: fighting level (max +$100/+$105/+$102, or 1): sweeps */
    }
}

/*
 * PORT H063+$1F34: name of the character at (col, row): colour $0C if
 * +$198 = 0, $0E if +$199 = 1 during combat ($3DE3 = 5),
 * otherwise $0B; with possessive it adds "'s".
 */
void draw_character_name(Character *c, u16 col, u16 row, u8 possessive)
{
    u16 pen;                            /* -$2(a5) */

    if (c->b[0x198] == 0) { /* ch+$198: active/standing (0 down or out of the combat) */
        pen = 0x0C;
    /* ch+$199: side in combat (0 party, 1 opponents); $3DE3: current game mode/context (0 menu, 1
     * view, 5 combat) */
    } else if (c->b[0x199] == 1 && H005_B(0x3DE3) == 5) {
        pen = 0x0E;
    } else {
        pen = 0x0B;
    }
    ui_draw_text(col, row, pen, 0, 0x0F, (const char *)c->b);
    if (possessive) {
        ui_draw_text((u16)(h026_strlen(0x0F, (const char *)c->b) + col), row,
                     pen, 0, 2, "'s");
    }
}

/*
 * PORT H063+$3F72: row of the experience table H005+$1946 ($9A
 * bytes per row) for class cls: according to +$5E (cleric), +$5D (class
 * 7), +$5F (class 5).  For classes 1 and 3, and for +$5D outside 1..3,
 * the original returns an uninitialised value; here 0.
 */
u8 class_xp_row(Character *c, u8 cls)
{
    u8 row = 0;                         /* -$1(a5) */

    switch (cls) {
    case 0:
        /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
        row = (u8)(c->b[0x5E] > 4 ? 1 : 0);
        break;
    case 2:
        row = 2;
        break;
    case 4:
        row = 6;
        break;
    case 5:
        /* ch+$5F: mage order (1 alignm. 0/3/6, 2 for 1/4/7, 0 none) */
        row = (u8)(c->b[0x5F] == 1 ? 7 : 8);
        break;
    case 6:
        row = 9;
        break;
    case 7:
        switch (c->b[0x5D]) { /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
        case 1:
            row = 3;
            break;
        case 2:
            row = 4;
            break;
        case 3:
            row = 5;
            break;
        default:
            break;
        }
        break;
    default:
        break;
    }
    return row;
}

/*
 * PORT H063+$1D44: message on row $18 (text by value), message
 * pause, then the row is cleared.
 */
void show_message_line(u16 len, const char *text)
{
    char copy[0x100];
    u16 i;

    for (i = 0; i <= len && i < sizeof(copy) - 1; ++i) {
        copy[i] = text[i];
    }
    copy[i] = 0;
    clear_text_cells(0, 0x18, 0x27, 0x18);
    ui_draw_text(0, 0x18, 0x0A, 0, len, copy);
    message_delay();
    clear_text_cells(0, 0x18, 0x27, 0x18);
}

/*
 * PORT H063+$0D80: party list (name, AC, HP) from row 4, in
 * column 1 (outside combat) or $11; the current character in
 * white.  Sets the clickable area H005+$248A..$248D.  It does not draw in
 * combat without H005 state A +$270, nor with $24AE.
 */
void draw_party(Character *current)
{
    Character *m;                       /* -$4(a5) */
    u16 col;                            /* -$6(a5) */
    u16 row;                            /* -$8(a5) */
    u16 off;                            /* -$a(a5) */

    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat); A+$270: (word) town area:
     * no view redraw nor EXIT from the camp */
    if ((H005_B(0x3DE3) == 3 && COK_GET16(g_state_a + 0x270) == 0) ||
        H005_B(0x24AE)) { /* $24AE: 1 with a full-screen big picture: no party list */
        return;
    }
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    col = (u16)(H005_B(0x3DE3) == 0 ? 1 : 0x11);
    H005_B(0x248D) = (u8)col; /* $248D: clickable party area: first column (1 or $11) */
    H005_B(0x248B) = 4; /* $248B: clickable party area: first row (4) */
    H005_B(0x248C) = 0x26; /* $248C: clickable party area: last column ($26) */
    H005_B(0x248A) = 3; /* $248A: clickable party area: last row (3 + members) */
    row = 2;
    ui_draw_text(col, row, 0x0F, 0, 4, "Name");
    ui_draw_text(0x21, row, 0x0F, 0, 6, "AC  HP");
    row = (u16)(row + 2);
    for (m = g_party_head; m != NULL; m = m->next) {
        add_to_byte(&H005_B(0x248A), 1); /* $248A: clickable party area: last row (3 + members) */
        clear_text_cells(col, row, 0x26, row);
        if (m == current) {
            ui_draw_text(col, row, 0x0F, 0, 0x0F, (const char *)m->b);
        } else {
            draw_character_name(m, col, row, 0);
        }
        if (m->b[0x19C] < 0x33) { /* ch+$19C: encoded current armour class (60 - AC) */
            off = 1;
        } else if (m->b[0x19C] < 0x3D) { /* ch+$19C: encoded current armour class (60 - AC) */
            off = 2;
        } else if (m->b[0x19C] < 0x46) { /* ch+$19C: encoded current armour class (60 - AC) */
            off = 1;
        } else {
            off = 0;
        }
        draw_armor_class(m, (u16)(off + 0x20), row);
        if (m->b[0x1A8] < 0x0A) { /* ch+$1A8: current hit points */
            off = 2;
        } else if (m->b[0x1A8] < 0x64) { /* ch+$1A8: current hit points */
            off = 1;
        } else {
            off = 0;
        }
        draw_hit_points(m, (u16)(off + 0x24), row, 0, 0);
        ++row;
    }
    clear_text_cells(col, row, 0x26, row);
}

/*
 * PORT H063+$321A (body at $3384): redraws the screen according to the game
 * mode $3DE3 (0 menu frame, 1 view, 2 and 6 "PIC" pictures $3B and
 * $3C, 3 and 4 combat/camp) and the party; $24E1 = 1.
 */
void redraw_game_screen(void)
{
    H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
    switch (H005_B(0x3DE3)) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    case 0:                             /* H063+$3238 */
        draw_screen_frame(1);
        break;
    case 1:                             /* H063+$3244 */
        if (H005_B(0x24C2)) { /* $24C2: 1: in context 1 the redraw includes the exploration frame */
            draw_explore_frame();
        }
        /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        if (COK_GET16(g_state_a + 0x1CC) == 0) {
            show_picture(3, 3, 1, g_pic_rec_27c2);
        } else {
            /* $2488: head of the head+body portrait shown (for redrawing); $2487: body of the
             * head+body portrait shown (for redrawing) */
            load_head_body(H005_B(0x2488), H005_B(0x2487));
            draw_head_body(3, 3, 1);
        }
        draw_party(g_current_char);
        draw_status_line();
        break;
    case 2:                             /* H063+$32BC */
        draw_explore_frame();
        load_sequence(3, "PIC", 0x3B, 0);
        draw_party(g_current_char);
        draw_status_line();
        break;
    case 4:                             /* H063+$32EE */
        draw_explore_frame();
        /* A+$270: (word) town area: no view redraw nor EXIT from the camp */
        if (COK_GET16(g_state_a + 0x270) == 0) {
            refresh_view();
        }
        draw_party(g_current_char);
        draw_status_line();
        H005_B(0x24B2) = 0; /* $24B2: 1: exploration frame to be redrawn (after LOAD FILES) */
        break;
    case 3:                             /* H063+$3320 */
        /* $2486: id of the sequence loaded at $27BC (name at $27A6), $FF none; A+$270: (word)
         * town area: no view redraw nor EXIT from the camp */
        if (H005_B(0x2486) != 9 && COK_GET16(g_state_a + 0x270) == 0) {
            refresh_view();
        }
        break;
    case 6:                             /* H063+$3346 */
        draw_explore_frame();
        load_sequence(3, "PIC", 0x3C, 0);
        draw_party(g_current_char);
        break;
    default:
        break;
    }
}

/*
 * PORT H063+$1BE8: removes item it from the list of c and frees it
 * (error messages if it is null or not in the list).
 */
void delete_item(Character *c, CokItem *it)
{
    CokItem *p;                         /* -$4(a5) */

    debug_trace(0x0F, (const char *)c->b, 0, 0, 0);
    if (it == NULL) {
        show_message_wait(0x0E, 0, 0x13, "Nil Item pointer...");
        return;
    }
    p = c->items;
    if (p == it) {
        c->items = it->next;
    } else {
        while (p != NULL && p->next != it) {
            p = p->next;
        }
    }
    if (p == NULL) {
        show_message_wait(0x0E, 0, 0x26,
                          "Tried to Lose item & couldn't find it!");
        return;
    }
    p->next = it->next;
    it->next = NULL;
    exec_free_mem(it, sizeof(CokItem));
}

/*
 * PORT H063+$1DC2: name of the character and text (word-wrapped) in the
 * message area: in combat on the right from ($17, row), otherwise
 * at the bottom from row $11 ($12 with $24E2); wait: wait and clean-up.
 */
void show_char_message(Character *c, u16 len, const char *text, u16 row,
                       u8 wait)
{
    u16 top;                            /* -$2(a5) */

    if (H005_B(0x3DE3) == 5) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        clear_text_cells(0x17, row, 0x26, 0x15);
        draw_character_name(c, 0x17, row, 0);
        word_wrap_text(0x17, (u16)(row + 1), 0x26, 0x15, 0x0A, 0, 1, len,
                       text);
    } else {
        if (H005_B(0x24E2)) { /* $24E2: 1 while resting: wait pointer, messages from row $12 */
            top = 0x12;
        } else {
            top = 0x11;
        }
        clear_text_cells(1, top, 0x26, 0x16);
        draw_character_name(c, 1, (u16)(top + 1), 0);
        word_wrap_text(1, (u16)(top + 2), 0x26, 0x16, 0x0A, 0, 1, len, text);
    }
    if (wait) {
        message_delay();
        clear_message_area();
    }
}

/* PORT H063+$1EE8: clears the message area. */
void clear_message_area(void)
{
    if (H005_B(0x3DE3) == 5) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        clear_text_cells(0x17, 0x0A, 0x26, 0x15);
    } else {
        clear_text_cells(1, 0x12, 0x26, 0x16);
    }
}

/* PORT H063+$2F12: clears the combat turn (block +$192). */
u8 end_combat_turn(Character *c)
{
    u8 *turn = c->block_192->b;

    COK_PUT16(&turn[4], 0);
    turn[0] = 0;
    turn[9] = 0;
    turn[8] = 0;
    return 1;
}

/*
 * PORT H063+$3A26: chooses a party member into *out with
 * "Select [Exit]": the arrows (special codes 'H' up, 'P' down) change
 * character; with_exit: Exit or 0 cancel (*out = NULL).
 */
void choose_party_member(u16 len, const char *text, u8 with_exit,
                         u8 mode, Character **out)
{
    char prompt[0x52];                  /* text by value + " " */
    char options[0x2A];                 /* -$5c(a5) */
    char tail[0x2A];                    /* -$32(a5) */
    Character *node;                    /* -$8(a5) */
    /* $24A2: 1: clicking a party name selects the character */
    u8 saved = H005_B(0x24A2);          /* -$5d(a5) */
    u8 animate;                         /* -$3(a5) */
    u8 special;                         /* -$2(a5) */
    u8 key;                             /* -$1(a5) */

    h026_copy(sizeof(prompt) - 1, prompt, len, text);
    H005_B(0x24D8) = mode; /* $24D8: member choice mode: the click goes to $2508 and not to the current one */
    g_h005_2508 = g_current_char;
    key = ' ';
    strcpy(tail, "");
    h026_append(len, prompt, 1, " ");
    if (with_exit) {
        strcpy(tail, " Exit");
    }
    while (key != 'E' && key != 0x1B && key != 'S' && key != '\r') {
        draw_party(*out);
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        if (H005_B(0x3DE3) == 2 || H005_B(0x3DE3) == 6) {
            animate = 1;
        } else {
            animate = 0;
        }
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        if (H005_B(0x3DE3) == 0) {
            H005_B(0x24A2) = 1; /* $24A2: 1: clicking a party name selects the character */
        }
        strcpy(options, "Select");
        h026_append(0x28, options, 0x28, tail);
        key = ui_request_choice(len, prompt, 0x28, options, 0x0D, 0x0A, 0x0F,
                                1, animate, &special);
        H005_B(0x24A2) = saved; /* $24A2: 1: clicking a party name selects the character */
        node = *out;
        if (special) {
            switch (key) {
            case 'P':                   /* $3B94: down arrow */
                node = node->next;
                if (node == NULL) {
                    node = g_party_head;
                }
                break;
            case 'H':                   /* $3BB0: up arrow */
                if (H005_B(0x249E)) { /* $249E: 1 if the key comes from the mouse (click) */
                    /* $24D8: member choice mode: the click goes to $2508 and not to the current one */
                    if (H005_B(0x24D8)) {
                        node = g_h005_2508;
                    } else {
                        node = g_current_char;
                    }
                } else {
                    node = g_party_head;
                    if (*out == g_party_head) {
                        while (node->next != NULL) {
                            node = node->next;
                        }
                    } else {
                        while (node->next != *out) {
                            node = node->next;
                        }
                    }
                }
                break;
            default:
                break;
            }
        } else if (with_exit) {
            if (key == 'E' || key == 0) {
                node = NULL;
            }
        }
        *out = node;
    }
    H005_B(0x24D8) = 0; /* $24D8: member choice mode: the click goes to $2508 and not to the current one */
}

/* PORT H063+$1CC0: appends a copy of item it to c. */
void give_item_copy(Character *c, CokItem *it)
{
    CokItem *copy;                      /* -$8(a5) */
    CokItem *p;                         /* -$4(a5) */

    copy = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
    memcpy(copy->b, it->b, 0x48);       /* CopyMem($48) */
    copy->next = NULL;
    p = c->items;
    if (p == NULL) {
        c->items = copy;
    } else {
        while (p->next != NULL) {
            p = p->next;
        }
        p->next = copy;
    }
}

/* PORT H063+$2ACC: "is fully healed" o "is partially healed". */
void heal_message(Character *c)
{
    char text[0x2A];                    /* -$2a(a5) */

    if (c->b[0x1A8] == c->b[0x64]) { /* ch+$1A8: current hit points; ch+$64: maximum hit points */
        strcpy(text, "is fully healed");
    } else {
        strcpy(text, "is partially healed");
    }
    show_char_message(c, 0x28, text, 0x0A, 1);
    if (H005_B(0x3DE3) != 5) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        draw_party(g_current_char);
    }
}

/*
 * PORT H063+$2FAA: caster level of the current character for
 * spell (from the class of the spell); 6 for whoever is not a caster and
 * for the items ($24D9) except class 4.  For a class beyond 4
 * the original returns the uninitialised word; here 0.
 */
s16 caster_level(u16 spell)
{
    Character *c = g_current_char;
    s16 a;                              /* -$2(a5) */
    s16 b;                              /* -$4(a5) */
    s16 level = 0;                      /* -$8(a5) */

    /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; ch+$103: mage level;
     * ch+$105: knight level */
    if (c->b[0xFE] == 0 && c->b[0x103] == 0 && c->b[0x105] < 9 &&
        c->b[0x102] < 8) { /* ch+$102: ranger level */
        level = 6;
    } else {
        switch (H005_B(0x66 + (spell - 1) * 16)) {
        case 0:
        case 2:                         /* $3012 */
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; ch+$106:
             * levels of the previous class, 8 entries like +$FE; cleric */
            a = (s16)(c->b[0xFE] + c->b[0x106] * h073_130a(c));
            /* ch+$105: knight level; ch+$10D: previous knight level */
            b = (s16)(c->b[0x105] + c->b[0x10D] * h073_130a(c) - 8);
            level = a > b ? a : b;
            break;
        case 1:                         /* $30A6 */
            level = 0;
            break;
        case 3:                         /* $30AC */
            /* ch+$103: mage level; ch+$10B: previous mage level */
            a = (s16)(c->b[0x103] + c->b[0x10B] * h073_130a(c));
            /* ch+$102: ranger level; ch+$10A: previous ranger level */
            b = (s16)(c->b[0x102] + c->b[0x10A] * h073_130a(c) - 8);
            /* ch+$103: mage level; ch+$5F: mage order (1 alignm. 0/3/6, 2 for 1/4/7, 0 none) */
            if (c->b[0x103] > 0 && c->b[0x5F] > 0) {
                /* A+$3F0: tab. of cycle phase words (idx CH+$5F, 1..3); entry 0 set to 1 by H070;
                 * ch+$5F: mage order (1 alignm. 0/3/6, 2 for 1/4/7, 0 none) */
                switch (COK_GET16(g_state_a + (c->b[0x5F] + 0x1F8) * 2)) {
                case 0:
                    --a;
                    break;
                case 2:
                    ++a;
                    break;
                default:
                    break;
                }
            }
            level = a > b ? a : b;
            break;
        case 4:                         /* $31B4 */
            level = 0x0C;
            break;
        default:
            break;
        }
    }
    /* $24D9: 1 if the spell comes from an item (it is not forgotten) */
    if (H005_B(0x24D9) && H005_B(0x66 + (spell - 1) * 16) != 4) {
        level = 6;
    }
    return level;
}

/* PORT H063+$1B90: removes from c the first memorised spell spell. */
void forget_spell(Character *c, u16 spell)
{
    u16 i;                              /* -$2(a5) */

    for (i = 0; i <= 0x39; ++i) {
        /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
        if (c->b[0x1E + i] == spell) {
            /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
            c->b[0x1E + i] = 0;
            i = 0x3A;
        }
    }
}

/*
 * PORT H063+$2760: message of an effect on c.  In combat it
 * redraws, plays a sound and flashes the icon of the target ($3DF6 times
 * if flag); otherwise like H063+$1DC2 with a wait.
 */
void show_effect_message(Character *c, u8 flag, u16 len, const char *text)
{
    s16 x;                              /* -$2(a5) */
    s16 y;                              /* -$4(a5) */
    u16 frame;                          /* -$8(a5) */
    u16 n;                              /* -$a(a5) */
    u16 times;                          /* -$c(a5) */
    u16 k;                              /* index of c, read once */

    if (H005_B(0x3DE3) != 5) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        show_char_message(c, len, text, 0x0A, 1);
        return;
    }
    load_missile_frames(flag ? 0x16 : 0x17);
    if (!combatant_visible(c, 1)) {
        x = (s16)combatant_x(c);
        y = (s16)combatant_y(c);
        center_view((u16)x, (u16)y, 3, 8);
    }
    if (flag) {
        h043_190e(7);
    /* $2475: incoming effect (0 = cancelled by the handlers) */
    } else if (H005_B(0x2475) == 0x42 || H005_B(0x2475) == 0x55 ||
               H005_B(0x2471) == 0x33) { /* $2471: spell being cast (0 = none) */
        h043_190e(3);
    } else {
        h043_190e(0x13);
    }
    show_char_message(c, len, text, 0x0A, 0);
    if (flag) {
        times = H005_W(0x3DF6); /* $3DF6: (word) game speed 0..9 (message pause) */
    } else {
        times = 0;
    }
    k = combatant_index(c);
    /* $3104: (word) column in the view for combatant n (step 2, from 1) */
    x = (s16)(H005_W(0x3104 + (k - 1) * 2) * 3);
    /* $30B4: (word) row in the view for combatant n (step 2, from 1) */
    y = (s16)(H005_W(0x30B4 + (k - 1) * 2) * 3);
    for (n = 0; n <= times; ++n) {
        for (frame = 0; frame <= 3; ++frame) {
            draw_tile24_saving((u16)(x * 8), (u16)(y * 8), (u8)frame, 5,
                               g_gfx_243a, g_gfx_3d8e);
            dos_delay(3);
            draw_tile24_saving((u16)(x * 8), (u16)(y * 8), 0, 0,
                               g_gfx_3d8a, g_gfx_3d8e);
        }
    }
    if (times == 0) {
        message_delay();
    }
}

/*
 * PORT H063+$2984: removes dmg hit points (+$1A8) from c: more than 9 below
 * zero (or a dying one at 0) it dies (6), below zero it is dying (5), at 0 it is
 * unconscious (4).  Whoever is no longer active goes to 0 HP.
 */
void damage_hit_points(Character *c, u16 dmg)
{
    u16 below = 0;                      /* -$2(a5) */
    u16 left = 0;                       /* -$4(a5) */

    if (c->b[0x1A8] >= dmg) { /* ch+$1A8: current hit points */
        left = (u16)(c->b[0x1A8] - dmg); /* ch+$1A8: current hit points */
    } else {
        below = (u16)(dmg - c->b[0x1A8]); /* ch+$1A8: current hit points */
    }
    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    if (below > 9 || (left == 0 && c->b[0x197] == 1)) {
        c->b[0x197] = 6; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    } else if (below > 0) {
        c->b[0x197] = 5; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        if (H005_B(0x3DE3) == 5) {
            /* turn+$10: rounds spent below zero hit points (beyond 9 it dies) */
            (c->block_192->b)[0x10] = (u8)below;
        }
    } else if (left == 0) {
        c->b[0x197] = 4; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    }
    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    if (c->b[0x197] != 0 && c->b[0x197] != 1) {
        c->b[0x198] = 0; /* ch+$198: active/standing (0 down or out of the combat) */
        c->b[0x1A8] = 0; /* ch+$1A8: current hit points */
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        if (H005_B(0x3DE3) == 5) {
            /* $2A1C: active combatants of side 0; byte table indexed by side; ch+$199: side in
             * combat (0 party, 1 opponents) */
            H005_B(0x2A1C + c->b[0x199]) =
                /* $2A1C: active combatants of side 0; byte table indexed by side; ch+$199: side in
                 * combat (0 party, 1 opponents) */
                (u8)(H005_B(0x2A1C + c->b[0x199]) - 1);
            /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
            COK_PUT16(c->block_192->b + 4, 0);
        }
    } else {
        c->b[0x1A8] = (u8)left; /* ch+$1A8: current hit points */
    }
}

/* PORT H063+$2B7C: counts the active combatants per side into $2A1C/$2A1D. */
void count_sides(void)
{
    Character *p;                       /* -$4(a5) */

    H005_B(0x2A1C) = 0; /* $2A1C: active combatants of side 0; byte table indexed by side */
    H005_B(0x2A1D) = 0; /* $2A1D: active combatants of side 1 (entry 2 of $2A1C) */
    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
            /* $2A1C: active combatants of side 0; byte table indexed by side; ch+$199: side in
             * combat (0 party, 1 opponents) */
            add_to_byte(&H005_B(0x2A1C + p->b[0x199]), 1);
        }
    }
}

/* PORT H063+$135A: does c have one of the effects H005+$4066..$4069 (helpless)? */
u8 is_helpless(Character *c)
{
    CokEffect *e;                       /* -$6(a5) */
    u16 i;                              /* -$2(a5) */
    u8 found = 0;                       /* -$7(a5) */

    for (i = 1; i <= 4; ++i) {
        /* $4065: i-1 base of the 4 helplessness effects ($4066..$4069) */
        if (find_effect(c, H005_B(0x4066 + i - 1), &e)) {
            found = 1;
        }
    }
    return found;
}

/*
 * PORT H063+$1160: panel of combatant c on the right (name, hit
 * points, AC, readied weapon and status), if $24C7 asks for it.
 */
void draw_combat_status(Character *c)
{
    u16 row;                            /* -$4(a5) */

    if (!H005_B(0x24C7)) { /* $24C7: 1: combatant panel on the right to be redrawn */
        return;
    }
    H005_B(0x24C7) = 0; /* $24C7: 1: combatant panel on the right to be redrawn */
    clear_text_cells(0x17, 1, 0x26, 0x15);
    row = 1;
    show_char_message(c, 1, " ", row, 0);
    ++row;
    ui_draw_text(0x17, (u16)(row + 1), 0x0A, 0, 9, "Hitpoints");
    draw_hit_points(c, 0x21, (u16)(row + 1), 0, 0);
    row = (u16)(row + 2);
    ui_draw_text(0x17, (u16)(row + 1), 0x0A, 0, 2, "AC");
    draw_armor_class(c, 0x1A, (u16)(row + 1));
    H005_SET_W(0x334C, (u16)(row + 1)); /* $334C: (word) text cursor: row */
    if (c->readied[0] != NULL) {
        row = (u16)(row + 2);
        build_item_name(c, c->readied[0], 0, 0, 0, 0);
        word_wrap_text(0x17, (u16)(row + 1), 0x26, (u16)(row + 1 + 2), 0x0A, 0,
                       1, 0x28, (const char *)c->readied[0]->b);
    }
    row = (u16)(H005_W(0x334C) + 1); /* $334C: (word) text cursor: row */
    if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        ui_draw_text(0x17, (u16)(row + 1), 0x0F, 0, 0x0C,
                     /* $4B00: names of the character status (+$197), $0E bytes; ECL var base; ch+$197: status: 0 ok,
                      * 4 unconscious, 5 dying, 6-8 dead, $0A down */
                     (const char *)&H005_B(0x4B00 + c->b[0x197] * 0x0E));
    } else if (is_helpless(c)) {
        ui_draw_text(0x17, (u16)(row + 1), 0x0F, 0, 0x0A, "(Helpless)");
    /* turn+$0: spell being prepared, cast at the start of the turn */
    } else if (c->block_192->b[0] > 0) {
        ui_draw_text(0x17, (u16)(row + 1), 0x0F, 0, 9, "(Casting)");
    }
}

/*
 * PORT H063+$2DC6: distance (half of the byte of H005+$2A3E) between c and t
 * in the area of c on the combat map; $2A3E is restored.
 */
u16 combat_distance(Character *c, Character *t)
{
    u8 saved[0xA0];                     /* -$3fc(a5) */
    u16 i;                              /* -$3fe(a5) */
    u16 d;                              /* -$400(a5) */
    u16 a;
    u16 b;

    /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
    memcpy(saved, &H005_B(0x2A3E), 0xA0);
    g_combat_area[8] = 1;
    a = combatant_x(c);
    b = combatant_y(c);
    find_in_area((s16)a, (s16)b, 0xFF, 0xFF, combatant_size(c), g_combat_area);
    g_combat_area[8] = 0;
    i = 1;
    /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
    while (g_combatants[H005_B(0x2A3E + (i - 1) * 4) - 1] != t &&
           i < H005_B(0x2479)) { /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
        ++i;
    }
    /* $2A3F: area list, byte 1: distance (cost, half = squares) */
    d = (u16)(H005_B(0x2A3E + (i - 1) * 4 + 1) >> 1);
    /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
    memcpy(&H005_B(0x2A3E), saved, 0xA0);
    return d;
}

/*
 * PORT H063+$37B2: weapon of c into *weapon (from the hand, +$154, or from the
 * ammunition +$180/+$184 according to the bits of H005+$336C+type*$12+$10);
 * true if there is one or if those bits are $A.
 */
u8 find_weapon(Character *c, CokItem **weapon)
{
    CokItem *it = c->readied[0];        /* -$4(a5) */
    u16 f = 0;                          /* -$6(a5) */

    *weapon = NULL;
    if (it != NULL) {
        /* $337C: item types +$10: weapon flags (dex/str, ammunition, melee); ogg+$30: type of
         * the item (index into the table H005+$336C, $12 bytes per entry) */
        f = H005_B(0x336C + it->b[0x30] * 0x12 + 0x10);
        if (mask_byte((u8)f, 0x10)) {
            *weapon = it;
        }
        if (mask_byte((u8)f, 8)) {
            if (mask_byte((u8)f, 1)) {
                *weapon = c->readied[11];       /* +$180 */
            }
            if (mask_byte((u8)f, 0x80)) {
                *weapon = c->readied[12];       /* +$184 */
            }
        }
    }
    return (u8)(*weapon != NULL || f == 0x0A);
}

/*
 * PORT H063+$1FDC: copies set which of slot slot ($3244) into
 * frame dest (column dest*24) of $243A, picture and mask;
 * with mirror it goes through a temporary mirrored record (H049+$09D6).
 */
void copy_sprite_frame(u16 slot, u16 which, u16 dest, u8 mirror)
{
    struct GfxRecord *tmp;              /* -$8(a5) */
    struct GfxRecord *src = g_sprite_sets[slot][which];

    if (mirror) {
        allocate_gfx_record(0x18, 3, 1, 1, &tmp);
        mirror_gfx_record(src, tmp);
        (void)graphics_blt_bitmap(tmp->image, 0, 0, g_gfx_243a->image,
                                  (u16)(dest * 0x18), 0, 0x18, 0x18, 0xC0,
                                  0xFF, NULL);
        (void)graphics_blt_bitmap(tmp->mask, 0, 0, g_gfx_243a->mask,
                                  (u16)(dest * 0x18), 0, 0x18, 0x18, 0xC0,
                                  0xFF, NULL);
        free_gfx_record(&tmp);
    } else {
        (void)graphics_blt_bitmap(src->image, 0, 0, g_gfx_243a->image,
                                  (u16)(dest * 0x18), 0, 0x18, 0x18, 0xC0,
                                  0xFF, NULL);
        (void)graphics_blt_bitmap(src->mask, 0, 0, g_gfx_243a->mask,
                                  (u16)(dest * 0x18), 0, 0x18, 0x18, 0xC0,
                                  0xFF, NULL);
    }
}

/*
 * PORT H063+$2178: prepares in $243A the 4 frames of missile slot:
 * set 0, set 0 mirrored, set 1 mirrored, set 1.
 */
void load_missile_frames(u16 slot)
{
    copy_sprite_frame(slot, 0, 0, 0);
    copy_sprite_frame(slot, 0, 1, 1);
    copy_sprite_frame(slot, 1, 2, 1);
    copy_sprite_frame(slot, 1, 3, 0);
}

/* Variables of H063+$21D2 read by the nested procedure $21E0. */
typedef struct MissileFrame {
    struct BitMap *dest;                /* -$42(a5) */
    s16 saved_x[2];                     /* -$34(a5) */
    s16 saved_y[2];                     /* -$38(a5) */
    u16 row;                            /* -$28(a5) */
} MissileFrame;

/*
 * PORT H063+$21E0 (nested in $21D2): on the bitmap in use (off screen
 * or screen) puts back the background saved in $3D8A (row -$8*24) for the
 * current buffer, if there is one.
 */
static void restore_missile_background(MissileFrame *f)
{
    f->row = (u16)(g_h029_m8 * 0x18);
    if (g_h029_m5) {
        f->dest = g_gfx_3d8e->image;
    } else {
        f->dest = &g_screen->BitMap;
    }
    if (f->saved_x[g_h029_m8] >= 0) {
        (void)graphics_blt_bitmap(g_gfx_3d8a->image, 0, f->row, f->dest,
                                  (u16)(f->saved_x[g_h029_m8] + 8),
                                  (u16)(f->saved_y[g_h029_m8] + 8), 0x18,
                                  0x18, 0xC0, 0xFF, NULL);
    }
}

/*
 * PORT H063+$21D2: missile from (x0, y0) to (x1, y1): follows the line in
 * steps of 2 pixels with frames 0..frames-1 of $243A (one every 6
 * steps), alternating the two Views; the view moves when the
 * missile leaves it.  unused is not read.
 */
void animate_missile(s16 x0, s16 y0, s16 x1, s16 y1, u16 frames, u16 unused)
{
    MissileFrame f;
    u8 offscreen;                       /* -$1(a5) */
    u8 major_x;                         /* -$2(a5) */
    s16 px;                             /* -$4(a5) */
    s16 py;                             /* -$6(a5) */
    s16 cx;                             /* -$8(a5) */
    s16 cy;                             /* -$A(a5) */
    s16 rx;                             /* -$C(a5) */
    s16 ry;                             /* -$E(a5) */
    s16 vx = 0;                         /* -$10(a5) */
    s16 vy = 0;                         /* -$12(a5) */
    s16 ddx;                            /* -$14(a5) */
    s16 ddy;                            /* -$16(a5) */
    s16 sx = 0;                         /* -$18(a5) */
    s16 sy = 0;                         /* -$1A(a5) */
    s16 a;                              /* -$1C(a5) */
    s16 b;                              /* -$1E(a5) */
    s16 step_a;                         /* -$20(a5) */
    s16 step_b;                         /* -$22(a5) */
    s16 acc;                            /* -$24(a5) */
    s16 minor;                          /* -$26(a5) */
    s16 k;                              /* -$2A(a5) */
    s16 n;                              /* -$2C(a5) */
    s16 half;                           /* -$2E(a5) */
    s16 count;                          /* -$30(a5) */
    u16 frame = 0;                      /* -$3A(a5) */

    (void)unused;
    f.dest = NULL;
    f.row = 0;
    f.saved_x[0] = f.saved_x[1] = -1;
    f.saved_y[0] = f.saved_y[1] = 0;
    px = (s16)(x0 * 0x18);
    py = (s16)(y0 * 0x18);
    ddx = (s16)((x1 - x0) * 0x18);
    ddy = (s16)((y1 - y0) * 0x18);
    major_x = (u8)((ddx < 0 ? -ddx : ddx) > (ddy < 0 ? -ddy : ddy));
    if (major_x) {
        a = px;
        b = py;
        step_a = (s16)(ddx > 0 ? 2 : -2);
        half = (s16)((ddx < 0 ? -ddx : ddx) / 2);
        minor = (s16)(ddy < 0 ? -ddy : ddy);
        step_b = (s16)(ddy > 0 ? 1 : -1);
    } else {
        a = py;
        b = px;
        step_a = (s16)(ddy > 0 ? 2 : -2);
        half = (s16)((ddy < 0 ? -ddy : ddy) / 2);
        minor = (s16)(ddx < 0 ? -ddx : ddx);
        step_b = (s16)(ddx > 0 ? 1 : -1);
    }
    count = (s16)(half - 1);
    acc = (s16)(minor / 4);
    offscreen = 0;
    while (count > 0) {
        cx = (s16)(px / 0x18);
        cy = (s16)(py / 0x18);
        rx = (s16)(x1 - cx);
        ry = (s16)(y1 - cy);
        if ((!in_view((s16)(cx - (s16)COK_GET16(g_combat_area + 2)),
                      (s16)(cy - (s16)COK_GET16(g_combat_area + 4))) ||
             !in_view((s16)(x1 - (s16)COK_GET16(g_combat_area + 2)),
                      (s16)(y1 - (s16)COK_GET16(g_combat_area + 4)))) &&
            (rx < 0 ? -rx : rx) <= 6 && (ry < 0 ? -ry : ry) <= 6) {
            vx = (s16)(rx / 2 + cx);
            vy = (s16)(ry / 2 + cy);
        } else if (offscreen) {
            if (sx < 0) {
                vx = (s16)(vx - 6);
            }
            if (sx > 0x90) {
                vx = (s16)(vx + 6);
            }
            if (sy < 0) {
                vy = (s16)(vy - 6);
            }
            if (sy > 0x90) {
                vy = (s16)(vy + 6);
            }
        } else {
            vx = (s16)((s16)COK_GET16(g_combat_area + 2) + 3);
            vy = (s16)((s16)COK_GET16(g_combat_area + 4) + 3);
        }
        center_view(vx, vy, 0xFF, 8);
        copy_screen_to_offscreen();
        offscreen = 0;
        sx = (s16)(px - (s16)COK_GET16(g_combat_area + 2) * 0x18);
        f.saved_x[0] = -1;
        f.saved_x[1] = -1;
        sy = (s16)(py - (s16)COK_GET16(g_combat_area + 4) * 0x18);
        do {
            swap_display_view();
            restore_missile_background(&f);
            f.saved_x[g_h029_m8] = sx;
            f.saved_y[g_h029_m8] = sy;
            (void)graphics_blt_bitmap(f.dest, (u16)(sx + 8), (u16)(sy + 8),
                                      g_gfx_3d8a->image, 0, f.row, 0x18,
                                      0x18, 0xC0, 0xFF, NULL);
            draw_tile24((u16)sx, (u16)sy, (u8)frame, 1, g_gfx_243a,
                        g_gfx_3d8e);
            if (count % 6 == 0) {
                ++frame;
                if (frame >= frames) {
                    frame = 0;
                }
            }
            --count;
            a = (s16)(a + step_a);
            acc = (s16)(acc + minor);
            while (acc >= half) {
                acc = (s16)(acc - half);
                b = (s16)(b + step_b);
            }
            if (major_x) {
                px = a;
                py = b;
            } else {
                px = b;
                py = a;
            }
            sx = (s16)(px - (s16)COK_GET16(g_combat_area + 2) * 0x18);
            sy = (s16)(py - (s16)COK_GET16(g_combat_area + 4) * 0x18);
            if (sx < 0 || sy < 0 || sx > 0x90 || sy > 0x90) {
                offscreen = 1;
            }
        } while (!offscreen && count > 0);
        n = (s16)(3 - g_h029_m8);
        for (k = 1; k <= n; ++k) {
            swap_display_view();
            restore_missile_background(&f);
        }
        g_h029_m5 = 0;
        g_h029_m6 = 1;
    }
}

/* PORT H063+$2B4C: side opposite to that of c (+$199). */
u8 other_side(Character *c)
{
    return (u8)(c->b[0x199] == 0); /* ch+$199: side in combat (0 party, 1 opponents) */
}

/*
 * PORT H063+$2BDE: enemies of c within radius (area list reduced to the
 * combatants of the opposite side, numbers also in H005+$2444); with
 * effect $5B the combatant $2432 moves to the head of $2444.
 */
u16 count_enemies_near(Character *c, u16 radius)
{
    u16 n;                              /* -$2(a5) */
    u16 k = 0;                          /* -$4(a5) */
    u16 i;                              /* -$6(a5) */
    u16 result;                         /* -$8(a5) */
    CokEffect *e;                       /* -$C(a5) */
    u8 done;                            /* -$D(a5) */
    u16 t;

    find_in_area((s16)combatant_x(c), (s16)combatant_y(c), radius, 0xFF,
                 combatant_size(c), g_combat_area);
    n = H005_B(0x2479); /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    if (n > 0) {
        for (i = 1; i <= n; ++i) {
            /* ch+$199: side in combat (0 party, 1 opponents); $2A3E: area list: 4-byte entries
             * ($2479), byte 0 = combatant no. */
            if (g_combatants[H005_B(0x2A3E + (i - 1) * 4) - 1]->b[0x199] ==
                other_side(c)) {
                ++k;
                /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
                memcpy(&H005_B(0x2A3E + (k - 1) * 4),
                       /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
                       &H005_B(0x2A3E + (i - 1) * 4), 4);
            }
        }
        n = k;
        H005_B(0x2479) = (u8)k; /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    }
    result = n;
    for (i = 1; i <= n; ++i) {
        /* $2444..: list of the nearby enemies ($2444+i-1, i from 1); $2A3E:
         * area list: 4-byte entries ($2479), byte 0 = combatant no. */
        H005_B(0x2444 + i - 1) = H005_B(0x2A3E + (i - 1) * 4);
    }
    if (find_effect(c, 0x5B, &e)) {
        done = 0;
        for (i = 1; i <= n && !done; ++i) {
            /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
            if (g_combatants[H005_B(0x2444 + i - 1) - 1] == g_h005_2432) {
                /* $2444: list of the nearby enemies (combatant number, 1 byte per entry) */
                t = H005_B(0x2444);
                /* $2444: list of the nearby enemies (combatant number, 1 byte per entry);
                 * $2444..: nearby enemies ($2444+i-1) */
                H005_B(0x2444) = H005_B(0x2444 + i - 1);
                /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
                H005_B(0x2444 + i - 1) = (u8)t;
                done = 1;
            }
        }
    }
    return result;
}

/*
 * PORT H063+$33A0: status row of the map (row $F, columns $11..$26):
 * coordinates (if not hidden, +$1F6), direction, time, "*" ($24D2) and
 * " camping" or " search".  Not in context 3.
 */
void draw_status_line(void)
{
    char line[0x29];                    /* -$36(a5) */
    char hours[4];                      /* -$8(a5) */
    char minutes[4];                    /* -$C(a5) */
    char tmp[0x2A];                     /* -$60(a5) */
    u16 x;                              /* -$2(a5) */
    u16 y;                              /* -$4(a5) */
    u16 dir;                            /* -$62(a5) */

    if (H005_B(0x3DE3) == 3) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        return;
    }
    line[0] = '\0';
    x = H005_W(0x281C); /* $281C: (word) party x on the 16x16 area map */
    y = H005_W(0x281E); /* $281E: (word) party y on the 16x16 area map */
    /* A+$192: (word) hours of the game time */
    format_number(2, hours, (s32)COK_GET16(g_state_a + 0x192), 0, 0x0A, 2,
                  '0');
    format_number(2, minutes,
                  /* A+$190: (word) tens of minutes of the game time */
                  (s32)(u16)(COK_GET16(g_state_a + 0x190) * 0x0A +
                             /* A+$18E: (word) minutes (units) of the game time */
                             COK_GET16(g_state_a + 0x18E)),
                  0, 0x0A, 2, '0');
    /* A+$1F6: (word) area without a map: coordinates hidden, map "Not Here" */
    if (COK_GET16(g_state_a + 0x1F6) == 0) {
        format_number(0x28, line, (s32)x, 0, 0x0A, 2, '0');
        h026_append(0x28, line, 1, ",");
        format_number(0x28, tmp, (s32)y, 0, 0x0A, 2, '0');
        h026_append(0x28, line, 0x28, tmp);
        h026_append(0x28, line, 1, " ");
    }
    if (COK_GET16(g_state_a + 0x1CC) != 0) { /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        /* A+$3FE: use: forces the animation while waiting for a choice; added to the direction; $2820:
         * party direction (0 north, 2 east, 4 south, 6 west) */
        dir = (u16)(COK_GET16(g_state_a + 0x3FE) * 2 + H005_B(0x2820));
    } else {
        /* $2820: party direction (0 north, 2 east, 4 south, 6 west); A+$3FE: use: forces
         * the animation while waiting for a choice; added to the direction */
        dir = (u16)(H005_B(0x2820) + COK_GET16(g_state_a + 0x3FE));
    }
    if (dir >= 8) {
        dir = (u16)(dir - 8);
    }
    /* $3DB2: names of the compass points, 4 bytes per direction 0..7 */
    h026_append(0x28, line, 2, (const char *)&H005_B(0x3DB2 + dir * 4));
    h026_append(0x28, line, 1, " ");
    h026_append(0x28, line, 2, hours);
    h026_append(0x28, line, 1, ":");
    h026_append(0x28, line, 2, minutes);
    if (H005_B(0x24D2)) { /* $24D2: debug enabled ("*" in the status, extra values) */
        h026_append(0x28, line, 1, "*");
    }
    if (H005_B(0x3DE3) == 2) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        h026_append(0x28, line, 8, " camping");
    /* B+$594: (word) bit 0 search mode, bit 1 Look in progress */
    } else if (mask_byte((u8)COK_GET16(g_state_b + 0x594), 1) > 0) {
        h026_append(0x28, line, 7, " search");
    }
    clear_text_cells(0x11, 0x0F, 0x26, 0x0F);
    ui_draw_text(0x11, 0x0F, 0x0A, 0, 0x28, line);
}

/* PORT H063+$3658: redraws the frame and the view of the combat. */
void redraw_combat_screen(void)
{
    draw_combat_frame();
    center_view((s16)((s16)COK_GET16(g_combat_area + 2) + 3),
                (s16)((s16)COK_GET16(g_combat_area + 4) + 3), 0xFF, 8);
}

/*
 * PORT H063+$3CA0: direction (0..7) from a towards b: tries 1, 3, 5, 7, 0,
 * 2, 4, 6... until the sector contains it (slopes $6A/$100 and
 * $26A/$100).
 */
u16 direction_toward(Character *a, Character *b)
{
    s16 ax;                             /* -$6(a5) */
    s16 ay;                             /* -$8(a5) */
    s16 bx;                             /* -$A(a5) */
    s16 by;                             /* -$C(a5) */
    s16 adx;                            /* -$E(a5) */
    s16 ady;                            /* -$10(a5) */
    s16 steep;
    s16 flat;
    u16 d = 1;                          /* -$2(a5) */
    u8 found = 0;                       /* -$3(a5) */

    ax = (s16)combatant_x(a);
    ay = (s16)combatant_y(a);
    bx = (s16)combatant_x(b);
    by = (s16)combatant_y(b);
    adx = (s16)(bx - ax < 0 ? ax - bx : bx - ax);
    ady = (s16)(by - ay < 0 ? ay - by : by - ay);
    steep = (s16)((s32)adx * 0x26A / 0x100);
    flat = (s16)((s32)adx * 0x6A / 0x100);
    while (!found) {
        switch (d) {
        case 0:
            found = (u8)(by <= ay && ady >= steep);
            break;
        case 1:
            found = (u8)(by < ay && bx > ax && ady <= steep && ady >= flat);
            break;
        case 2:
            found = (u8)(bx >= ax && ady <= flat);
            break;
        case 3:
            found = (u8)(by > ay && bx > ax && ady <= steep && ady >= flat);
            break;
        case 4:
            found = (u8)(by >= ay && ady >= steep);
            break;
        case 5:
            found = (u8)(by > ay && bx < ax && ady <= steep && ady >= flat);
            break;
        case 6:
            found = (u8)(bx <= ax && ady <= flat);
            break;
        case 7:
            found = (u8)(by < ay && bx < ax && ady <= steep && ady >= flat);
            break;
        default:
            break;
        }
        if (!found) {
            d = (u16)(d + 2);
            if (d > 7) {
                d = 0;
            }
        }
    }
    return d;
}

/* PORT H063+$3698: does the weapon in hand shoot at a distance (table $336C +$E > 1)? */
u8 has_ranged_weapon(Character *c)
{
    if (c->readied[0] != NULL &&
        /* $337A: item types +$E: weapon range (>1 = ranged); ogg+$30: type of the item
         * (index into the table H005+$336C, $12 bytes per entry) */
        H005_B(0x336C + c->readied[0]->b[0x30] * 0x12 + 0x0E) > 1) {
        return 1;
    }
    return 0;
}

/* PORT H063+$36EE: is the weapon in hand of type $43? */
u8 weapon_is_43(Character *c)
{
    /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    if (c->readied[0] != NULL && c->readied[0]->b[0x30] == 0x43) {
        return 1;
    }
    return 0;
}

/*
 * PORT H063+$3734: the weapon in hand also hits at close range: ranged
 * with bits $14 of the table $336C (+$10), or of type $43.  Without a weapon
 * the original reads +$30 from NULL (low memory); not here.
 */
u8 weapon_melee_ok(Character *c)
{
    if (has_ranged_weapon(c) &&
        /* $337C: item types +$10: weapon flags (dex/str, ammunition, melee); ogg+$30: type of
         * the item (index into the table H005+$336C, $12 bytes per entry) */
        mask_byte(H005_B(0x336C + c->readied[0]->b[0x30] * 0x12 + 0x10),
                  0x14) == 0x14) {
        return 1;
    }
    /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    if (c->readied[0] != NULL && c->readied[0]->b[0x30] == 0x43) {
        return 1;
    }
    return 0;
}

/*
 * PORT H063+$3980: is there a party companion (side 0, in combat)
 * who is dying (+$197 = 5)?  With bandage the first one found is
 * bandaged (status 4, "is bandaged").
 */
u8 bandage_dying(u8 bandage)
{
    u8 found = 0;                       /* -$5(a5) */
    Character *p;                       /* -$4(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight;
         * ch+$199: side in combat (0 party, 1 opponents) */
        if (p->block_192->b[0x15] == 0 && p->b[0x199] == 0 &&
            p->b[0x197] == 5) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            found = 1;
            if (bandage) {
                p->b[0x197] = 4; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                /* turn+$10: rounds spent below zero hit points (beyond 9 it dies) */
                p->block_192->b[0x10] = 0;
                show_char_message(p, 0x0B, "is bandaged", 0x0A, 1);
                bandage = 0;
            }
        }
    }
    return found;
}

/* PORT H063+$2F5A (Guard): end of the turn; if it can, c stays on guard. */
u8 guard_turn(Character *c)
{
    u8 r;                               /* -$1(a5) */

    r = end_combat_turn(c);
    if (c->block_192->b[0x12] == 0) { /* turn+$12: forced to flee flag (fear, confusion) */
        c->block_192->b[9] = 1; /* turn+$9: on guard flag (Guard), attacks whoever comes close */
        show_message_line(8, "Guarding");
    }
    return r;
}
