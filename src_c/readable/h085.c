/* H085: module data (names of the spell levels). */
#include "init_data.h"
#include "h085.h"
#include "globals.h"
#include "h062.h"
#include "h063.h"
#include "h008.h"
#include "h029_gfx.h"
#include "unported.h"
#include "h077.h"
#include "h048.h"
#include "h026_string.h"
#include "h030.h"
#include "h003_exec.h"

/* Module data below a4: g_h085_bss[0x292 - off] is -off(a4). */
u8 g_h085_bss[0x292];
u16 g_h085_scroll_count;
CokItem *g_h085_scroll_items[0x31];
u16 g_h085_spell_ids[0x3A];
u16 g_h085_spell_counts[0x3A];
CokMenuItem *g_h085_spell_list;

#include "h085_init_data.h"

/* PORT H085+$0664 */
void h085_init(void)
{
    INIT_APPLY(s_init_4d1a, g_h085_bss, sizeof(g_h085_bss));
}

/* Heals the first target by dice d8 + bonus (+1d8 for +$5E = 4). */
static void cure_wounds(u16 dice, u16 extra)
{
    u16 bonus;                          /* -$2(a5) */

    if (H005_B(0x246C) == 0) { /* $246C: number of spell targets in g_spell_targets ($2520) */
        return;
    }
    /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
    if (g_current_char->b[0x5E] == 4) {
        bonus = roll_dice(1, 8);
    } else {
        bonus = 0;
    }
    if (heal_character(g_spell_targets[0],
                       (u16)(roll_dice(dice, 8) + extra + bonus), 0)) {
        heal_message(g_spell_targets[0]);
    }
}

/* PORT H085+$1CB8: Cure Light Wounds, 1d8. */
void cure_light_wounds(void)
{
    cure_wounds(1, 0);
}

/* PORT H085+$3298: Cure Serious Wounds, 2d8 + 1. */
void cure_serious_wounds(void)
{
    cure_wounds(2, 1);
}

/*
 * PORT H085+$0A1A: removes the diseases from the first target ($22, $2B; with
 * $2B also $2C and $1F and recomputes the strength).
 */
static u8 cure_target_disease(void)
{
    u8 ok = 0;                          /* -$1(a5) */

    H005_B(0x24AA) = 1; /* $24AA: 1 during healing: the handlers do not add effects again */
    if (cure_effect(g_spell_targets[0], 0x22)) {
        ok = 1;
    }
    if (cure_effect(g_spell_targets[0], 0x2B)) {
        ok = 1;
        remove_effect(g_spell_targets[0], 0x2C, NULL);
        remove_effect(g_spell_targets[0], 0x1F, NULL);
        recompute_stat(g_spell_targets[0], 0);
    }
    H005_B(0x24AA) = 0; /* $24AA: 1 during healing: the handlers do not add effects again */
    return ok;
}

/* PORT H085+$2E28: Cure Disease. */
void cure_disease(void)
{
    (void)cure_target_disease();
}

/*
 * PORT H085+$3552: Neutralize Poison: removes the effects $37, $16 and $F
 * (poison) and revives the target; a dead one (+$197 = 1) has no effect.
 */
void neutralize_poison(void)
{
    Character *t = g_spell_targets[0];  /* -$4(a5) */
    CokEffect *e;                       /* -$8(a5) */

    if (t->b[0x197] == 1) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        g_spell_targets[0] = NULL;
        return;
    }
    if (find_effect(t, 0x37, &e)) {
        if (t->b[0x1A8] == 0) { /* ch+$1A8: current hit points */
            t->b[0x1A8] = 1; /* ch+$1A8: current hit points */
        }
        H005_B(0x24AA) = 1; /* $24AA: 1 during healing: the handlers do not add effects again */
        remove_effect(t, 0x37, NULL);
        remove_effect(t, 0x16, NULL);
        remove_effect(t, 0x0F, NULL);
        H005_B(0x24AA) = 0; /* $24AA: 1 during healing: the handlers do not add effects again */
        show_char_message(t, 0x0D, "is unpoisoned", 0x0A, 1);
        t->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
        t->b[0x197] = 0; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    } else {
        show_char_message(t, 0x0D, "is unaffected", 0x0A, 1);
    }
}

/*
 * PORT H085+$0672: duration of the effect of spell: fixed rolls for $28, $39,
 * $3B, $3D and $3F, otherwise byte 4 + caster level * byte 5.
 */
static u16 spell_duration(u16 spell)
{
    u16 d = 0;                          /* -$2(a5) */

    switch (spell) {
    case 0x28:
        d = (u16)(roll_dice(1, 6) * 10);
        break;
    case 0x39:
    case 0x3D:
        d = roll_dice(5, 4);
        break;
    case 0x3B:
        d = (u16)(roll_dice(1, 4) * 10 + 0x28);
        break;
    case 0x3F:
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        if (H005_B(0x3DE3) == 5) {
            d = (u16)(roll_dice(2, 0x0A) * 10);
        } else {
            d = (u16)((roll_dice(1, 0x0A) + 0x0A) * 10);
        }
        break;
    default:                            /* $0716 */
        d = (u16)(H005_B(0x66 + (spell - 1) * 16 + 4) +
                  (u16)caster_level(spell) *
                  H005_B(0x66 + (spell - 1) * 16 + 5));
        break;
    }
    return d;
}

#define H085_W(off)        COK_GET16(&g_h085_bss[(off)])
#define H085_SET_W(off, v) COK_PUT16(&g_h085_bss[(off)], (v))

/*
 * PORT H085+$1EBA: Enlarge: strength 18/00..22 according to the caster
 * level (H085+$0 exceptional, +$2 strength), if greater than the
 * base one.
 */
void enlarge(void)
{
    Character *t = g_spell_targets[0];  /* -$6(a5) */
    u16 value;                          /* -$2(a5) */

    /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success */
    H085_SET_W(2, 0x12);
    H085_SET_W(0, 0); /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    switch (caster_level(H005_B(0x2471))) { /* $2471: spell being cast (0 = none) */
    /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    case 1:  H085_SET_W(0, 0);    break;
    /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    case 2:  H085_SET_W(0, 1);    break;
    /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    case 3:  H085_SET_W(0, 0x33); break;
    /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    case 4:  H085_SET_W(0, 0x4C); break;
    /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    case 5:  H085_SET_W(0, 0x5B); break;
    /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    case 6:  H085_SET_W(0, 0x64); break;
    /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success */
    case 7:  H085_SET_W(2, 0x13); break;
    /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success */
    case 8:  H085_SET_W(2, 0x14); break;
    /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success */
    case 9:  H085_SET_W(2, 0x15); break;
    case 10:
    /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success */
    case 11: H085_SET_W(2, 0x16); break;
    default: break;
    }
    /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success;
     * H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    if (strength_raises(t, H085_W(2), H085_W(0), &value)) {
        show_char_message(t, 0x0B, "is stronger", 0x0A, 1);
        /* $2471: spell being cast (0 = none) */
        add_effect(t, 0x0C, spell_duration(H005_B(0x2471)), value, 1);
        recompute_stat(t, 0);
    } else {
        show_char_message(t, 0x0D, "is unaffected", 0x0A, 1);
    }
}

/*
 * PORT H085+$2BD4: Strength: +1d4 (mages), 1d6 (clerics, thieves) or 1d8
 * (fighters) to strength, with the exceptional one for fighters.  Without
 * suitable classes the original uses the uninitialised word; here 0.
 */
void strength_spell(void)
{
    Character *t = g_spell_targets[0];  /* -$4(a5) */
    u16 ext = 0;                        /* -$6(a5) */
    u16 bonus = 0;                      /* -$8(a5) */
    u16 str;                            /* -$a(a5) */
    u16 value;                          /* -$c(a5) */

    /* ch+$103: mage level; ch+$10B: previous mage level; ch+$DC: use: threshold for the levels
     * +$106..+$10D and the HP; !=0 forbids Modify */
    if (t->b[0x103] > 0 || t->b[0x10B] > t->b[0xDC]) {
        bonus = roll_dice(1, 4);
    }
    /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; ch+$106: levels of the
     * previous class, 8 entries like +$FE; cleric; ch+$DC: use: threshold for the levels
     * +$106..+$10D and the HP; !=0 forbids Modify; ch+$104: thief level */
    if (t->b[0xFE] > 0 || t->b[0x106] > t->b[0xDC] || t->b[0x104] > 0 ||
        /* ch+$10C: previous thief level; ch+$DC: use: threshold for the levels +$106..+$10D and
         * the HP; !=0 forbids Modify */
        t->b[0x10C] > t->b[0xDC]) {
        bonus = roll_dice(1, 6);
    }
    /* ch+$100: fighter level; ch+$108: previous fighter level; ch+$DC: use: threshold for the
     * levels +$106..+$10D and the HP; !=0 forbids Modify */
    if (t->b[0x100] > 0 || t->b[0x108] > t->b[0xDC]) {
        bonus = roll_dice(1, 8);
    }
    /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
    str = (u16)(t->b[0x11] + bonus);
    if (str > 0x12) {
        /* ch+$100: fighter level; ch+$108: previous fighter level; ch+$DC: use: threshold for
         * the levels +$106..+$10D and the HP; !=0 forbids Modify */
        if (t->b[0x100] > 0 || t->b[0x108] > t->b[0xDC] ||
            /* ch+$105: knight level; ch+$10D: previous knight level; ch+$DC: use: threshold for the
             * levels +$106..+$10D and the HP; !=0 forbids Modify */
            t->b[0x105] > 0 || t->b[0x10D] > t->b[0xDC] ||
            /* ch+$102: ranger level; ch+$10A: previous ranger level; ch+$DC: use: threshold
             * for the levels +$106..+$10D and the HP; !=0 forbids Modify */
            t->b[0x102] > 0 || t->b[0x10A] > t->b[0xDC]) {
            /* ch+$1C: current exceptional strength (18/xx, 1..100) */
            ext = (u16)(t->b[0x1C] + (str - 0x12) * 10);
            if (ext > 0x64) {
                ext = 0x64;
            }
            str = 0x12;
        } else {
            str = 0x12;
        }
    }
    if (strength_raises(t, str, ext, &value)) {
        value = (u16)(bonus + 0x64);
        /* $2471: spell being cast (0 = none) */
        add_effect(t, 0x26, spell_duration(H005_B(0x2471)), value, 1);
        recompute_stat(t, 0);
    }
}

/*
 * PORT H085+$07B6: applies spell spell to every target ($2520,
 * $246C): saving throw (byte 8/9), for byte 2 = $FF a to-hit
 * roll, then damage dmg (type dmg_type in $2473) and effect (byte $A)
 * with its duration and level level (0: the caster one).
 */
