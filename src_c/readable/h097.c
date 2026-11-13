/* H097: AI of the computer-controlled combatants. */
#include <string.h>
#include "init_data.h"
#include "h097.h"
#include "globals.h"
#include "unported.h"
#include "h003_exec.h"
#include "h008.h"
#include "h010_input.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h033.h"
#include "h045.h"
#include "h048.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include "h077.h"
#include "h096.h"

/* Module data below a4: g_h097_bss[0x42 - off] is -off(a4). */
u8 g_h097_bss[0x42];

#include "h097_init_data.h"

/* PORT H097+$00A2 */
void h097_init(void)
{
    INIT_APPLY(s_init_1fac, g_h097_bss, sizeof(g_h097_bss));
}

#define TURN(c)         ((c)->block_192)
#define TURN_W(c, o)    COK_GET16(TURN(c)->b + (o))
#define TURN_PUTW(c, o, v) COK_PUT16(TURN(c)->b + (o), (v))
/* $2444: list of the nearby enemies (combatant number, 1 byte per entry, i from 1) */
#define NEAR(i)         H005_B(0x2444 + (i) - 1)
#define COMBATANT(n)    g_combatants[(n) - 1]
/* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
#define POS_X(n)        H005_W(0x3154 + ((n) - 1) * 6)
/* $3156: combatant positions +2: row on the map (word) */
#define POS_Y(n)        H005_W(0x3154 + ((n) - 1) * 6 + 2)
/* $66: spell table, 16 bytes per spell (from 1); k/o = field */
#define SPELL_B(s, o)   H005_B(0x66 + ((s) - 1) * 16 + (o))
/* $336C: table of the item types (item+$30), $12 bytes per type; off = field */
#define WTAB(t, o)      H005_B(0x336C + (t) * 0x12 + (o))
#define H097_W(off)     COK_GET16(&g_h097_bss[0x42 - (off)])
#define H097_SETW(off, v) COK_PUT16(&g_h097_bss[0x42 - (off)], (v))

/*
 * PORT H097+$00B0: key pressed during a monster's turn ($5305):
 * '2' magic on/off, space takes computer control away from the party
 * (and the current turn ends), 4 (H096+$4DE8).  Returns whether a
 * key was handled.
 */
static u8 monster_keys(Character *c)
{
    u8 handled = 0;                     /* -$6(a5) */
    u8 key;                             /* -$5(a5) */
    u8 unused;                          /* -$7(a5) */
    Character *p;                       /* -$4(a5) */

    poll_intuition_events();
    if (!G_KEY) { /* $5305: key/action pending from the input (G_KEY) */
        return 0;
    }
    key = G_KEY; /* $5305: key/action pending from the input (G_KEY) */
    handled = 1;
    switch (key) {
    case '2':
        /* $24A0: Magic On/Off (key 2): characters on automatic cast spells */
        H005_B(0x24A0) = (u8)(H005_B(0x24A0) == 0);
        if (H005_B(0x24A0)) { /* $24A0: Magic On/Off (key 2): characters on automatic cast spells */
            show_message_line(8, "Magic On");
        } else {
            show_message_line(9, "Magic Off");
        }
        break;
    case ' ':
        for (p = g_party_head; p != NULL; p = p->next) {
            /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused); ch+$197: status:
             * 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            if (p->b[0xEC] < 0x80 && p->b[0x197] != 1) {
                p->b[0x19A] = 0; /* ch+$19A: automatic control in combat (1 = AI) */
            }
        }
        if (!c->b[0x19A]) { /* ch+$19A: automatic control in combat (1 = AI) */
            /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
            TURN_PUTW(c, 4, 0x14);
            if (TURN(c)->b[8] > 0) { /* turn+$8: movement points left in the turn */
                /* $2480: current position in the turn order (1..$48, g_turn_order) */
                add_to_byte(&H005_B(0x2480), 0xFFFF);
            }
            handled = 1;
        }
        break;
    case 4:
        unused = combat_bandage();
        (void)unused;
        break;
    default:
        break;
    }
    return handled;
}

/*
 * PORT H097+$0244: end of the monster's turn: on guard (H063+$2F5A) if
 * it can still act and is neither helpless nor armed with a ranged weapon.
 */
static u8 monster_end(Character *c)
{
    clear_message_area();
    /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
    if (is_helpless(c) || has_ranged_weapon(c) || TURN_W(c, 4) == 0) {
        return end_combat_turn(c);
    }
    return guard_turn(c);
}

/*
 * PORT H097+$02B2: value of the weapon it for c (table $336C): average
 * damage, bonus, range, plus 3 if one-handed; 0 if the hands are not enough,
 * if it is of another alignment (+$46 = $84), of type $53 or
 * cursed (+$3C).  Spear $36 against an undead is worth 8.
 */
