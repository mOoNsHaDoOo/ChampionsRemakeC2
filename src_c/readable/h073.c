/* H073: interface drawing and screen composition. */
#include "h073.h"
#include "h029_gfx.h"
#include "globals.h"

/* PORT H073+$0004: link/unlk, no effect. */
void h073_init(void)
{
}

/*
 * PORT H073+$09BA: cleric spells per level (+$124..+$128).  The
 * level is the cleric one (+$FE); the table H005+$1946 ($9A bytes per
 * row) depends on +$5E > 4; wisdom (+$15) gives extra spells.
 */
void cleric_spell_slots(Character *c)
{
    /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
    u8 level = c->b[0xFE];              /* -$3(a5) */
    u8 high;                            /* -$4(a5) */
    u8 i;                               /* -$2(a5) */
    u8 l;                               /* -$1(a5) */

    if (level == 0) {
        return;
    }
    /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
    high = (u8)(c->b[0x5E] > 4 ? 1 : 0);
    for (i = 2; i <= 5; ++i) {
        c->b[0x124 + i - 1] = 0; /* ch+$123: maximum HP without constitution; base -1 of the spell slots +$124 */
    }
    /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
    c->b[0x124] = (u8)(high ? 2 : 1);
    for (l = 2; l <= level; ++l) {
        for (i = 1; i <= 5; ++i) {
            /* ch+$123: maximum HP without constitution; base -1 of the spell slots +$124 */
            c->b[0x124 + i - 1] = (u8)(c->b[0x124 + i - 1] +
                /* $1972: spell slots of the class tab. +$2C: 5 words per level 2..12 */
                H005_W(0x1946 + high * 0x9A + 0x2C + (l - 2) * 0x0A +
                       (i - 1) * 2));
        }
        if (l == 0xFF) {
            break;              /* addq.b/bcc */
        }
    }
    /* ch+$15: current wisdom; ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
    if (c->b[0x15] > 12 && c->b[0x124] > 0) {
        ++c->b[0x124]; /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
    }
    /* ch+$15: current wisdom; ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
    if (c->b[0x15] > 13 && c->b[0x124] > 0) {
        ++c->b[0x124]; /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
    }
    /* ch+$15: current wisdom; ch+$125: level 2 cleric spell slots */
    if (c->b[0x15] > 14 && c->b[0x125] > 0) {
        ++c->b[0x125]; /* ch+$125: level 2 cleric spell slots */
    }
    /* ch+$15: current wisdom; ch+$125: level 2 cleric spell slots */
    if (c->b[0x15] > 15 && c->b[0x125] > 0) {
        ++c->b[0x125]; /* ch+$125: level 2 cleric spell slots */
    }
    /* ch+$15: current wisdom; ch+$126: level 3 cleric spell slots */
    if (c->b[0x15] > 16 && c->b[0x126] > 0) {
        ++c->b[0x126]; /* ch+$126: level 3 cleric spell slots */
    }
    /* ch+$15: current wisdom; ch+$127: level 4 cleric spell slots (Cure Serious) */
    if (c->b[0x15] > 17 && c->b[0x127] > 0) {
        ++c->b[0x127]; /* ch+$127: level 4 cleric spell slots (Cure Serious) */
    }
}

/* Row of the saving throw table (H005+$1566): class, level, throw. */
static u16 save_table(u8 cls, u8 level, u8 save)
{
    /* level - 1 with level 0 gives -1 (signed muls): previous row. */
    /* $1566: saving throws: $78 bytes per class, $A per level, word per type */
    return H005_W((u16)(0x1566 + cls * 0x78 + ((s16)level - 1) * 0x0A +
                        save * 2));
}

/*
 * PORT H073+$0BA8: saving throws +$D4..+$D8: the minimum between 20 and the values
 * of the classes (current level +$FE and previous +$106).  For the first
 * throw the constitution bonuses (+$19) of dwarves/halflings (races 3, 4, 5) or
 * with the special item of type 6, and those for constitution above 18,
 * are added on every pass over the 8 classes, as in the original.
 */