void apply_spell_effect(u16 spell, u16 level, u8 b5, u16 dmg, u16 dmg_type,
                        u16 len, const char *text)
{
    s16 lvl;                            /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    u8 saved;                           /* -$9(a5) */
    Character *t;
/* $66: spell table, 16 bytes per spell (from 1); k/o = field */
#define SP(k) H005_B(0x66 + (spell - 1) * 16 + (k))

    if (dmg == 0) {
        H005_B(0x2473) = 0; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    } else {
        H005_B(0x2473) = (u8)dmg_type; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    }
    if (H005_B(0x246C) == 0) { /* $246C: number of spell targets in g_spell_targets ($2520) */
        return;
    }
    if (level == 0) {
        lvl = caster_level(spell);
    } else {
        lvl = (s16)level;
    }
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = 1; i <= H005_B(0x246C); ++i) {
        if (g_spell_targets[i - 1] == NULL) {
            continue;
        }
        if (SP(8) == 0) {
            saved = 0;
        } else {
            saved = saving_throw_roll(g_spell_targets[i - 1], SP(9), 0);
        }
        /* $2471: spell being cast (0 = none) */
        if (H005_B(0x66 + (H005_B(0x2471) - 1) * 16 + 2) == 0xFF) {
            recompute_stats(g_spell_targets[i - 1]);
            trigger_event(&g_spell_targets[i - 1], 0x0B);
            t = g_spell_targets[i - 1];
            /* ch+$19C: encoded current armour class (60 - AC) */
            if (!attack_roll(g_current_char, t, t->b[0x19C])) {
                dmg = 0;
                saved = 1;
            }
        }
        if (dmg > 0) {
            apply_damage(g_spell_targets[i - 1], dmg, SP(8), saved);
        }
        if (SP(0x0A) > 0) {
            apply_spell_effect_on(g_spell_targets[i - 1], SP(0x0A),
                                  spell_duration(spell), (u16)lvl, b5,
                                  SP(8), saved, len, text);
        }
    }
    H005_B(0x2473) = 0; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
#undef SP
}

#define SPELL_NOW H005_B(0x2471) /* $2471: spell being cast (0 = none) */

/* Spell with only an effect and a message (H085+$07B6 without damage). */
static void simple_effect(u16 len, const char *text)
{
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 0, 0, 0, len, text);
}


/*
 * PORT H085+$0AB2: effect on the targets of side side (the others are
 * removed; with Bless in combat also those not suitable, H063+$2BDE).
 */
static void side_effect(u8 side, u16 len, const char *text)
{
    u16 i;                              /* -$2(a5) */

    H005_B(0x24A9) = 1; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = 1; i <= H005_B(0x246C); ++i) {
        /* ch+$199: side in combat (0 party, 1 opponents) */
        if (g_spell_targets[i - 1]->b[0x199] != side) {
            g_spell_targets[i - 1] = NULL;
        /* $2471: spell being cast (0 = none) */
        } else if ((SPELL_NOW == 1 || SPELL_NOW == 0x69) &&
                   /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
                   H005_B(0x3DE3) == 5 &&
                   count_enemies_near(g_spell_targets[i - 1], 1) > 0) {
            g_spell_targets[i - 1] = NULL;
        }
    }
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 0, 0, 0, len, text);
}

/* PORT H085+$1C60: Bless. */
void spell_bless(void)
{
    /* ch+$199: side in combat (0 party, 1 opponents) */
    side_effect(g_current_char->b[0x199], 0x0A, "is Blessed");
}

/* PORT H085+$1C86: Curse. */
void spell_curse(void)
{
    H005_B(0x24A9) = 1; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
    side_effect(other_side(g_current_char), 9, "is Cursed");
}

/* PORT H085+$1D3C: Cause Light Wounds, 1d8. */
void spell_cause_light_wounds(void)
{
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 0, roll_damage_dice(1, 8), 8, 0, "");
}

/* PORT H085+$1D78: Resist Cold. */
void spell_resist_cold(void)
{
    simple_effect(0x11, "is cold-resistant");
}

/* PORT H085+$1DA6: Burning Hands, damage = caster level. */
void spell_burning_hands(void)
{
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 0, (u16)caster_level(SPELL_NOW), 9, 0,
                       "");
}

/* PORT H085+$1DE4: Charm Person. */
void spell_charm_person(void)
{
    Character *t = g_spell_targets[0];  /* -$8(a5) */
    CokEffect *e;                       /* -$4(a5) */

    if (t == NULL) {
        return;
    }
    /* ch+$14C: creature type flags (bits used by effects and spells); ch+$D3: shape/size on the
     * combat map (bits 0-2, >1 large) */
    if (t->b[0x14C] > 1 || t->b[0xD3] > 1) {
        show_char_message(t, 0x0D, "is unaffected", 0x0A, 1);
        return;
    }
    apply_spell_effect(SPELL_NOW, /* $2471: spell being cast (0 = none) */
                       /* $2471: spell being cast (0 = none) */
                       (u16)(caster_level(SPELL_NOW) +
                             /* ch+$199: side in combat (0 party, 1 opponents) */
                             (g_current_char->b[0x199] << 7)),
                       1, 0, 0, 0x0A, "is charmed");
    if (find_effect(t, 0x0B, &e)) {
        call_effect_handler(0x0B, &t, e, 0);
    }
}

/* PORT H085+$1FFA: Reduce: cancels Enlarge ($C) if the target does not save. */
void spell_reduce(void)
{
    Character *t = g_spell_targets[0];  /* -$8(a5) */
    CokEffect *e;                       /* -$4(a5) */

    /* $246C: number of spell targets in g_spell_targets ($2520) */
    if (t == NULL || H005_B(0x246C) == 0) {
        return;
    }
    if (saving_throw_roll(t, 4, 0)) {
        return;
    }
    if (find_effect(t, 0x0C, &e)) {
        remove_effect(t, 0x0C, NULL);
        recompute_stat(t, 0);
        show_char_message(t, 0x10, "has been reduced", 0x0A, 1);
    }
}

/* PORT H085+$2090: Friends (level 2d4), then recomputes the charisma. */
void spell_friends(void)
{
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, roll_dice(2, 4), 1, 0, 0, 0x0B,
                       "is friENDly");
    recompute_stat(g_current_char, 5);
}

/* PORT H085+$20DE: Magic Missile, (level+1)/2 d4 dice + as many. */
void spell_magic_missile(void)
{
    /* $2471: spell being cast (0 = none) */
    u16 n = (u16)(caster_level(SPELL_NOW) + 1);   /* -$2(a5) */
    u16 dmg = roll_damage_dice((u16)(n >> 1), 4);

    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 0, (u16)(dmg + (n >> 1)), 8, 0, "");
}

/* PORT H085+$2144: Shield. */
void spell_shield(void)
{
    simple_effect(0x0B, "is shielded");
}

/* PORT H085+$2172: Shocking Grasp, 1d8 + level. */
void spell_shocking_grasp(void)
{
    u16 dmg = roll_damage_dice(1, 8);

    dmg = (u16)(dmg + caster_level(SPELL_NOW)); /* $2471: spell being cast (0 = none) */
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 0, dmg, 0x0C, 0, "");
}

#define H085W(off)        COK_GET16(&g_h085_bss[(off)])
#define H085SETW(off, v)  COK_PUT16(&g_h085_bss[(off)], (v))

/*
 * PORT H085+$21C8: Sleep: 4d4 hit dice (H085+$2); every target
 * costs according to +$DB (H085+$0); the dead, already asleep or too strong
 * are removed.
 */
void spell_sleep(void)
{
    CokEffect *e;                       /* -$6(a5) */
    Character *t;
    u16 i;                              /* -$2(a5) */

    H005_B(0x24A9) = 1; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
    /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success */
    H085SETW(2, roll_dice(4, 4));
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = 1; i <= H005_B(0x246C); ++i) {
        t = g_spell_targets[i - 1];
        switch (t->b[0xDB]) { /* ch+$DB: highest level among the classes (also used as hit dice) */
        case 0:
        /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
        case 1: H085SETW(0, 1); break;
        /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
        case 2: H085SETW(0, 2); break;
        /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
        case 3: H085SETW(0, 4); break;
        /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
        case 4: H085SETW(0, 6); break;
        case 5:
            if (t->b[0x5B] == 7) { /* ch+$5B: race (0..6, names H005+$4D04) */
                /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
                H085SETW(0, 0x0A);
            } else {
                /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
                H085SETW(0, 0x14);
            }
            break;
        default:
            /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
            H085SETW(0, 0x14);
            break;
        }
        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        if (t->b[0x197] == 1 || find_effect(t, 0x35, &e) ||
            /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success;
             * H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
            H085W(2) < H085W(0)) {
            g_spell_targets[i - 1] = NULL;
        } else {
            /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success;
             * H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
            H085SETW(2, (u16)(H085W(2) - H085W(0)));
        }
    }
    simple_effect(0x0C, "falls asleep");
}

/* PORT H085+$23B8: Resist Fire. */
void spell_resist_fire(void)
{
    simple_effect(0x11, "is fire resistant");
}

/* PORT H085+$23E6: Silence 15' Radius. */
void spell_silence(void)
{
    simple_effect(0x0B, "is silenced");
}

/* PORT H085+$2414: Slow Poison: revives the poisoned one ($37). */
void spell_slow_poison(void)
{
    Character *t = g_spell_targets[0];  /* -$8(a5) */
    CokEffect *e;                       /* -$4(a5) */

    if (t->b[0x197] == 1) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        g_spell_targets[0] = NULL;
        return;
    }
    if (find_effect(t, 0x37, &e)) {
        if (t->b[0x1A8] == 0) { /* ch+$1A8: current hit points */
            t->b[0x1A8] = 1; /* ch+$1A8: current hit points */
        }
        t->b[0x197] = 0; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        t->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
        /* $2471: spell being cast (0 = none) */
        apply_spell_effect(SPELL_NOW, 0xFF, 1, 0, 0, 0x0B, "is affected");
        add_effect(t, 0x0F, 0x0A, 0xFF, 1);
    }
}

/*
 * PORT H085+$24C6: Snake Charm: the party members with bit $10 of
 * +$14C, active and not charmed ($33) while the caster's HP are enough.
 */