static u16 weapon_value(Character *c, CokItem *it)
{
    u8 tab[0x12];                       /* -$14(a5) */
    u16 v;                              /* -$2(a5) */

    /* $336C: item types, $12 bytes per type (+$30): +0 slot/kind; ogg+$30: type of the item (index
     * into the table H005+$336C, $12 bytes per entry) */
    exec_copy_mem(&g_h005[0x336C + it->b[0x30] * 0x12], tab, 0x12);
    v = (u16)(tab[0x0B] * tab[0x0A]);
    if ((s16)COK_GET16(it->b + 0x36) > 0) { /* item+$36: (word) magic bonus (+n) of the item, signed */
        /* item+$36: (word) magic bonus (+n) of the item, signed */
        v = (u16)(v + COK_GET16(it->b + 0x36) * 8);
    }
    if ((s16)COK_GET16(tab + 0x0C) > 0) {
        v = (u16)(v + COK_GET16(tab + 0x0C) * 2);
    }
    /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    if (it->b[0x30] == 0x36 && TURN(c)->target != NULL &&
        /* ch+$DF: undead type (0 = no); base -1 of the thief skills +$E0..+$E7 */
        TURN(c)->target->b[0xDF] > 0) {
        v = 8;
    }
    if (mask_byte(tab[0x10], 8)) {
        v = (u16)(v + (tab[6] - 1) * 2);
    }
    if (tab[1] <= 1) {
        v = (u16)(v + 3);
    }
    if ((u16)(tab[1] + c->b[0x188]) > 3) { /* ch+$188: hands used by the readied items (max 2) */
        v = 0;
    }
    /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type; item+$45:
     * spell/parameter of the magic item (bit 7 excluded); ch+$10F: alignment (0..8, evil
     * 2/5/8; names H005+$4C62) */
    if (it->b[0x46] == 0x84 && mask_byte(it->b[0x45], 0x0F) != c->b[0x10F]) {
        v = 0;
    }
    if (it->b[0x45] == 0x53) { /* item+$45: spell/parameter of the magic item (bit 7 excluded) */
        v = 0;
    }
    if (it->b[0x3C]) { /* item+$3C: cursed item flag */
        v = 0;
    }
    return v;
}

/*
 * PORT H097+$043A: monster morale: forced to flee (+$12 of the
 * turn), or for monsters (+$EC > $7F) rolls against wounds and the strength
 * of the group ($2481): it flees if it is faster than the enemies (removing the
 * effects $4A and $4B), otherwise with +$13 > 5 it surrenders.  With maximum
 * hit points at 0 the original divides by 0: here it counts as unharmed.
 */
static u8 monster_morale(Character *c)
{
    u16 saved;                          /* -$4(a5) */
    u16 best;                           /* -$2(a5) */
    u16 hurt;

    TURN(c)->b[0x16] = 0; /* turn+$16: fleeing monster flag (morale) */
    h062_nop_1898();
    if (TURN(c)->b[0x12]) { /* turn+$12: forced to flee flag (fear, confusion) */
        TURN(c)->b[0x16] = 1; /* turn+$16: fleeing monster flag (morale) */
        show_char_message(c, 0x11, "is forced to flee", 0x0A, 1);
        return 0;
    }
    if (c->b[0xEC] <= 0x7F) { /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
        return 0;
    }
    /* $2478: monster morale (0..100) passed to the $11 events; ch+$EC: control: <$80 PC, >$7F
     * NPC/AI ($B3 = charmed or confused) */
    H005_B(0x2478) = (u8)(mask_byte(c->b[0xEC], 0x7F) * 2);
    if (H005_B(0x2478) > 0x66) { /* $2478: monster morale (0..100) passed to the $11 events */
        H005_B(0x2478) = 0; /* $2478: monster morale (0..100) passed to the $11 events */
    }
    trigger_event(&c, 0x11);
    /* ch+$64: maximum hit points; ch+$1A8: current hit points */
    hurt = (u16)(c->b[0x64] ? (u16)(c->b[0x1A8] * 0x64) / c->b[0x64] : 0x64);
    /* $2478: monster morale (0..100) passed to the $11 events */
    if (!(H005_B(0x2478) < (u16)(0x64 - hurt)) && H005_B(0x2478) != 0) {
        return 0;
    }
    saved = H005_B(0x2478); /* $2478: monster morale (0..100) passed to the $11 events */
    (void)saved;
    /* $2478: monster morale (0..100) passed to the $11 events; $2481: enemy strength in %
     * (live/max HP, steps of 5) for fleeing */
    H005_B(0x2478) = H005_B(0x2481);
    trigger_event(&c, 0x11);
    /* $2478: monster morale (0..100) passed to the $11 events; B+$58C: use: AI ($80+v) of the
     * NPCs out of the fight; subtracted from 100 in the flee test */
    if (!(H005_B(0x2478) < (u16)(0x64 - COK_GET16(g_state_b + 0x58C))) &&
        /* $2478: monster morale (0..100) passed to the $11 events; ch+$199: side in combat (0
         * party, 1 opponents) */
        H005_B(0x2478) != 0 && c->b[0x199]) {
        return 0;
    }
    best = enemy_distance_points(c);
    if ((u16)(movement_points(c) >> 1) >= best) {
        TURN(c)->b[0x16] = 1; /* turn+$16: fleeing monster flag (morale) */
        remove_effect(c, 0x4A, NULL);
        remove_effect(c, 0x4B, NULL);
        return 0;
    }
    if (c->b[0x13] > 5) { /* ch+$13: current intelligence */
        fall_down(c, 4, 0x0A, "Surrenders");
        return end_combat_turn(c);
    }
    return 0;
}

/*
 * PORT H097+$062E: nested: would an ally in the area of the spell
 * around (x, y) that fails the saving throw (bonus -2 for the party,
 * 8 for the monsters) be hit?
 */