void saving_throws(Character *c)
{
    u8 special = 0;                     /* -$9(a5) */
    CokItem *item = c->items;           /* -$8(a5) */
    u8 s;                               /* -$1(a5) */
    u8 k;                               /* -$2(a5) */

    while (item != NULL && !special) {
        /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type; item+$3A:
         * item readied flag (Ready) */
        if (item->b[0x46] > 0x80 && item->b[0x3A] != 0) {
            /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type */
            special = (u8)(mask_byte(item->b[0x46], 0x7F) == 6);
        }
        item = item->next;
    }
    for (s = 0; s <= 4; ++s) {
        c->b[0xD4 + s] = 0x14; /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
        for (k = 0; k <= 7; ++k) {
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            if (c->b[0xFE + k] > 0) {
                /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
                u16 t = save_table(k, c->b[0xFE + k], s);

                /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                if (c->b[0xD4 + s] > t) {
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    c->b[0xD4 + s] = (u8)t;
                }
            }
            /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; ch+$106:
             * levels of the previous class, 8 entries like +$FE; cleric */
            if (c->b[0xFE + k] > c->b[0x106 + k]) {
                /* ch+$106: levels of the previous class, 8 entries like +$FE; cleric */
                u16 t = save_table(k, c->b[0x106 + k], s);

                /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                if (c->b[0xD4 + s] > t) {
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    c->b[0xD4 + s] = (u8)t;
                }
            }
            if (s == 0 && (c->b[0x5B] == 3 || c->b[0x5B] == 5 || /* ch+$5B: race (0..6, names H005+$4D04) */
                           c->b[0x5B] == 4 || special)) { /* ch+$5B: race (0..6, names H005+$4D04) */
                switch (c->b[0x19]) { /* ch+$19: current constitution */
                case 4: case 5: case 6:
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    add_to_byte(&c->b[0xD4 + s], 1);
                    break;
                case 7: case 8: case 9: case 10:
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    add_to_byte(&c->b[0xD4 + s], 2);
                    break;
                case 11: case 12: case 13:
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    add_to_byte(&c->b[0xD4 + s], 3);
                    break;
                case 14: case 15: case 16: case 17:
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    add_to_byte(&c->b[0xD4 + s], 4);
                    break;
                case 18:
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    add_to_byte(&c->b[0xD4 + s], 5);
                    break;
                default:
                    break;
                }
            }
            if (s == 0) {
                switch (c->b[0x19]) { /* ch+$19: current constitution */
                case 19: case 20:
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    add_to_byte(&c->b[0xD4 + s], 1);
                    break;
                case 21: case 22:
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    add_to_byte(&c->b[0xD4 + s], 2);
                    break;
                case 23: case 24:
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    add_to_byte(&c->b[0xD4 + s], 3);
                    break;
                case 25:
                    /* ch+$D4: saving throws, 5 entries (+$D4..+$D8) per type; minimum d20 value */
                    add_to_byte(&c->b[0xD4 + s], 4);
                    break;
                default:
                    break;
                }
            }
        }
    }
}

/* PORT H073+$1294: always returns $11. */
u8 h073_1294(Character *c)
{
    (void)c;
    return 0x11;
}

/* PORT H073+$12AE: always returns $11. */
u8 h073_12ae(Character *c)
{
    (void)c;
    return 0x11;
}

/* PORT H073+$12C8: always returns 0. */
u8 h073_12c8(Character *c)
{
    (void)c;
    return 0;
}

/* PORT H073+$130A: +$DC < H073+$12C8 (that is never: unsigned comparison with 0). */
u8 h073_130a(Character *c)
{
    /* ch+$DC: use: threshold for the levels +$106..+$10D and the HP; !=0 forbids Modify */
    return (u8)(c->b[0xDC] < h073_12c8(c));
}

/*
 * PORT H073+$0FC8: thief skills +$E0..+$E7.  The effective level is
 * +$104 + +$10C * H073+$130A; the per-level table is H005+$50F8 (8 bytes
 * per level), the race adjustments H005+$5088 (16 bytes per race) and,
 * for the first 5, the dexterity ones (+$17) H005+$3FF8.  The special item
 * of type $0B raises the level of the first two skills; the one of
 * type 2 brings the level to at least 4 or adds 10 to all.
 *
 * bonus (-$4(a5)) in the original is assigned only with the item of type
 * $0B; without it, the code adds the value left in the stack memory.
 * Here it starts from 0.
 */