void spell_snake_charm(void)
{
    Character *p;                       /* -$4(a5) */
    CokEffect *e;                       /* -$8(a5) */

    /* ch+$1A8: current hit points; H085_bss+$2: (word) spell work value: Enlarge strength,
     * remaining HD/HP, % success */
    H085SETW(2, g_current_char->b[0x1A8]);
    H005_B(0x246C) = 0; /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (p = g_party_head; p != NULL; p = p->next) {
        /* ch+$14C: creature type flags (bits used by effects and spells); ch+$198:
         * active/standing (0 down or out of the combat) */
        if (mask_byte(p->b[0x14C], 0x10) && p->b[0x198] &&
            /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, %
             * success; ch+$1A8: current hit points */
            !find_effect(p, 0x33, &e) && H085W(2) >= p->b[0x1A8]) {
            /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, %
             * success; ch+$1A8: current hit points */
            H085SETW(2, (u16)(H085W(2) - p->b[0x1A8]));
            /* $246C: number of spell targets in g_spell_targets ($2520) */
            add_to_byte(&H005_B(0x246C), 1);
            /* $246C: number of spell targets in g_spell_targets ($2520) */
            g_spell_targets[H005_B(0x246C) - 1] = p;
        }
    }
    simple_effect(0x0A, "is charmed");
}

/* PORT H085+$25B8: Spiritual Hammer: effect, then the handler $17. */
void spell_spiritual_hammer(void)
{
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 1, 0, 0, 0, "");
    call_effect_handler(0x17, &g_spell_targets[0], NULL, 0);
}

/* PORT H085+$25FA: Knock. */
void spell_knock(void)
{
    simple_effect(0x0B, "Knock-Knock");
}

/* PORT H085+$2628: Mirror Image: 1d4 images (high nibble) and level. */
void spell_mirror_image(void)
{
    u8 v;                               /* -$1(a5) */

    v = (u8)(roll_dice(1, 4) << 4);
    v = or_byte(v, (u16)caster_level(SPELL_NOW)); /* $2471: spell being cast (0 = none) */
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, v, 0, 0, 0, 0x0D, "is duplicated");
}

/* PORT H085+$2692: Ray of Enfeeblement. */
void spell_ray_of_enfeeblement(void)
{
    simple_effect(0x0B, "is weakened");
}

/* PORT H085+$2DBA: Cure Blindness. */
void spell_cure_blindness(void)
{
    if (cure_effect(g_spell_targets[0], 0x21)) {
        show_effect_message(g_spell_targets[0], 1, 7, "can see");
    }
}

/* PORT H085+$2DFA: Cause Blindness. */
void spell_cause_blindness(void)
{
    simple_effect(8, "is blind");
}

/* PORT H085+$2E40: Cause Disease. */
void spell_cause_disease(void)
{
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 1, 0, 0, 0x0B, "is diseased");
}

/* PORT H085+$2E70: Prayer (level: side * 16 + caster level). */
void spell_prayer(void)
{
    /* ch+$199: side in combat (0 party, 1 opponents) */
    u16 side = (u16)(g_current_char->b[0x199] << 4);

    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, (u16)(side + caster_level(SPELL_NOW)), 0,
                       0, 0, 0x0A, "is praying");
}

/*
 * PORT H085+$2EC4: Remove Curse: removes the curse ($24) or frees the
 * first cursed item (+$3C), cancelling its magic effect.
 */
void spell_remove_curse(void)
{
    CokItem *it;                        /* -$4(a5) */
    u8 found;                           /* -$5(a5) */
    u8 k;                               /* -$6(a5) */

    if (cure_effect(g_spell_targets[0], 0x24)) {
        show_effect_message(g_spell_targets[0], 1, 0x0C, "is un-cursed");
        return;
    }
    found = 0;
    for (it = g_spell_targets[0]->items; it != NULL && !found;
         it = it->next) {
        if (it->b[0x3C]) { /* item+$3C: cursed item flag */
            found = 1;
            it->b[0x3A] = 0; /* item+$3A: item readied flag (Ready) */
            /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type */
            if (it->b[0x46] > 0x7F) {
                H005_B(0x24E0) = 1; /* $24E0: 1: the effects go to the handler $2A0E (magic items) */
                /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type */
                call_effect_handler(it->b[0x46], &g_spell_targets[0], it, 1);
                for (k = 0; k <= 5; ++k) {
                    recompute_stat(g_spell_targets[0], k);
                }
            }
        }
    }
    if (found) {
        show_effect_message(g_spell_targets[0], 1, 0x15,
                            "has an item un-cursed");
    }
}

/* PORT H085+$2FCE: Bestow Curse. */
void spell_bestow_curse(void)
{
    simple_effect(0x10, "has been cursed!");
}

/* PORT H085+$2FFC: Blink. */
void spell_blink(void)
{
    simple_effect(0x0B, "is blinking");
}

/*
 * PORT H085+$302A: effect on the targets of side side, at most as many as
 * the caster level; whoever has the opposite effect type loses it instead
 * of getting the new one.  Then event $12 for every target.
 */
static void side_limited_effect(u16 type, u8 side, u16 len, const char *text)
{
    s16 left;                           /* -$2(a5) */
    u16 i;                              /* -$4(a5) */

    H005_B(0x24A9) = 1; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
    left = caster_level(SPELL_NOW); /* $2471: spell being cast (0 = none) */
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = 1; i <= H005_B(0x246C); ++i) {
        /* ch+$199: side in combat (0 party, 1 opponents) */
        if (g_spell_targets[i - 1]->b[0x199] == side && (u16)left > 0) {
            --left;
            if (cure_effect(g_spell_targets[i - 1], type)) {
                g_spell_targets[i - 1] = NULL;
            }
        } else {
            g_spell_targets[i - 1] = NULL;
        }
    }
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 0, 0, 0, len, text);
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = 1; i <= H005_B(0x246C); ++i) {
        if (g_spell_targets[i - 1] != NULL) {
            trigger_event(&g_spell_targets[i - 1], 0x12);
        }
    }
}

/* PORT H085+$318A: Haste (cancels Slow, $2A). */
void spell_haste(void)
{
    /* ch+$199: side in combat (0 party, 1 opponents) */
    side_limited_effect(0x2A, g_current_char->b[0x199], 9, "is Hasted");
}

/* PORT H085+$3224: Slow (cancels Haste, $27). */
void spell_slow(void)
{
    side_limited_effect(0x27, other_side(g_current_char), 9, "is Slowed");
}

/* PORT H085+$3252: speed (if there was no Slow, $2A). */
void spell_speedy(void)
{
    if (!cure_effect(g_spell_targets[0], 0x2A)) {
        simple_effect(9, "is Speedy");
    }
}

/*
 * PORT H085+$331E: strength 21 (effect $71, 1d4*10+40 rounds).  If the strength
 * does not rise the original uses the uninitialised word; here 0.
 */
void spell_strength_21(void)
{
    u16 value = 0;                      /* -$2(a5) */

    if (strength_raises(g_spell_targets[0], 0x15, 0, &value)) {
        show_char_message(g_spell_targets[0], 0x0B, "is stronger", 0x0A, 1);
    }
    add_effect(g_spell_targets[0], 0x71,
               (u16)(roll_dice(1, 4) * 10 + 0x28), value, 1);
    recompute_stat(g_spell_targets[0], 0);
}

/* PORT H085+$3402: paralysis. */
void spell_paralyze(void)
{
    simple_effect(0x0C, "is paralyzed");
}

/* Heals the first target by 2d4+2 with "is Healed". */
static void heal_2d4(void)
{
    if (heal_character(g_spell_targets[0], (u16)(roll_dice(2, 4) + 2), 0)) {
        show_effect_message(g_spell_targets[0], 1, 9, "is Healed");
    }
}

/* PORT H085+$3482: invisibility. */
void spell_invisible(void)
{
    simple_effect(0x0C, "is invisible");
}

/* PORT H085+$34B0: damage 2d4+2. */
void spell_damage_2d4(void)
{
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 0, (u16)(roll_damage_dice(2, 4) + 2),
                       8, 0, "");
}

/* PORT H085+$34F0: Cause Serious Wounds, 2d8 + 1 (+3 with +$5E = 4). */
void spell_cause_serious_wounds(void)
{
    u16 bonus;                          /* -$2(a5) */

    /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
    if (g_current_char->b[0x5E] == 4) {
        bonus = 3;
    } else {
        bonus = 1;
    }
    apply_spell_effect(SPELL_NOW, 0, 0, /* $2471: spell being cast (0 = none) */
                       (u16)(roll_damage_dice(2, 8) + bonus), 8, 0, "");
}

/* PORT H085+$36B8: Sticks to Snakes. */
void spell_sticks_to_snakes(void)
{
    CokEffect *e;                       /* -$4(a5) */

    /* ch+$DB: highest level among the classes (also used as hit dice) */
    if (g_spell_targets[0]->b[0xDB] < 6) {
        /* $2471: spell being cast (0 = none) */
        apply_spell_effect(SPELL_NOW, (u16)caster_level(SPELL_NOW), 0, 0, 8,
                           0, "");
        if (find_effect(g_spell_targets[0], 3, &e)) {
            call_effect_handler(3, &g_spell_targets[0], e, 0);
        }
    } else {
        show_char_message(g_spell_targets[0], 0x11, "smashes them flat",
                          0x0A, 1);
    }
}

/* PORT H085+$37E2: Confusion on at most 2d8 targets. */
void spell_confusion(void)
{
    Character *t;                       /* -$8(a5) */
    u16 n = roll_dice(2, 8);            /* -$e(a5) */
    u16 i;                              /* -$2(a5) */
    u8 saved;                           /* -$3(a5) */

    if (H005_B(0x246C) > n) { /* $246C: number of spell targets in g_spell_targets ($2520) */
        H005_B(0x246C) = (u8)n; /* $246C: number of spell targets in g_spell_targets ($2520) */
    }
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = 1; i <= H005_B(0x246C); ++i) {
        if (g_spell_targets[i - 1] != NULL) {
            t = g_spell_targets[i - 1];
            saved = saving_throw_roll(t, 4, 0);
            apply_spell_effect_on(t, 0x23, spell_duration(0x52), 0, 0, 1,
                                  saved, 0x0B, "is confused");
        }
    }
}

/* PORT H085+$3A5E: Fire Shield: warm or cold shield. */
void spell_fire_shield(void)
{
    u8 key;                             /* -$1(a5) */
    u8 special;                         /* -$2(a5) */
    u8 done = 0;                        /* -$3(a5) */

    do {
        if (g_current_char->b[0x19A]) { /* ch+$19A: automatic control in combat (1 = AI) */
            if (roll_dice(1, 0x0A) > 5) {
                key = 'H';
            } else {
                key = 'C';
            }
        } else {
            key = ui_request_choice(0x0E, "flame type :  ", 8, "Hot Cold", 0x0D,
                                    0x0A, 0x0F, 0, 0, &special);
        }
        switch (key) {
        case 'H':
            apply_spell_effect_on(g_current_char, 0x32, spell_duration(0x55),
                                  0, 0, 0, 0, 0x0C, "is protected");
            apply_spell_effect_on(g_current_char, 0x70, spell_duration(0x55),
                                  0, 0, 0, 0, 0, "");
            done = 1;
            break;
        case 'C':
            apply_spell_effect_on(g_current_char, 0x36, spell_duration(0x55),
                                  0, 0, 0, 0, 0, "");
            apply_spell_effect_on(g_current_char, 0x70, spell_duration(0x55),
                                  0, 0, 0, 0, 0, "");
            done = 1;
            break;
        default:
            key = ui_request_choice(0x0D, "Abort spell? ", 6, "Yes No", 0x0D,
                                    0x0A, 0x0F, 0, 0, &special);
            if (key == 'Y') {
                done = 1;
            }
            break;
        }
    } while (!done);
}