static u8 spell_hits_ally(u16 spell, s16 x, s16 y)
{
    s16 bonus;                          /* -$4(a5) */
    u16 i;                              /* -$2(a5) */
    Character *e;

    /* ch+$199: side in combat (0 party, 1 opponents) */
    bonus = (s16)(g_current_char->b[0x199] == 0 ? -2 : 8);
    find_in_area(x, y, SPELL_B(spell, 0x0F), 0xFF, 1, g_combat_area);
    /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    for (i = 1; i <= H005_B(0x2479); ++i) {
        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
        e = COMBATANT(H005_B(0x2A3E + (i - 1) * 4));
        /* ch+$199: side in combat (0 party, 1 opponents) */
        if (e->b[0x199] != other_side(g_current_char) &&
            SPELL_B(spell, 8) != 1 &&
            !saving_throw_roll(e, SPELL_B(spell, 9), bonus)) {
            return 1;
        }
    }
    return 0;
}

/*
 * PORT H097+$0620 (body at $075C): is the spell spell (level +$D
 * at least level) useful to c?  Without a target or healing (if there is a
 * wounded one) yes; otherwise enemies within range are needed and, for an area
 * (+$F), no ally around them must be hit.  Where
 * the original returns an unset register, here 0.
 */
static u8 spell_useful(Character *c, u16 spell, u16 level)
{
    Character *tmp;                     /* -$4(a5) */
    u16 n;                              /* -$6(a5) */
    u16 i;                              /* -$8(a5) */

    if (SPELL_B(spell, 0x0D) < level) {
        return 0;
    }
    if (spell != 3 && SPELL_B(spell, 0x0E) == 0) {
        return 1;
    }
    if (spell == 3 && find_heal_target(c, &tmp)) {
        return 1;
    }
    n = count_enemies_near(c, spell_range(spell));
    if (n == 0) {
        return 0;
    }
    if (SPELL_B(spell, 0x0F) == 0) {
        return 1;
    }
    for (i = 1; i <= n; ++i) {
        /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word); $2444..: nearby
         * enemies ($2444+i-1); $3156: combatant positions +2: row on the map (word) */
        if (spell_hits_ally(spell, (s16)POS_X(NEAR(i)), (s16)POS_Y(NEAR(i)))) {
            return 0;
        }
    }
    return 1;
}

/*
 * PORT H097+$0890: the monster uses a readied magic item (not a
 * scroll, +$46 < $80) with a useful spell: 1d7 attempts with
 * minimum level from 7 down.  Spells beyond $38 count as -$17.
 */
static u8 monster_use_item(Character *c)
{
    CokItem *found = NULL;              /* -$1A(a5) */
    CokItem *it;                        /* -$16(a5) */
    u16 level = 7;                      /* -$2(a5) */
    u16 tries;                          /* -$4(a5) */
    u16 i;                              /* -$6(a5) */
    u16 sp;                             /* -$E(a5) */
    u8 redraw;                          /* -$1B(a5) */

    tries = roll_dice(1, 7);
    /* turn+$2: can use items flag (cleared by coughing in the cloud); $2A1C: active combatants of
     * side 0; byte table indexed by side */
    if (TURN(c)->b[2] && H005_B(0x2A1C + other_side(c)) > 0 &&
        /* A+$1CA: (word) if not zero no spells can be cast in the area */
        COK_GET16(g_state_a + 0x1CA) == 0) {
        for (i = 1; i <= tries; ++i) {
            for (it = c->items; it != NULL && found == NULL; it = it->next) {
                sp = it->b[0x45]; /* item+$45: spell/parameter of the magic item (bit 7 excluded) */
                /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6
                 * type; item+$3A: item readied flag (Ready) */
                if (!is_scroll(it) && it->b[0x46] < 0x80 && it->b[0x3A] &&
                    sp > 0) {
                    if (sp > 0x38) {
                        sp = (u16)(sp - 0x17);
                    }
                    if (spell_useful(c, sp, level)) {
                        found = it;
                    }
                }
            }
            --level;
        }
    }
    if (found != NULL) {
        use_item(found, &redraw);
        return 1;
    }
    return 0;
}

/*
 * PORT H097+$0A04: the cleric monster turns undead if it sees any and
 * has not already done it $248F times.  The maximum type passed to H096+$1B04
 * is not initialised in the original: here $FF.
 */
static u8 monster_turn_undead(Character *c)
{
    Character *t;                       /* -$4(a5) */
    u8 max = 0xFF;                      /* -$5(a5) */

    /* turn+$13: Turn Undead already used in the combat (max H005+$248F); $248F: monsters loaded
     * with +$DF: Turn Undead limit (turn +$13) */
    if (TURN(c)->b[0x13] < H005_B(0x248F) &&
        /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; ch+$106: levels of the
         * previous class, 8 entries like +$FE; cleric; ch+$DC: use: threshold for the levels
         * +$106..+$10D and the HP; !=0 forbids Modify */
        (c->b[0xFE] > 0 || c->b[0x106] > c->b[0xDC]) &&
        find_undead(c, &t, &max)) {
        turn_undead(c);
        return 1;
    }
    return 0;
}

/*
 * PORT H097+$0A88: the monster casts a useful memorised spell
 * (with magic enabled for the party): 1d7 rounds of 3 draws, minimum
 * level from 7 down.
 */
