/* H027: Handlers of the game's effects/abilities; the complete map is still partial. */
#include "globals.h"
#include "unported.h"
#include "h077.h"
#include "h062.h"
#include "h063.h"
#include "h029_gfx.h"
#include "h073.h"
#include "h003_exec.h"
#include "h065.h"
#include "h030.h"
#include "h048.h"
#include <string.h>

/* PORT H027+$0206: link/unlk, no effect. */
void h027_init(void)
{
}

/*
 * PORT H027+$0286: cancels the incoming effect ($2475) and the damage ($2474)
 * if type is 0 or matches the effect.
 */
static void cancel_incoming(u16 type)
{
    if (type == 0 || H005_B(0x2475) == type) { /* $2475: incoming effect (0 = cancelled by the handlers) */
        H005_B(0x2474) = 0; /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2475) = 0; /* $2475: incoming effect (0 = cancelled by the handlers) */
    }
}

/* PORT H027+$0A00 (effect $12): 30% chance of cancelling $B and $35. */
static void effect_12(Character **cp, void *obj, u8 flag)
{
    (void)cp; (void)obj; (void)flag;
    if (roll_dice(1, 0x64) <= 0x1E) {
        cancel_incoming(0x0B);
        cancel_incoming(0x35);
    }
}

/* PORT H027+$3A46 (effect $5F): 90% chance of cancelling $35 and $B. */
static void effect_5f(Character **cp, void *obj, u8 flag)
{
    (void)cp; (void)obj; (void)flag;
    if (roll_dice(1, 0x64) <= 0x5A) {
        cancel_incoming(0x35);
        cancel_incoming(0x0B);
    }
}

/* PORT H027+$41F6 (effect $5C and others): no effect. */
static void effect_none(Character **cp, void *obj, u8 flag)
{
    (void)cp; (void)obj; (void)flag;
}

#define EH(name) static void name(Character **cp, void *obj, u8 flag)
#define UNUSED_ARGS (void)cp; (void)obj; (void)flag
#define EFF ((CokEffect *)obj)
/* $66: spell table, 16 bytes per spell (from 1); k/o = field */
#define SPELL_B(s, k)   H005_B(0x66 + ((int)(s) - 1) * 16 + (k))

/* PORT H027+$0312 (effects $1B, $1F, $33-$35): end of the turn. */
EH(effect_end_turn)
{
    u8 r;
    UNUSED_ARGS;
    r = end_combat_turn(*cp);
    (void)r;
}

/* PORT H027+$0364 (effetto 1): +5 a $2478, +1 a $2A1A. */
EH(effect_01)
{
    UNUSED_ARGS;
    add_to_byte(&H005_B(0x2478), 5); /* $2478: monster morale (0..100) passed to the $11 events */
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 1));
}

/* PORT H027+$0390 (effetto 2): -5 a $2478 (minimo 0), +1 a $2A1A. */
EH(effect_02)
{
    UNUSED_ARGS;
    if (H005_B(0x2478) < 5) { /* $2478: monster morale (0..100) passed to the $11 events */
        H005_B(0x2478) = 0; /* $2478: monster morale (0..100) passed to the $11 events */
    } else {
        add_to_byte(&H005_B(0x2478), 0xFFFB); /* $2478: monster morale (0..100) passed to the $11 events */
    }
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 1));
}

/*
 * PORT H027+$03D6 (effect 3, snakes): the blows +$19E/+$19F use up
 * the effect (+$4); "is fighting with snakes" and end of the turn.
 */
EH(effect_03)
{
    u8 hits;                            /* -$1(a5) */
    u8 r;                               /* -$2(a5) */

    (void)flag;
    /* ch+$19E: attacks of the round, attack 1 (2 entries +$19E..+$19F); ch+$19F: attacks of the
     * round, attack 2; base -1 of the dice +$1A0.. */
    hits = (u8)((*cp)->b[0x19E] + (*cp)->b[0x19F]);
    if (EFF->b[4] > hits) { /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        add_to_byte(&EFF->b[4], (u16)-(s16)hits);
    } else {
        remove_effect(*cp, 3, NULL);
    }
    show_effect_message(*cp, 1, 0x17, "is fighting with snakes");
    clear_message_area();
    r = end_combat_turn(*cp);
    (void)r;
}

/* Bonus +2 to the saving throw and to the to-hit roll. */
static void bonus_2(void)
{
    add_to_byte(&H005_B(0x2476), 2); /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 2));
}

/* PORT H027+$05C6 (effects 8, $2D): +2 if +$10F of the current one is 2, 5 or 8. */
EH(effect_08)
{
    u8 a = g_current_char->b[0x10F]; /* ch+$10F: alignment (0..8, evil 2/5/8; names H005+$4C62) */
    UNUSED_ARGS;
    if (a == 2 || a == 5 || a == 8) {
        bonus_2();
    }
}

/* PORT H027+$0622 (effects 9, $2E): +2 if +$10F of the current one is 0, 3 or 6. */
EH(effect_09)
{
    u8 a = g_current_char->b[0x10F]; /* ch+$10F: alignment (0..8, evil 2/5/8; names H005+$4C62) */
    UNUSED_ARGS;
    if (a == 0 || a == 3 || a == 6) {
        bonus_2();
    }
}

/* PORT H027+$067C (effect $A): cold damage halved, +3 to the save. */
EH(effect_0a)
{
    UNUSED_ARGS;
    if (mask_byte(H005_B(0x2473), 2)) { /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
        /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2474) = (u8)(H005_B(0x2474) >> 1);
        /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
        add_to_byte(&H005_B(0x2476), 3);
    }
}

/* PORT H027+$07F4: nothing (also used for $08FC, $098E, $1CF6, $2D30, $38E2,
 * $3C14, $3E9C, $4012 and $40EE, identical). */
EH(effect_nothing)
{
    UNUSED_ARGS;
}

/*
 * PORT H027+$02BE: adds to *cp the effect type (value value, +$4 b4)
 * unless $24AA is active; returns 1 if added.
 */
static u8 add_effect_unless_quiet(Character **cp, u8 type, u8 b4, u16 value)
{
    if (H005_B(0x24AA)) { /* $24AA: 1 during healing: the handlers do not add effects again */
        return 0;
    }
    add_effect(*cp, type, value, b4, 1);
    return 1;
}

/* PORT H027+$0912 (effect $F): slow poison, 1 point of damage. */
EH(effect_0f)
{
    (void)flag;
    /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    if (add_effect_unless_quiet(cp, 0x0F, EFF->b[4], 0x0A) &&
        (*cp)->b[0x1A8] > 1) { /* ch+$1A8: current hit points */
        H005_B(0x2473) = 0; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
        apply_damage(*cp, 1, 0, 0);
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        if (H005_B(0x3DE3) != 5) {
            draw_party(g_current_char);
        }
    }
}

/* PORT H027+$09A4 (effect $11): AC at least $39, +1 to the save. */
EH(effect_11)
{
    (void)obj; (void)flag;
    if ((*cp)->b[0x19C] < 0x39) { /* ch+$19C: encoded current armour class (60 - AC) */
        (*cp)->b[0x19C] = 0x39; /* ch+$19C: encoded current armour class (60 - AC) */
    }
    add_to_byte(&H005_B(0x2476), 1); /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
    if (H005_B(0x2471) == 0x0F) { /* $2471: spell being cast (0 = none) */
        H005_B(0x2474) = 0; /* $2474: incoming damage points, changeable by the effect handlers */
    }
}

/* PORT H027+$0A3E (effect $14): fire damage halved, +3 to the save. */
EH(effect_14)
{
    (void)cp; (void)obj;
    /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    if (!flag && mask_byte(H005_B(0x2473), 1)) {
        /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2474) = (u8)(H005_B(0x2474) >> 1);
        /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
        add_to_byte(&H005_B(0x2476), 3);
    }
}

/* PORT H027+$0A9E (effect $15): "is silenced", cancels the spell. */
EH(effect_15)
{
    u8 *turn = (*cp)->block_192->b;

    (void)obj; (void)flag;
    if (turn[2]) {
        show_char_message(*cp, 0x0B, "is silenced", 0x0A, 1);
    }
    turn[2] = 0;
    turn[1] = 0;
}

/* PORT H027+$0D70 (effect $19): without effect $18, -4 to hit. */
EH(effect_19)
{
    CokEffect *e;                       /* -$4(a5) */

    (void)cp; (void)obj;
    if (!flag && !find_effect(g_current_char, 0x18, &e)) {
        H005_B(0x24AB) = 1; /* $24AB: 1 if an effect handler forbids the attack (H096+$1562) */
        /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
        H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 4));
    }
}

/*
 * PORT H027+$0E18 (effect $1C, images): a blow destroys
 * an image ("lost an image"); when the images run out the effect goes away.
 */
EH(effect_1c)
{
    (void)flag;
    /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    if (roll_dice(1, (u16)((EFF->b[4] >> 4) + 1)) > 1 &&
        /* $2471: spell being cast (0 = none); $24A9: 1 if the spell acts on an area/group
         * (pictures unharmed) */
        !(H005_B(0x2471) > 0 && H005_B(0x24A9))) {
        cancel_incoming(0);
        show_char_message(*cp, 0x0D, "lost an image", 0x0A, 1);
        /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        add_to_byte(&EFF->b[4], 0xFFFF);
        if (EFF->b[4] == 0) { /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
            remove_effect(*cp, 0x1C, NULL);
        }
    }
}

/* PORT H027+$0EC6 (effect $1D): damage reduced by a quarter. */
EH(effect_1d)
{
    UNUSED_ARGS;
    /* $2474: incoming damage points, changeable by the effect handlers */
    H005_B(0x2474) = (u8)(H005_B(0x2474) - (H005_B(0x2474) >> 2));
}

/* PORT H027+$10CC (effect $21, blindness): -4 to hit, AC and save. */
EH(effect_21)
{
    (void)obj; (void)flag;
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 4));
    add_to_byte(&(*cp)->b[0x19C], 0xFFFC); /* ch+$19C: encoded current armour class (60 - AC) */
    /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
    add_to_byte(&(*cp)->b[0x19D], 0xFFFC);
    /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
    add_to_byte(&H005_B(0x2476), 0xFFFC);
}

/* PORT H027+$1120 (effect $22): handlers $2B and $2C. */
EH(effect_22)
{
    call_effect_handler(0x2B, cp, obj, flag);
    call_effect_handler(0x2C, cp, obj, flag);
}

/* PORT H027+$1310 (effect $24, curse): -4 to hit and save. */
EH(effect_24)
{
    UNUSED_ARGS;
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 4));
    /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
    add_to_byte(&H005_B(0x2476), 0xFFFC);
}

/* PORT H027+$133C (effect $25): without movement no attack. */
EH(effect_25)
{
    (void)obj; (void)flag;
    /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
    if (COK_GET16((*cp)->block_192->b + 4) == 0) {
        H005_B(0x24AB) = 1; /* $24AB: 1 if an effect handler forbids the attack (H096+$1562) */
        /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
        H005_SET_W(0x2A1A, 0xFFFF);
    }
}