/* PORT H085+$3C06: Fumble: clumsy ($1B) or, if it saves, slowed ($2A). */
void spell_fumble(void)
{
    Character *t = g_spell_targets[0];  /* -$4(a5) */
    CokEffect *e;                       /* -$8(a5) */

    H005_B(0x2473) = 0x40; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    if (!saving_throw_roll(t, 4, 0)) {
        apply_spell_effect_on(t, 0x1B, spell_duration(0x56), 0, 0, 0, 0, 9,
                              "is clumsy");
        if (find_effect(t, 0x1B, &e)) {
            call_effect_handler(0x1B, &t, NULL, 0);
        }
    } else {
        apply_spell_effect_on(t, 0x2A, spell_duration(0x56), 0, 0, 0, 0, 9,
                              "is slowed");
        if (find_effect(t, 0x2A, &e)) {
            call_effect_handler(0x2A, &t, NULL, 0);
        }
    }
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 1, 0, 0, 9, "is clumsy");
}

/* PORT H085+$3D0A: Ice Storm, 3d10. */
void spell_ice_storm(void)
{
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(SPELL_NOW, 0, 0, roll_damage_dice(3, 0x0A), 8, 0, "");
}

/* PORT H085+$3D46: Minor Globe of Invulnerability. */
void spell_minor_globe(void)
{
    simple_effect(0x0C, "is protected");
}

/* PORT H085+$3D74: effect without a message. */
void spell_silent_3d74(void)
{
    simple_effect(0, "");
}

/* PORT H085+$3DA0: effect without a message. */
void spell_silent_3da0(void)
{
    simple_effect(0, "");
}

/* PORT H085+$3DCC: effect without a message. */
void spell_silent_3dcc(void)
{
    simple_effect(0, "");
}

/* PORT H085+$3E4A: "is affected". */
void spell_affected(void)
{
    simple_effect(0x0B, "is affected");
}

/* PORT H085+$3E78: "is protected". */
void spell_protected(void)
{
    simple_effect(0x0C, "is protected");
}

/* PORT H085+$3EA6: "is invisible". */
void spell_invisibility(void)
{
    simple_effect(0x0C, "is invisible");
}

/* PORT H085+$3430: heals 2d4+2. */
void spell_heal_3430(void)
{
    heal_2d4();
}

/* PORT H085+$3DF8: heals 2d4+2. */
void spell_heal_3df8(void)
{
    heal_2d4();
}

/*
 * PORT H085+$3EE2 (nested in Dispel Magic, H085+$3ED4).
 * Chance (in H085+$2) of dispelling an effect of level level
 * (H085+$0) with the caster level caster: +5% per level above,
 * -2% per level below, 50% when equal.  Then the d100 roll.
 */
static u8 dispel_roll(s16 caster, u16 level)
{
    H085SETW(0, level); /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    if ((u16)caster > H085W(0)) {
        /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level; H085_bss+$2:
         * (word) spell work value: Enlarge strength, remaining HD/HP, % success */
        H085SETW(2, (u16)(((u16)caster - H085W(0)) * 5 + 0x32));
    /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level */
    } else if ((u16)caster < H085W(0)) {
        /* H085_bss+$0: (word) spell work value: % Enlarge strength, Sleep HD cost, level; H085_bss+$2:
         * (word) spell work value: Enlarge strength, remaining HD/HP, % success */
        H085SETW(2, (u16)(0x32 - (H085W(0) - (u16)caster) * 2));
    } else {
        /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success */
        H085SETW(2, 0x32);
    }
    /* H085_bss+$2: (word) spell work value: Enlarge strength, remaining HD/HP, % success */
    return (u8)(roll_dice(1, 0x64) <= H085W(2));
}

/*
 * PORT H085+$3ED4: Dispel Magic: removes the effects with a duration of the first
 * target (once per target), then dispels the clouds ($28) of the
 * caster in the 9 squares around $2518/$251A.
 */
void spell_dispel_magic(void)
{
    Character *t;                       /* -$8(a5) */
    CokEffect *e;                       /* -$e(a5) */
    CokEffect *next;                    /* -$12(a5) */
    CokCloud *p;                        /* -$24(a5) */
    CokCloud *p_next;                   /* -$28(a5) */
    s16 caster;                         /* -$4(a5) */
    s16 x = 0;                          /* -$14(a5) */
    s16 y = 0;                          /* -$16(a5) */
    u16 tile;                           /* -$18(a5) */
    u16 count;                          /* -$1a(a5) */
    u16 i;                              /* -$2(a5) */
    u16 k;                              /* -$1c(a5) */
    u16 dir;
    u8 dispelled;                       /* -$9(a5) */
    u8 found;                           /* -$a(a5) */

    H005_B(0x24A9) = 1; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
    caster = caster_level(SPELL_NOW); /* $2471: spell being cast (0 = none) */
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = 1; i <= H005_B(0x246C); ++i) {
        dispelled = 0;
        t = g_spell_targets[0];
        for (e = t->effects; e != NULL; e = next) {
            next = e->next;
            if (e->b[4] < 0xFF && /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
                /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
                dispel_roll(caster, mask_byte(e->b[4], 0x0F))) {
                remove_effect(t, e->b[0], e); /* eff+$0: type of the effect (code of the handler) */
                dispelled = 1;
            }
        }
        if (dispelled) {
            show_effect_message(t, 1, 0x0B, "is affected");
        }
    }
    for (k = 0; k <= 8; ++k) {
        switch (k) {
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518:
         * (word) y of the chosen target square (spells, breaths, telep.) */
        case 0: x = (s16)H005_W(0x251A); y = (s16)H005_W(0x2518); break;
        /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
        case 1: y = (s16)(H005_W(0x2518) - 1); break;
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
        case 2: x = (s16)(H005_W(0x251A) + 1); break;
        /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
        case 3: y = (s16)H005_W(0x2518); break;
        /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
        case 4: y = (s16)(H005_W(0x2518) + 1); break;
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
        case 5: x = (s16)H005_W(0x251A); break;
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
        case 6: x = (s16)(H005_W(0x251A) - 1); break;
        /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
        case 7: y = (s16)H005_W(0x2518); break;
        /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
        case 8: y = (s16)(H005_W(0x2518) - 1); break;
        }
        combat_map_cell(x, y, &count, &tile);
        if (tile != 0x1E) {
            continue;
        }
        p = g_clouds;
        count = 4;
        while (p != NULL) {
            p_next = p->next;
            for (i = 1; i <= count; ++i) {
                /* $5021: i-1 base of the 4 directions of the squares of a cloud ($5022) */
                dir = H005_B(0x5022 + i - 1);
                if ((s16)(COK_GET16(&p->b[0x1C - 8]) + /* nube+$14: (word) x of the centre of the cloud/pool */
                          /* $3EE2: (word) x offset for direction d (step 2) */
                          H005_W(0x3EE2 + dir * 2)) == x &&
                    (s16)(COK_GET16(&p->b[0x1E - 8]) + /* nube+$16: (word) y of the centre of the cloud/pool */
                          /* $3ED0: (word) y offset for direction d (step 2) */
                          H005_W(0x3ED0 + dir * 2)) == y &&
                    !p->b[0x21 - 8]) { /* nube+$19: flag Dispel Magic already failed on this cloud */
                    if (dispel_roll(caster, p->owner->b[0x103])) { /* ch+$103: mage level */
                        found = 0;
                        e = p->owner->effects;
                        while (e != NULL && !found) {
                            /* eff+$0: type of the effect (code of the handler) */
                            if (e->b[0] == 0x28 && tile == 0x1E &&
                                /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.); nube+$18: number
                                 * of the cloud (= high nibble of EF +$4 of the effect) */
                                (e->b[4] >> 4) == p->b[0x20 - 8]) {
                                found = 1;
                            } else {
                                e = e->next;
                            }
                        }
                        if (found) {
                            remove_effect(p->owner, 0x28, e);
                        }
                    } else {
                        p->b[0x21 - 8] = 1; /* nube+$19: flag Dispel Magic already failed on this cloud */
                    }
                }
            }
            p = p_next;
        }
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518:
         * (word) y of the chosen target square (spells, breaths, telep.) */
        center_view(H005_W(0x251A), H005_W(0x2518), 3, 8);
    }
}

/*
 * PORT H085+$15FE: fireball: as many d6 dice as the level of the
 * caster (for spell $40: 1d3 * 2 + 1) on whoever is within 2
 * squares of the chosen point (in combat), view centred on the point.
 */
void spell_fireball(void)
{
    u16 level;                          /* -$2(a5) */
    u16 k;                              /* -$4(a5) */

    H005_B(0x24A9) = 1; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
    if (H005_B(0x2471) == 0x40) { /* $2471: spell being cast (0 = none) */
        level = (u16)(roll_dice(1, 3) * 2 + 1);
    } else {
        level = (u16)caster_level(H005_B(0x2471)); /* $2471: spell being cast (0 = none) */
    }
    if (COK_GET16(g_state_a + 0x1CC) == 0) { /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518:
         * (word) y of the chosen target square (spells, breaths, telep.) */
        find_in_area((s16)H005_W(0x251A), (s16)H005_W(0x2518), 2, 0xFF, 1,
                     g_combat_area);
        /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
        for (k = 1; k <= H005_B(0x2479); ++k) {
            g_spell_targets[k - 1] =
                /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
                g_combatants[H005_B(0x2A3E + (k - 1) * 4) - 1];
        }
        /* $246C: number of spell targets in g_spell_targets ($2520); $2479: number of entries of
         * the area list +$2A3E (4 bytes per entry) */
        H005_B(0x246C) = H005_B(0x2479);
    }
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of
     * the chosen target square (spells, breaths, telep.) */
    center_view((s16)H005_W(0x251A), (s16)H005_W(0x2518), 0, 8);
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(H005_B(0x2471), 0, 0, roll_damage_dice(level, 6), 9,
                       0, "");
}

/* Frame of H085+$0BB2 seen by the nested procedures. */
typedef struct BreathFrame {
    CokLine line;                       /* -$60(a5) */
    u16 hit[0x1E];                      /* -$100(a5): combatants hit */
    u16 who;                            /* -$10A(a5) */
    u16 tile;                           /* -$10C(a5) */
    u8 done;                            /* -$115(a5) */
} BreathFrame;