static u8 monster_cast(Character *c)
{
    u16 list[0x3A];                     /* -$74(a5) */
    u16 n = 0;                          /* -$84(a5) */
    u16 k;                              /* -$86(a5) */
    u16 chosen = 0;                     /* -$8A(a5) */
    u16 level = 7;                      /* -$7A(a5) */
    u16 tries;                          /* -$7C(a5) */
    u16 i;                              /* -$80(a5) */
    u16 j;                              /* -$82(a5) */
    u16 sp;                             /* -$88(a5) */
    u8 done;                            /* -$7D(a5) */

    if (TURN(c)->b[1]) { /* turn+$1: can cast spells flag (not in a cloud; cleared when attacking) */
        for (k = 1; k <= 0x39; ++k) {
            /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
            if (c->b[0x1E + k] > 0) {
                /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
                list[n] = c->b[0x1E + k];
                ++n;
            }
        }
    }
    tries = roll_dice(1, 7);
    i = 1;
    /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused); $24A0: Magic On/Off (key
     * 2): characters on automatic cast spells */
    if (n > 0 && (c->b[0xEC] > 0x7F || H005_B(0x24A0)) &&
        /* $2A1C: active combatants of side 0; byte table indexed by side */
        H005_B(0x2A1C + other_side(c)) > 0) {
        while (i <= tries && chosen == 0) {
            for (j = 1; j < 4 && chosen == 0; ++j) {
                k = (u16)(roll_dice(1, n) - 1);
                sp = list[k];
                if (spell_useful(c, sp, level)) {
                    chosen = sp;
                }
            }
            --level;
            ++i;
        }
    }
    if (chosen > 0) {
        combat_cast(chosen, 1, &done);
    } else {
        done = 0;
    }
    return done;
}

/*
 * PORT H097+$0C14: the monster chooses its weapons: the best thrown or
 * ranged one (with ammunition), the best melee one, the best shield
 * (armour class +$36); it readies them (H065+$2C04) if different from the
 * readied ones and not cursed, respecting the hands (+$188).
 */