/* PORT H027+$1374 (effect $27): ages once ("ages"). */
EH(effect_27)
{
    (void)flag;
    /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    if (mask_byte(EFF->b[4], 0x10) == 0) {
        /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        EFF->b[4] = (u8)(EFF->b[4] + 0x10);
        show_char_message(*cp, 4, "ages", 0x0A, 1);
        CH_PUTW(*cp, 0x62, (u16)(CH_W(*cp, 0x62) + 1)); /* ch+$62: age (word) */
    }
    /* $2472: working value of the events: speed or attacks of the round */
    H005_B(0x2472) = (u8)(H005_B(0x2472) << 1);
}

/* PORT H027+$1878 (effect $2A): halves $2472. */
EH(effect_2a)
{
    UNUSED_ARGS;
    /* $2472: working value of the events: speed or attacks of the round */
    H005_B(0x2472) = (u8)(H005_B(0x2472) >> 1);
}

/* PORT H027+$1A0A (effect $2F): -4 to hit with bit 2 of +$14C. */
EH(effect_2f)
{
    UNUSED_ARGS;
    /* ch+$14C: creature type flags (bits used by effects and spells) */
    if (mask_byte(g_current_char->b[0x14C], 4)) {
        /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
        H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 4));
    }
}

/* PORT H027+$1BFE (effect $32): cold +2 save, fire doubled without a save. */
EH(effect_32)
{
    UNUSED_ARGS;
    if (mask_byte(H005_B(0x2473), 2)) { /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
        /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
        add_to_byte(&H005_B(0x2476), 2);
    /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20); $24A5: outcome of the
     * last saving throw (1 succeeded) */
    } else if (mask_byte(H005_B(0x2473), 1) && !H005_B(0x24A5)) {
        /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2474) = (u8)(H005_B(0x2474) << 1);
    }
}

/*
 * PORT H027+$1C7A (effect $36): fire +2 save, cold doubled.  The
 * test reads $24A3 like the asm (H027+$1CD0); the twin $32 reads $24A5.
 */
EH(effect_36)
{
    UNUSED_ARGS;
    if (mask_byte(H005_B(0x2473), 1)) { /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
        /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
        add_to_byte(&H005_B(0x2476), 2);
    /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20); $24A3: 1 if the game is
     * saved (warning on exit); read by eff. $36 */
    } else if (mask_byte(H005_B(0x2473), 2) && !H005_B(0x24A3)) {
        /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2474) = (u8)(H005_B(0x2474) << 1);
    }
}

/* PORT H027+$1D0C (effect $38): adds effect $19 (value 1, $C). */
EH(effect_38)
{
    (void)obj; (void)flag;
    add_effect(*cp, 0x19, 1, 0x0C, 0);
}

/* PORT H027+$1D3C (effect $39): +2 to hit, AC and +$19D. */
EH(effect_39)
{
    (void)obj; (void)flag;
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 2));
    add_to_byte(&(*cp)->b[0x19C], 2); /* ch+$19C: encoded current armour class (60 - AC) */
    add_to_byte(&(*cp)->b[0x19D], 2); /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
}

/* PORT H027+$1E1A (effect $3B): cancels effect and damage. */
EH(effect_3b)
{
    UNUSED_ARGS;
    cancel_incoming(0);
    H005_B(0x2474) = 0; /* $2474: incoming damage points, changeable by the effect handlers */
}

/* PORT H027+$2138 (effect $3F): cancels the spells below the 4th level. */
EH(effect_3f)
{
    UNUSED_ARGS;
    if (H005_B(0x2471) > 0 && /* $2471: spell being cast (0 = none) */
        /* $2471: spell being cast (0 = none) */
        H005_B(0x66 + (H005_B(0x2471) - 1) * 16 + 1) < 4) {
        cancel_incoming(0);
    }
}

/* PORT H027+$2CA6 (effect $49): immune to bit 5 of the damage. */
EH(effect_49)
{
    (void)obj; (void)flag;
    /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    if (mask_byte(H005_B(0x2473), 0x20) > 0) {
        cancel_incoming(0);
        show_char_message(*cp, 0x0D, "is unaffected", 0x0A, 1);
    }
}

/* PORT H027+$2CFA (effect $4A): 1 in 20 triggers the handler of $2660. */
EH(effect_4a)
{
    UNUSED_ARGS;
    if (roll_dice(1, 0x14) == 1) {
        g_handlers_25c0[40]();
    }
}

/*
 * PORT H027+$3842 (effect $59): in combat, without $247C and $2A1A,
 * clears the high nibble of +$4; otherwise bit 4 cancels the blow.
 */
EH(effect_59)
{
    (void)cp;
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    if (flag || H005_B(0x3DE3) != 5) {
        return;
    }
    /* $247C: combat round number (0 at the start; bit 0 rounds); $2A1A: (word) to-hit roll: d20 (20
     * counts as 100) + effect modifiers */
    if (H005_B(0x247C) == 0 && H005_W(0x2A1A) == 0) {
        /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        EFF->b[4] = mask_byte(EFF->b[4], 0x0F);
    } else {
        /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        if (mask_byte(EFF->b[4], 0x10) == 0) {
            /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
            H005_SET_W(0x2A1A, 0xFFFF);
        }
        /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
        EFF->b[4] = or_byte(EFF->b[4], 0x10);
    }
}

/* PORT H027+$3A84 (effect $60): cancels $B and $35. */
EH(effect_60)
{
    UNUSED_ARGS;
    cancel_incoming(0x0B);
    cancel_incoming(0x35);
}

/* PORT H027+$3AAA (effect $61): cancels $34. */
EH(effect_61)
{
    UNUSED_ARGS;
    cancel_incoming(0x34);
}

/* PORT H027+$3AC8 (effect $62): cancels everything with cold. */
EH(effect_62)
{
    UNUSED_ARGS;
    if (mask_byte(H005_B(0x2473), 2)) { /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
        cancel_incoming(0);
    }
}

/* PORT H027+$3AFC (effect $63): cancels $37 and $34; save $64 for type 0. */
EH(effect_63)
{
    UNUSED_ARGS;
    cancel_incoming(0x37);
    cancel_incoming(0x34);
    if (H005_B(0x2A13) == 0) { /* $2A13: type of the saving throw in progress (index into +$D4), for the effects */
        H005_B(0x2476) = 0x64; /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
    }
}

/* PORT H027+$3BC0 (effect $65): damage 1d6+1 with weapon $36. */
EH(effect_65)
{
    CokItem *w = g_current_char->readied[0];   /* +$154 */
    UNUSED_ARGS;
    /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    if (w != NULL && w->b[0x30] == 0x36) {
        /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2474) = (u8)(roll_damage_dice(1, 6) + 1);
    }
}

/* PORT H027+$3D02 (effect $6A): end of the turn. */
EH(effect_6a)
{
    u8 r;
    UNUSED_ARGS;
    r = end_combat_turn(*cp);
    (void)r;
}

/* PORT H027+$3E6C (effect $6C): adds effect $19. */
EH(effect_6c)
{
    (void)obj; (void)flag;
    add_effect(*cp, 0x19, 0xFF, 0xFF, 0);
}

/* PORT H027+$3EB2 (effect $6E): removed, recomputes +$60 from the level. */
EH(effect_6e)
{
    Character *c = *cp;

    (void)obj;
    if (flag) {
        /* ch+$60: use: (knight level - 1) / 5 + 1, written at the end of eff. $6E; ch+$105:
         * knight level; ch+$10D: previous knight level */
        c->b[0x60] = (u8)((u16)(c->b[0x105] + c->b[0x10D] * h073_130a(c) - 1)
                          / 5 + 1);
    }
}

/* PORT H027+$3F1E (effect $6F): removed, frees from control. */
EH(effect_6f)
{
    Character *c = *cp;

    (void)obj;
    if (flag) {
        if (c->b[0xEC] == 0xB3) { /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            c->b[0xEC] = 0; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            c->b[0x19A] = 0; /* ch+$19A: automatic control in combat (1 = AI) */
        }
        (c->block_192->b)[0x12] = 0; /* turn+$12: forced to flee flag (fear, confusion) */
    }
}

/* PORT H027+$418E (effect $76): -2 to hit. */
EH(effect_76)
{
    UNUSED_ARGS;
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 2));
}

/* PORT H027+$41AA (effect $77): -1 to hit. */
EH(effect_77)
{
    UNUSED_ARGS;
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 1));
}

/*
 * PORT H027+$420C (vector $2A0E, magic items): readied adds
 * the effect +$45 of the item, unreadied removes it.
 */
EH(effect_item)
{
    CokItem *it = (CokItem *)obj;       /* -$4(a5) */

    H005_B(0x24E0) = 0; /* $24E0: 1: the effects go to the handler $2A0E (magic items) */
    if (flag) {
        /* item+$45: spell/parameter of the magic item (bit 7 excluded) */
        remove_effect(*cp, it->b[0x45], NULL);
    } else {
        /* item+$45: spell/parameter of the magic item (bit 7 excluded) */
        add_effect(*cp, it->b[0x45], 0, 0xFF, 1);
    }
}

/*
 * PORT H027+$0214: if the target of the turn (block +$192, +$C) does not
 * save (bonus) it stays paralysed ($34, duration dur).
 */
static void paralyze_turn_target(Character **cp, u16 dur, s16 bonus)
{
    g_h005_2a14 = (*cp)->block_192->target;
    if (!saving_throw_roll(g_h005_2a14, 0, bonus)) {
        show_effect_message(g_h005_2a14, 1, 0x0C, "is Paralyzed");
        add_effect(g_h005_2a14, 0x34, dur, 0x0C, 0);
    }
}

/* PORT H027+$0338: +1 to the saving throw and to the to-hit roll. */
EH(effect_bonus_1)
{
    UNUSED_ARGS;
    add_to_byte(&H005_B(0x2476), 1); /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 1));
}

/*
 * PORT H027+$2182: poison on the target of the turn: if it does not save (bonus,
 * plus effect $74) it dies poisoned.
 */
static void poison_turn_target(Character **cp, s16 bonus)
{
    CokEffect *e;                       /* -$4(a5) */

    g_h005_2a14 = (*cp)->block_192->target;
    if (find_effect(g_h005_2a14, 0x74, &e)) {
        if (bonus < 0) {
            bonus = 0;
        } else {
            /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
            bonus = (s16)(bonus + e->b[4]);
        }
    }
    if (!saving_throw_roll(g_h005_2a14, 0, bonus)) {
        show_char_message(g_h005_2a14, 0x0B, "is Poisoned", 0x0A, 0);
        message_delay();
        add_effect(g_h005_2a14, 0x37, 0, 0xFF, 0);
        knock_out(g_h005_2a14, 6, 9, "is killed");
    }
}