/* PORT H085+$0BC0 (nested): prepares the line from (x0, y0) to (x1, y1). */
static void breath_line(BreathFrame *f, s16 x0, s16 y0, s16 x1, s16 y1)
{
    f->line.x0 = x0;
    f->line.y0 = y0;
    f->line.x1 = x1;
    f->line.y1 = y1;
    line_init(&f->line);
}

/* PORT H085+$0C04 (annidata): x in 0..$31, y in 0..$18. */
static void breath_clamp(s16 *x, s16 *y)
{
    if (*x > 0x31) {
        *x = 0x31;
    } else if (*x < 0) {
        *x = 0;
    }
    if (*y > 0x18) {
        *y = 0x18;
    } else if (*y < 0) {
        *y = 0;
    }
}

/*
 * PORT H085+$0C62 (nested): follows the line and adds to the list
 * of those hit the combatants met that are not already there.  With
 * the list full the original would write past the 30 entries; here it stops.
 */
static void breath_trace(BreathFrame *f)
{
    u16 i;                              /* -$2(a5) */
    u8 placed;                          /* -$3(a5) */

    do {
        f->done = (u8)(line_step(&f->line) == 0);
        if (f->done) {
            continue;
        }
        combat_map_cell(f->line.cx, f->line.cy, &f->who, &f->tile);
        i = 1;
        placed = 0;
        while (f->who > 0 && !placed && i <= 0x1E) {
            if (f->hit[i - 1] == f->who) {
                placed = 1;
            } else if (f->hit[i - 1] == 0) {
                f->hit[i - 1] = f->who;
                placed = 1;
            } else {
                ++i;
            }
        }
    } while (!f->done);
}

/*
 * PORT H085+$0BB2: area of a breath from (ax, ay) towards (tx, ty): the line
 * is extended up to the length length (in half steps), stops at the
 * line of sight, and collects the combatants met; with width 2 or 3
 * also the lines towards the sides of the tip (tables -$10..-$40), with $FF
 * whoever is within 3 squares of the tip.  Those hit (except the current
 * character) become the targets (g_spell_targets, $246C).
 * Not initialised in the original: the distance -$114(a5) passed to the
 * line of sight (here $FFFF, that is no limit: the length is already
 * limited by the extension) and the direction -$112(a5) if the line does not
 * meet anyone (here 0).
 */
static void breath_area(s16 ax, s16 ay, s16 tx, s16 ty, u16 width,
                        u16 length)
{
    static const s16 side1_x[8] = { -1, 0, 0, 1, 1, 0, 0, -1 };  /* -$10 */
    static const s16 side1_y[8] = { 0, -1, -1, 0, 0, 1, 1, 0 };  /* -$20 */
    static const s16 side2_x[8] = { 1, 1, 0, 0, -1, -1, 0, 0 };  /* -$30 */
    static const s16 side2_y[8] = { 0, 0, 1, 1, 0, 0, -1, -1 };  /* -$40 */
    BreathFrame f;
    s16 p1x, p1y;                       /* -$42, -$44(a5) */
    s16 p2x, p2y;                       /* -$46, -$48(a5) */
    u16 dirs[0x31];                     /* -$C4(a5) */
    u16 k;                              /* -$102(a5) */
    u16 cost;                           /* -$104(a5) */
    u16 n = 0;                          /* -$106(a5) */
    u16 last;                           /* -$108(a5) */
    u16 count;                          /* -$10E(a5) */
    u16 slot;                           /* -$110(a5) */
    u16 last_dir = 0;                   /* -$112(a5) */
    u16 dist = 0xFFFF;                  /* -$114(a5) */
    u8 dup = 0;                         /* -$117(a5) */

    memset(&f, 0, sizeof(f));
    breath_line(&f, ax, ay, tx, ty);
    do {
        f.done = (u8)(line_step(&f.line) == 0);
        if (!f.done && n < 0x31) {
            dirs[n] = f.line.dir;
            ++n;
        }
    } while (!f.done);
    last = (u16)(n - 1);
    n = 0;
    length = (u16)(length * 2);
    cost = f.line.cost;
    f.done = 0;
    while (cost < length && !f.done) {
        if (tx < 0x31 && tx > 0 && ty < 0x18 && ty > 0) {
            if (dirs[n] & 1) {
                cost = (u16)(cost + 2);
            } else {
                cost = (u16)(cost + 3);
            }
            /* $3EE2: (word) x offset for direction d (step 2) */
            tx = (s16)(tx + (s16)H005_W(0x3EE2 + dirs[n] * 2));
            /* $3ED0: (word) y offset for direction d (step 2) */
            ty = (s16)(ty + (s16)H005_W(0x3ED0 + dirs[n] * 2));
            if (n == last) {
                n = 0;
            } else {
                ++n;
            }
        } else {
            f.done = 1;
        }
    }
    breath_clamp(&tx, &ty);
    (void)line_of_sight(ax, ay, &tx, &ty, &dist, g_combat_area);
    breath_line(&f, ax, ay, tx, ty);
    h029_fill_bytes(0x3B, (u8 *)f.hit, 0x3C, 0);
    count = 1;
    do {
        f.done = (u8)(line_step(&f.line) == 0);
        if (f.done) {
            continue;
        }
        combat_map_cell(f.line.cx, f.line.cy, &f.who, &f.tile);
        if (f.who == 0) {
            continue;
        }
        if (count > 1) {
            for (k = 1; k <= (u16)(count - 1); ++k) {
                if (f.hit[k - 1] == f.who) {
                    dup = 1;
                }
            }
        } else {
            dup = 0;
        }
        if (!dup) {
            f.hit[count - 1] = f.who;
            ++count;
        }
        last_dir = f.line.dir;
    } while (!f.done);
    if (width > 1 && width != 0xFF) {
        p1x = (s16)(tx + side1_x[last_dir & 7]);
        p1y = (s16)(ty + side1_y[last_dir & 7]);
        breath_clamp(&p1x, &p1y);
        p2x = (s16)(tx + side2_x[last_dir & 7]);
        p2y = (s16)(ty + side2_y[last_dir & 7]);
        breath_clamp(&p2x, &p2y);
        breath_line(&f, ax, ay, p2x, p2y);
        breath_trace(&f);
        if (width > 2) {
            breath_line(&f, ax, ay, p1x, p1y);
            breath_trace(&f);
        }
    }
    if (width == 0xFF) {
        find_in_area(tx, ty, 3, 0xFF, 1, g_combat_area);
        /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
        for (k = 1; k <= H005_B(0x2479); ++k) {
            /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
            f.hit[k - 1] = H005_B(0x2A3E + (k - 1) * 4);
        }
    }
    count = 1;
    slot = 1;
    H005_B(0x246C) = 0; /* $246C: number of spell targets in g_spell_targets ($2520) */
    while (count <= 0x1E && f.hit[count - 1] != 0) {
        if (g_combatants[f.hit[count - 1] - 1] != g_current_char) {
            /* $246C: number of spell targets in g_spell_targets ($2520) */
            add_to_byte(&H005_B(0x246C), 1);
            g_spell_targets[slot - 1] = g_combatants[f.hit[count - 1] - 1];
            ++slot;
        }
        ++count;
    }
}

/*
 * PORT H085+$172A (effects $06, $53: cold; $68: fire): dragon
 * breath.  The charges (+$4) are set to 1 ($06) or 3 if $247C is set or
 * they are more than 3; the target is chosen, the area is computed with
 * H085+$0BB2 and if it hits only opponents each one takes the maximum hit
 * points of the dragon (saving throw 3, damage of type 2).
 */
void effect_breath(Character **cp, void *obj, u8 flag)
{
    CokEffect *e = (CokEffect *)obj;    /* $E(a5) */
    u8 r;                               /* -$1(a5) */
    s16 ax;                             /* -$4(a5) */
    s16 ay;                             /* -$6(a5) */
    u16 k;                              /* -$8(a5) */
    Character *t;                       /* -$C(a5) */
    u8 saved;                           /* -$D(a5) */
    u16 width = 0;                      /* -$10(a5) */
    u16 length = 0;                     /* -$12(a5) */
    char what[6];                       /* -$18(a5) */
    u16 dir;                            /* -$1A(a5) */
    char text[0x52];                    /* -$6C(a5) */

    (void)flag;
    what[0] = 0;
    /* $247C: combat round number (0 at the start; bit 0 rounds); eff+$4: parameter/level
     * of the effect (for $28 high nibble = cloud no.) */
    if (H005_B(0x247C) == 0 || e->b[4] > 3) {
        /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.); eff+$0:
         * type of the effect (code of the handler) */
        e->b[4] = (u8)(e->b[0] == 6 ? 1 : 3);
    }
    if (e->b[4] == 0) { /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        return;
    }
    if (e->b[0] == 6 || e->b[0] == 0x53) { /* eff+$0: type of the effect (code of the handler) */
        H005_B(0x2473) = 0x22; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
        width = 3;
        length = (u16)(e->b[0] == 6 ? 8 : 7); /* eff+$0: type of the effect (code of the handler) */
        h026_copy(5, what, 4, "cold");
    }
    if (e->b[0] == 0x68) { /* eff+$0: type of the effect (code of the handler) */
        H005_B(0x2473) = 0x21; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
        width = 3;
        length = 9;
        h026_copy(5, what, 4, "Fire");
    }
    ax = (s16)combatant_x(*cp);
    ay = (s16)combatant_y(*cp);
    /* $24C5: outcome of the target choice (breaths, effect $42) */
    ((void (*)(u8, u8, u8 *))g_handlers_25c0[107])(0x3D, 1, &H005_B(0x24C5));
    if (!H005_B(0x24C5)) { /* $24C5: outcome of the target choice (breaths, effect $42) */
        return;
    }
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of
     * the chosen target square (spells, breaths, telep.) */
    breath_area(ax, ay, (s16)H005_W(0x251A), (s16)H005_W(0x2518), width,
                length);
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (k = 1; k <= H005_B(0x246C); ++k) {
        /* ch+$199: side in combat (0 party, 1 opponents) */
        if (g_spell_targets[k - 1]->b[0x199] != other_side(*cp)) {
            H005_B(0x24C5) = 0; /* $24C5: outcome of the target choice (breaths, effect $42) */
        }
    }
    /* $246C: number of spell targets in g_spell_targets ($2520); $24C5: outcome of the target
     * choice (breaths, effect $42) */
    if (H005_B(0x246C) == 0 || !H005_B(0x24C5)) {
        return;
    }
    h026_copy(0x50, text, 9, "breathes ");
    h026_append(0x50, text, 5, what);
    show_char_message(*cp, 0x50, text, 0x0A, 1);
    dir = direction_toward(*cp, g_spell_targets[0]);
    draw_combat_status(*cp);
    set_combatant_frame(*cp, (u8)dir, 1, 0);
    load_missile_frames(0x12);
    animate_missile((s16)combatant_x(*cp), (s16)combatant_y(*cp),
                    (s16)combatant_x(g_spell_targets[0]),
                    (s16)combatant_y(g_spell_targets[0]), 1, 1);
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (k = 1; k <= H005_B(0x246C); ++k) {
        if (g_spell_targets[k - 1] != NULL) {
            t = g_spell_targets[k - 1];
            saved = saving_throw_roll(t, 3, 0);
            apply_damage(t, (*cp)->b[0x64], 2, saved); /* ch+$64: maximum hit points */
        }
    }
    e->b[4] = (u8)(e->b[4] - 1); /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    r = end_combat_turn(*cp);
    (void)r;
}