static void monster_choose_weapons(Character *c)
{
    CokItem *best = NULL;               /* -$4(a5) */
    CokItem *melee = NULL;              /* -$8(a5) */
    CokItem *shield = NULL;             /* -$C(a5) */
    CokItem *it;                        /* -$10(a5) */
    CokItem *ammo = NULL;               /* -$14(a5) */
    CokItem *chosen;                    /* -$10(a5) */
    u16 s1 = 1;                         /* -$16(a5) */
    u16 s2;                             /* -$18(a5) */
    u16 s3 = 0;                         /* -$1A(a5) */
    u16 v;                              /* -$1C(a5) */
    u16 t;                              /* -$1E(a5) */
    u16 f = 0;                          /* -$20(a5) */
    u8 changed = 0;                     /* -$23(a5) */
    u8 need;                            /* -$22(a5) */
    u8 ranged;                          /* -$24(a5) */
    u8 ammo_ok = 0;                     /* -$25(a5) */

    if (c->readied[0] != NULL) {
        /* ch+$188: hands used by the readied items (max 2); $336D: item types +1: hands used
         * (added to +$188, max 2); ogg+$30: type of the item (index into the table
         * H005+$336C, $12 bytes per entry) */
        c->b[0x188] = (u8)(c->b[0x188] - WTAB(c->readied[0]->b[0x30], 1));
    }
    if (c->readied[1] != NULL) {
        /* ch+$188: hands used by the readied items (max 2); $336D: item types +1: hands used
         * (added to +$188, max 2); ogg+$30: type of the item (index into the table
         * H005+$336C, $12 bytes per entry) */
        c->b[0x188] = (u8)(c->b[0x188] - WTAB(c->readied[1]->b[0x30], 1));
    }
    /* ch+$114: sides of the base die of attack 1 (2 entries +$114..+$115); ch+$112: number of
     * base dice of attack 1 (2 entries +$112..+$113) */
    s2 = (u16)(c->b[0x114] * c->b[0x112]);
    if ((s16)CH_W(c, 0x116) > 0) { /* ch+$116: base damage bonus, 2 words (attack 1 and 2) */
        s2 = (u16)(s2 + CH_W(c, 0x116) * 2); /* ch+$116: base damage bonus, 2 words (attack 1 and 2) */
    }
    for (it = c->items; it != NULL; it = it->next) {
        t = it->b[0x30]; /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
        /* $336C: item types, $12 bytes per type (+$30): +0 slot/kind; $337B: item types +$F: mask of
         * the allowed classes (vs +$122); ch+$122: mask of the usable weapons (sum of
         * H005+$5040 per class) */
        if (WTAB(t, 0) == 0 && mask_byte(WTAB(t, 0x0F), c->b[0x122])) {
            v = weapon_value(c, it);
            /* $337C: item types +$10: weapon flags (dex/str, ammunition, melee) */
            if (mask_byte(WTAB(t, 0x10), 8) || mask_byte(WTAB(t, 0x10), 0x10)) {
                if (v > s1) {
                    best = it;
                    s1 = v;
                }
            }
            /* $337C: item types +$10: weapon flags (dex/str, ammunition, melee) */
            if (!mask_byte(WTAB(t, 0x10), 8) && v > s2) {
                melee = it;
                s2 = v;
            }
        }
        /* $336C: item types, $12 bytes per type (+$30): +0 slot/kind; $337B: item types +$F: mask of
         * the allowed classes (vs +$122); ch+$122: mask of the usable weapons (sum of
         * H005+$5040 per class) */
        if (WTAB(t, 0) == 1 && mask_byte(WTAB(t, 0x0F), c->b[0x122]) > 0) {
            /* item+$36: (word) magic bonus (+n) of the item, signed */
            if ((s16)COK_GET16(it->b + 0x36) >= 0) {
                /* item+$36: (word) magic bonus (+n) of the item, signed */
                v = (u16)(COK_GET16(it->b + 0x36) + 1);
            } else {
                v = 0;
            }
            if (v > s3) {
                shield = it;
                s3 = v;
            }
        }
    }
    /* $337A: item types +$E: weapon range (>1 = ranged); ogg+$30: type of the item (index into
     * the table H005+$336C, $12 bytes per entry) */
    ranged = (u8)(best != NULL && WTAB(best->b[0x30], 0x0E) > 1 &&
                  /* $337C: item types +$10: weapon flags (dex/str, ammunition, melee); ogg+$30: type of
                   * the item (index into the table H005+$336C, $12 bytes per entry) */
                  mask_byte(WTAB(best->b[0x30], 0x10), 0x14) == 0x14);
    if (best != NULL) {
        /* $337C: item types +$10: weapon flags (dex/str, ammunition, melee); ogg+$30: type of
         * the item (index into the table H005+$336C, $12 bytes per entry) */
        f = WTAB(best->b[0x30], 0x10);
        if (mask_byte((u8)f, 0x10)) {
            ammo = best;
        }
        if (mask_byte((u8)f, 8)) {
            if (mask_byte((u8)f, 1)) {
                ammo = c->readied[11];
            }
            if (mask_byte((u8)f, 0x80)) {
                ammo = c->readied[12];
            }
        }
    }
    if (ammo != NULL || f == 0x0A) {
        ammo_ok = 1;
    }
    if (best != NULL && s1 > (u16)(s2 >> 1) && ammo_ok &&
        (ranged || count_enemies_near(c, 1) == 0)) {
        chosen = best;
    } else {
        chosen = melee;
    }
    need = 1;
    if (c->readied[0] != NULL &&
        (c->readied[0] == chosen || c->readied[0]->b[0x3C])) { /* item+$3C: cursed item flag */
        need = 0;
    }
    if (need) {
        if (c->readied[0] != NULL) {
            ready_item(c->readied[0]);
        }
        recompute_stats(c);
        if (c->readied[1] != NULL && !c->readied[1]->b[0x3C]) { /* item+$3C: cursed item flag */
            /* ch+$188: hands used by the readied items (max 2); $336D: item types +1: hands used (added
             * to +$188, max 2); ogg+$30: type of the item (index into the table H005+$336C,
             * $12 bytes per entry) */
            c->b[0x188] = (u8)(c->b[0x188] - WTAB(c->readied[1]->b[0x30], 1));
        }
        if (chosen != NULL) {
            ready_item(chosen);
        }
        changed = 1;
    }
    recompute_stats(c);
    combat_attacks(c);
    need = 1;
    if (c->readied[1] != NULL &&
        (c->readied[1] == shield || c->readied[1]->b[0x3C])) { /* item+$3C: cursed item flag */
        need = 0;
    }
    if (c->b[0x188] > 2) { /* ch+$188: hands used by the readied items (max 2) */
        if (c->readied[1] == NULL || c->readied[1]->b[0x3C]) { /* item+$3C: cursed item flag */
            if (chosen != NULL) {
                ready_item(chosen);
            }
            changed = 1;
        } else {
            ready_item(c->readied[1]);
            changed = 1;
        }
    } else if (c->b[0x188] < 2 && need) { /* ch+$188: hands used by the readied items (max 2) */
        if (c->readied[1] != NULL) {
            ready_item(c->readied[1]);
        }
        recompute_stats(c);
        if (shield != NULL) {
            ready_item(shield);
        }
        changed = 1;
    }
    recompute_stats(c);
    if (changed) {
        draw_combat_status(c);
    }
}

/*
 * PORT H097+$11EE: is step k (of sequence +$17 of the turn in the
 * module table) from direction dir possible?  The terrain cost
 * (x3 diagonally) must fit in the movement points; clouds and
 * acid make it impossible without protection.  *edge = 1 off the map.
 */