void thief_skills(Character *c)
{
    u8 type_b = 0;                      /* -$d(a5) */
    u8 type_2 = 0;                      /* -$e(a5) */
    CokItem *item = c->items;           /* -$c(a5) */
    u8 level;                           /* -$6(a5) */
    u8 saved_level;                     /* -$7(a5) */
    s16 bonus = 0;                      /* -$4(a5) */
    u16 i;                              /* -$2(a5) */

    while (item != NULL && !type_b && !type_2) {
        /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type; item+$3A:
         * item readied flag (Ready) */
        if (item->b[0x46] > 0x80 && item->b[0x3A] != 0) {
            /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type */
            u8 t = mask_byte(item->b[0x46], 0x7F);      /* -$5(a5) */

            type_b = (u8)(t == 0x0B);
            type_2 = (u8)(t == 2);
        }
        item = item->next;
    }
    /* ch+$104: thief level; ch+$10C: previous thief level */
    level = (u8)(c->b[0x104] + c->b[0x10C] * h073_130a(c));
    if (level < 4 && type_2) {
        level = 4;
        type_2 = 0;
    }
    saved_level = level;
    for (i = 1; i <= 8; ++i) {
        s16 race_adj;
        /* ch+$DF: undead type (0 = no); base -1 of the thief skills +$E0..+$E7 */
        u8 *skill = &c->b[0xE0 + i - 1];
        u8 base;

        if (type_b) {
            if (i == 1) {
                if (level < 5) {
                    level = 5;
                    bonus = 0;
                } else {
                    bonus = 5;
                }
            } else if (i == 2) {
                if (level < 7) {
                    level = 7;
                    bonus = 0;
                } else {
                    bonus = 5;
                }
            }
        }
        /* $5088: (word) thief skill adjustments by race, 16 bytes per race; ch+$5B: race
         * (0..6, names H005+$4D04) */
        race_adj = (s16)H005_W(0x5088 + c->b[0x5B] * 16 + (i - 1) * 2);
        /* $50F8: base thief skills per level, 8 bytes per level */
        base = H005_B((u16)(0x50F8 + ((s16)level - 1) * 8 + (i - 1)));
        if (race_adj < 0 &&
            (s16)((race_adj < 0 ? -race_adj : race_adj) + bonus) >
            (s16)base) {
            *skill = 0;
        } else {
            *skill = (u8)(base + race_adj + bonus);
            if (i < 6) {
                *skill = (u8)(*skill +
                    /* $3FF8: (word) thief skill adjustments by dexterity 9..19, 5 per row;
                     * ch+$17: current dexterity */
                    H005_W((u16)(0x3FF8 + ((s16)c->b[0x17] - 9) * 0x0A +
                                 (i - 1) * 2)));
            }
        }
        if (type_2) {
            add_to_byte(skill, 0x0A);
        }
        level = saved_level;
    }
}

/* Adds the row of level l of the table row to the 5 cells from slots. */
static void add_spell_row(u8 *slots, u8 row, u8 l, u8 count)
{
    u8 i;

    for (i = 1; i <= count; ++i) {
        slots[i - 1] = (u8)(slots[i - 1] +
            /* $1972: spell slots of the class tab. +$2C: 5 words per level 2..12 */
            H005_W((u16)(0x1946 + row * 0x9A + 0x2C + ((s16)l - 2) * 0x0A +
                         (i - 1) * 2)));
    }
}

/*
 * Known cleric spells for the spell levels with slots
 * (H005+$1476: 10 words per level, 0 = end).
 */
static void learn_cleric_spells(Character *c)
{
    u8 sl;                              /* -$6(a5) */
    u16 j;                              /* -$2(a5) */
    u16 spell;                          /* -$a(a5) */

    for (sl = 1; sl <= 4; ++sl) {
        /* ch+$123: maximum HP without constitution; base -1 of the spell slots +$124 */
        if (c->b[0x124 + sl - 1] == 0) {
            continue;
        }
        j = 1;
        spell = 0xFF;
        while (j <= 0x0A && spell != 0) {
            /* $1476: inc. per class/level: 3x4 rows of 10 words ($14), 0 = end */
            spell = H005_W(0x1476 + (sl - 1) * 0x14 + (j - 1) * 2);
            if (spell != 0) {
                /* ch+$65: base -1 of the known spells +$66+s-1 (s = 1..$6B, flag per spell) */
                c->b[0x66 + spell - 1] = 1;
            }
            ++j;
        }
    }
}

/*
 * PORT H073+$0012: spell slots of all the classes (+$124..+$13B
 * cleared, then per class: cleric 0, class 7, mage 4 above
 * level 7, class 5) and known spells; readied items of type $81
 * double the slots +$136..+$138.
 */