/*
 * PORT H027+$0B7A (effect $17, Spiritual Hammer): gives (or removes, on
 * removal) the magic hammer (type 6, +$34 = $79).  As in the original
 * the search after the addition leaves in it the item after the hammer.
 */
EH(effect_17)
{
    Character *c = *cp;
    Character *saved;                   /* -$a(a5) */
    CokItem *it;                        /* -$4(a5) */
    u8 found;                           /* -$5(a5) */

    (void)obj;
    it = c->items;
    found = 0;
    while (it != NULL && !found) {
        /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry);
         * item+$34: name word 3 (index into H005+$406E); base name of the type */
        if (it->b[0x30] == 6 && it->b[0x34] == 0x79) {
            found = 1;
        } else {
            it = it->next;
        }
    }
    if (flag && it != NULL) {
        delete_item(*cp, it);
    }
    if (!flag && !found && (*cp)->b[0x14F] < 0x10) { /* ch+$14F: number of items owned (max 16) */
        it = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
        it->b[0x30] = 6; /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
        it->b[0x33] = 6; /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes) */
        it->b[0x34] = 0x79; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
        COK_PUT16(&it->b[0x36], 1); /* item+$36: (word) magic bonus (+n) of the item, signed */
        it->b[0x45] = 0x17; /* item+$45: spell/parameter of the magic item (bit 7 excluded) */
        it->b[0x46] = 0x80; /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type */
        give_item_copy(*cp, it);
        exec_free_mem(it, sizeof(CokItem));     /* FreeMem($48) */
        it = (*cp)->items;
        found = 0;
        while (it != NULL && !found) {
            /* item+$34: name word 3 (index into H005+$406E); base name of the type; ogg+$30: type
             * of the item (index into the table H005+$336C, $12 bytes per entry) */
            found = (u8)(it->b[0x34] == 0x79 && it->b[0x30] == 6);
            it = it->next;
        }
        saved = g_current_char;
        g_current_char = *cp;
        if (it != NULL && (*cp)->readied[0] == NULL) {
            ready_item(it);
            it->b[0x3A] = 1; /* item+$3A: item readied flag (Ready) */
        }
        g_current_char = saved;
        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        if ((*cp)->b[0x197] == 0) {
            show_char_message(*cp, 0x0D, "Gains an item", 0x0A, 1);
        }
    }
    recompute_stats(*cp);
}

/* PORT H027+$18A4 (effect $2B, weakness): -1 to strength down to 3. */
EH(effect_2b)
{
    CokEffect *e;                       /* -$4(a5) */

    (void)flag;
    /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    if (!add_effect_unless_quiet(cp, 0x2B, EFF->b[4], 0x3C)) {
        return;
    }
    if ((*cp)->b[0x11] > 3) { /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
        show_char_message(*cp, 0x0B, "is weakened", 0x0A, 1);
        /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
        add_to_byte(&(*cp)->b[0x11], 0xFFFF);
    } else if (!find_effect(*cp, 0x1F, &e)) {
        add_effect(*cp, 0x1F, 0, 0xFF, 0);
    }
}

/* PORT H027+$1956 (effect $2C, disease): 1 point of damage. */
EH(effect_2c)
{
    CokEffect *e;                       /* -$4(a5) */

    (void)flag;
    /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    if (!add_effect_unless_quiet(cp, 0x2C, EFF->b[4], 0x0A)) {
        return;
    }
    if ((*cp)->b[0x1A8] > 1) { /* ch+$1A8: current hit points */
        H005_B(0x2473) = 0; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
        apply_damage(*cp, 1, 0, 0);
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        if (H005_B(0x3DE3) != 5) {
            draw_party(g_current_char);
        }
    } else if (!find_effect(*cp, 0x1F, &e)) {
        add_effect(*cp, 0x1F, 0, 0xFF, 0);
    }
}

/*
 * PORT H027+$1A42 (effect $30): "immolates": 1d6 of damage to the
 * active combatants of the surrounding area.
 */
EH(effect_30)
{
    u16 list[8];                        /* -$12(a5) */
    u16 n;                              /* -$14(a5) */
    u16 j;                              /* -$2(a5) */
    u16 a;
    u16 b;
    Character *p;

    (void)obj; (void)flag;
    a = combatant_x(*cp);
    b = combatant_y(*cp);
    find_in_area((s16)a, (s16)b, 1, 0xFF, combatant_size(*cp), g_combat_area);
    show_char_message(*cp, 9, "immolates", 0x0A, 1);
    n = (u16)(H005_B(0x2479) - 1); /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    for (j = 2; j <= H005_B(0x2479); ++j) {
        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
        list[j - 2] = H005_B(0x2A3E + (j - 1) * 4);
    }
    for (j = 1; j <= n; ++j) {
        p = g_combatants[list[j - 1] - 1];
        if (p->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
            apply_damage(p, roll_damage_dice(1, 6), 0, 0);
        }
    }
}

/* PORT H027+$1B88 (effect $31): +1 to its own side (+$4 bit 4), -1 to the others. */
EH(effect_31)
{
    u8 side;                            /* -$1(a5) */

    /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    side = (u8)(mask_byte(EFF->b[4], 0x10) >> 4);
    if ((*cp)->b[0x199] == side) { /* ch+$199: side in combat (0 party, 1 opponents) */
        effect_bonus_1(cp, obj, flag);
    } else {
        /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
        H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 1));
        /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
        add_to_byte(&H005_B(0x2476), 0xFFFF);
    }
}

/* PORT H027+$1D80 (effect $3A): on removal, effects $3B/$3C and removes 4, $20, $30, $39. */
EH(effect_3a)
{
    (void)obj;
    if (!flag) {
        return;
    }
    add_effect(*cp, 0x3B, 0, 0xFF, 0);
    add_effect(*cp, 0x3C, 3, 0xFF, 1);
    remove_effect(*cp, 4, NULL);
    remove_effect(*cp, 0x20, NULL);
    remove_effect(*cp, 0x30, NULL);
    remove_effect(*cp, 0x39, NULL);
}

/* PORT H027+$0AFE (effect $16): the poisoned one ($37) dies; removes $F. */
EH(effect_16)
{
    CokEffect *e;                       /* -$4(a5) */

    (void)obj; (void)flag;
    if (find_effect(*cp, 0x37, &e)) {
        knock_out(*cp, 6, 0x10, "dies from poison");
        remove_effect(*cp, 0x37, NULL);
    }
    H005_B(0x24AA) = 1; /* $24AA: 1 during healing: the handlers do not add effects again */
    remove_effect(*cp, 0x0F, NULL);
    H005_B(0x24AA) = 0; /* $24AA: 1 during healing: the handlers do not add effects again */
}

/* PORT H027+$0DB8 (effect $1A): +1 to hit a target with bit 7 of +$14C. */
EH(effect_1a)
{
    (void)obj; (void)flag;
    g_h005_2a14 = (*cp)->block_192->target;
    /* ch+$14C: creature type flags (bits used by effects and spells) */
    if (mask_byte(g_h005_2a14->b[0x14C], 0x80)) {
        /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
        H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 1));
    }
}

/*
 * PORT H027+$2028 (effect $3D): fire loses 2 points per die (minimum
 * one point per die, $2470), +4 to the save; without magic it cancels.
 */
EH(effect_3d)
{
    u16 j;                              /* -$2(a5) */

    UNUSED_ARGS;
    /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    if (!mask_byte(H005_B(0x2473), 1)) {
        return;
    }
    for (j = 1; j <= H005_B(0x2470); ++j) { /* $2470: number of dice of the last damage roll */
        /* $2474: incoming damage points, changeable by the effect handlers */
        add_to_byte(&H005_B(0x2474), 0xFFFE);
        /* $2474: incoming damage points, changeable by the effect handlers; $2470: number of dice
         * of the last damage roll */
        if (H005_B(0x2474) < H005_B(0x2470)) {
            /* $2474: incoming damage points, changeable by the effect handlers; $2470: number
             * of dice of the last damage roll */
            H005_B(0x2474) = H005_B(0x2470);
        }
    }
    add_to_byte(&H005_B(0x2476), 4); /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
    /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    if (mask_byte(H005_B(0x2473), 8) == 0) {
        cancel_incoming(0);
    }
}

/* PORT H027+$20DA (effect $3E, regeneration): +1 HP. */
EH(effect_3e)
{
    (void)flag;
    /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    if (add_effect_unless_quiet(cp, 0x3E, EFF->b[4], 0x3C) &&
        heal_character(*cp, 1, 1)) {
        heal_message(*cp);
    }
}

/* PORT H027+$224C (effect $40): poison on the target of the turn. */
EH(effect_40) { (void)obj; (void)flag; poison_turn_target(cp, 0); }

/* PORT H027+$226C (effect $41): poison, +4 to the save. */
EH(effect_41) { (void)obj; (void)flag; poison_turn_target(cp, 4); }

/* PORT H027+$37C2 (effect $56): poison, -2 to the save. */
EH(effect_56) { (void)obj; (void)flag; poison_turn_target(cp, -2); }

/* PORT H027+$37E4 (effect $57): poison, +1 to the save. */
EH(effect_57) { (void)obj; (void)flag; poison_turn_target(cp, 1); }

/*
 * PORT H027+$228E (effect $42): the first enemy combatant of the area
 * "gets zapped!" (2d6); end of the turn.
 */
EH(effect_42)
{
    Character *target = NULL;           /* -$4(a5) */
    Character *p;
    u16 j;                              /* -$8(a5) */
    u16 a;
    u16 b;
    u8 r;

    (void)obj; (void)flag;
    a = combatant_x(*cp);
    b = combatant_y(*cp);
    find_in_area((s16)a, (s16)b, 1, 0xFF, combatant_size(*cp), g_combat_area);
    H005_B(0x24C5) = 0; /* $24C5: outcome of the target choice (breaths, effect $42) */
    j = 2;
    do {
        if (j <= H005_B(0x2479)) { /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
            /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
            p = g_combatants[H005_B(0x2A3E + (j - 1) * 4) - 1];
            /* ch+$199: side in combat (0 party, 1 opponents) */
            if (p != NULL && p->b[0x199] != (*cp)->b[0x199]) {
                target = p;
                H005_B(0x24C5) = 1; /* $24C5: outcome of the target choice (breaths, effect $42) */
            }
        }
        ++j;
    /* $24C5: outcome of the target choice (breaths, effect $42); $2479: number of entries of
     * the area list +$2A3E (4 bytes per entry) */
    } while (!H005_B(0x24C5) && j <= H005_B(0x2479));
    if (target != NULL) {
        show_char_message(target, 0x0C, "gets zapped!", 0x0A, 1);
        apply_damage(target, roll_damage_dice(2, 6), 0, 0);
        r = end_combat_turn(*cp);
        (void)r;
    }
}