/*
 * PORT H085+$363E: effect of the spell on the target of the turn
 * (+$192 +$C), then event 9; if no handler cancelled it ($2475
 * still $40) the handler of effect $40 on the current character.
 * The item passed to the handler is -$4(a5), uninitialised
 * in the original: here NULL.
 */
void spell_event_9(void)
{
    Character *target;                  /* -$8(a5) */

    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(H005_B(0x2471), 0, 0, 0, 8, 0, "");
    target = g_current_char->block_192->target;
    H005_B(0x2475) = 0x40; /* $2475: incoming effect (0 = cancelled by the handlers) */
    trigger_event(&target, 9);
    if (H005_B(0x2475) == 0x40) { /* $2475: incoming effect (0 = cancelled by the handlers) */
        call_effect_handler(0x40, &g_current_char, NULL, 0);
    }
}

/*
 * PORT H085+$38AA: teleport of the current character to the chosen
 * point ($251A, $2518): redraws the terrain where it was, places it, centres
 * the view and "teleports".
 */
void spell_teleport(void)
{
    Character *c = g_current_char;      /* -$4(a5) */
    u8 ok;                              /* -$9(a5) */

    redraw_ground(0, 0, combatant_index(c));
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of
     * the chosen target square (spells, breaths, telep.) */
    ok = place_combatant(c, (u8)H005_W(0x251A), (u8)H005_W(0x2518), 0);
    (void)ok;
    center_view((s16)combatant_x(c), (s16)combatant_y(c), 0, 8);
    show_char_message(c, 9, "teleports", 0x0A, 1);
}

/*
 * PORT H085+$1A6C: the effect of the current spell on every target,
 * from the last to the first (from the second on with sound 2 and the missile
 * from the caster): saving throw (byte 9, with bonus) except for $4F and $51
 * on the last target; races 7 always resist $17 and $31.
 */
static void spell_on_targets(s16 bonus, u16 len, const char *text)
{
    Character *t;                       /* -$4(a5) */
    u8 saved;                           /* -$5(a5) */
    u16 i;                              /* -$8(a5) */
    u8 kind;                            /* -$9(a5) */
    u16 spell = SPELL_NOW; /* $2471: spell being cast (0 = none) */

    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = H005_B(0x246C); i >= 1; --i) {
        if (g_spell_targets[i - 1] == NULL) {
            continue;
        }
        t = g_spell_targets[i - 1];
        if (i < H005_B(0x246C)) { /* $246C: number of spell targets in g_spell_targets ($2520) */
            h043_190e(2);
            load_missile_frames(0x12);
            animate_missile((s16)combatant_x(g_current_char),
                            (s16)combatant_y(g_current_char),
                            (s16)combatant_x(t), (s16)combatant_y(t), 4, 1);
        }
        spell = SPELL_NOW; /* $2471: spell being cast (0 = none) */
        /* $246C: number of spell targets in g_spell_targets ($2520) */
        if ((spell == 0x4F || spell == 0x51) && i == H005_B(0x246C)) {
            saved = 1;
            kind = 1;
        } else {
            saved = saving_throw_roll(t, H005_B(0x66 + (spell - 1) * 16 + 9),
                                      bonus);
            kind = H005_B(0x66 + (spell - 1) * 16 + 8);
        }
        if (t->b[0x5B] == 7 && (spell == 0x17 || spell == 0x31)) { /* ch+$5B: race (0..6, names H005+$4D04) */
            saved = 1;
        }
        apply_spell_effect_on(t, H005_B(0x66 + (spell - 1) * 16 + 0x0A),
                              spell_duration(spell),
                              (u16)caster_level(spell), 0, kind, saved,
                              len, text);
    }
}

/*
 * PORT H085+$2338: Hold Person ($17 and others): the saving throw malus
 * depends on the number of targets (1: -2 for $17, -3 for the others; 2: -1;
 * 3 or 4: 0).  With more than 4 targets the original leaves the malus
 * uninitialised; here 0.
 */
void spell_hold_person(void)
{
    s16 bonus = 0;                      /* -$2(a5) */

    switch (H005_B(0x246C)) { /* $246C: number of spell targets in g_spell_targets ($2520) */
    case 1:
        bonus = (s16)(SPELL_NOW == 0x17 ? -2 : -3); /* $2471: spell being cast (0 = none) */
        break;
    case 2:
        bonus = -1;
        break;
    case 3:
    case 4:
        bonus = 0;
        break;
    default:
        break;
    }
    spell_on_targets(bonus, 7, "is held");
}

/* Offsets of direction d (tables H005+$3EE2 / $3ED0). */
#define DIR_DX(d)   ((s16)H005_W(0x3EE2 + (d) * 2))  /* $3EE2: (word) x offset for direction d (step 2) */
#define DIR_DY(d)   ((s16)H005_W(0x3ED0 + (d) * 2))  /* $3ED0: (word) y offset for direction d (step 2) */

/*
 * PORT H085+$26C0: stinking cloud on the chosen point ($251A, $2518): a
 * record in g_clouds ($2514) with the number of the cloud of this
 * caster (in the list the original does not count the last record),
 * effect $28 to remove it, and the 4 squares (directions $5022) that
 * become $1E if the terrain allows it (H005+$3EF4 < $FF), saving
 * the previous contents; then the combatants in the squares (once
 * each) enter the cloud (H062+$1038).
 */
void spell_stinking_cloud(void)
{
    CokCloud *q;                        /* -$4(a5) */
    CokCloud *r;                        /* -$8(a5) */
    u16 who[4];                         /* -$10(a5) */
    u16 k;                              /* -$12(a5) */
    u16 count = 0;                      /* -$14(a5) */
    u16 tile;                           /* -$16(a5) */
    u16 level;                          /* -$18(a5) */
    u16 i;                              /* -$1A(a5) */
    u16 d;                              /* -$1C(a5) */
    s16 x;
    s16 y;

    H005_B(0x24A9) = 1; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
    level = (u16)caster_level(SPELL_NOW); /* $2471: spell being cast (0 = none) */
    r = g_clouds;
    if (g_clouds == NULL) {
        g_clouds = (CokCloud *)exec_alloc_mem(sizeof(CokCloud),
                                              COK_MEMF_CLEAR);
        r = g_clouds;
    } else {
        while (r->next != NULL) {
            if (r->owner == g_current_char) {
                ++count;
            }
            r = r->next;
        }
        r->next = (CokCloud *)exec_alloc_mem(sizeof(CokCloud),
                                             COK_MEMF_CLEAR);
        r = r->next;
    }
    /* H029+$0312 on $22 bytes: the whole record. */
    memset(r, 0, sizeof(CokCloud));
    add_effect(g_current_char, 0x28, level, (u16)(count * 16 + level), 1);
    r->owner = g_current_char;
    r->b[0x20 - 8] = (u8)count; /* nube+$18: number of the cloud (= high nibble of EF +$4 of the effect) */
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); nube+$14: (word) x of
     * the centre of the cloud/pool */
    COK_PUT16(&r->b[0x1C - 8], H005_W(0x251A));
    /* $2518: (word) y of the chosen target square (spells, breaths, telep.); nube+$16: (word) y of
     * the centre of the cloud/pool */
    COK_PUT16(&r->b[0x1E - 8], H005_W(0x2518));
    for (i = 1; i <= 4; ++i) {
        d = H005_B(0x5022 + i - 1); /* $5021: i-1 base of the 4 directions of the squares of a cloud ($5022) */
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $3EE2:
         * (word) x offset for direction d (step 2) */
        x = (s16)(H005_W(0x251A) + DIR_DX(d));
        /* $2518: (word) y of the chosen target square (spells, breaths, telep.); $3ED0:
         * (word) y offset for direction d (step 2) */
        y = (s16)(H005_W(0x2518) + DIR_DY(d));
        combat_map_cell(x, y, &who[i - 1], &tile);
        /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
        if (tile > 0 && H005_B(0x3EF4 + (tile - 1) * 4) < 0xFF) {
            /* nube+$9: base of the table of 4 covered-square flags +$A..+$D (index 1..4) */
            r->b[0x12 - 8 + i - 1] = 1;
        } else {
            /* nube+$9: base of the table of 4 covered-square flags +$A..+$D (index 1..4) */
            r->b[0x12 - 8 + i - 1] = 0;
        }
        if (tile == 0x1E) {
            for (q = g_clouds; q != NULL; q = q->next) {
                if (q == r) {
                    continue;
                }
                for (k = 1; k <= 4; ++k) {
                    /* nube+$9: base of the table of 4 covered-square flags +$A..+$D (index 1..4) */
                    if (q->b[0x12 - 8 + k - 1] &&
                        /* nube+$14: (word) x of the centre of the cloud/pool */
                        (s16)(COK_GET16(&q->b[0x1C - 8]) +
                              /* $3EE2: (word) x offset for direction d (step 2); $5021: i-1 base of the 4 directions of
                               * the squares of a cloud ($5022) */
                              DIR_DX(H005_B(0x5022 + k - 1))) == x &&
                        /* nube+$16: (word) y of the centre of the cloud/pool */
                        (s16)(COK_GET16(&q->b[0x1E - 8]) +
                              /* $3ED0: (word) y offset for direction d (step 2); $5021: i-1 base of the 4 directions of
                               * the squares of a cloud ($5022) */
                              DIR_DY(H005_B(0x5022 + k - 1))) == y &&
                        q->b[k - 1] != 0x1E) {
                        tile = q->b[k - 1];
                    }
                }
            }
        } else if (tile == 0x1F) {
            for (k = 1; k <= H005_B(0x247A); ++k) { /* $247A: number of bodies in the table +$2AE2 (max 8) */
                if (g_bodies[k - 1].x == (u16)x &&
                    g_bodies[k - 1].y == (u16)y) {
                    tile = g_bodies[k - 1].tile;
                }
            }
        }
        r->b[i - 1] = (u8)tile;
        /* nube+$9: base of the table of 4 covered-square flags +$A..+$D (index 1..4) */
        if (r->b[0x12 - 8 + i - 1]) {
            g_combat_area[0x0A + (s32)y * 0x64 + x * 2 + 1] = 0x1E;
        }
    }
    show_char_message(g_current_char, 0x17, "Creates a noxious cloud", 0x0A,
                      0);
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of
     * the chosen target square (spells, breaths, telep.) */
    center_view((s16)H005_W(0x251A), (s16)H005_W(0x2518), 0xFF, 8);
    message_delay();
    clear_message_area();
    for (i = 2; i <= 4; ++i) {
        for (k = 1; k <= 4; ++k) {
            if (who[i - 1] == who[k - 1] && i != k) {
                who[i - 1] = 0;
            }
        }
    }
    for (i = 1; i <= 4; ++i) {
        if (who[i - 1] > 0) {
            check_cloud(g_combatants[who[i - 1] - 1], 1);
        }
    }
}