static void spell_slots_all(Character *c)
{
    CokItem *it;                        /* -$e(a5) */
    u8 k;                               /* -$3(a5) */
    u8 lvl;                             /* -$5(a5) */
    u8 row;                             /* -$4(a5) */
    u8 l;                               /* -$6(a5) */
    u8 i;                               /* -$8(a5) */
    u16 s;                              /* -$a(a5) */

    /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
    h029_fill_bytes(0x17, &c->b[0x124], 0x18, 0);
    for (k = 0; k <= 7; ++k) {
        lvl = c->b[0xFE + k]; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        if (lvl == 0) {
            continue;
        }
        switch (k) {
        case 0:                 /* H073+$0068 */
            /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
            row = (u8)(c->b[0x5E] > 4 ? 1 : 0);
            ++c->b[0x124]; /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
            for (l = 2; l <= lvl; ++l) {
                /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
                add_spell_row(&c->b[0x124], row, l, 5);
                if (l == 0xFF) {
                    break;
                }
            }
            cleric_spell_slots(c);
            learn_cleric_spells(c);
            break;
        case 7:                 /* H073+$01B6 */
            if (lvl > 5 && c->b[0x5D] != 1) { /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
                /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
                row = (u8)(c->b[0x5D] == 2 ? 4 : 5);
                for (l = 6; l <= lvl; ++l) {
                    /* ch+$124: spell slots, 24 bytes: type*6 + level-1; cleric lvl. 1 */
                    add_spell_row(&c->b[0x124], row, l, 5);
                    if (l == 0xFF) {
                        break;
                    }
                }
                learn_cleric_spells(c);
            }
            break;
        case 4:                 /* H073+$0304 */
            if (lvl > 7) {
                for (l = 8; l <= lvl; ++l) {
                    for (i = 1; i <= 3; ++i) {
                        /* ch+$129: base -1 of the type 1 slots (+$12A..+$12C, given to the ranger) */
                        c->b[0x12A + i - 1] = (u8)(c->b[0x12A + i - 1] +
                            /* $1D0E: slots per level of the class 6 table (+$2C): 5 words per
                             * level */
                            H005_W((u16)(0x1D0E + (l - 2) * 0x0A +
                                         (i - 1) * 2)));
                    }
                    for (i = 4; i <= 5; ++i) {
                        u8 m = (u8)(i - 3);     /* -$7(a5) */

                        /* ch+$135: base -1 of the mage slots (type 3, +$136..+$13B) per level */
                        c->b[0x136 + m - 1] = (u8)(c->b[0x136 + m - 1] +
                            /* $1D0E: slots per level of the class 6 table (+$2C): 5 words per
                             * level */
                            H005_W((u16)(0x1D0E + (l - 2) * 0x0A +
                                         (i - 1) * 2)));
                    }
                    if (l == 0xFF) {
                        break;
                    }
                }
                for (s = 1; s <= 0x64; ++s) {
                    if (H005_B(0x66 + (s - 1) * 16) == 1) {
                        /* ch+$65: base -1 of the known spells +$66+s-1 (s = 1..$6B, flag
                         * per spell) */
                        c->b[0x66 + s - 1] = 1;
                    }
                }
            }
            break;
        case 5:                 /* H073+$0430 */
            /* ch+$5F: mage order (1 alignm. 0/3/6, 2 for 1/4/7, 0 none) */
            row = (u8)(c->b[0x5F] == 0 ? 7 : 8);
            ++c->b[0x136]; /* ch+$136: level 1 mage spell slots */
            for (l = 2; l <= lvl; ++l) {
                add_spell_row(&c->b[0x136], row, l, 5); /* ch+$136: level 1 mage spell slots */
                if (l == 0xFF) {
                    break;
                }
            }
            break;
        default:
            break;
        }
    }
    for (it = c->items; it != NULL; it = it->next) {
        /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type; item+$3A:
         * item readied flag (Ready) */
        if (it->b[0x46] == 0x81 && it->b[0x3A]) {
            for (i = 1; i <= 3; ++i) {
                /* ch+$135: base -1 of the mage slots (type 3, +$136..+$13B) per level */
                c->b[0x136 + i - 1] = (u8)(c->b[0x136 + i - 1] * 2);
            }
        }
    }
}