static u8 monster_step_ok(Character *c, u16 k, u16 dir, u8 *edge)
{
    u8 ok = 0;                          /* -$11(a5) */
    u16 d;                              /* -$8(a5) */
    u16 blk;                            /* -$A(a5) */
    u16 tile;                           /* -$C(a5) */
    u16 cost;                           /* -$E(a5) */
    u8 cloud;                           /* -$F(a5) */
    u8 acid;                            /* -$10(a5) */
    CokEffect *e;                       /* -$4(a5) */

    *edge = 0;
    /* H097_bss+$6: table of 6 sequences x 5 words: direction deviations of the steps;
     * turn+$17: step deviation sequence (1..6, table H097 bss +$6) */
    d = (u16)((dir + H097_W(0x3C - (TURN(c)->b[0x17] - 1) * 10 - (k - 1) * 2))
              & 7);
    probe_move(c, d, &blk, &tile, &cloud, &acid);
    if (tile == 0) {
        *edge = 1;
        return ok;
    }
    /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
    if (H005_B(0x3EF4 + (tile - 1) * 4) == 0xFF) {
        return 0;
    }
    if (d & 1) {
        /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
        cost = (u16)(H005_B(0x3EF4 + (tile - 1) * 4) * 3);
    } else {
        /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
        cost = (u16)(H005_B(0x3EF4 + (tile - 1) * 4) * 2);
    }
    if (blk != 0 || !(cost < TURN(c)->b[8])) { /* turn+$8: movement points left in the turn */
        return ok;
    }
    if (cloud && !find_effect(c, 0x20, &e) && !find_effect(c, 0x1E, &e) &&
        !find_effect(c, 0x63, &e) && !find_effect(c, 0x3F, &e) &&
        /* turn+$12: forced to flee flag (fear, confusion) */
        !TURN(c)->b[0x12] && !saving_throw_roll(c, 0, 0)) {
        cost = (u16)(TURN(c)->b[8] + 1); /* turn+$8: movement points left in the turn */
    }
    /* ch+$DB: highest level among the classes (also used as hit dice) */
    if (acid && c->b[0xDB] < 7 && !find_effect(c, 0x63, &e) &&
        !TURN(c)->b[0x12]) { /* turn+$12: forced to flee flag (fear, confusion) */
        cost = (u16)(TURN(c)->b[8] + 1); /* turn+$8: movement points left in the turn */
    }
    if (TURN(c)->b[8] >= cost) { /* turn+$8: movement points left in the turn */
        ok = 1;
    }
    return ok;
}

/*
 * PORT H097+$142C: one step of the monster towards the target (or fleeing,
 * away from the party) trying up to 5 directions of sequence +$17;
 * going back or finding no steps changes the sequence and in the long run
 * the target or the turn.  Shows "Move/Attack, Move Left = n".
 */
static u8 monster_move(Character *c)
{
    char num[0x52];                     /* -$60(a5) */
    u16 dir = 0;                        /* -$2(a5) */
    u16 ndir = 0;                       /* -$4(a5) */
    u16 k;                              /* -$6(a5) */
    u8 edge = 0;                        /* -$7(a5) */
    u8 done = 0;                        /* -$8(a5) */

    /* $3C82: generic 80-character text buffer (TEXT_BUF) */
    strcpy((char *)&g_h005[0x3C82], "Move/Attack, Move Left = ");
    /* turn+$8: movement points left in the turn */
    format_number(0x50, num, (s32)(TURN(c)->b[8] >> 1), 0, 0x0A, 2, ' ');
    h026_append(0x50, num, 1, " ");
    /* $3C82: generic 80-character text buffer (TEXT_BUF) */
    h026_append(0x50, (char *)&g_h005[0x3C82], 0x50, num);
    /* $3C82: generic 80-character text buffer (TEXT_BUF) */
    ui_draw_text(0, 0x18, 0x0A, 0, 0x50, (const char *)&g_h005[0x3C82]);
    if (monster_keys(c)) {
        return done;
    }
    /* turn+$8: movement points left in the turn; turn+$4: (word) initiative of the round
     * (1d6+dexterity); <=0 turn over */
    if (!((TURN(c)->b[8] >> 1) > 0 && (s16)TURN_W(c, 4) > 0)) {
        return monster_end(c);
    }
    if (c->b[0xEC] >= 0x80 && /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
        /* $2478: monster morale (0..100) passed to the $11 events; $2481: enemy strength in %
         * (live/max HP, steps of 5) for fleeing */
        (u16)(roll_dice(1, 0x64) + H005_B(0x2478)) < H005_B(0x2481) &&
        c->b[0x199] != 1) { /* ch+$199: side in combat (0 party, 1 opponents) */
        return monster_end(c);
    }
    /* turn+$16: fleeing monster flag (morale); ch+$5C: class or class combination (0..16, names
     * H005+$4D84) */
    if (!TURN(c)->b[0x16] && c->readied[2] == NULL && c->b[0x5C] == 5) {
        return monster_end(c);
    }
    if (!TURN(c)->b[0x16]) { /* turn+$16: fleeing monster flag (morale) */
        dir = direction_toward(c, TURN(c)->target);
    } else {
        /* turn+$17: step deviation sequence (1..6, table H097 bss +$6) */
        TURN(c)->b[0x17] = (u8)roll_dice(1, 2);
        /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        dir = (u16)(H005_B(0x2820) - (((H005_B(0x2820) + 2) & 3) >> 1));
        if (!c->b[0x199]) { /* ch+$199: side in combat (0 party, 1 opponents) */
            dir = (u16)(dir + 4);
        }
        dir &= 7;
    }
    k = 1;
    while (k < 6 && !done) {
        if (monster_step_ok(c, k, dir, &edge)) {
            break;
        }
        if (TURN(c)->b[0x16] && edge) { /* turn+$16: fleeing monster flag (morale) */
            done = combat_flee(c);
        } else {
            ++k;
        }
    }
    if (done) {
        TURN(c)->b[8] = 0; /* turn+$8: movement points left in the turn */
        TURN(c)->b[0x16] = 0; /* turn+$16: fleeing monster flag (morale) */
        return end_combat_turn(c);
    }
    if (k < 6) {
        /* H097_bss+$6: table of 6 sequences x 5 words: direction deviations of the steps;
         * turn+$17: step deviation sequence (1..6, table H097 bss +$6) */
        ndir = (u16)((dir + H097_W(0x3C - (TURN(c)->b[0x17] - 1) * 10 -
                                   (k - 1) * 2)) & 7);
    }
    /* H097_bss+$4: (word) direction of the monster's last step (8 = none) */
    if (k == 6 || ((ndir + 4) & 7) == H097_W(0x3E)) {
        /* H097_bss+$2: (word) failed/reversed monster steps in the turn */
        H097_SETW(0x40, (u16)(H097_W(0x40) + 1));
        /* turn+$17: step deviation sequence (1..6, table H097 bss +$6) */
        TURN(c)->b[0x17] = (u8)(TURN(c)->b[0x17] % 6 + 1);
        if (H097_W(0x40) > 1) { /* H097_bss+$2: (word) failed/reversed monster steps in the turn */
            TURN(c)->target = NULL;
            if (H097_W(0x40) > 2) { /* H097_bss+$2: (word) failed/reversed monster steps in the turn */
                TURN(c)->b[8] = 0; /* turn+$8: movement points left in the turn */
                done = 1;
            } else if (!ai_pick_target(c, 0xFF, 1, 0)) {
                done = monster_end(c);
            }
        }
    }
    if (k < 6) {
        H097_SETW(0x3E, ndir); /* H097_bss+$4: (word) direction of the monster's last step (8 = none) */
    } else {
        done = 1;
    }
    if (done) {
        return done;
    }
    /* $24C6: 1 if the combatant's actions must be drawn (visible); $24C8: 1 if the monster can
     * attack the target now (in range) */
    H005_B(0x24C6) = (u8)(H005_B(0x24C8) || combatant_visible(c, 0) ||
                          c->b[0x199] == 0); /* ch+$199: side in combat (0 party, 1 opponents) */
    set_combatant_frame(c, (u8)ndir, 0, 0);
    /* turn+$B: facing/frame of the combatant (direction 0..7) */
    combat_leave_attacks(c, TURN(c)->b[0x0B]);
    if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        return end_combat_turn(c);
    }
    if (TURN(c)->b[8] > 0) { /* turn+$8: movement points left in the turn */
        /* turn+$B: facing/frame of the combatant (direction 0..7) */
        combat_step(c, TURN(c)->b[0x0B]);
    }
    if (!c->b[0x198] || is_helpless(c)) { /* ch+$198: active/standing (0 down or out of the combat) */
        done = end_combat_turn(c);
    }
    check_cloud(c, 1);
    return done;
}