/*
 * PORT H085+$3758: charm ("is charmed", H085+$1A6C without bonus), then for
 * whoever has effect $B its handler.
 */
void spell_charm_monster(void)
{
    u16 i;                              /* -$2(a5) */
    CokEffect *e;                       /* -$A(a5) */

    spell_on_targets(0, 0x0A, "is charmed");
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = 1; i <= H005_B(0x246C); ++i) {
        if (find_effect(g_spell_targets[i - 1], 0x0B, &e)) {
            call_effect_handler(0x0B, &g_spell_targets[i - 1], e, 0);
        }
    }
}

/*
 * PORT H085+$3936: cone of fear (breath area, width 3, length
 * 6, towards the chosen point): whoever fails saving throw 4 "runs in
 * terror" (effect $6F with the duration of spell $54), flees
 * (turn +$12, +$19A), passes to computer control (+$EC = $B3) and
 * loses the target; the others "is unaffected".
 */
void spell_fear(void)
{
    Character *c = g_current_char;      /* -$4(a5) */
    Character *t;                       /* -$8(a5) */
    u16 i;                              /* -$A(a5) */
    u8 saved;                           /* -$B(a5) */

    breath_area((s16)combatant_x(c), (s16)combatant_y(c),
                /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of the
                 * chosen target square (spells, breaths, telep.) */
                (s16)H005_W(0x251A), (s16)H005_W(0x2518), 3, 6);
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = 1; i <= H005_B(0x246C); ++i) {
        t = g_spell_targets[i - 1];
        saved = saving_throw_roll(t, 4, 0);
        if (!saved) {
            apply_spell_effect_on(t, 0x6F, spell_duration(0x54), 0, 1, 1,
                                  saved, 0x0E, "runs in terror");
            t->block_192->b[0x12] = 1; /* turn+$12: forced to flee flag (fear, confusion) */
            t->b[0x19A] = 1; /* ch+$19A: automatic control in combat (1 = AI) */
            if (t->b[0xEC] <= 0x7F) { /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
                t->b[0xEC] = 0xB3; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            }
            t->block_192->target = NULL;
        } else {
            show_char_message(t, 0x0D, "is unaffected", 0x0A, 1);
        }
    }
}

/* Row of the terrain table H005+$3EF4 (4 bytes per type, from 1). */
/* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
#define TERRAIN(tile)   H005_B(0x3EF4 + ((s32)(tile) - 1) * 4)

/*
 * PORT H085+$1234: the lightning bolt hits the square (x, y): *bounce becomes
 * 1 if it is a wall (terrain $FF, only with g_state_a +$1CC = 1) and it was not
 * already bouncing; the combatant in the square (if different from skip)
 * takes dmg (saving throw kind, damage of type 2).
 */
static void bolt_hit(s16 x, s16 y, u16 dmg, u8 kind, u16 skip, u8 *bounce)
{
    Character *t;                       /* -$4(a5) */
    u16 who;                            /* -$6(a5) */
    u16 tile;                           /* -$8(a5) */
    u8 saved;

    combat_map_cell(x, y, &who, &tile);
    /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
    if (tile > 0 && TERRAIN(tile) == 0xFF &&
        /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        COK_GET16(g_state_a + 0x1CC) == 1 && !*bounce) {
        *bounce = 1;
    } else {
        *bounce = 0;
    }
    if (who > 0 && who != skip) {
        t = g_combatants[who - 1];
        saved = saving_throw_roll(t, kind, 0);
        apply_damage(t, dmg, 2, saved);
        load_missile_frames(0x13);
    }
}

/*
 * PORT H085+$1306: the lightning bolt starts from the chosen point and goes on for
 * length squares (in half steps) in the direction caster -> point;
 * it stops on an obstacle or on a combatant (different from the last one
 * hit) and hits it; on a wall it bounces reversing the direction
 * (with can_bounce only once, and if the caster is within 8 steps
 * the stretch counts 8 more).
 */
static void bolt(u16 length, u16 dmg, u8 kind, u8 can_bounce)
{
    CokLine l1;                         /* -$18(a5) */
    CokLine l2;                         /* -$30(a5) */
    s16 ax;                             /* -$32(a5) */
    s16 ay;                             /* -$34(a5) */
    s16 px;                             /* -$36(a5) */
    s16 py;                             /* -$38(a5) */
    s16 sign = 1;                       /* -$3A(a5) */
    u8 bounce = 0;                      /* -$3B(a5) */
    u8 stepped;                         /* -$3C(a5) */
    u8 may_bounce;                      /* -$3D(a5) */
    u16 last_who;                       /* -$40(a5) */
    u16 who = 0;                        /* -$42(a5) */
    u16 tile = 0;                       /* -$44(a5) */
    u16 left;                           /* -$46(a5) */
    u16 used = 0;                       /* -$48(a5) */

    load_missile_frames(0x13);
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of
     * the chosen target square (spells, breaths, telep.) */
    combat_map_cell((s16)H005_W(0x251A), (s16)H005_W(0x2518), &last_who,
                    &tile);
    ax = (s16)combatant_x(g_current_char);
    ay = (s16)combatant_y(g_current_char);
    may_bounce = can_bounce;
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of
     * the chosen target square (spells, breaths, telep.) */
    if (ax == (s16)H005_W(0x251A) && ay == (s16)H005_W(0x2518)) {
        return;
    }
    left = (u16)(length * 2);
    H005_B(0x24A9) = 1; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
    while (left > 0) {
        memset(&l1, 0, sizeof(l1));
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
        l1.x0 = (s16)H005_W(0x251A);
        /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
        l1.y0 = (s16)H005_W(0x2518);
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
        l1.x1 = (s16)((s16)H005_W(0x251A) +
                      /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
                      (s16)((s16)H005_W(0x251A) - ax) * sign * (s16)left);
        /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
        l1.y1 = (s16)((s16)H005_W(0x2518) +
                      /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
                      (s16)((s16)H005_W(0x2518) - ay) * sign * (s16)left);
        line_init(&l1);
        do {
            px = l1.cx;
            py = l1.cy;
            if (!(l1.x0 == l1.x1 && l1.y0 == l1.y1)) {
                do {
                    stepped = line_step(&l1);
                    combat_map_cell(l1.cx, l1.cy, &who, &tile);
                    /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
                    if (TERRAIN(tile) == 1) {
                        bounce = 0;
                    }
                } while (stepped && (who == 0 || who == last_who) &&
                         /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
                         tile != 0 && TERRAIN(tile) <= 1 && l1.cost < left);
            }
            if (tile == 0) {
                left = 0;
            }
            animate_missile(px, py, l1.cx, l1.cy, 4, 1);
            bolt_hit(l1.cx, l1.cy, dmg, kind, last_who, &bounce);
            last_who = who;
            if (bounce) {
                /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
                H005_SET_W(0x251A, (u16)l1.cx);
                /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
                H005_SET_W(0x2518, (u16)l1.cy);
                memset(&l2, 0, sizeof(l2));
                /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
                l2.x0 = (s16)H005_W(0x251A);
                /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
                l2.y0 = (s16)H005_W(0x2518);
                l2.x1 = ax;
                l2.y1 = ay;
                line_init(&l2);
                while (line_step(&l2)) {
                }
                if (may_bounce && l2.cost <= 8) {
                    add_to_byte(&l1.cost, 8);
                }
                sign = (s16)-sign;
                may_bounce = 0;
                last_who = 0;
            }
            used = (u16)(l1.cost - used);
            if (used < left) {
                left = (u16)(left - used);
            } else {
                left = 0;
            }
            used = l1.cost;
        } while (!bounce && left != 0);
    }
    H005_B(0x24A9) = 0; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
}

/*
 * PORT H085+$31B4: lightning bolt: caster level d6 dice (type $C),
 * first on the chosen point, then along 7 squares with one bounce.
 */
void spell_lightning_bolt(void)
{
    u16 dmg;                            /* -$2(a5) */
    u8 bounce = 1;                      /* -$3(a5) */

    /* $2471: spell being cast (0 = none) */
    dmg = roll_dice((u16)caster_level(SPELL_NOW), 6);
    H005_B(0x2473) = 0x0C; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of
     * the chosen target square (spells, breaths, telep.) */
    bolt_hit((s16)H005_W(0x251A), (s16)H005_W(0x2518), dmg, 4, 0, &bounce);
    bolt(7, dmg, 4, 1);
}

/*
 * PORT H085+$33A8: discharge (type 4): 1d6+20 on the chosen point, then 20
 * along 3 squares without a bounce.  The flag -$1(a5) passed to the first hit
 * is not initialised in the original (and is not needed afterwards): here 0.
 */
void spell_bolt_20(void)
{
    u8 bounce = 0;                      /* -$1(a5) */

    H005_B(0x2473) = 4; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of
     * the chosen target square (spells, breaths, telep.) */
    bolt_hit((s16)H005_W(0x251A), (s16)H005_W(0x2518),
             (u16)(roll_dice(1, 6) + 0x14), 4, 0, &bounce);
    bolt(3, 0x14, 4, 0);
}

/* Target selection (action $276C) for spell spell. */
static void select_target_for(u8 spell, u8 *ok)
{
    ((void (*)(u8, u8, u8 *))g_handlers_25c0[107])(spell, 1, ok);
}

/* Missile animation from combatant c to the first target. */
static void missile_to_first(Character *c)
{
    animate_missile((s16)combatant_x(c), (s16)combatant_y(c),
                    (s16)combatant_x(g_spell_targets[0]),
                    (s16)combatant_y(g_spell_targets[0]), 1, 1);
}

/* Message, direction towards the first target and pose of the caster. */
static void breath_pose(Character *c, u16 len, const char *text,
                        u16 missile)
{
    u16 dir;

    show_char_message(c, len, text, 0x0A, 1);
    dir = direction_toward(c, g_spell_targets[0]);
    draw_combat_status(c);
    set_combatant_frame(c, (u8)dir, 1, 0);
    load_missile_frames(missile);
}