/* PORT H027+$25BA (effect $44): down, enters the list H005+$16. */
EH(effect_44)
{
    (void)obj; (void)flag;
    if ((*cp)->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        return;
    }
    (*cp)->b[0x197] = 0x0A; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    /* $14: number of characters on the ground in the list +$16 (word, max 20) */
    H005_SET_W(0x14, (u16)(H005_W(0x14) + 1));
    if (H005_W(0x14) < 1) { /* $14: number of characters on the ground in the list +$16 (word, max 20) */
        H005_SET_W(0x14, 1); /* $14: number of characters on the ground in the list +$16 (word, max 20) */
    }
    if (H005_W(0x14) <= 0x14) { /* $14: number of characters on the ground in the list +$16 (word, max 20) */
        /* $14: number of characters on the ground in the list +$16 (word, max 20) */
        g_h005_0016[H005_W(0x14) - 1] = *cp;
    } else {
        H005_SET_W(0x14, 0x14); /* $14: number of characters on the ground in the list +$16 (word, max 20) */
    }
    remove_effect(*cp, 0x44, NULL);
}

/* PORT H027+$2646 (effect $45): paralysis of the target. */
EH(effect_45) { (void)obj; (void)flag; paralyze_turn_target(cp, 0x64, 0); }

/* PORT H027+$3612 (effect $51): paralysis of the target. */
EH(effect_51) { (void)obj; (void)flag; paralyze_turn_target(cp, 0x64, 0); }

/* PORT H027+$3806 (effect $58): paralysis if the target has +$5B > 1. */
EH(effect_58)
{
    (void)obj; (void)flag;
    if ((*cp)->block_192->target->b[0x5B] > 1) { /* ch+$5B: race (0..6, names H005+$4D04) */
        paralyze_turn_target(cp, 0x64, 0);
    }
}

/* PORT H027+$4028 (effect $72): damage equal to the HP with bit 0 of +$14D. */
EH(effect_72)
{
    Character *t;                       /* -$4(a5) */

    (void)obj;
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    if (flag || H005_B(0x3DE3) != 5) {
        return;
    }
    t = (*cp)->block_192->target;
    /* ch+$14D: creature type flags, second byte (bit 0: effect $72) */
    if (mask_byte(t->b[0x14D], 1)) {
        /* $2474: incoming damage points, changeable by the effect handlers; ch+$1A8: current hit
         * points */
        H005_B(0x2474) = (*cp)->b[0x1A8];
    }
}

/* PORT H027+$408A (effect $73): +3 damage with bit 5 of +$14C. */
EH(effect_73)
{
    Character *t;                       /* -$4(a5) */

    (void)obj;
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    if (flag || H005_B(0x3DE3) != 5) {
        return;
    }
    t = (*cp)->block_192->target;
    /* ch+$14C: creature type flags (bits used by effects and spells) */
    if (mask_byte(t->b[0x14C], 0x20)) {
        /* $2474: incoming damage points, changeable by the effect handlers */
        add_to_byte(&H005_B(0x2474), 3);
    }
}

/* PORT H027+$4104 (effect $75): against bit 1 of +$14C it destroys or doubles. */
EH(effect_75)
{
    Character *t;                       /* -$4(a5) */

    (void)obj;
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    if (flag || H005_B(0x3DE3) != 5) {
        return;
    }
    t = (*cp)->block_192->target;
    /* ch+$14C: creature type flags (bits used by effects and spells) */
    if (mask_byte(t->b[0x14C], 2)) {
        if (t->b[0xDF]) { /* ch+$DF: undead type (0 = no); base -1 of the thief skills +$E0..+$E7 */
            knock_out(t, 8, 0x0C, "is disrupted");
        } else {
            /* $2474: incoming damage points, changeable by the effect handlers */
            H005_B(0x2474) = (u8)(H005_B(0x2474) << 1);
        }
    }
}

/* PORT H027+$17DE: weapon c fights with (H063+$37B2, or the one in hand). */
static CokItem *combat_weapon(Character *c)
{
    CokItem *w = NULL;                  /* -$4(a5) */
    u8 ok;                              /* -$5(a5) */

    if (c->readied[0] != NULL) {
        ok = find_weapon(c, &w);
        if (!ok || w == NULL) {
            w = c->readied[0];
        }
    }
    return w;
}

/* PORT H027+$0EFC (effect $1E, cloud): "is coughing", AC towards 50. */
EH(effect_1e)
{
    Character *c = *cp;

    (void)obj; (void)flag;
    if (c->block_192->b[2]) { /* turn+$2: can use items flag (cleared by coughing in the cloud) */
        show_char_message(c, 0x0B, "is coughing", 0x0A, 1);
    }
    c->block_192->b[2] = 0; /* turn+$2: can use items flag (cleared by coughing in the cloud) */
    c->block_192->b[1] = 0; /* turn+$1: can cast spells flag (not in a cloud; cleared when attacking) */
    recompute_stats(c);
    if (c->b[0x19D] > 0x34) { /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
        /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
        add_to_byte(&c->b[0x19D], 0xFFFE);
    } else {
        c->b[0x19D] = 0x32; /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
    }
    /* ch+$19C: encoded current armour class (60 - AC); ch+$19D: AC from behind (without
     * dexterity); base -1 of the attacks +$19E.. */
    c->b[0x19C] = c->b[0x19D];
    if (c == g_current_char) {
        draw_combat_status(c);
    }
}

/* PORT H027+$3916 (effect $5D): half damage from weapons with bits $81. */
EH(effect_5d)
{
    CokItem *w;                         /* -$4(a5) */

    UNUSED_ARGS;
    w = combat_weapon(g_current_char);
    /* $3374: item types +8: damage kind bits of the weapon; ogg+$30: type of the item (index
     * into the table H005+$336C, $12 bytes per entry) */
    if (w != NULL && mask_byte(H005_B(0x336C + w->b[0x30] * 0x12 + 8), 0x81)) {
        /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2474) = (u8)(H005_B(0x2474) >> 1);
    }
}

/* PORT H027+$3B34 (effect $64): half damage from weapons without bits or with bit 0. */
EH(effect_64)
{
    CokItem *w;                         /* -$4(a5) */
    u8 v;

    UNUSED_ARGS;
    w = combat_weapon(g_current_char);
    if (w == NULL) {
        return;
    }
    /* $3374: item types +8: damage kind bits of the weapon; ogg+$30: type of the item (index
     * into the table H005+$336C, $12 bytes per entry) */
    v = H005_B(0x336C + w->b[0x30] * 0x12 + 8);
    if (v == 0 || mask_byte(v, 1)) {
        /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2474) = (u8)(H005_B(0x2474) >> 1);
    }
}

/* PORT H027+$3C2A (effect $66): only magic weapons (+$36) or strong monsters wound. */
EH(effect_66)
{
    CokItem *w;                         /* -$4(a5) */

    UNUSED_ARGS;
    w = combat_weapon(g_current_char);
    /* item+$36: (word) magic bonus (+n) of the item, signed */
    if ((w == NULL || COK_GET16(&w->b[0x36]) == 0) &&
        /* ch+$5B: race (0..6, names H005+$4D04); ch+$DB: highest level among the classes (also used
         * as hit dice) */
        (g_current_char->b[0x5B] < 7 || g_current_char->b[0xDB] < 4)) {
        H005_B(0x2474) = 0; /* $2474: incoming damage points, changeable by the effect handlers */
    }
}

/* PORT H027+$3C88 (effect $69): +level ($102) of damage at distance 1 on bit 3. */
EH(effect_69)
{
    (void)obj; (void)flag;
    g_h005_2a14 = (*cp)->block_192->target;
    /* ch+$14C: creature type flags (bits used by effects and spells) */
    if (mask_byte(g_h005_2a14->b[0x14C], 8) &&
        combat_distance(*cp, g_h005_2a14) == 1) {
        /* $2474: incoming damage points, changeable by the effect handlers; ch+$102: ranger level */
        add_to_byte(&H005_B(0x2474), (*cp)->b[0x102]);
    }
}

/* PORT H027+$3F72 (effect $70): whoever hits at close range "gets zapped" (double). */
EH(effect_70)
{
    u8 dmg;                             /* -$1(a5) */
    u8 kind;                            /* -$2(a5) */

    (void)obj; (void)flag;
    if (combat_distance(g_current_char, *cp) >= 2) {
        return;
    }
    dmg = H005_B(0x2474); /* $2474: incoming damage points, changeable by the effect handlers */
    /* $2474: incoming damage points, changeable by the effect handlers */
    H005_B(0x2474) = (u8)(H005_B(0x2474) << 1);
    kind = H005_B(0x2473); /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    H005_B(0x2473) = 8; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    show_char_message(g_current_char, 0x0B, "gets zapped", 0x0A, 1);
    /* $2474: incoming damage points, changeable by the effect handlers */
    apply_damage(g_current_char, H005_B(0x2474), 0, 0);
    H005_B(0x2474) = dmg; /* $2474: incoming damage points, changeable by the effect handlers */
    H005_B(0x2473) = kind; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
}

/*
 * PORT H027+$0492 (effect 7, natural attack): at close range 1d6+2 plus the
 * strength, at a distance 1d4+1 plus the dexterity; +$36 of the weapon is added.
 * Without a weapon the original uses the uninitialised word; here 0.
 */
EH(effect_07)
{
    Character *c = *cp;
    Character *t;                       /* -$4(a5) */
    u16 dist;                           /* -$6(a5) */
    u16 bonus = 0;                      /* -$8(a5) */
    u16 dmg;

    (void)obj;
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    if (flag || H005_B(0x3DE3) != 5) {
        return;
    }
    if (c->readied[0] != NULL) {
        /* item+$36: (word) magic bonus (+n) of the item, signed */
        bonus = COK_GET16(&c->readied[0]->b[0x36]);
    }
    t = c->block_192->target;
    dist = combat_distance(c, t);
    /* ch+$19B: encoded current THAC0 (60 - THAC0); ch+$5A: encoded base THAC0 (60 - THAC0) from
     * the per-level table */
    c->b[0x19B] = c->b[0x5A];
    if (dist < 2) {
        dmg = roll_damage_dice(1, 6);
        dmg = (u16)(dmg + str_damage_bonus(c) + 2 + bonus);
        /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2474) = (u8)dmg;
        /* ch+$19B: encoded current THAC0 (60 - THAC0) */
        c->b[0x19B] = (u8)(c->b[0x19B] + str_hit_bonus(c));
    } else {
        dmg = roll_damage_dice(1, 4);
        /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2474) = (u8)(dmg + 1 + bonus);
        /* ch+$19B: encoded current THAC0 (60 - THAC0) */
        c->b[0x19B] = (u8)(c->b[0x19B] + dex_missile_adj(c));
    }
}

/*
 * PORT H027+$06D4 (effect $B, charm): moves to the caster's side
 * (+$4 bit 6/7) and goes back to its own on removal.
 */