/*
 * PORT H097+$18D2: the monster attacks: it flees if it must, then while it has
 * actions (at most 20 rounds) it looks for the target within the range
 * of the weapon (in sight) or a nearby enemy; otherwise it comes closer
 * (H097+$142C).  Sweep or normal attack, with the ranged weapon if
 * it is not adjacent.  Returns 1 if the turn is over.
 */
static u8 monster_attack(Character *c)
{
    u16 iter = 0;                       /* -$18(a5) */
    u8 cont = 1;                        /* -$2(a5) */
    u8 done = 0;                        /* -$1(a5) */
    u16 range;                          /* -$4(a5) */
    u16 dist;                           /* -$6(a5) */
    u16 n;                              /* -$8(a5) */
    s16 tx;                             /* -$14(a5) */
    s16 ty;                             /* -$16(a5) */
    Character *t = NULL;                /* -$12(a5) */
    CokItem *w;                         /* -$E(a5) */

    H097_SETW(0x3E, 8); /* H097_bss+$4: (word) direction of the monster's last step (8 = none) */
    H097_SETW(0x40, 0); /* H097_bss+$2: (word) failed/reversed monster steps in the turn */
    H097_SETW(0x42, 0); /* H097_bss+$0: use: (word) cleared at the start of the monster's attack */
    trigger_event(&c, 0x0E);
    if (!c->b[0x199] && bandage_dying(1)) { /* ch+$199: side in combat (0 party, 1 opponents) */
        TURN_PUTW(c, 4, 0); /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
    }
    if (TURN_W(c, 4) == 0) { /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
        cont = 0;
    }
    while (!done && cont) {
        /* turn+$16: fleeing monster flag (morale); turn+$8: movement points left in the turn */
        while (TURN(c)->b[0x16] && TURN(c)->b[8] > 0 &&
               /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
               (s16)TURN_W(c, 4) > 0 && (s16)TURN_W(c, 4) < 0x14) {
            (void)monster_move(c);
        }
        /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
        if (TURN_W(c, 4) == 0 || TURN_W(c, 4) == 0x14) {
            cont = 0;
        } else {
            done = 0;
        }
        if (done || !cont) {
            continue;
        }
        ++iter;
        if (iter > 0x14) {
            done = 1;
            cont = (u8)(monster_end(c) == 0);
        }
        H005_B(0x24C8) = 0; /* $24C8: 1 if the monster can attack the target now (in range) */
        range = 1;
        if (c->readied[0] != NULL) {
            /* $337A: item types +$E: weapon range (>1 = ranged); ogg+$30: type of the item
             * (index into the table H005+$336C, $12 bytes per entry) */
            range = (u16)(WTAB(c->readied[0]->b[0x30], 0x0E) - 1);
        }
        if (range == 0 || range >= 0xFF) {
            range = 1;
        }
        t = TURN(c)->target;
        /* ch+$198: active/standing (0 down or out of the combat); ch+$199: side in
         * combat (0 party, 1 opponents) */
        if (t != NULL && (!t->b[0x198] || !t->b[0x199])) {
            t = NULL;
        }
        if (t != NULL && can_attack(c, t)) {
            tx = (s16)combatant_x(t);
            ty = (s16)combatant_y(t);
            dist = range;
            g_combat_area[8] = 0;
            if (line_of_sight((s16)combatant_x(c), (s16)combatant_y(c), &tx,
                              &ty, &dist, g_combat_area) &&
                (u16)(dist >> 1) <= range) {
                H005_B(0x24C8) = 1; /* $24C8: 1 if the monster can attack the target now (in range) */
            }
        }
        if (!H005_B(0x24C8)) { /* $24C8: 1 if the monster can attack the target now (in range) */
            n = count_enemies_near(c, range);
            if (n == 0) {
                if (ai_pick_target(c, 0xFF, 0, 0)) {
                    (void)monster_move(c);
                } else {
                    done = monster_end(c);
                }
            } else {
                /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
                t = COMBATANT(NEAR(roll_dice(1, n)));
                if (has_ranged_weapon(c) && !weapon_melee_ok(c) &&
                    count_enemies_near(c, 1) > 0) {
                    monster_choose_weapons(c);
                    done = 1;
                } else if (combat_distance(c, t) == 1 || can_attack(c, t)) {
                    /* $24C8: 1 if the monster can attack the target now (in range) */
                    H005_B(0x24C8) = 1;
                }
            }
        }
        if (H005_B(0x24C8)) { /* $24C8: 1 if the monster can attack the target now (in range) */
            center_view((s16)combatant_x(c), (s16)combatant_y(c), 2,
                        direction_toward(c, t));
        }
        if (!H005_B(0x24C8)) { /* $24C8: 1 if the monster can attack the target now (in range) */
            continue;
        }
        if (combat_sweep(c, t)) {
            done = end_combat_turn(c);
            continue;
        }
        record_attack(c, t);
        w = NULL;
        if (has_ranged_weapon(c)) {
            /* $24C8: 1 if the monster can attack the target now (in range) */
            H005_B(0x24C8) = find_weapon(c, &w);
            if (weapon_melee_ok(c) && combat_distance(c, t) == 1) {
                w = NULL;
            }
        }
        combat_attack(c, t, 0, w, &done);
        if (done) {
            TURN(c)->b[8] = 0; /* turn+$8: movement points left in the turn */
            cont = 0;
        } else if (!t->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
            done = 1;
        }
    }
    return (u8)(cont == 0);
}