/* Damage equal to the maximum hit points of c to every target (save 3). */
static void breath_damage(Character *c)
{
    u16 k;
    Character *t;
    u8 saved;

    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (k = 1; k <= H005_B(0x246C); ++k) {
        if (g_spell_targets[k - 1] != NULL) {
            t = g_spell_targets[k - 1];
            saved = saving_throw_roll(t, 3, 0);
            apply_damage(t, c->b[0x64], 2, saved); /* ch+$64: maximum hit points */
        }
    }
}

/*
 * PORT H085+$431A (effect $4E): a fireball ($2F, 15d6) on the
 * chosen target: "throws a fireball", then the effect is removed.
 */
void effect_fireball(Character **cp, void *obj, u8 flag)
{
    u8 ok;                              /* -$3(a5) */

    (void)obj; (void)flag;
    H005_B(0x24A9) = 1; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
    select_target_for(0x2F, &ok);
    if (!ok) {
        return;
    }
    H005_B(0x2471) = 0x2F; /* $2471: spell being cast (0 = none) */
    center_view((s16)combatant_x(*cp), (s16)combatant_y(*cp), 0, 8);
    show_char_message(*cp, 0x11, "throws a fireball", 0x0A, 1);
    load_missile_frames(0x12);
    missile_to_first(*cp);
    /* $2471: spell being cast (0 = none) */
    apply_spell_effect(H005_B(0x2471), 0, 0, roll_damage_dice(0x0F, 6), 9,
                       0, "");
    remove_effect(*cp, 0x4E, NULL);
}

/*
 * PORT H085+$442E (effect $54): poison breath in the area of radius 3
 * around the chosen point (damage of type $20).  The charges (+$4) go back
 * to 3 without $247C and drop only if it hit someone.
 */
void effect_poison_breath(Character **cp, void *obj, u8 flag)
{
    CokEffect *e = (CokEffect *)obj;
    s16 ax;                             /* -$2(a5) */
    s16 ay;                             /* -$4(a5) */
    u8 ok;                              /* -$9(a5) */
    u8 r;                               /* -$B(a5) */

    (void)flag;
    if (H005_B(0x247C) == 0) { /* $247C: combat round number (0 at the start; bit 0 rounds) */
        e->b[4] = 3; /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    }
    if (e->b[4] == 0) { /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        return;
    }
    ax = (s16)combatant_x(*cp);
    ay = (s16)combatant_y(*cp);
    select_target_for(0x24, &ok);
    if (!ok) {
        return;
    }
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of
     * the chosen target square (spells, breaths, telep.) */
    breath_area(ax, ay, (s16)H005_W(0x251A), (s16)H005_W(0x2518), 0xFF, 3);
    if (H005_B(0x246C) == 0) { /* $246C: number of spell targets in g_spell_targets ($2520) */
        return;
    }
    H005_B(0x2473) = 0x20; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    breath_pose(*cp, 0x0F, "breathes poison", 0x12);
    missile_to_first(*cp);
    breath_damage(*cp);
    e->b[4] = (u8)(e->b[4] - 1); /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    r = end_combat_turn(*cp);
    (void)r;
}

/*
 * PORT H085+$4628 (effect $55): lightning breath (type $24): "Breathes!",
 * hit on the chosen point and a lightning bolt of 10 squares without a bounce, with
 * damage equal to the maximum hit points (save 3).  The flag -$1(a5) of the
 * first hit is not initialised in the original: here 0.
 */
void effect_lightning_breath(Character **cp, void *obj, u8 flag)
{
    CokEffect *e = (CokEffect *)obj;
    u8 bounce = 0;                      /* -$1(a5) */
    s16 ax;                             /* -$4(a5) */
    s16 ay;                             /* -$6(a5) */
    u8 r;

    (void)flag;
    if (H005_B(0x247C) == 0) { /* $247C: combat round number (0 at the start; bit 0 rounds) */
        e->b[4] = 3; /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    }
    if (e->b[4] == 0) { /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        return;
    }
    H005_B(0x2473) = 0x24; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    ax = (s16)combatant_x(*cp);
    ay = (s16)combatant_y(*cp);
    /* $24C5: outcome of the target choice (breaths, effect $42) */
    select_target_for(0x33, &H005_B(0x24C5));
    if (!H005_B(0x24C5)) { /* $24C5: outcome of the target choice (breaths, effect $42) */
        return;
    }
    breath_pose(*cp, 9, "Breathes!", 0x13);
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of
     * the chosen target square (spells, breaths, telep.) */
    animate_missile(ax, ay, (s16)H005_W(0x251A), (s16)H005_W(0x2518), 4, 2);
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of the
     * chosen target square (spells, breaths, telep.); ch+$64: maximum hit points */
    bolt_hit((s16)H005_W(0x251A), (s16)H005_W(0x2518), (*cp)->b[0x64], 3, 0,
             &bounce);
    bolt(0x0A, (*cp)->b[0x64], 3, 0); /* ch+$64: maximum hit points */
    e->b[4] = (u8)(e->b[4] - 1); /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    r = end_combat_turn(*cp);
    (void)r;
}

/*
 * PORT H085+$4798 (effect $5A): acid breath (type $30) in a narrow cone
 * (width 1, length 6), only if it hits only opponents.  The
 * check of the sides also runs if the target choice is cancelled,
 * on the previous targets, as in the original.
 */
void effect_acid_breath(Character **cp, void *obj, u8 flag)
{
    CokEffect *e = (CokEffect *)obj;
    s16 ax;                             /* -$4(a5) */
    s16 ay;                             /* -$6(a5) */
    u16 k;                              /* -$8(a5) */
    u8 r;

    (void)flag;
    H005_B(0x24C5) = 0; /* $24C5: outcome of the target choice (breaths, effect $42) */
    if (H005_B(0x247C) == 0) { /* $247C: combat round number (0 at the start; bit 0 rounds) */
        e->b[4] = 3; /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    }
    if (e->b[4] == 0) { /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        return;
    }
    H005_B(0x2473) = 0x30; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    ax = (s16)combatant_x(*cp);
    ay = (s16)combatant_y(*cp);
    /* $24C5: outcome of the target choice (breaths, effect $42) */
    select_target_for(0x3D, &H005_B(0x24C5));
    if (H005_B(0x24C5)) { /* $24C5: outcome of the target choice (breaths, effect $42) */
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518:
         * (word) y of the chosen target square (spells, breaths, telep.) */
        breath_area(ax, ay, (s16)H005_W(0x251A), (s16)H005_W(0x2518), 1, 6);
    }
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (k = 1; k <= H005_B(0x246C); ++k) {
        /* ch+$199: side in combat (0 party, 1 opponents) */
        if (g_spell_targets[k - 1]->b[0x199] != other_side(*cp)) {
            H005_B(0x24C5) = 0; /* $24C5: outcome of the target choice (breaths, effect $42) */
        }
    }
    /* $24C5: outcome of the target choice (breaths, effect $42); $246C: number of spell
     * targets in g_spell_targets ($2520) */
    if (!H005_B(0x24C5) || H005_B(0x246C) == 0) {
        return;
    }
    breath_pose(*cp, 0x0D, "breathes acid", 0x12);
    missile_to_first(*cp);
    breath_damage(*cp);
    e->b[4] = (u8)(e->b[4] - 1); /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    r = end_combat_turn(*cp);
    (void)r;
}

/*
 * PORT H085+$4A02 (effect $04): in 75% of the turns.  With the charges and the
 * 25%, blinding breath on an adjacent opponent (the last one found):
 * "Breathes!", save 3: 10 damage, otherwise 20 and blindness ($21) and
 * end of the turn.  If it has not breathed, up to two energy bolts
 * (1d8+2) on the chosen target: the second only if it stays standing.
 */
void effect_eye_attack(Character **cp, void *obj, u8 flag)
{
    CokEffect *e = (CokEffect *)obj;
    u8 r = 0;                           /* -$1(a5) */
    u8 breathed = 0;                    /* -$2(a5) */
    Character *t = NULL;                /* -$6(a5) */
    u16 k;                              /* -$8(a5) */
    Character *c;

    (void)flag;
    if (H005_B(0x247C) == 0) { /* $247C: combat round number (0 at the start; bit 0 rounds) */
        e->b[4] = 3; /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    }
    if (roll_dice(1, 0x64) > 0x4B) {
        return;
    }
    /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    if (e->b[4] != 0 && roll_dice(1, 0x64) <= 0x19) {
        t = NULL;
        find_in_area((s16)combatant_x(*cp), (s16)combatant_y(*cp), 1, 0xFF, 1,
                     g_combat_area);
        /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
        for (k = 2; k <= H005_B(0x2479); ++k) {
            /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
            c = g_combatants[H005_B(0x2A3E + (k - 1) * 4) - 1];
            if (c->b[0x199] != (*cp)->b[0x199]) { /* ch+$199: side in combat (0 party, 1 opponents) */
                t = c;
            }
        }
        if (t != NULL) {
            show_char_message(*cp, 9, "Breathes!", 0x0A, 1);
            breathed = 1;
            if (saving_throw_roll(t, 3, 0)) {
                apply_damage(t, 0x0A, 0, 1);
            } else {
                apply_damage(t, 0x14, 0, 0);
                apply_spell_effect_on(t, 0x21, 0, 0, 0, 0, 0, 0x0A,
                                      "is blinded");
                r = end_combat_turn(*cp);
            }
            /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
            e->b[4] = (u8)(e->b[4] - 1);
        }
    }
    if (breathed) {
        return;
    }
    r = 0;
    k = 0;
    do {
        /* $24C5: outcome of the target choice (breaths, effect $42) */
        select_target_for(0x3D, &H005_B(0x24C5));
        /* $24C5: outcome of the target choice (breaths, effect $42) */
        if (g_spell_targets[0] != NULL && H005_B(0x24C5)) {
            ++k;
            show_char_message(*cp, 0x15, "Fires An Energy Bolt!", 0x0A, 1);
            load_missile_frames(0x12);
            missile_to_first(*cp);
            apply_damage(g_spell_targets[0],
                         (u16)(roll_damage_dice(1, 8) + 2), 0, 0);
            /* ch+$198: active/standing (0 down or out of the combat) */
            if (g_spell_targets[0]->b[0x198] && k == 1) {
                apply_damage(g_spell_targets[0],
                             (u16)(roll_damage_dice(1, 8) + 2), 0, 0);
                ++k;
            }
            r = 1;
        } else {
            k = 2;
        }
    } while (k < 2);
    if (r) {
        r = end_combat_turn(*cp);
    }
}