EH(effect_0b)
{
    Character *c = *cp;

    if (flag) {
        /* ch+$199: side in combat (0 party, 1 opponents); eff+$4: parameter/level of the
         * effect (for $28 high nibble = cloud no.) */
        c->b[0x199] = (u8)(mask_byte(EFF->b[4], 0x40) >> 6);
        if (c->b[0xEC] == 0xB3) { /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            c->b[0xEC] = 0; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            c->b[0x19A] = 0; /* ch+$19A: automatic control in combat (1 = AI) */
        }
        return;
    }
    /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    if (mask_byte(EFF->b[4], 0x20) == 0) {
        /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.); ch+$199: side
         * in combat (0 party, 1 opponents) */
        EFF->b[4] = (u8)(EFF->b[4] + 0x20 + (c->b[0x199] << 6));
        /* ch+$199: side in combat (0 party, 1 opponents); eff+$4: parameter/level of the
         * effect (for $28 high nibble = cloud no.) */
        c->b[0x199] = (u8)(EFF->b[4] >> 7);
        c->b[0x19A] = 1; /* ch+$19A: automatic control in combat (1 = AI) */
        if (c->b[0xEC] <= 0x7F) { /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            c->b[0xEC] = 0xB3; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
        }
        c->block_192->target = NULL;
        count_sides();
    }
    H005_B(0x2478) = 0x64; /* $2478: monster morale (0..100) passed to the $11 events */
}

/* PORT H027+$080A (effect $D): comes back to life raging ("goes mad!"), without spells. */
EH(effect_0d)
{
    Character *c = *cp;

    (void)flag;
    if (c->b[0x197] == 0) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        return;
    }
    c->b[0x197] = 0; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    c->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
    if (!revive(*cp, 0x14, 9, "goes mad!")) {
        return;
    }
    add_effect(*cp, 0x20, 0, 0xFF, 0);
    add_effect(*cp, 0x30, 0, 0xFF, 0);
    add_effect(*cp, 0x39, 0, 0xFF, 0);
    add_effect(*cp, 0x3A, 6, 0xFF, 1);
    remove_effect(*cp, 0x0D, EFF);
    /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
    h029_fill_bytes(0x39, &(*cp)->b[0x1E], 0x3A, 0);
}

/* PORT H027+$0FCE (effetto $20): "Arises in a new form". */
EH(effect_20)
{
    Character *c = *cp;

    (void)obj; (void)flag;
    if (c->b[0x197] == 0) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        return;
    }
    c->b[0x197] = 0; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    c->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
    if (!revive(*cp, 0x14, 0x14, "Arises in a new form")) {
        return;
    }
    add_effect(*cp, 0x3B, 0, 0xFF, 0);
    add_effect(*cp, 0x3C, 3, 0xFF, 0);
    add_effect(*cp, 0x42, 0, 0xFF, 0);
    remove_effect(*cp, 0x20, NULL);
    remove_effect(*cp, 4, NULL);
    remove_effect(*cp, 0x30, NULL);
    remove_effect(*cp, 0x39, NULL);
    remove_effect(*cp, 0x3A, NULL);
}

/*
 * PORT H027+$1162 (effect $23, confusion): d10: 1 flees, 2-6 stays
 * confused, 7-8 goes berserk, 9-10 becomes enraged; then a saving throw (-2)
 * can remove the confusion.
 */
EH(effect_23)
{
    Character *c = *cp;
    u16 r;                              /* -$2(a5) */
    u8 saved;                           /* -$3(a5) */

    r = roll_dice(1, 0x0A);
    switch (r) {
    case 1:                             /* $1186 */
        remove_effect(c, 0x23, NULL);
        c->block_192->b[0x12] = 1; /* turn+$12: forced to flee flag (fear, confusion) */
        c->b[0x19A] = 1; /* ch+$19A: automatic control in combat (1 = AI) */
        if (c->b[0xEC] <= 0x7F) { /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            c->b[0xEC] = 0xB3; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
        }
        c->block_192->target = NULL;
        apply_spell_effect_on(c, 0x6F, 0x0A, 0, 1, 1, 0, 9, "runs away");
        break;
    case 2: case 3: case 4: case 5: case 6:     /* $120C */
        show_effect_message(c, 1, 0x0B, "is confused");
        clear_message_area();
        effect_end_turn(cp, obj, 0);
        break;
    case 7: case 8:                     /* $123A */
        /* ch+$199: side in combat (0 party, 1 opponents) */
        apply_spell_effect_on(c, 0x4D, 1, c->b[0x199], 1, 1, 0, 0x0C,
                              "goes berserk");
        call_effect_handler(0x4D, cp, NULL, 0);
        break;
    case 9: case 10:                    /* $1282 */
        show_effect_message(c, 1, 0x0A, "is enraged");
        clear_message_area();
        break;
    default:
        break;
    }
    (void)flag;
    saved = saving_throw_roll(*cp, 4, -2);
    if (saved) {
        remove_effect(*cp, 0x23, NULL);
    }
}

/* ---- Clouds ($2514) and acid pools ($250C) on the combat map ---- */

/* Byte of the square (x, y) of the map H005+$2ADE: +$A + y*$64 + x*2 + 1. */
static u8 *combat_cell(s16 x, s16 y)
{
    return g_combat_area + 0x0A + (s32)y * 0x64 + x * 2 + 1;
}

/* Square i (1..4) of a cloud: centre +$1C/+$1E plus the direction $5022. */
static s16 cloud_x(CokCloud *p, u16 i)
{
    return (s16)(COK_GET16(&p->b[0x1C - 8]) + /* nube+$14: (word) x of the centre of the cloud/pool */
                 /* $3EE2: (word) x offset for direction d (step 2); $5021: i-1 base of the 4
                  * directions of the squares of a cloud ($5022) */
                 H005_W(0x3EE2 + H005_B(0x5022 + i - 1) * 2));
}

static s16 cloud_y(CokCloud *p, u16 i)
{
    return (s16)(COK_GET16(&p->b[0x1E - 8]) + /* nube+$16: (word) y of the centre of the cloud/pool */
                 /* $3ED0: (word) y offset for direction d (step 2); $5021: i-1 base of the 4
                  * directions of the squares of a cloud ($5022) */
                 H005_W(0x3ED0 + H005_B(0x5022 + i - 1) * 2));
}

/* Is a body of the table H005+$2AE2 ($247A entries) on (x, y)? */
static u8 on_2ae2_table(u16 x, u16 y)
{
    u16 k;
    u8 found = 0;

    for (k = 1; k <= H005_B(0x247A); ++k) { /* $247A: number of bodies in the table +$2AE2 (max 8) */
        if (g_bodies[k - 1].who != NULL && g_bodies[k - 1].x == x &&
            g_bodies[k - 1].y == y) {
            found = 1;
        }
    }
    return found;
}

/*
 * Removes r from the list *head and frees it ($22 bytes in the original; here the
 * size of the C record, with which it must be allocated).  Like the original, if r is
 * at the head the head advances and then r->next = r->next.
 */
static void unlink_cloud(CokCloud **head, CokCloud *r)
{
    CokCloud *prev;                     /* -$4(a5) */

    prev = *head;
    if (prev == r) {
        *head = prev->next;
    } else {
        while (prev->next != r) {
            prev = prev->next;
        }
    }
    prev->next = r->next;
    exec_free_mem(r, sizeof(CokCloud));
}

/* Redraws the remaining clouds ($1E) and the acid pools ($1D). */
static void redraw_clouds_and_pools(void)
{
    CokCloud *p;
    u16 i;

    for (p = g_clouds; p != NULL; p = p->next) {
        for (i = 1; i <= 4; ++i) {
            /* nube+$9: base of the table of 4 covered-square flags +$A..+$D (index 1..4) */
            if (p->b[0x12 - 8 + i - 1]) {
                *combat_cell(cloud_x(p, i), cloud_y(p, i)) = 0x1E;
            }
        }
    }
    for (p = g_acid_pools; p != NULL; p = p->next) {
        *combat_cell((s16)COK_GET16(&p->b[0x1C - 8]), /* nube+$14: (word) x of the centre of the cloud/pool */
                     /* nube+$16: (word) y of the centre of the cloud/pool */
                     (s16)COK_GET16(&p->b[0x1E - 8])) = 0x1D;
    }
}

/*
 * PORT H027+$13F4 (effect $28, cloud): removes cloud number +$4>>4 of
 * this character: "The air clears a little...", its squares go back
 * to the saved contents (+$08..) or $1F if there is a body ($2AE2).
 */
EH(effect_28)
{
    u16 id;                             /* -$14(a5) */
    u8 found = 0;                       /* -$D(a5) */
    CokCloud *p;                        /* -$8(a5) */
    u16 i;                              /* -$12(a5) */
    u8 x;                               /* -$E(a5) */
    u8 y;                               /* -$F(a5) */

    (void)flag;
    id = (u16)(EFF->b[4] >> 4); /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    p = g_clouds;
    while (p != NULL && !found) {
        /* nube+$18: number of the cloud (= high nibble of EF +$4 of the effect) */
        if (p->owner == *cp && p->b[0x20 - 8] == id) {
            found = 1;
        } else {
            p = p->next;
        }
    }
    if (!found) {
        return;
    }
    show_message_line(0x1A, "The air clears a little...");
    for (i = 1; i <= 4; ++i) {
        /* nube+$9: base of the table of 4 covered-square flags +$A..+$D (index 1..4) */
        if (!p->b[0x12 - 8 + i - 1]) {
            continue;
        }
        x = (u8)cloud_x(p, i);
        y = (u8)cloud_y(p, i);
        if (on_2ae2_table(x, y)) {
            *combat_cell(x, y) = 0x1F;
        } else {
            *combat_cell(x, y) = p->b[i - 1];
        }
    }
    unlink_cloud(&g_clouds, p);
    redraw_clouds_and_pools();
}

/*
 * PORT H027+$3292 (effect $50): removes acid pool number +$4 of
 * this character: "The acid drains away..", the square goes back to the
 * saved contents (+$08) or $1F if there is a body ($2AE2).
 */
EH(effect_50)
{
    u16 id;                             /* -$10(a5) */
    u8 found = 0;                       /* -$D(a5) */
    CokCloud *r;                        /* -$8(a5) */
    s16 x;
    s16 y;

    (void)flag;
    id = EFF->b[4]; /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    r = g_acid_pools;
    while (r != NULL && !found) {
        /* nube+$18: number of the cloud (= high nibble of EF +$4 of the effect) */
        if (r->owner == *cp && r->b[0x20 - 8] == id) {
            found = 1;
        } else {
            r = r->next;
        }
    }
    if (!found) {
        return;
    }
    show_message_line(0x16, "The acid drains away..");
    x = (s16)COK_GET16(&r->b[0x1C - 8]); /* nube+$14: (word) x of the centre of the cloud/pool */
    y = (s16)COK_GET16(&r->b[0x1E - 8]); /* nube+$16: (word) y of the centre of the cloud/pool */
    if (on_2ae2_table((u16)x, (u16)y)) {
        *combat_cell(x, y) = 0x1F;
    } else {
        *combat_cell(x, y) = r->b[0]; /* nube+$0: 4-byte table: saved contents of the covered squares */
    }
    unlink_cloud(&g_acid_pools, r);
    redraw_clouds_and_pools();
}