/* Classes beyond level 6 (2 and 7) or 7 (4): +$110 = 3. */
static void check_level_limit(Character *c, u8 k, u8 lvl)
{
    switch (k) {
    case 2: case 7:
        if (lvl > 6) {
            c->b[0x110] = 3; /* ch+$110: attacks every 2 rounds of attack 1 (2 = 1/round, 3 = 3/2) */
        }
        break;
    case 4:
        if (lvl > 7) {
            c->b[0x110] = 3; /* ch+$110: attacks every 2 rounds of attack 1 (2 = 1/round, 3 = 3/2) */
        }
        break;
    default:
        break;
    }
}

/*
 * PORT H073+$05AE: values that depend on the level: +$5A (from the table
 * H005+$5158), highest level +$DB, +$110, deity bonus,
 * spells, saving throws, thief skills, +$122 and readied items
 * no longer allowed; with H073+$130A also the previous classes.
 */
void level_derived_values(Character *c)
{
    u8 k;                               /* -$1(a5) */
    u8 lvl;                             /* -$4(a5) */
    u8 s;                               /* -$6(a5) */

    c->b[0x5A] = 0; /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
    for (k = 0; k <= 7; ++k) {
        u16 t;

        lvl = c->b[0xFE + k]; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
        /* $5158: (word) +$5A value per class and level, $1A bytes per class */
        t = H005_W(0x5158 + k * 0x1A + lvl * 2);
        if (c->b[0x5A] < t) { /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
            c->b[0x5A] = (u8)t; /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
        }
        if (c->b[0xDB] < lvl) { /* ch+$DB: highest level among the classes (also used as hit dice) */
            c->b[0xDB] = lvl; /* ch+$DB: highest level among the classes (also used as hit dice) */
        }
        check_level_limit(c, k, lvl);
    }
    /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4); ch+$5B: race (0..6, names
     * H005+$4D04) */
    if ((c->b[0x5E] == 6 && (c->b[0x5B] == 3 || c->b[0x5B] == 4)) ||
        c->b[0x5E] == 3) { /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
        ++c->b[0x5A]; /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
    }
    spell_slots_all(c);
    saving_throws(c);
    if (c->b[0x104] > 0) { /* ch+$104: thief level */
        thief_skills(c);
    }
    c->b[0x122] = 0; /* ch+$122: mask of the usable weapons (sum of H005+$5040 per class) */
    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] > 0 || /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            /* ch+$106: levels of the previous class, 8 entries like +$FE; cleric; ch+$DB: highest
             * level among the classes (also used as hit dice) */
            (c->b[0x106 + k] > 0 && c->b[0x106 + k] < c->b[0xDB])) {
            /* ch+$122: mask of the usable weapons (sum of H005+$5040 per class); $5040:
             * per-class bits added into +$122 (classes for the items) */
            c->b[0x122] = (u8)(c->b[0x122] + H005_B(0x5040 + k));
        }
    }
    for (s = 0; s <= 0x0C; ++s) {
        CokItem *it = c->readied[s];

        if (it != NULL &&
            /* $337B: item types +$F: mask of the allowed classes (vs +$122); ogg+$30: type of the
             * item (index into the table H005+$336C, $12 bytes per entry) */
            !mask_byte(H005_B(0x336C + it->b[0x30] * 0x12 + 0x0F),
                       /* ch+$122: mask of the usable weapons (sum of H005+$5040 per class) */
                       c->b[0x122]) &&
            !it->b[0x3C]) { /* item+$3C: cursed item flag */
            it->b[0x3A] = 0; /* item+$3A: item readied flag (Ready) */
        }
    }
    if (h073_130a(c)) {
        for (k = 0; k <= 7; ++k) {
            u16 t;

            lvl = c->b[0x106 + k]; /* ch+$106: levels of the previous class, 8 entries like +$FE; cleric */
            check_level_limit(c, k, lvl);
            /* $5158: (word) +$5A value per class and level, $1A bytes per class */
            t = H005_W(0x5158 + k * 0x1A + lvl * 2);
            if (c->b[0x5A] < t) { /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
                c->b[0x5A] = (u8)t; /* ch+$5A: encoded base THAC0 (60 - THAC0) from the per-level table */
            }
        }
        /* ch+$108: previous fighter level; ch+$10A: previous ranger level; ch+$10D: previous knight
         * level */
        if (c->b[0x108] > 6 || c->b[0x10A] > 7 || c->b[0x10D] > 6) {
            c->b[0x110] = 3; /* ch+$110: attacks every 2 rounds of attack 1 (2 = 1/round, 3 = 3/2) */
        }
        if (c->b[0x10C] > 0) { /* ch+$10C: previous thief level */
            thief_skills(c);
        }
    }
}