/*
 * PORT H097+$1D68: turn of a computer-controlled combatant: keys,
 * movement sequence (+$17), morale ("flees in panic"), then in order
 * magic item, spell in progress, Turn Undead, spell, and
 * finally choice of weapons and attack or end of turn.
 */
void monster_turn(Character *c)
{
    u8 done;                            /* -$3(a5) */
    u16 m;                              /* -$2(a5) */

    done = monster_keys(c);
    clear_message_line();
    clear_message_area();
    if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        done = end_combat_turn(c);
    }
    m = TURN(c)->b[0x17]; /* turn+$17: step deviation sequence (1..6, table H097 bss +$6) */
    if (m == 0 || m > 4 || roll_dice(1, 4) == 1) {
        m = roll_dice(1, 8);
        if (m == 8) {
            m = (u16)(roll_dice(1, 2) + 4);
        } else {
            m = roll_dice(1, 4);
        }
    }
    TURN(c)->b[0x17] = (u8)m; /* turn+$17: step deviation sequence (1..6, table H097 bss +$6) */
    if (!done) {
        done = monster_morale(c);
    }
    /* turn+$16: fleeing monster flag (morale); turn+$12: forced to flee flag (fear,
     * confusion) */
    if (TURN(c)->b[0x16] && !TURN(c)->b[0x12]) {
        show_char_message(c, 0x0E, "flees in panic", 0x0A, 1);
    }
    if (done) {
        return;
    }
    if (monster_use_item(c)) {
        (void)end_combat_turn(c);
        return;
    }
    if (TURN(c)->b[0] > 0) { /* turn+$0: spell being prepared, cast at the start of the turn */
        /* turn+$0: spell being prepared, cast at the start of the turn */
        cast_spell(TURN(c)->b[0], 1, 1, &done);
        (void)end_combat_turn(c);
        return;
    }
    if (monster_turn_undead(c)) {
        (void)end_combat_turn(c);
        return;
    }
    if (monster_cast(c)) {
        return;
    }
    monster_choose_weapons(c);
    done = monster_keys(c);
    while (!done) {
        /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
        if (ai_pick_target(c, 0xFF, 1, 0) && (s16)TURN_W(c, 4) > 0 &&
            c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
            done = monster_attack(c);
        } else {
            done = monster_end(c);
        }
    }
}