/*
 * PORT H027+$266A (effect $46): if down without hit points or out of
 * combat, "dissolves into acid!": a pool ($1D) in its square,
 * with effect $50 (1d6 turns) to remove it.  In the list the original does not
 * count the last record in the pool number.  With a $1F square
 * the direction index -$10(a5) is not initialised: here 0.
 */
EH(effect_46)
{
    u16 count = 0;                      /* -$A(a5) */
    CokCloud *r;                        /* -$4(a5) */
    CokCloud *q;                        /* -$8(a5) */
    u16 value;                          /* -$14(a5) */
    u16 tile;                           /* -$C(a5) */
    u16 dir = 0;                        /* -$10(a5) */
    u16 i;                              /* -$16(a5) */
    u16 k;
    s16 x;
    s16 y;

    (void)obj; (void)flag;
    /* ch+$1A8: current hit points; ch+$198: active/standing (0 down or out of the combat) */
    if ((*cp)->b[0x1A8] > 0 && (*cp)->b[0x198]) {
        return;
    }
    r = g_acid_pools;
    if (g_acid_pools == NULL) {
        g_acid_pools = (CokCloud *)exec_alloc_mem(sizeof(CokCloud), COK_MEMF_CLEAR);
        r = g_acid_pools;
    } else {
        while (r->next != NULL) {
            if (r->owner == *cp) {
                ++count;
            }
            r = r->next;
        }
        r->next = (CokCloud *)exec_alloc_mem(sizeof(CokCloud), COK_MEMF_CLEAR);
        r = r->next;
    }
    add_effect(*cp, 0x50, roll_dice(1, 6), count, 1);
    /* H029+$0312 on $22 bytes: the whole record. */
    memset(r, 0, sizeof(CokCloud));
    r->next = NULL;
    r->owner = *cp;
    r->b[0x20 - 8] = (u8)count; /* nube+$18: number of the cloud (= high nibble of EF +$4 of the effect) */
    COK_PUT16(&r->b[0x1C - 8], combatant_x(*cp)); /* nube+$14: (word) x of the centre of the cloud/pool */
    COK_PUT16(&r->b[0x1E - 8], combatant_y(*cp)); /* nube+$16: (word) y of the centre of the cloud/pool */
    x = (s16)COK_GET16(&r->b[0x1C - 8]); /* nube+$14: (word) x of the centre of the cloud/pool */
    y = (s16)COK_GET16(&r->b[0x1E - 8]); /* nube+$16: (word) y of the centre of the cloud/pool */
    combat_map_cell(x, y, &value, &tile);
    if (tile == 0x1E) {
        for (q = g_clouds; q != NULL; q = q->next) {
            for (i = 1; i <= 4; ++i) {
                /* nube+$9: base of the table of 4 covered-square flags +$A..+$D (index 1..4) */
                if (q->b[0x12 - 8 + i - 1] &&
                    cloud_x(q, i) == x && cloud_y(q, i) == y &&
                    q->b[i - 1] != 0x1E) {
                    tile = q->b[i - 1];
                }
            }
        }
    } else if (tile == 0x1F) {
        for (k = 1; k <= H005_B(0x247A); ++k) { /* $247A: number of bodies in the table +$2AE2 (max 8) */
            if (g_bodies[k - 1].x ==
                    /* $251A: (word) x of the chosen target square (spells, breaths, telep.);
                     * $3EE2: (word) x offset for direction d (step 2) */
                    (u16)(H005_W(0x251A) + H005_W(0x3EE2 + dir * 2)) &&
                g_bodies[k - 1].y ==
                    /* $2518: (word) y of the chosen target square (spells, breaths, telep.);
                     * $3ED0: (word) y offset for direction d (step 2) */
                    (u16)(H005_W(0x2518) + H005_W(0x3ED0 + dir * 2))) {
                tile = g_bodies[k - 1].tile;
            }
        }
    }
    r->b[0] = (u8)tile; /* nube+$0: 4-byte table: saved contents of the covered squares */
    *combat_cell(x, y) = 0x1D;
    center_view(combatant_x(*cp), combatant_y(*cp), 0xFF, 8);
    show_char_message(*cp, 0x14, "dissolves into acid!", 0x0A, 0);
}

/*
 * PORT H027+$174E: whoever fights with a weapon in hand from a distance > 1 has
 * chance% of dodging the blow ("Avoids it"): damage 0, -1 to the roll.
 */
static void avoid_missile(Character **cp, u16 chance)
{
    if (g_current_char->readied[0] == NULL) {
        return;
    }
    if (combat_distance(g_current_char, *cp) <= 1) {
        return;
    }
    if (roll_dice(1, 100) > chance) {
        return;
    }
    show_char_message(*cp, 9, "Avoids it", 0x0A, 1);
    H005_B(0x2474) = 0; /* $2474: incoming damage points, changeable by the effect handlers */
    H005_SET_W(0x2A1A, 0xFFFF); /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    /* $2A18: hits of the round with attack 1 (cleared at every attack) */
    add_to_byte(&H005_B(0x2A18), 0xFFFF);
}

/* PORT H027+$1836 (effect $29): always dodges weapons without a bonus (+$36). */
EH(effect_29)
{
    CokItem *w;                         /* -$4(a5) */

    (void)obj; (void)flag;
    w = combat_weapon(g_current_char);
    /* item+$36: (word) magic bonus (+n) of the item, signed */
    if (w != NULL && COK_GET16(&w->b[0x36]) == 0) {
        avoid_missile(cp, 100);
    }
}

/*
 * PORT H027+$1E3C (effect $3C): on removal "explodes!": 3d6 to the
 * surrounding active combatants, stun ($6A) without a saving throw; after
 * every neighbour the characters down explode (H062+$2734).
 */
EH(effect_3c)
{
    u8 n;                               /* -$1(a5) */
    u16 list[8];                        /* -$12(a5) */
    u16 j;                              /* -$14(a5) */
    u16 a;
    u16 b;
    Character *p;

    (void)obj;
    if (!flag) {
        return;
    }
    a = combatant_x(*cp);
    b = combatant_y(*cp);
    find_in_area((s16)a, (s16)b, 1, 0xFF, combatant_size(*cp), g_combat_area);
    knock_out(*cp, 8, 9, "explodes!");
    n = (u8)(H005_B(0x2479) - 1); /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    for (j = 2; j <= H005_B(0x2479); ++j) {
        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
        list[j - 2] = H005_B(0x2A3E + (j - 1) * 4);
    }
    for (j = 1; j <= n; ++j) {
        p = g_combatants[list[j - 1] - 1];
        if (p->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
            apply_damage(p, roll_damage_dice(3, 6), 0, 0);
            if (!saving_throw_roll(g_combatants[list[j - 1] - 1], 4, 0)) {
                show_char_message(g_combatants[list[j - 1] - 1], 0x0A,
                                  "is stunned", 0x0A, 1);
                add_effect(g_combatants[list[j - 1] - 1], 0x6A, 0, 0xFF, 0);
            }
        }
        explode_fallen();
    }
}

/*
 * PORT H027+$2400 (effect $43): whoever attacks at close range with a non-cursed
 * weapon (+$3C), on d20 >= STR-3, "loses his weapon": the weapon moves to the
 * list H005+$3360 (copy + who lost it) and leaves the inventory.  The
 * hammer (type 6, +$34 = $79) is not lost.
 */
EH(effect_43)
{
    CokItem *w;                         /* -$4(a5) */
    CokDropped *d;                      /* -$8(a5) */

    (void)obj; (void)flag;
    w = combat_weapon(g_current_char);
    if (roll_dice(1, 0x14) < (u16)(g_current_char->b[0x17] - 3)) { /* ch+$17: current dexterity */
        return;
    }
    /* $2471: spell being cast (0 = none); item+$3C: cursed item flag; $24AF: use: cleared at the
     * start of combat; if 1 effect $43 does not act */
    if (H005_B(0x2471) != 0 || w == NULL || w->b[0x3C] || H005_B(0x24AF)) {
        return;
    }
    if (combat_distance(g_current_char, *cp) != 1) {
        return;
    }
    show_char_message(g_current_char, 0x10, "loses his weapon", 0x0A, 1);
    d = g_dropped_items;
    /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry); item+$34:
     * name word 3 (index into H005+$406E); base name of the type */
    if (w->b[0x30] == 6 && w->b[0x34] == 0x79) {
        return;
    }
    ready_item(w);
    if (d == NULL) {
        g_dropped_items = (CokDropped *)exec_alloc_mem(sizeof(CokDropped),
                                                       COK_MEMF_CLEAR);
        memcpy(g_dropped_items->b, w->b, 0x48);
        g_dropped_items->owner = g_current_char;
        g_dropped_items->next = NULL;
    } else {
        while (d->next != NULL) {
            d = d->next;
        }
        d->next = (CokDropped *)exec_alloc_mem(sizeof(CokDropped),
                                               COK_MEMF_CLEAR);
        d = d->next;
        memcpy(d->b, w->b, 0x48);
        d->owner = g_current_char;
        d->next = NULL;
    }
    delete_item(g_current_char, w);
    g_current_char->readied[0] = NULL;
    draw_combat_status(g_current_char);
}

/*
 * PORT H027+$29E2 (effect $47): with d10 = 1 on a spell of level
 * (+6) < 8, or always above $E, "reflects the spell" towards the caster.
 * Like the original, animation and *cp = caster repeat for every
 * target of the list, even those not replaced.
 */
EH(effect_47)
{
    u16 i;                              /* -$2(a5) */

    (void)obj; (void)flag;
    /* $2471: spell being cast (0 = none) */
    if (!(roll_dice(1, 0x0A) == 1 && SPELL_B(H005_B(0x2471), 6) < 8) &&
        SPELL_B(H005_B(0x2471), 6) <= 0x0E) { /* $2471: spell being cast (0 = none) */
        return;
    }
    show_char_message(*cp, 0x12, "reflects the spell", 0x0A, 0);
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
    H005_SET_W(0x251A, combatant_x(g_current_char));
    /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
    H005_SET_W(0x2518, combatant_y(g_current_char));
    /* $246C: number of spell targets in g_spell_targets ($2520) */
    for (i = 1; i <= H005_B(0x246C); ++i) {
        if (g_spell_targets[i - 1] == *cp) {
            g_spell_targets[i - 1] = g_current_char;
        }
        load_missile_frames(0x12);
        animate_missile(combatant_x(*cp), combatant_y(*cp),
                  combatant_x(g_spell_targets[0]),
                  combatant_y(g_spell_targets[0]),
                  1, 0x1E);
        *cp = g_current_char;
    }
}

/* Fright: flees ($19A, $EC = $B3), no target, turn +$12. */
static void make_flee(Character *p)
{
    p->b[0x19A] = 1; /* ch+$19A: automatic control in combat (1 = AI) */
    if (p->b[0xEC] <= 0x7F) { /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
        p->b[0xEC] = 0xB3; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    }
    p->block_192->target = NULL;
    p->block_192->b[0x12] = 1; /* turn+$12: forced to flee flag (fear, confusion) */
}

/*
 * PORT H027+$2B3E (effect $48): the surrounding enemies without $5C that fail
 * the saving throw "is terrified" ($6F) and flee.
 */
EH(effect_48)
{
    Character *p;                       /* -$4(a5) */
    CokEffect *e;                       /* -$8(a5) */
    u16 j;                              /* -$A(a5) */
    u16 a;
    u16 b;

    (void)obj; (void)flag;
    a = combatant_x(*cp);
    b = combatant_y(*cp);
    find_in_area((s16)a, (s16)b, 1, 0xFF, combatant_size(*cp), g_combat_area);
    /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    for (j = 2; j <= H005_B(0x2479); ++j) {
        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
        p = g_combatants[H005_B(0x2A3E + (j - 1) * 4) - 1];
        /* ch+$199: side in combat (0 party, 1 opponents) */
        if (p->b[0x199] == (*cp)->b[0x199] || find_effect(p, 0x5C, &e) ||
            saving_throw_roll(p, 4, 0)) {
            continue;
        }
        apply_spell_effect_on(p, 0x6F, 0, 0, 1, 1, 0, 0x0C, "is terrified");
        if (find_effect(p, 0x6F, &e)) {
            make_flee(p);
        }
    }
}

/*
 * PORT H027+$2D46 (effect $4C, "gates in"): while it has less than half of its
 * hit points, puts back into the field the characters in status 9 on the free
 * squares ($17) around the characters of the other side, then removes the effect.
 * The original does not advance the direction for a square off the map (endless
 * loop at the edge) and reads +$199 of a NULL next one; here a NULL
 * closes like the return to the caster.
 */
EH(effect_4c)
{
    Character *s;                       /* -$12(a5) */
    Character *anchor;                  /* -$E(a5) */
    u8 done = 0;                        /* -$13(a5) */
    u8 revived;                         /* -$14(a5) */
    u16 dir = 0;                        /* -$A(a5) */
    s16 x0;                             /* -$2(a5) */
    s16 y0;                             /* -$4(a5) */
    s16 x;                              /* -$6(a5) */
    s16 y;                              /* -$8(a5) */
    u16 value;                          /* -$18(a5) */
    u16 tile;                           /* -$16(a5) */
    u16 n;                              /* -$1A(a5) */

    (void)obj; (void)flag;
    /* ch+$1A8: current hit points; ch+$64: maximum hit points */
    if ((*cp)->b[0x1A8] >= (u16)((*cp)->b[0x64] >> 1)) {
        return;
    }
    s = g_party_head;
    anchor = g_party_head;
    /* ch+$199: side in combat (0 party, 1 opponents) */
    while (anchor != NULL && anchor->b[0x199] == (*cp)->b[0x199]) {
        anchor = anchor->next;
    }
    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    while (s != NULL && s->b[0x197] != 9) {
        s = s->next;
    }
    do {
        if ((s16)dir > 7) {
            if (anchor == NULL) {
                anchor = *cp;
                done = 1;
            } else {
                anchor = anchor->next;
                /* ch+$199: side in combat (0 party, 1 opponents) */
                if (anchor == NULL || anchor->b[0x199] == (*cp)->b[0x199]) {
                    done = 1;
                    anchor = *cp;
                }
            }
            dir = 0;
        }
        if (s == NULL) {
            done = 1;
            continue;
        }
        x0 = (s16)combatant_x(anchor);
        y0 = (s16)combatant_y(anchor);
        revived = 0;
        do {
            /* $3EE2: (word) x offset for direction d (step 2) */
            x = (s16)(x0 + H005_W(0x3EE2 + dir * 2));
            /* $3ED0: (word) y offset for direction d (step 2) */
            y = (s16)(y0 + H005_W(0x3ED0 + dir * 2));
            if (x > 0x31 || x < 0 || y > 0x18 || y < 0) {
                continue;
            }
            combat_map_cell(x, y, &value, &tile);
            if (value == 0 && tile == 0x17) {
                n = combatant_index(s);
                /* $3159: combatant positions +5: shape/size (0 = off the map); ch+$D3: shape/size
                 * on the combat map (bits 0-2, >1 large) */
                H005_B(0x3154 + (n - 1) * 6 + 5) = mask_byte(s->b[0xD3], 7);
                /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
                H005_SET_W(0x3154 + (n - 1) * 6, (u16)x);
                /* $3156: combatant positions +2: row on the map (word) */
                H005_SET_W(0x3154 + (n - 1) * 6 + 2, (u16)y);
                h043_190e(0x16);
                revived = revive(s, s->b[0x64], 8, "gates in"); /* ch+$64: maximum hit points */
                s = s->next;
                /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                if (s == NULL || s->b[0x197] != 9) {
                    done = 1;
                }
            }
            ++dir;
        } while (!revived && (s16)dir <= 7);
    } while (!done && anchor != *cp);
    remove_effect(*cp, 0x4C, NULL);
}

/*
 * PORT H027+$2FE2 (effect $4D, berserk): flees from its companions ($EC = $B3, or
 * $B2 for the monsters with their own AI); in combat it takes as target
 * the first one of the area ($2A42), moves to the opposite side and "goes berserk".  On
 * removal it goes back to side 0.
 */
EH(effect_4d)
{
    Character *c = *cp;
    u16 a;
    u16 b;

    (void)obj;
    if (flag) {
        if (c->b[0xEC] == 0xB3) { /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            c->b[0xEC] = 0; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            c->b[0x19A] = 0; /* ch+$19A: automatic control in combat (1 = AI) */
        }
        c->b[0x199] = 0; /* ch+$199: side in combat (0 party, 1 opponents) */
        return;
    }
    c->b[0x19A] = 1; /* ch+$19A: automatic control in combat (1 = AI) */
    /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    if (c->b[0xEC] <= 0x7F || c->b[0xEC] == 0xB3) {
        c->b[0xEC] = 0xB3; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    } else {
        c->b[0xEC] = 0xB2; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    }
    if (H005_B(0x3DE3) != 5) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        return;
    }
    c->block_192->target = NULL;
    a = combatant_x(*cp);
    b = combatant_y(*cp);
    find_in_area((s16)a, (s16)b, 0xFF, 0xFF,
                 combatant_size(*cp), g_combat_area);
    /* $2A42: area list: combatant of the second entry (first after c) */
    (*cp)->block_192->target = g_combatants[H005_B(0x2A42) - 1];
    /* turn+$1: can cast spells flag (not in a cloud; cleared when attacking) */
    (*cp)->block_192->b[1] = 0;
    /* ch+$199: side in combat (0 party, 1 opponents) */
    (*cp)->b[0x199] = xor_byte((*cp)->block_192->target->b[0x199], 1);
    show_char_message(*cp, 0x0C, "goes berserk", 0x0A, 1);
}

/*
 * PORT H027+$3D28 (effect $6B): like $4D without the combat
 * check and without a message; on removal the side goes back to +$4
 * of the effect and $19A stays.
 */
EH(effect_6b)
{
    Character *c = *cp;
    u16 a;
    u16 b;

    if (flag) {
        if (c->b[0xEC] == 0xB3) { /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            c->b[0xEC] = 0; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
        }
        /* ch+$199: side in combat (0 party, 1 opponents); eff+$4: parameter/level of the
         * effect (for $28 high nibble = cloud no.) */
        c->b[0x199] = EFF->b[4];
        return;
    }
    c->b[0x19A] = 1; /* ch+$19A: automatic control in combat (1 = AI) */
    /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    if (c->b[0xEC] <= 0x7F || c->b[0xEC] == 0xB3) {
        c->b[0xEC] = 0xB3; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    } else {
        c->b[0xEC] = 0xB2; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    }
    c->block_192->target = NULL;
    a = combatant_x(*cp);
    b = combatant_y(*cp);
    find_in_area((s16)a, (s16)b, 0xFF, 0xFF,
                 combatant_size(*cp), g_combat_area);
    /* $2A42: area list: combatant of the second entry (first after c) */
    (*cp)->block_192->target = g_combatants[H005_B(0x2A42) - 1];
    /* ch+$199: side in combat (0 party, 1 opponents) */
    (*cp)->b[0x199] = xor_byte((*cp)->block_192->target->b[0x199], 1);
}

/*
 * PORT H027+$3160 (effect $4F): "emits an evil stench"; for every surrounding enemy
 * that fails the saving throw and does not have $76: "is affected" and,
 * as in the original, effect $76 goes to whoever emits the stench.
 */
EH(effect_4f)
{
    Character *p;                       /* -$4(a5) */
    CokEffect *e;                       /* -$8(a5) */
    u16 j;                              /* -$A(a5) */
    u16 a;
    u16 b;

    (void)obj; (void)flag;
    show_char_message(*cp, 0x14, "emits an evil stench", 0x0A, 0);
    a = combatant_x(*cp);
    b = combatant_y(*cp);
    find_in_area((s16)a, (s16)b, 1, 0xFF, combatant_size(*cp), g_combat_area);
    /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    for (j = 2; j <= H005_B(0x2479); ++j) {
        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
        p = g_combatants[H005_B(0x2A3E + (j - 1) * 4) - 1];
        /* ch+$199: side in combat (0 party, 1 opponents) */
        if (p->b[0x199] == (*cp)->b[0x199] || saving_throw_roll(p, 4, 0) ||
            find_effect(p, 0x76, &e)) {
            continue;
        }
        show_effect_message(p, 1, 0x0B, "is affected");
        add_effect(*cp, 0x76, 0, 0xFF, 0);
    }
}

/*
 * PORT H027+$3636 (effect $52, fear aura): the characters of the other
 * side without $5C/$6F/$77: up to 3 hit dice (+$DB) "is terrified" ($6F) and
 * flee, beyond that "is afraid" ($77) if they fail the saving throw.
 */
EH(effect_52)
{
    CokEffect *e = NULL;                /* -$8(a5) */
    Character *p;                       /* -$4(a5) */

    (void)obj; (void)flag;
    for (p = g_party_head; p != NULL; p = p->next) {
        /* ch+$199: side in combat (0 party, 1 opponents) */
        if (p->b[0x199] == (*cp)->b[0x199] || find_effect(p, 0x5C, &e) ||
            find_effect(p, 0x6F, &e) || find_effect(p, 0x77, &e)) {
            continue;
        }
        if (p->b[0xDB] <= 3) { /* ch+$DB: highest level among the classes (also used as hit dice) */
            apply_spell_effect_on(p, 0x6F, 0, 0xFF, 1, 1, 0, 0x0C,
                                  "is terrified");
            if (find_effect(p, 0x6F, &e)) {
                make_flee(p);
            }
        } else if (!saving_throw_roll(p, 4, 0)) {
            apply_spell_effect_on(p, 0x77, 0, 0xFF, 1, 1, 0, 9, "is afraid");
        }
    }
}

/*
 * PORT H027+$3982 (effect $5E): with $2A13 = 0, 2 or 4 adds to $2476 a
 * constitution bonus (+$19): 4-6 +1, 7-10 +2, 11-13 +3, 14-17 +4,
 * 18-20 +5.  Outside the table the original adds an uninitialised byte:
 * here 0.
 */
EH(effect_5e)
{
    u8 bonus = 0;                       /* -$1(a5) */
    u8 con;

    (void)obj; (void)flag;
    /* $2A13: type of the saving throw in progress (index into +$D4), for the effects */
    if (H005_B(0x2A13) != 4 && H005_B(0x2A13) != 2 && H005_B(0x2A13) != 0) {
        return;
    }
    con = (*cp)->b[0x19]; /* ch+$19: current constitution */
    if (con >= 4 && con <= 6) {
        bonus = 1;
    } else if (con >= 7 && con <= 10) {
        bonus = 2;
    } else if (con >= 11 && con <= 13) {
        bonus = 3;
    } else if (con >= 14 && con <= 17) {
        bonus = 4;
    } else if (con >= 18 && con <= 20) {
        bonus = 5;
    }
    /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
    H005_B(0x2476) = (u8)(H005_B(0x2476) + bonus);
}

/*
 * PORT H027+$4276: installs the handlers of the H027 effects into the table
 * H005+$2832 (the other entries are written by H033+$1A50).
 */
void install_effect_handlers(void)
{
    g_handlers_2832[0] = (CokHandler)effect_01;   /* $2832 */
    g_handlers_2832[1] = (CokHandler)effect_02;   /* $2836 */
    g_handlers_2832[2] = (CokHandler)effect_03;   /* $283A */
    g_handlers_2832[4] = (CokHandler)effect_none;   /* $2842 */
    g_handlers_2832[6] = (CokHandler)effect_07;   /* $284A */
    g_handlers_2832[7] = (CokHandler)effect_08;   /* $284E */
    g_handlers_2832[8] = (CokHandler)effect_09;   /* $2852 */
    g_handlers_2832[9] = (CokHandler)effect_0a;   /* $2856 */
    g_handlers_2832[10] = (CokHandler)effect_0b;   /* $285A */
    g_handlers_2832[11] = (CokHandler)effect_nothing;   /* $285E */
    g_handlers_2832[12] = (CokHandler)effect_0d;   /* $2862 */
    g_handlers_2832[13] = (CokHandler)effect_nothing;   /* $2866 */
    g_handlers_2832[14] = (CokHandler)effect_0f;   /* $286A */
    g_handlers_2832[15] = (CokHandler)effect_nothing;   /* $286E */
    g_handlers_2832[16] = (CokHandler)effect_11;   /* $2872 */
    g_handlers_2832[17] = (CokHandler)effect_12;   /* $2876 */
    g_handlers_2832[18] = (CokHandler)effect_none;   /* $287A */
    g_handlers_2832[19] = (CokHandler)effect_14;   /* $287E */
    g_handlers_2832[20] = (CokHandler)effect_15;   /* $2882 */
    g_handlers_2832[21] = (CokHandler)effect_16;   /* $2886 */
    g_handlers_2832[22] = (CokHandler)effect_17;   /* $288A */
    g_handlers_2832[23] = (CokHandler)effect_none;   /* $288E */
    g_handlers_2832[24] = (CokHandler)effect_19;   /* $2892 */
    g_handlers_2832[25] = (CokHandler)effect_1a;   /* $2896 */
    g_handlers_2832[26] = (CokHandler)effect_end_turn;   /* $289A */
    g_handlers_2832[27] = (CokHandler)effect_1c;   /* $289E */
    g_handlers_2832[28] = (CokHandler)effect_1d;   /* $28A2 */
    g_handlers_2832[29] = (CokHandler)effect_1e;   /* $28A6 */
    g_handlers_2832[30] = (CokHandler)effect_end_turn;   /* $28AA */
    g_handlers_2832[31] = (CokHandler)effect_20;   /* $28AE */
    g_handlers_2832[32] = (CokHandler)effect_21;   /* $28B2 */
    g_handlers_2832[33] = (CokHandler)effect_22;   /* $28B6 */
    g_handlers_2832[34] = (CokHandler)effect_23;   /* $28BA */
    g_handlers_2832[35] = (CokHandler)effect_24;   /* $28BE */
    g_handlers_2832[36] = (CokHandler)effect_25;   /* $28C2 */
    g_handlers_2832[37] = (CokHandler)effect_nothing;   /* $28C6 */
    g_handlers_2832[38] = (CokHandler)effect_27;   /* $28CA */
    g_handlers_2832[39] = (CokHandler)effect_28;   /* $28CE */
    g_handlers_2832[40] = (CokHandler)effect_29;   /* $28D2 */
    g_handlers_2832[41] = (CokHandler)effect_2a;   /* $28D6 */
    g_handlers_2832[42] = (CokHandler)effect_2b;   /* $28DA */
    g_handlers_2832[43] = (CokHandler)effect_2c;   /* $28DE */
    g_handlers_2832[44] = (CokHandler)effect_08;   /* $28E2 */
    g_handlers_2832[45] = (CokHandler)effect_09;   /* $28E6 */
    g_handlers_2832[46] = (CokHandler)effect_2f;   /* $28EA */
    g_handlers_2832[47] = (CokHandler)effect_30;   /* $28EE */
    g_handlers_2832[48] = (CokHandler)effect_31;   /* $28F2 */
    g_handlers_2832[49] = (CokHandler)effect_32;   /* $28F6 */
    g_handlers_2832[50] = (CokHandler)effect_end_turn;   /* $28FA */
    g_handlers_2832[51] = (CokHandler)effect_end_turn;   /* $28FE */
    g_handlers_2832[52] = (CokHandler)effect_end_turn;   /* $2902 */
    g_handlers_2832[53] = (CokHandler)effect_36;   /* $2906 */
    g_handlers_2832[54] = (CokHandler)effect_nothing;   /* $290A */
    g_handlers_2832[55] = (CokHandler)effect_38;   /* $290E */
    g_handlers_2832[56] = (CokHandler)effect_39;   /* $2912 */
    g_handlers_2832[57] = (CokHandler)effect_3a;   /* $2916 */
    g_handlers_2832[58] = (CokHandler)effect_3b;   /* $291A */
    g_handlers_2832[59] = (CokHandler)effect_3c;   /* $291E */
    g_handlers_2832[60] = (CokHandler)effect_3d;   /* $2922 */
    g_handlers_2832[61] = (CokHandler)effect_3e;   /* $2926 */
    g_handlers_2832[62] = (CokHandler)effect_3f;   /* $292A */
    g_handlers_2832[63] = (CokHandler)effect_40;   /* $292E */
    g_handlers_2832[64] = (CokHandler)effect_41;   /* $2932 */
    g_handlers_2832[65] = (CokHandler)effect_42;   /* $2936 */
    g_handlers_2832[66] = (CokHandler)effect_43;   /* $293A */
    g_handlers_2832[67] = (CokHandler)effect_44;   /* $293E */
    g_handlers_2832[68] = (CokHandler)effect_45;   /* $2942 */
    g_handlers_2832[69] = (CokHandler)effect_46;   /* $2946 */
    g_handlers_2832[70] = (CokHandler)effect_47;   /* $294A */
    g_handlers_2832[71] = (CokHandler)effect_48;   /* $294E */
    g_handlers_2832[72] = (CokHandler)effect_49;   /* $2952 */
    g_handlers_2832[73] = (CokHandler)effect_4a;   /* $2956 */
    g_handlers_2832[74] = (CokHandler)effect_nothing;   /* $295A */
    g_handlers_2832[75] = (CokHandler)effect_4c;   /* $295E */
    g_handlers_2832[76] = (CokHandler)effect_4d;   /* $2962 */
    g_handlers_2832[78] = (CokHandler)effect_4f;   /* $296A */
    g_handlers_2832[79] = (CokHandler)effect_50;   /* $296E */
    g_handlers_2832[80] = (CokHandler)effect_51;   /* $2972 */
    g_handlers_2832[81] = (CokHandler)effect_52;   /* $2976 */
    g_handlers_2832[85] = (CokHandler)effect_56;   /* $2986 */
    g_handlers_2832[86] = (CokHandler)effect_57;   /* $298A */
    g_handlers_2832[87] = (CokHandler)effect_58;   /* $298E */
    g_handlers_2832[88] = (CokHandler)effect_59;   /* $2992 */
    g_handlers_2832[90] = (CokHandler)effect_nothing;   /* $299A */
    g_handlers_2832[91] = (CokHandler)effect_none;   /* $299E */
    g_handlers_2832[92] = (CokHandler)effect_5d;   /* $29A2 */
    g_handlers_2832[93] = (CokHandler)effect_5e;   /* $29A6 */
    g_handlers_2832[94] = (CokHandler)effect_5f;   /* $29AA */
    g_handlers_2832[95] = (CokHandler)effect_60;   /* $29AE */
    g_handlers_2832[96] = (CokHandler)effect_61;   /* $29B2 */
    g_handlers_2832[97] = (CokHandler)effect_62;   /* $29B6 */
    g_handlers_2832[98] = (CokHandler)effect_63;   /* $29BA */
    g_handlers_2832[99] = (CokHandler)effect_64;   /* $29BE */
    g_handlers_2832[100] = (CokHandler)effect_65;   /* $29C2 */
    g_handlers_2832[101] = (CokHandler)effect_nothing;   /* $29C6 */
    g_handlers_2832[102] = (CokHandler)effect_66;   /* $29CA */
    g_handlers_2832[104] = (CokHandler)effect_69;   /* $29D2 */
    g_handlers_2832[105] = (CokHandler)effect_6a;   /* $29D6 */
    g_handlers_2832[106] = (CokHandler)effect_6b;   /* $29DA */
    g_handlers_2832[107] = (CokHandler)effect_6c;   /* $29DE */
    g_handlers_2832[108] = (CokHandler)effect_nothing;   /* $29E2 */
    g_handlers_2832[109] = (CokHandler)effect_6e;   /* $29E6 */
    g_handlers_2832[110] = (CokHandler)effect_6f;   /* $29EA */
    g_handlers_2832[111] = (CokHandler)effect_70;   /* $29EE */
    g_handlers_2832[112] = (CokHandler)effect_nothing;   /* $29F2 */
    g_handlers_2832[113] = (CokHandler)effect_72;   /* $29F6 */
    g_handlers_2832[114] = (CokHandler)effect_73;   /* $29FA */
    g_handlers_2832[115] = (CokHandler)effect_nothing;   /* $29FE */
    g_handlers_2832[116] = (CokHandler)effect_75;   /* $2A02 */
    g_handlers_2832[117] = (CokHandler)effect_76;   /* $2A06 */
    g_handlers_2832[118] = (CokHandler)effect_77;   /* $2A0A */
    g_handlers_2832[119] = (CokHandler)effect_item;   /* $2A0E */
}
