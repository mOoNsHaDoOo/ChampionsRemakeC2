/* H096: combat actions, attacks, aiming and calculations. */
#include <string.h>
#include "h096.h"
#include "globals.h"
#include "unported.h"
#include "h003_exec.h"
#include "h008.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h033.h"
#include "h045.h"
#include "h048.h"
#include "h059.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include "h073.h"
#include "h077.h"

/* Static functions used before their definition. */
u16 movement_points(Character *c);
u8 can_attack(Character *a, Character *t);
static u8 is_backstab(Character *a, Character *t);
static void attack_damage(Character *a, Character *d, u16 k);
static void range_penalty(Character *a, Character *t, s16 *ac);
static void missile_attack(Character *a, Character *t, CokItem *item);
u16 enemy_distance_points(Character *c);
u8 find_heal_target(Character *c, Character **out);
u8 ai_pick_target(Character *c, u16 radius, u8 b_any, u8 b0);

/* PORT H096+$01F2: link/unlk, no effect. */
void h096_init(void)
{
}

/*
 * PORT H096+$37C2: remaining strength of the enemies (side 1): hit points of the
 * living over the maximum total, in H005+$2481 as (living * 20 / total) * 5.
 */
void enemy_strength(void)
{
    u16 total = 0;                      /* -$2(a5) */
    u16 alive = 0;                      /* -$4(a5) */
    Character *p;                       /* -$8(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0x199] == 1) { /* ch+$199: side in combat (0 party, 1 opponents) */
            if (p->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
                alive = (u16)(alive + p->b[0x1A8]); /* ch+$1A8: current hit points */
            }
            total = (u16)(total + p->b[0x64]); /* ch+$64: maximum hit points */
        }
    }
    if (total > 0) {
        /* $2481: enemy strength in % (live/max HP, steps of 5) for fleeing */
        H005_B(0x2481) = (u8)((u16)((u32)alive * 0x14 / total) * 5);
    }
}

#define TURN(c)         ((c)->block_192)
#define TURN_W(c, o)    COK_GET16(TURN(c)->b + (o))
#define TURN_PUTW(c, o, v) COK_PUT16(TURN(c)->b + (o), (v))
#define NEAR(i)         H005_B(0x2444 + (i) - 1)     /* list of H063+$2BDE */
#define COMBATANT(n)    g_combatants[(n) - 1]
/* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
#define POS_X(n)        H005_W(0x3154 + ((n) - 1) * 6)
/* $3156: combatant positions +2: row on the map (word) */
#define POS_Y(n)        H005_W(0x3154 + ((n) - 1) * 6 + 2)
/* $3159: combatant positions +5: shape/size (0 = off the map) */
#define POS_SIZE(n)     H005_B(0x3154 + ((n) - 1) * 6 + 5)
#define DX(d)           ((s16)H005_W(0x3EE2 + (d) * 2))  /* $3EE2: (word) x offset for direction d (step 2) */
#define DY(d)           ((s16)H005_W(0x3ED0 + (d) * 2))  /* $3ED0: (word) y offset for direction d (step 2) */
#define AREA_X0         ((s16)COK_GET16(g_combat_area + 2))
#define AREA_Y0         ((s16)COK_GET16(g_combat_area + 4))

/* PORT H096+$0200: half rounded according to bit 0 of the round ($247C). */
static u16 half_round(u16 v)
{
    u16 r = v;                          /* -$2(a5) */

    if (H005_B(0x247C) & 1) { /* $247C: combat round number (0 at the start; bit 0 rounds) */
        ++r;
    }
    return (u16)(r >> 1);
}

/*
 * PORT H096+$023E: movement of the turn: speed (+$1A9, for the party
 * plus the bonus $3E00+$6E4), outside 1..$60 it counts as 1; double that goes
 * through event $12 (which can change it in $2472) and is returned.
 */
u16 movement_points(Character *c)
{
    u16 v;                              /* -$2(a5) */

    v = c->b[0x1A9]; /* ch+$1A9: current movement (armour and encumbrance) */
    if (!c->b[0x199]) { /* ch+$199: side in combat (0 party, 1 opponents) */
        /* B+$6E4: (word) movement bonus of the party in combat */
        v = (u16)(v + COK_GET16(g_state_b + 0x6E4));
    }
    H005_B(0x24AC) = 1; /* $24AC: 1 while event $12 computes the movement (0: attacks) */
    if (v < 1 || v > 0x60) {
        v = 1;
    }
    H005_B(0x2472) = (u8)(v * 2); /* $2472: working value of the events: speed or attacks of the round */
    trigger_event(&c, 0x12);
    H005_B(0x24AC) = 0; /* $24AC: 1 while event $12 computes the movement (0: attacks) */
    return H005_B(0x2472); /* $2472: working value of the events: speed or attacks of the round */
}

/*
 * PORT H096+$02CE: prepares the turn of the combatant: turn block
 * partly cleared, attacks (H096+$11D4) and half attacks (+$19F),
 * initiative (d6 + dexterity, -6 if the side is surprised, 0 outside
 * 0..20; 0 for those down) and movement points.
 */
void combat_prepare_turn(Character *c)
{
    CokTurn *t;                         /* a3 */
    u16 blocker;                        /* -$4(a5) */
    u8 in_cloud;                        /* -$5(a5) */
    u8 in_acid;                         /* -$6(a5) */
    s16 v;

    t = TURN(c);
    t->b[0] = 0; /* turn+$0: spell being prepared, cast at the start of the turn */
    probe_move(c, 8, &blocker, &blocker, &in_cloud, &in_acid);
    /* turn+$1: can cast spells flag (not in a cloud; cleared when attacking) */
    t->b[1] = (u8)(in_cloud == 0);
    t->b[2] = 1; /* turn+$2: can use items flag (cleared by coughing in the cloud) */
    t->b[0x0A] = 0; /* turn+$A: has already attacked in the round flag */
    t->b[6] = 2; /* turn+$6: current attack (1..2, index into CH +$19E/+$19F) */
    combat_attacks(c);
    /* $2472: working value of the events: speed or attacks of the round; ch+$111: attacks every 2
     * rounds of attack 2; base -1 of the dice +$112.. */
    H005_B(0x2472) = c->b[0x111];
    H005_B(0x24AC) = 0; /* $24AC: 1 while event $12 computes the movement (0: attacks) */
    trigger_event(&c, 0x12);
    /* ch+$19F: attacks of the round, attack 2; base -1 of the dice +$1A0..; $2472: working value
     * of the events: speed or attacks of the round */
    c->b[0x19F] = (u8)half_round(H005_B(0x2472));
    /* turn+$7: sweep attacks available (from CH +$D2); ch+$D2: fighting level (max
     * +$100/+$105/+$102, or 1): sweeps */
    t->b[7] = c->b[0xD2];
    if (c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        v = (s16)(roll_dice(1, 6) + dex_missile_adj(c));
        if (v < 1) {
            v = 1;
        }
        /* B+$596: (word) mask of the surprised sides: bit side+1 removes 6 from the initiative */
        if (mask_byte((u8)COK_GET16(g_state_b + 0x596),
                      (u16)(c->b[0x199] + 1))) { /* ch+$199: side in combat (0 party, 1 opponents) */
            v = (s16)(v - 6);
        }
        if (v < 0 || v > 0x14) {
            v = 0;
        }
        /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
        COK_PUT16(t->b + 4, (u16)v);
    } else {
        COK_PUT16(t->b + 4, 0); /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
    }
    TURN(c)->b[8] = (u8)movement_points(c); /* turn+$8: movement points left in the turn */
}

/*
 * PORT H096+$0434: damage of attack k (1 or 2) of a on d: dice
 * (+$1A0/+$1A2) plus the bonus (+$1A4) in $2474, events 4 and 5; on a
 * backstab (H096+$3358) multiplied by 2 + (thief
 * level - 1) / 4.
 */
static void attack_damage(Character *a, Character *d, u16 k)
{
    u16 v;

    /* ch+$19F: attacks of the round, attack 2; base -1 of the dice +$1A0..; ch+$1A1: number
     * of dice of attack 2; base -1 of the sides +$1A2.. */
    v = (u16)(roll_damage_dice(a->b[0x1A0 + k - 1], a->b[0x1A2 + k - 1]) +
              CH_W(a, 0x1A4 + (k - 1) * 2)); /* ch+$1A4: damage bonus, 2 words (attack 1 and 2) */
    H005_B(0x2474) = (u8)v; /* $2474: incoming damage points, changeable by the effect handlers */
    trigger_event(&a, 4);
    trigger_event(&d, 5);
    if (is_backstab(a, d)) {
        /* ch+$104: thief level; ch+$10C: previous thief level */
        v = (u16)(a->b[0x104] + a->b[0x10C] * h073_130a(a));
        v = (u16)(((u16)(v - 1) >> 2) + 2);
        /* $2474: incoming damage points, changeable by the effect handlers */
        H005_B(0x2474) = (u8)(H005_B(0x2474) * v);
    }
    H005_B(0x2473) = 0; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
}

/*
 * PORT H096+$0530: attack message: "Attacks" ("-Backstabs-" for
 * kind 2, "slays helpless" for 3) with the name of the target, then "Hitting
 * for n point(s) of damage" (applying dmg_applied) or "and Misses"; if
 * the target loses a spell or falls, the related messages.
 */
static void attack_message(Character *a, Character *t, u16 kind,
                           u16 dmg_applied, u16 dmg, u8 hit)
{
    char text[0x52];                    /* -$54(a5) */
    u16 row;                            /* -$2(a5) */

    switch (kind) {
    case 2: strcpy(text, "-Backstabs-"); break;
    case 3: strcpy(text, "slays helpless"); break;
    default: strcpy(text, "Attacks"); break;
    }
    show_char_message(a, 0x50, text, 0x0A, 0);
    row = 0x0C;
    draw_character_name(t, 0x17, row, 0);
    ++row;
    if (kind == 1) {
        strcpy(text, "(from behind) ");
    } else {
        text[0] = '\0';
    }
    if (hit) {
        if (kind == 3) {
            strcpy(text, "with one cruel blow");
        } else {
            h026_append(0x50, text, 0x0C, "Hitting for ");
            /* $3C82: generic 80-character text buffer (TEXT_BUF) */
            format_number(0x50, (char *)&g_h005[0x3C82], (s32)dmg, 0, 0x0A,
                          3, ' ');
            /* $3C82: generic 80-character text buffer (TEXT_BUF) */
            trim_leading_spaces(0x50, (char *)&g_h005[0x3C82]);
            /* $3C82: generic 80-character text buffer (TEXT_BUF) */
            h026_append(0x50, text, 0x50, (const char *)&g_h005[0x3C82]);
            if (dmg == 1) {
                h026_append(0x50, text, 7, " point ");
            } else {
                h026_append(0x50, text, 8, " points ");
            }
            h026_append(0x50, text, 9, "of damage");
        }
        damage_hit_points(t, dmg_applied);
    } else {
        h026_append(0x50, text, 0x0A, "and Misses");
    }
    if (t->b[0x197] != 8) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        word_wrap_text(0x17, row, 0x26, (u16)(row + 3), 0x0A, 0, 1, 0x50,
                       text);
    }
    row = (u16)(H005_W(0x334C) + 1); /* $334C: (word) text cursor: row */
    if (dmg_applied > 0) {
        TURN(t)->b[1] = 0; /* turn+$1: can cast spells flag (not in a cloud; cleared when attacking) */
        if (TURN(t)->b[0] > 0) { /* turn+$0: spell being prepared, cast at the start of the turn */
            message_delay();
            show_char_message(t, 0x0C, "lost a spell", 0x0C, 1);
            /* turn+$0: spell being prepared, cast at the start of the turn */
            forget_spell(t, TURN(t)->b[0]);
            (void)end_combat_turn(t);
        } else {
            message_delay();
        }
    } else {
        message_delay();
    }
    if (!t->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        show_char_message(t, 9, "goes down", row, 0);
        row = (u16)(row + 2);
        if (t->b[0x197] == 5) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            ui_draw_text(0x17, row, 0x0A, 0, 0x0C, "and is Dying");
        }
        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        if (t->b[0x197] == 6 || t->b[0x197] == 8 || t->b[0x197] == 7) {
            show_char_message(t, 9, "is killed", row, 0);
        }
        row = (u16)(row + 2);
        drop_effects(t);
        trigger_event(&t, 0x0D);
        /* ch+$198: active/standing (0 down or out of the combat); ch+$197: status: 0 ok, 4
         * unconscious, 5 dying, 6-8 dead, $0A down */
        if (!t->b[0x198] && t->b[0x197] != 0x0A) {
            combatant_falls(t);
        } else {
            message_delay();
        }
    }
    clear_message_area();
}

/*
 * PORT H096+$08B2: whoever moves next to enemies ready to attack
 * (+$9 of the turn) and not helpless takes their attack.
 */
static void opportunity_attacks(Character *c)
{
    u16 n;                              /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    Character *e;                       /* -$8(a5) */
    u8 done;                            /* -$9(a5) */

    n = count_enemies_near(c, 1);
    for (i = 1; i <= n; ++i) {
        if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
            continue;
        }
        e = COMBATANT(NEAR(i)); /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
        /* turn+$9: on guard flag (Guard), attacks whoever comes close */
        if (TURN(e)->b[9] && !is_helpless(e)) {
            center_view((s16)combatant_x(c), (s16)combatant_y(c), 2, 8);
            TURN(e)->b[9] = 0; /* turn+$9: on guard flag (Guard), attacks whoever comes close */
            record_attack(e, c);
            combat_attack(e, c, 0, NULL, &done);
        }
    }
}

/*
 * PORT H096+$099C: one step of the combatant in direction dir: terrain
 * cost (x3 diagonally, x2 otherwise) from the movement points,
 * move with redraw and centred view, sound and attacks of whoever
 * stays adjacent (H096+$08B2).
 */
void combat_step(Character *c, u16 dir)
{
    u16 n;                              /* -$4(a5) */
    s16 x0;                             /* -$A(a5) */
    s16 y0;                             /* -$C(a5) */
    s16 nx;                             /* -$6(a5) */
    s16 ny;                             /* -$8(a5) */
    u16 cost;                           /* -$2(a5) */
    u8 top;

    n = combatant_index(c);
    x0 = (s16)POS_X(n); /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
    y0 = (s16)POS_Y(n); /* $3156: combatant positions +2: row on the map (word) */
    nx = (s16)(x0 + DX(dir)); /* $3EE2: (word) x offset for direction d (step 2) */
    ny = (s16)(y0 + DY(dir)); /* $3ED0: (word) y offset for direction d (step 2) */
    top = g_combat_area[0x0A + (s32)ny * 0x64 + nx * 2 + 1];
    if (dir & 1) {
        /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
        cost = (u16)(H005_B(0x3EF4 + (top - 1) * 4) * 3);
    } else {
        /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
        cost = (u16)(H005_B(0x3EF4 + (top - 1) * 4) * 2);
    }
    if (cost > TURN(c)->b[8]) { /* turn+$8: movement points left in the turn */
        TURN(c)->b[8] = 0; /* turn+$8: movement points left in the turn */
    } else {
        add_to_byte(&TURN(c)->b[8], (u16)(0 - cost)); /* turn+$8: movement points left in the turn */
    }
    cost = 2;
    if (c->b[0x19A]) { /* ch+$19A: automatic control in combat (1 = AI) */
        cost = 3;
        if (!in_view((s16)(nx - AREA_X0), (s16)(ny - AREA_Y0)) &&
            H005_B(0x24C6)) { /* $24C6: 1 if the combatant's actions must be drawn (visible) */
            center_view(x0, y0, 2, 8);
        }
    }
    if (H005_B(0x24C6)) { /* $24C6: 1 if the combatant's actions must be drawn (visible) */
        begin_screen_update();
        redraw_ground(0, 0, n);
    }
    /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
    H005_SET_W(0x3154 + (n - 1) * 6, (u16)nx);
    /* $3156: combatant positions +2: row on the map (word) */
    H005_SET_W(0x3154 + (n - 1) * 6 + 2, (u16)ny);
    rebuild_occupancy();
    if (H005_B(0x24C6)) { /* $24C6: 1 if the combatant's actions must be drawn (visible) */
        center_view(nx, ny, cost, 8);
        end_screen_update();
    }
    TURN(c)->b[0x11] = 0; /* turn+$11: attacks received in the round */
    TURN(c)->b[0x14] = 0; /* turn+$14: sum (mod 8) of the off-facing eighths of the attacks */
    if (POS_SIZE(n) == 1) { /* $3159: combatant positions +5: shape/size (0 = off the map) */
        h043_190e(0x11);
    } else {
        h043_190e(0x12);
    }
    opportunity_attacks(c);
    if (!c->b[0x198] || is_helpless(c)) { /* ch+$198: active/standing (0 down or out of the combat) */
        TURN(c)->b[8] = 0; /* turn+$8: movement points left in the turn */
    }
}

/*
 * PORT H096+$0C3C: before moving in dir, the adjacent enemies that will no
 * longer be adjacent (not helpless, without +$12 of the turn, that can
 * attack and do not have only ranged weapons) attack if the
 * combatant is behind them or in one of the directions +6..+10 from
 * their facing (+$B), with the best weapon.
 */
void combat_leave_attacks(Character *c, u16 dir)
{
    u16 list[0x0C];                     /* -$18(a5) */
    u16 n;                              /* -$20(a5) */
    u16 cnt;                            /* -$24(a5) */
    u16 cnt2;                           /* -$26(a5) */
    u16 i;                              /* -$2A(a5) */
    u16 j;                              /* -$28(a5) */
    u16 d;                              /* -$30(a5) */
    u16 k;                              /* -$2E(a5) */
    u16 s;                              /* -$2C(a5) */
    u8 found;                           /* -$1D(a5) */
    u8 done;                            /* -$1E(a5) */
    u8 party_flag = 0;                  /* -$39(a5): never read */
    Character *e;                       /* -$34(a5) */
    Character *saved;                   /* -$38(a5) */

    h029_fill_bytes(0x17, (u8 *)list, 0x18, 0);
    n = combatant_index(c);
    cnt = count_enemies_near(c, 1);
    if (cnt == 0) {
        return;
    }
    i = 1;
    for (j = 1; j <= cnt; ++j) {
        e = COMBATANT(NEAR(j)); /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
        /* turn+$12: forced to flee flag (fear, confusion) */
        if (!is_helpless(e) && !TURN(e)->b[0x12]) {
            list[i - 1] = NEAR(j); /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
            ++i;
        }
    }
    cnt = (u16)(i - 1);
    /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word); $3EE2: (word)
     * x offset for direction d (step 2) */
    H005_SET_W(0x3154 + (n - 1) * 6, (u16)(POS_X(n) + DX(dir)));
    /* $3156: combatant positions +2: row on the map (word); $3ED0: (word) y offset for
     * direction d (step 2) */
    H005_SET_W(0x3154 + (n - 1) * 6 + 2, (u16)(POS_Y(n) + DY(dir)));
    cnt2 = count_enemies_near(c, 1);
    /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word); $3EE2: (word)
     * x offset for direction d (step 2) */
    H005_SET_W(0x3154 + (n - 1) * 6, (u16)(POS_X(n) - DX(dir)));
    /* $3156: combatant positions +2: row on the map (word); $3ED0: (word) y offset for
     * direction d (step 2) */
    H005_SET_W(0x3154 + (n - 1) * 6 + 2, (u16)(POS_Y(n) - DY(dir)));
    for (i = 1; i <= cnt; ++i) {
        found = 0;
        for (j = 1; j <= cnt2; ++j) {
            /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
            if (NEAR(j) == list[i - 1]) {
                found = 1;
            }
        }
        if (found) {
            list[i - 1] = 0;
        }
    }
    if (!c->b[0x199]) { /* ch+$199: side in combat (0 party, 1 opponents) */
        for (i = 1; i <= cnt; ++i) {
            /* ch+$198: active/standing (0 down or out of the combat) */
            if (list[i - 1] > 0 && c->b[0x198]) {
                party_flag = 1;
            }
        }
    }
    (void)party_flag;
    for (i = 1; i <= cnt; ++i) {
        /* ch+$198: active/standing (0 down or out of the combat) */
        if (!(list[i - 1] > 0 && c->b[0x198])) {
            continue;
        }
        H005_B(0x24C7) = 1; /* $24C7: 1: combatant panel on the right to be redrawn */
        H005_B(0x24C6) = 1; /* $24C6: 1 if the combatant's actions must be drawn (visible) */
        done = 0;
        e = COMBATANT(list[i - 1]);
        if (!can_attack(e, c)) {
            continue;
        }
        if (has_ranged_weapon(e) && !weapon_melee_ok(e)) {
            continue;
        }
        /* turn+$B: facing/frame of the combatant (direction 0..7) */
        for (d = (u16)(TURN(e)->b[0x0B] + 6);
             /* turn+$B: facing/frame of the combatant (direction 0..7) */
             d <= (u16)(TURN(e)->b[0x0B] + 0x0A); ++d) {
            if (done) {
                continue;
            }
            /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over; turn+$11:
             * attacks received in the round */
            if (!((s16)TURN_W(e, 4) > 0 || TURN(e)->b[0x11] == 0 ||
                  in_direction((s16)combatant_x(e), (s16)combatant_y(e),
                               (s16)combatant_x(c), (s16)combatant_y(c),
                               (u16)(d & 7)))) {
                continue;
            }
            k = 1;
            if (e->b[0x110] == 0) { /* ch+$110: attacks every 2 rounds of attack 1 (2 = 1/round, 3 = 3/2) */
                k = 2;
            }
            for (s = 1; s <= 2; ++s) {
                /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
                if (e->b[0x19E + s - 1] > 0) {
                    k = s;
                }
            }
            /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
            if (e->b[0x19E + k - 1] == 0) {
                /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
                e->b[0x19E + k - 1] = 1;
            }
            TURN(e)->b[6] = (u8)k; /* turn+$6: current attack (1..2, index into CH +$19E/+$19F) */
            saved = TURN(e)->target;
            /* $249F: use: scratch byte for *special and outcomes in the combat menus */
            combat_attack(e, c, 1, NULL, &H005_B(0x249F));
            done = 1;
            TURN(e)->target = saved;
            if (c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
                H005_B(0x24C7) = 1; /* $24C7: 1: combatant panel on the right to be redrawn */
                draw_combat_status(c);
            }
        }
    }
}

/*
 * PORT H096+$10FA: attempt to flee: it succeeds without enemies, if the
 * distance from the enemies (H096+$3852) exceeds half the movement, or on
 * a tie with 1d2 = 1 ("Got Away"); otherwise "Escape is blocked".
 */
u8 combat_flee(Character *c)
{
    u8 fled = 0;                        /* -$1(a5) */
    u16 half;                           /* -$6(a5) */
    u16 v;                              /* -$4(a5) */

    if (count_enemies_near(c, 0xFF) == 0) {
        fled = 1;
    } else {
        half = (u16)(movement_points(c) >> 1);
        v = enemy_distance_points(c);
        if (v < half) {
            fled = 1;
        } else if (v == half && roll_dice(1, 2) == 1) {
            fled = 1;
        }
    }
    if (fled) {
        fall_down(c, 3, 8, "Got Away");
    } else {
        show_message_line(0x11, "Escape is blocked");
    }
    return end_combat_turn(c);
}

/*
 * PORT H096+$11D4: attacks of the round (+$19E): from +$110, or for a ranged
 * weapon the rate of the table $336C (at least 2) limited by the
 * ammunition (+$40); passed through event $12 and halved; with +$A of the
 * turn no more than the previous ones.
 */
void combat_attacks(Character *c)
{
    u8 ranged = 0;                      /* -$9(a5) */
    u16 was;                            /* -$4(a5) */
    u16 rate;                           /* -$8(a5) */
    u16 n;                              /* -$2(a5) */
    u16 k;                              /* -$6(a5) */
    CokItem *w = NULL;                  /* -$E(a5) */

    was = c->b[0x19E]; /* ch+$19E: attacks of the round, attack 1 (2 entries +$19E..+$19F) */
    /* ch+$19E: attacks of the round, attack 1 (2 entries +$19E..+$19F); ch+$110: attacks every 2
     * rounds of attack 1 (2 = 1/round, 3 = 3/2) */
    c->b[0x19E] = c->b[0x110];
    if (has_ranged_weapon(c) && find_weapon(c, &w)) {
        ranged = 1;
        /* $3372: item types +6: attacks per round of the missile weapon; ogg+$30: type
         * of the item (index into the table H005+$336C, $12 bytes per entry) */
        rate = H005_B(0x336C + c->readied[0]->b[0x30] * 0x12 + 6);
        if (rate < 2) {
            rate = 2;
        }
        H005_B(0x2472) = (u8)rate; /* $2472: working value of the events: speed or attacks of the round */
    } else {
        /* $2472: working value of the events: speed or attacks of the round; ch+$19E: attacks of
         * the round, attack 1 (2 entries +$19E..+$19F) */
        H005_B(0x2472) = c->b[0x19E];
    }
    H005_B(0x24AC) = 0; /* $24AC: 1 while event $12 computes the movement (0: attacks) */
    trigger_event(&c, 0x12);
    n = half_round(H005_B(0x2472)); /* $2472: working value of the events: speed or attacks of the round */
    if (ranged && w != NULL) {
        k = 1;
        if (w != NULL && w->b[0x40] > k) { /* item+$40: quantity (identical pieces grouped, max 255) */
            k = w->b[0x40]; /* item+$40: quantity (identical pieces grouped, max 255) */
        }
        if (k < n && w->b[0x40] > 0) { /* item+$40: quantity (identical pieces grouped, max 255) */
            n = k;
        }
    }
    if (TURN(c)->b[0x0A] == 0 || n < was) { /* turn+$A: has already attacked in the round flag */
        c->b[0x19E] = (u8)n; /* ch+$19E: attacks of the round, attack 1 (2 entries +$19E..+$19F) */
    } else {
        c->b[0x19E] = (u8)was; /* ch+$19E: attacks of the round, attack 1 (2 entries +$19E..+$19F) */
    }
}

/*
 * PORT H096+$1340: sweep attack: if the attacker has fewer attacks
 * than +$7 of the turn, the target is adjacent and has no +$DB, and the adjacent
 * enemies without +$DB are more than the attacks, it hits them all (at
 * most +$7), starting from the target ("sweeps").
 */
u8 combat_sweep(Character *a, Character *t)
{
    u8 res = 0;                         /* -$D(a5) */
    u16 cnt;                            /* -$2(a5) */
    u16 m = 0;                          /* -$4(a5) */
    u16 i;                              /* -$6(a5) */
    u16 idx = 0;                        /* -$8(a5) */
    Character *e;                       /* -$C(a5) */

    /* ch+$19E: attacks of the round, attack 1 (2 entries +$19E..+$19F); turn+$7: sweep attacks available
     * (from CH +$D2); ch+$DB: highest level among the classes (also used as hit dice) */
    if (!(a->b[0x19E] < TURN(a)->b[7] && !t->b[0xDB] &&
          combat_distance(a, t) == 1)) {
        return 0;
    }
    cnt = count_enemies_near(a, 1);
    for (i = 1; i <= cnt; ++i) {
        e = COMBATANT(NEAR(i)); /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
        if (e == t) {
            idx = i;
        }
        if (!e->b[0xDB]) { /* ch+$DB: highest level among the classes (also used as hit dice) */
            ++m;
        }
    }
    if (!(m > a->b[0x19E])) { /* ch+$19E: attacks of the round, attack 1 (2 entries +$19E..+$19F) */
        return 0;
    }
    if (m > TURN(a)->b[7]) { /* turn+$7: sweep attacks available (from CH +$D2) */
        m = TURN(a)->b[7]; /* turn+$7: sweep attacks available (from CH +$D2) */
    }
    show_char_message(a, 6, "sweeps", 0x0A, 1);
    /* $2444: list of the nearby enemies (combatant number, 1 byte per entry) */
    e = COMBATANT(H005_B(0x2444));
    if (e != t) {
        /* $2444..: list of the nearby enemies ($2444+i-1, i from 1); $2444: list
         * of the nearby enemies (combatant number, 1 byte per entry) */
        H005_B(0x2444 + idx - 1) = H005_B(0x2444);
        /* $2444: list of the nearby enemies (combatant number, 1 byte per entry) */
        H005_B(0x2444) = (u8)combatant_index(t);
    }
    for (i = 1; i <= cnt; ++i) {
        if (m == 0) {
            continue;
        }
        e = COMBATANT(NEAR(i)); /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
        if (e->b[0xDB]) { /* ch+$DB: highest level among the classes (also used as hit dice) */
            continue;
        }
        record_attack(a, e);
        a->b[0x19E] = 1; /* ch+$19E: attacks of the round, attack 1 (2 entries +$19E..+$19F) */
        /* $249F: use: scratch byte for *special and outcomes in the combat menus */
        combat_attack(a, e, 0, NULL, &H005_B(0x249F));
        --m;
    }
    res = 1;
    return res;
}

/*
 * PORT H096+$1562: can a attack t?  Itself yes, otherwise the
 * events 1 (of t) and 0 (of a, with the provisional target) must not
 * set $24AB.
 */
u8 can_attack(Character *a, Character *t)
{
    Character *saved;                   /* -$4(a5) */

    if (t == NULL) {
        return 0;
    }
    if (a == t) {
        return 1;
    }
    H005_B(0x24AB) = 0; /* $24AB: 1 if an effect handler forbids the attack (H096+$1562) */
    trigger_event(&t, 1);
    if (!H005_B(0x24AB)) { /* $24AB: 1 if an effect handler forbids the attack (H096+$1562) */
        saved = TURN(a)->target;
        TURN(a)->target = t;
        trigger_event(&a, 0);
        TURN(a)->target = saved;
    }
    return (u8)(H005_B(0x24AB) == 0); /* $24AB: 1 if an effect handler forbids the attack (H096+$1562) */
}

/*
 * Turn Undead table (local of H096+$160A, $9C words initialised to
 * $6363): row = undead type (+$DF) - 1, column = level of the
 * cleric - 1, 13 columns.  Positive: minimum d20 roll to turn it;
 * 0 or negative: destroyed.  The anomalies (an entry written twice, $47,
 * entries left at $6363) are those of the original.
 */
static const u16 s_turn_table[0x9C] = {
    0x000A, 0x0007, 0x0004, 0x0001, 0x0001, 0x0000, 0x0000, 0xFFFF,
    0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0x000D, 0x000A, 0x0007,
    0x0001, 0x0001, 0x0000, 0x0000, 0x0000, 0xFFFF, 0xFFFF, 0xFFFF,
    0xFFFF, 0xFFFF, 0x0010, 0x000D, 0x000A, 0x0004, 0x0001, 0x0001,
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0013,
    0x0010, 0x000D, 0x0007, 0x0004, 0x0001, 0x0001, 0x0000, 0x0000,
    0x0000, 0x0000, 0x0000, 0x0000, 0x0014, 0x0013, 0x0010, 0x000A,
    0x0007, 0x0004, 0x0001, 0x0001, 0x0000, 0x0000, 0x0000, 0x0000,
    0x0000, 0x6363, 0x0014, 0x0013, 0x000D, 0x000A, 0x0007, 0x0004,
    0x0001, 0x0001, 0x0001, 0x0001, 0x0001, 0x0001, 0x6363, 0x6363,
    0x0014, 0x0010, 0x000D, 0x000A, 0x0007, 0x0004, 0x0001, 0x0001,
    0x0001, 0x0001, 0x0001, 0x0010, 0x6363, 0x6363, 0x000D, 0x000A,
    0x0047, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004, 0x0004,
    0x6363, 0x6363, 0x6363, 0x6363, 0x0014, 0x0010, 0x000D, 0x000A,
    0x0007, 0x0007, 0x0007, 0x0007, 0x0007, 0x6363, 0x6363, 0x6363,
    0x6363, 0x6363, 0x0014, 0x0010, 0x000D, 0x000A, 0x000A, 0x000A,
    0x000A, 0x000A, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363,
    0x0014, 0x0010, 0x000D, 0x000A, 0x000A, 0x000A, 0x000A, 0x6363,
    0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363, 0x6363,
    0x6363, 0x6363, 0x6363, 0x6363,
};

/*
 * PORT H096+$1B04: among the enemies (not fled, +$12 of the turn) the undead
 * of the highest type (+$DF) not beyond *max; *max becomes that type.
 */
u8 find_undead(Character *c, Character **out, u8 *max)
{
    u8 best = 0;                        /* -$5(a5) */
    u8 found = 0;                       /* -$B(a5) */
    u16 cnt;                            /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    Character *e;                       /* -$A(a5) */

    *out = NULL;
    cnt = count_enemies_near(c, 0xFF);
    for (i = 1; i <= cnt; ++i) {
        e = COMBATANT(NEAR(i)); /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
        /* turn+$12: forced to flee flag (fear, confusion); ch+$DF: undead type (0 = no); base -1
         * of the thief skills +$E0..+$E7 */
        if (!TURN(e)->b[0x12] && e->b[0xDF] > 0 && e->b[0xDF] > best &&
            /* ch+$DF: undead type (0 = no); base -1 of the thief skills +$E0..+$E7 */
            e->b[0xDF] <= *max) {
            best = e->b[0xDF]; /* ch+$DF: undead type (0 = no); base -1 of the thief skills +$E0..+$E7 */
            *out = e;
            found = 1;
        }
    }
    *max = best;
    return found;
}

/*
 * PORT H096+$160A (Turn Undead): at most 1d12 undead (6 more if
 * destroyed), from the highest type: with 1d20 at least the table value
 * for the cleric level (+$FE, +2 for +$5E = 2) the undead flees
 * ("is turned") or is destroyed ("Is destroyed"); otherwise the
 * lower type is tried.  An index beyond the table would read the stack: here
 * it is $6363 (never succeeds).
 */
void turn_undead(Character *c)
{
    u8 turned = 0;                      /* -$141(a5) */
    u8 max;                             /* -$148(a5) */
    u16 extra;                          /* -$13E(a5) */
    u16 count;                          /* -$13C(a5) */
    u16 r;                              /* -$13A(a5) */
    u8 level;                           /* -$147(a5) */
    s16 v;                              /* -$140(a5) */
    u16 idx;
    Character *t;                       /* -$146(a5) */

    show_char_message(c, 0x0F, "turns undead...", 0x0A, 0);
    clear_message_line();
    message_delay();
    /* turn+$13: Turn Undead already used in the combat (max H005+$248F) */
    add_to_byte(&TURN(c)->b[0x13], 1);
    max = 0x0D;
    extra = 6;
    count = roll_dice(1, 0x0C);
    r = roll_dice(1, 0x14);
    /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; ch+$106: levels of the
     * previous class, 8 entries like +$FE; cleric */
    level = (u8)(c->b[0xFE] + c->b[0x106] * h073_130a(c));
    if (c->b[0x5E] == 2) { /* ch+$5E: deity of the cleric (0 none, 1..7; 6 for races 3-4) */
        level = (u8)(level + 2);
    }
    while (find_undead(c, &t, &max) && count > 0) {
        /* ch+$DF: undead type (0 = no); base -1 of the thief skills +$E0..+$E7 */
        idx = (u16)((t->b[0xDF] - 1) * 13 + (level - 1));
        v = (s16)(idx < 0x9C ? s_turn_table[idx] : 0x6363);
        if (r >= (u16)(v < 0 ? -v : v)) {
            turned = 1;
            show_combatant_cursor(t, 3, 0);
            H005_B(0x24C7) = 1; /* $24C7: 1: combatant panel on the right to be redrawn */
            draw_combat_status(t);
            if (v > 0) {
                fall_down(t, 3, 9, "is turned");
                h043_190e(0x15);
            } else {
                show_char_message(t, 0x0C, "Is destroyed", 0x0A, 0);
                combatant_falls(t);
                t->b[0x197] = 8; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                t->b[0x198] = 0; /* ch+$198: active/standing (0 down or out of the combat) */
            }
            if (extra > 0) {
                --extra;
            }
            --count;
            if (count == 0 && extra > 0 && v < 0) {
                ++count;
            }
            clear_message_area();
        } else {
            --max;
        }
    }
    if (!turned) {
        show_message_line(0x12, "Nothing Happens...");
    }
    count_sides();
    /* $249F: use: scratch byte for *special and outcomes in the combat menus */
    H005_B(0x249F) = end_combat_turn(c);
    clear_message_area();
}

/*
 * PORT H096+$1BE0: resolves the attacks of a on t.  On a helpless
 * target a fatal blow ("slays helpless").  Otherwise, with a readied
 * weapon against a large target, dice and bonus from the table $336C;
 * armour class (from behind or backstab: +$19D - 4 / +$19C+1),
 * distance (H096+$251C), then for every group of attacks from the current one to the
 * first: roll (H062+$12F6), damage and messages, until the target falls.
 * *done = 1 if no attacks remain (and the turn ends).
 */
static void resolve_attacks(Character *a, Character *t, u8 flag, u8 *done)
{
    u8 behind;                          /* -$15(a5) */
    u8 hit = 0;                         /* -$13(a5) */
    u8 killed = 0;                      /* -$14(a5) */
    u8 rear = 0;                        /* -$1F(a5) */
    u8 wtab[0x12];                      /* -$12(a5) */
    s16 ac;                             /* -$18(a5) */
    u16 kind;                           /* -$1E(a5) */
    u16 k0;                             /* -$1C(a5) */
    s16 k;                              /* -$1A(a5) */

    behind = flag;
    *done = 0;
    H005_B(0x2A18) = 0; /* $2A18: hits of the round with attack 1 (cleared at every attack) */
    H005_B(0x2A19) = 0; /* $2A19: hits of the round with attack 2 */
    H005_B(0x2442) = 0; /* $2442: attacks attempted in the blow, per attack k (byte): +0 first attack */
    H005_B(0x2443) = 0; /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
    H005_B(0x2474) = 0; /* $2474: incoming damage points, changeable by the effect handlers */
    TURN(a)->b[0x0A] = 1; /* turn+$A: has already attacked in the round flag */
    if (is_helpless(t)) {
        h043_190e(0x0E);
        /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E..;
         * turn+$6: current attack (1..2, index into CH +$19E/+$19F) */
        while (a->b[0x19E + TURN(a)->b[6] - 1] == 0) {
            /* turn+$6: current attack (1..2, index into CH +$19E/+$19F) */
            add_to_byte(&TURN(a)->b[6], 0xFFFF);
        }
        /* $2441: use: computed base $2442+k-1 with k>=1; see the counters at +$2442; turn+$6:
         * current attack (1..2, index into CH +$19E/+$19F) */
        add_to_byte(&H005_B(0x2442 + TURN(a)->b[6] - 1), 1);
        attack_message(a, t, 3, (u16)(t->b[0x1A8] + 5), 1, 1); /* ch+$1A8: current hit points */
        remove_effects_19(a);
        a->b[0x19E] = 0; /* ch+$19E: attacks of the round, attack 1 (2 entries +$19E..+$19F) */
        a->b[0x19F] = 0; /* ch+$19F: attacks of the round, attack 2; base -1 of the dice +$1A0.. */
        hit = 1;
        *done = 1;
    } else {
        if (a->readied[0] != NULL &&
            /* ch+$D3: shape/size on the combat map (bits 0-2, >1 large) */
            (t->b[0xD3] > 0x80 || mask_byte(t->b[0xD3], 7) > 1)) {
            /* $336C: item types, $12 bytes per type (+$30): +0 slot/kind; ogg+$30: type of
             * the item (index into the table H005+$336C, $12 bytes per entry) */
            exec_copy_mem(&g_h005[0x336C + a->readied[0]->b[0x30] * 0x12],
                          wtab, 0x12);
            a->b[0x1A0] = wtab[2]; /* ch+$1A0: number of dice of attack 1 (2 entries +$1A0..+$1A1) */
            a->b[0x1A2] = wtab[3]; /* ch+$1A2: sides of the die of attack 1 (2 entries +$1A2..+$1A3) */
            /* ch+$1A4: damage bonus, 2 words (attack 1 and 2) */
            CH_PUTW(a, 0x1A4, (u16)(CH_W(a, 0x1A4) - COK_GET16(wtab + 0x0C) +
                                    COK_GET16(wtab + 4)));
        }
        recompute_stats(t);
        trigger_event(&t, 0x0B);
        if (is_backstab(a, t)) {
            /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
            ac = (s16)(t->b[0x19D] - 4);
        } else {
            if (TURN(t)->b[0x11] > 1 && /* turn+$11: attacks received in the round */
                /* turn+$B: facing/frame of the combatant (direction 0..7) */
                direction_toward(a, t) == TURN(t)->b[0x0B] &&
                /* turn+$14: sum (mod 8) of the off-facing eighths of the attacks */
                TURN(t)->b[0x14] > 4) {
                behind = 1;
            }
            if (behind) {
                rear = 1;
            }
            ac = t->b[0x19C + rear]; /* ch+$19C: encoded current armour class (60 - AC) */
        }
        range_penalty(a, t, &ac);
        kind = 0;
        if (behind) {
            kind = 1;
        }
        if (is_backstab(a, t)) {
            kind = 2;
        }
        k0 = TURN(a)->b[6]; /* turn+$6: current attack (1..2, index into CH +$19E/+$19F) */
        for (k = (s16)k0; k >= 1; --k) {
            /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
            while (a->b[0x19E + k - 1] > 0 && !killed) {
                /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
                add_to_byte(&a->b[0x19E + k - 1], 0xFFFF);
                TURN(a)->b[6] = (u8)k; /* turn+$6: current attack (1..2, index into CH +$19E/+$19F) */
                /* $2441: use: computed base $2442+k-1 with k>=1; see the counters at +$2442 */
                add_to_byte(&H005_B(0x2442 + k - 1), 1);
                if (attack_roll(a, t, (u16)ac) || is_helpless(t)) {
                    /* $2A17: k-1 base of the hits table $2A18 (k = attack 1..2) */
                    add_to_byte(&H005_B(0x2A18 + k - 1), 1);
                    h043_190e(0x0E);
                    hit = 1;
                    attack_damage(a, t, (u16)k);
                    if (t->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
                        /* $2474: incoming damage points, changeable by the effect handlers */
                        attack_message(a, t, kind, H005_B(0x2474),
                                       /* $2474: incoming damage points, changeable by the effect
                                        * handlers */
                                       H005_B(0x2474), 1);
                    }
                    /* ch+$198: active/standing (0 down or out of the combat); $2474: incoming damage
                     * points, changeable by the effect handlers */
                    if (t->b[0x198] && H005_B(0x2474) > 0) {
                        trigger_event(&a, (u16)(k + 1));
                    }
                    if (!t->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
                        killed = 1;
                    }
                    if (!a->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
                        k0 = 0;
                        /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
                        a->b[0x19E + k - 1] = 0;
                    }
                }
                explode_fallen();
            }
        }
        (void)k0;
        if (!hit) {
            h043_190e(0x10);
            attack_message(a, t, kind, 0, 0, 0);
        }
        *done = 1;
        for (k = 1; k <= 2; ++k) {
            /* ch+$19D: AC from behind (without dexterity); base -1 of the attacks +$19E.. */
            if (a->b[0x19E + k - 1] > 0) {
                *done = 0;
            }
        }
        TURN(a)->b[7] = 0; /* turn+$7: sweep attacks available (from CH +$D2) */
    }
    if (!a->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        *done = 1;
    }
    if (*done) {
        *done = end_combat_turn(a);
    }
}

/*
 * PORT H096+$20E6: t takes an attack from a: +$11 of the turn counts the
 * attacks, +$14 accumulates by how much (0..4 eighths of a turn) a is off its
 * facing.
 */
void record_attack(Character *a, Character *t)
{
    u16 dir;                            /* -$4(a5) */
    u16 rel;                            /* -$2(a5) */

    add_to_byte(&TURN(t)->b[0x11], 1); /* turn+$11: attacks received in the round */
    dir = direction_toward(t, a);
    /* turn+$B: facing/frame of the combatant (direction 0..7) */
    rel = (u16)((dir - TURN(t)->b[0x0B] + 8) & 7);
    if (rel > 4) {
        rel = (u16)(8 - rel);
    }
    /* turn+$14: sum (mod 8) of the off-facing eighths of the attacks */
    TURN(t)->b[0x14] = (u8)((TURN(t)->b[0x14] + rel) & 7);
}

/*
 * PORT H096+$2182: a attacks t: facings and figures, target of the
 * turn, shot of the missile weapon (H096+$3492, also for types $1C and
 * $1D); if attacks remain it resolves them (H096+$1BE0) as the current
 * character, uses up the ammunition (+$40 of the weapon, for the attacks
 * made) and an exhausted thrown weapon ends up in the treasure (after the last
 * one thrown, $335C) or disappears.  With the readied weapon missing the original
 * still reads +$30 from address 0: here it is skipped.
 */
void combat_attack(Character *a, Character *t, u8 flag, CokItem *item,
                   u8 *done)
{
    u16 dir = 0;                        /* -$E(a5) */
    Character *saved;                   /* -$C(a5) */
    CokItem *copy;                      /* -$4(a5) */
    CokItem *p;                         /* -$8(a5) */

    H005_B(0x24C6) = 1; /* $24C6: 1 if the combatant's actions must be drawn (visible) */
    H005_B(0x24C7) = 1; /* $24C7: 1: combatant panel on the right to be redrawn */
    /* $2477: limit round of the combat (+$247C + 15); $247C: combat round number (0 at
     * the start; bit 0 rounds) */
    H005_B(0x2477) = (u8)(H005_B(0x247C) + 0x0F);
    if (TURN(t)->b[0x11] < 2 && !flag) { /* turn+$11: attacks received in the round */
        dir = direction_toward(t, a);
        /* turn+$B: facing/frame of the combatant (direction 0..7) */
        TURN(t)->b[0x0B] = (u8)((dir + 4) & 7);
    } else if (combatant_visible(t, 0)) {
        dir = TURN(t)->b[0x0B]; /* turn+$B: facing/frame of the combatant (direction 0..7) */
        if (!flag) {
            /* turn+$B: facing/frame of the combatant (direction 0..7) */
            TURN(t)->b[0x0B] = (u8)((dir + 4) & 7);
        }
    }
    if (combatant_visible(t, 0)) {
        set_combatant_frame(t, (u8)dir, 0, 0);
    }
    dir = direction_toward(a, t);
    draw_combat_status(a);
    set_combatant_frame(a, (u8)dir, 1, 0);
    TURN(a)->target = t;
    if (item != NULL) {
        missile_attack(a, t, item);
    }
    if (a->readied[0] != NULL &&
        /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
        (a->readied[0]->b[0x30] == 0x1C || a->readied[0]->b[0x30] == 0x1D)) {
        missile_attack(a, t, a->readied[0]);
    }
    *done = 1;
    /* ch+$19E: attacks of the round, attack 1 (2 entries +$19E..+$19F); ch+$19F: attacks of the
     * round, attack 2; base -1 of the dice +$1A0.. */
    if (a->b[0x19E] > 0 || a->b[0x19F] > 0) {
        saved = g_current_char;
        g_current_char = a;
        resolve_attacks(a, t, flag, done);
        if (item != NULL && !weapon_is_43(a)) {
            if (item->b[0x40] > 0) { /* item+$40: quantity (identical pieces grouped, max 255) */
                /* item+$40: quantity (identical pieces grouped, max 255); $2442: attacks
                 * attempted in the blow, per attack k (byte): +0 first attack */
                add_to_byte(&item->b[0x40], (u16)(0 - H005_B(0x2442)));
            }
            if (item->b[0x40] == 0) { /* item+$40: quantity (identical pieces grouped, max 255) */
                /* item+$45: spell/parameter of the magic item (bit 7 excluded) */
                if (weapon_melee_ok(a) && item->b[0x45] != 0x17) {
                    copy = (CokItem *)exec_alloc_mem(sizeof(CokItem),
                                                     COK_MEMF_CLEAR);
                    memcpy(copy->b, item->b, 0x48);
                    p = g_treasure_items;
                    if (p == NULL) {
                        g_treasure_items = copy;
                        copy->next = NULL;
                    } else {
                        while (p->next != NULL && p != g_thrown_tail) {
                            p = p->next;
                        }
                        copy->next = p->next;
                        p->next = copy;
                    }
                    copy->b[0x3A] = 0; /* item+$3A: item readied flag (Ready) */
                    delete_item(a, item);
                    g_thrown_tail = copy;
                } else {
                    delete_item(a, item);
                }
            }
        }
        recompute_stats(a);
        g_current_char = saved;
    }
    if (*done) {
        *done = end_combat_turn(a);
    }
    if (combatant_visible(a, 0)) {
        begin_screen_update();
        /* turn+$B: facing/frame of the combatant (direction 0..7) */
        set_combatant_frame(a, TURN(a)->b[0x0B], 1, 1);
        /* turn+$B: facing/frame of the combatant (direction 0..7) */
        set_combatant_frame(a, TURN(a)->b[0x0B], 0, 0);
        end_screen_update();
    }
}

/*
 * PORT H096+$251C: distance penalty: beyond the range of the ranged
 * weapon ((table $336C +$E - 1) / 3, or the distance itself) the armour
 * class rises by 2, and by another 3 beyond twice that.
 */
static void range_penalty(Character *a, Character *t, s16 *ac)
{
    s16 dist;                           /* -$4(a5) */
    s16 r;                              /* -$2(a5) */

    dist = (s16)combat_distance(a, t);
    if (has_ranged_weapon(a)) {
        /* $337A: item types +$E: weapon range (>1 = ranged); ogg+$30: type of the item
         * (index into the table H005+$336C, $12 bytes per entry) */
        r = (s16)((s16)(H005_B(0x336C + a->readied[0]->b[0x30] * 0x12 + 0x0E) -
                        1) / 3);
    } else {
        r = dist;
    }
    if (dist - r > 0) {
        dist = (s16)(dist - r);
        *ac = (s16)(*ac + 2);
    }
    if (dist - r > 0) {
        dist = (s16)(dist - r);
        *ac = (s16)(*ac + 3);
    }
}

/*
 * PORT H096+$25DA: target of a cure near c: the adjacent ally
 * (or itself below half) with fewer hit points, if not at the maximum;
 * with everyone above 7 a fallen body ($2AE2) on a nearby square.
 */
u8 find_heal_target(Character *c, Character **out)
{
    Character *best = NULL;             /* -$4(a5) */
    u16 body = 0;                       /* -$A(a5) */
    u16 minhp = 0xFF;                   /* -$C(a5) */
    u16 d;                              /* -$E(a5) */
    u16 i;                              /* -$10(a5) */
    s16 x;                              /* -$6(a5) */
    s16 y;                              /* -$8(a5) */
    u16 v;                              /* -$12(a5) */
    u16 tile;                           /* -$14(a5) */
    Character *p;

    for (d = 0; d <= 8; ++d) {
        x = (s16)(combatant_x(c) + DX(d)); /* $3EE2: (word) x offset for direction d (step 2) */
        y = (s16)(combatant_y(c) + DY(d)); /* $3ED0: (word) y offset for direction d (step 2) */
        combat_map_cell(x, y, &v, &tile);
        if (v > 0) {
            *out = p = COMBATANT(v);
            /* ch+$199: side in combat (0 party, 1 opponents); ch+$1A8: current hit points;
             * ch+$64: maximum hit points */
            if (p->b[0x199] == c->b[0x199] && p->b[0x1A8] < p->b[0x64]) {
                if (p->b[0x1A8] < minhp || /* ch+$1A8: current hit points */
                    /* ch+$1A8: current hit points; ch+$64: maximum hit points */
                    (p == c && p->b[0x1A8] < (u16)(p->b[0x64] >> 1))) {
                    best = p;
                    minhp = p->b[0x1A8]; /* ch+$1A8: current hit points */
                }
            }
        } else if (tile == 0x1F) {
            for (i = 1; i <= H005_B(0x247A); ++i) { /* $247A: number of bodies in the table +$2AE2 (max 8) */
                p = g_bodies[i - 1].who;
                /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                if (p != NULL && p->b[0x197] != 6 && p->b[0x197] != 8 &&
                    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                    p->b[0x197] != 7 && (s16)g_bodies[i - 1].x == x &&
                    (s16)g_bodies[i - 1].y == y) {
                    body = i;
                }
            }
        }
    }
    if (minhp < 8 || body == 0) {
        *out = best;
    } else {
        *out = g_bodies[body - 1].who;
    }
    return (u8)(*out != NULL);
}

/* $66: spell table, 16 bytes per spell (from 1); k/o = field */
#define SPELL_B(s, o)   H005_B(0x66 + ((s) - 1) * 16 + (o))
#define AREA_B(o)       g_combat_area[o]

/* Position of who in aim. */
static void aim_set_pos(CokAim *aim, Character *who)
{
    aim->x = combatant_x(who);
    aim->y = combatant_y(who);
}

/*
 * PORT H096+$284C: target of spell spell.  Manual (b12 = 0)
 * with the aim (H096+$4448) within its range (H033+$11FC); otherwise for
 * the current character: if the spell does not want a target (+$E
 * zero) itself (for cure $3 the nearby wounded one, H096+$25DA), otherwise
 * the AI target (H096+$4B86), provided it is not helpless for the
 * spells of the list $4066.  Found: position in $251A/$2518.
 */
static u8 find_spell_target(u16 spell, u8 b12, u8 b10, CokAim *out)
{
    u8 found = 0;                       /* -$1(a5) */
    u8 ok;                              /* -$2(a5) */
    u16 tries;                          /* -$A(a5) */
    u16 i;                              /* -$8(a5) */
    Character *t;                       /* -$6(a5) */

    if (!b12) {
        aim_target(g_current_char, spell_range(spell), 0, b10,
                   (u8)(spell != 0x53), &found, out);
        TURN(g_current_char)->target = out->who;
    } else if (SPELL_B(spell, 0x0E) == 0) {
        out->who = g_current_char;
        if (spell != 3 || find_heal_target(g_current_char, &out->who)) {
            aim_set_pos(out, out->who);
            found = 1;
        }
    } else {
        for (tries = 1; tries > 0 && !found; --tries) {
            ok = 1;
            if (ai_pick_target(g_current_char, spell_range(spell), 0, 1)) {
                t = TURN(g_current_char)->target;
                if (is_helpless(t)) {
                    for (i = 1; i <= 4; ++i) {
                        /* $4065: i-1 base of the 4 helplessness effects ($4066..$4069) */
                        if (SPELL_B(spell, 0x0A) == H005_B(0x4066 + i - 1)) {
                            ok = 0;
                        }
                    }
                }
                if (ok) {
                    out->who = TURN(g_current_char)->target;
                    aim_set_pos(out, out->who);
                    found = 1;
                }
            }
        }
    }
    if (found) {
        /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
        H005_SET_W(0x251A, out->x);
        /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
        H005_SET_W(0x2518, out->y);
        return 1;
    }
    memset(out, 0, sizeof(*out));
    return 0;
}

/* Copies into g_spell_targets the combatants found by H077+$08AC ($2A3E). */
static void targets_from_area(void)
{
    u16 i;                              /* -$4(a5) */

    /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    for (i = 1; i <= H005_B(0x2479); ++i) {
        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
        g_spell_targets[i - 1] = COMBATANT(H005_B(0x2A3E + (i - 1) * 4));
    }
    /* $246C: number of spell targets in g_spell_targets ($2520); $2479: number of entries of the
     * area list +$2A3E (4 bytes per entry) */
    H005_B(0x246C) = H005_B(0x2479);
    H005_B(0x24A9) = 1; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
}

/* Is t already among the first n targets? */
static u8 already_targeted(Character *t, u16 n)
{
    u16 i;                              /* -$6(a5) */
    u8 dup = 0;                         /* -$15(a5) */

    for (i = 1; i <= n; ++i) {
        if (t == g_spell_targets[i - 1]) {
            dup = 1;
        }
    }
    return dup;
}

/*
 * PORT H096+$2A6C (vector $276C in combat): targets
 * of the spell according to the table (+$6 & $F): 0 the caster; 5 more
 * targets while the hit dice (+$DB, or for $4F the size) exceed 2d4
 * (or the level for $4F); 8..$E an area around the chosen point; $F the
 * target or an area; otherwise (+$6 & 3) + 1 distinct targets.
 * Without targets *ok = 0.  With no target chosen the original reads
 * the position from the entry before the table: here the previous one stays.
 */
void combat_spell_targets(u8 spell, u8 flag, u8 *ok)
{
    CokAim aim;                         /* -$14(a5) */
    u16 n = 0;                          /* -$A(a5) */
    u16 cnt = 0;                        /* -$4(a5) */
    s16 limit;                          /* -$8(a5) */
    s16 count;                          /* -$2(a5) */
    u8 stop;                            /* -$16(a5) */
    Character *t;

    *ok = 1;
    H005_B(0x246C) = 0; /* $246C: number of spell targets in g_spell_targets ($2520) */
    H005_B(0x24A9) = 0; /* $24A9: 1 if the spell acts on an area/group (pictures unharmed) */
    /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
    H005_SET_W(0x251A, combatant_x(g_current_char));
    /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
    H005_SET_W(0x2518, combatant_y(g_current_char));
    switch (mask_byte(SPELL_B(spell, 6), 0x0F)) {
    case 0:
        g_spell_targets[0] = g_current_char;
        H005_B(0x246C) = 1; /* $246C: number of spell targets in g_spell_targets ($2520) */
        break;
    case 5:
        if (spell == 0x4F) {
            limit = caster_level(0x4F);
        } else {
            limit = (s16)roll_dice(2, 4);
        }
        do {
            stop = 0;
            if (find_spell_target(spell, flag, 0, &aim)) {
                if (!already_targeted(aim.who, cnt)) {
                    ++cnt;
                    g_spell_targets[cnt - 1] = aim.who;
                    /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
                    H005_SET_W(0x251A, combatant_x(aim.who));
                    /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
                    H005_SET_W(0x2518, combatant_y(aim.who));
                    /* $246C: number of spell targets in g_spell_targets ($2520) */
                    add_to_byte(&H005_B(0x246C), 1);
                    t = g_spell_targets[cnt - 1];
                    if (spell != 0x4F) {
                        /* ch+$DB: highest level among the classes (also used as hit dice) */
                        switch (t->b[0xDB]) {
                        case 0: case 1: n = (u16)(n + 1); break;
                        case 2: n = (u16)(n + 2); break;
                        case 3: n = (u16)(n + 4); break;
                        default: n = (u16)(n + 8); break;
                        }
                    } else {
                        /* ch+$D3: shape/size on the combat map (bits 0-2, >1 large) */
                        switch (mask_byte(t->b[0xD3], 7)) {
                        case 1: n = (u16)(n + 1); break;
                        case 2: case 3: n = (u16)(n + 2); break;
                        case 4: n = (u16)(n + 4); break;
                        default: break;
                        }
                    }
                    if (cnt > 1 && n > (u16)limit) {
                        stop = 1;
                    }
                } else {
                    if (flag) {
                        --limit;
                    } else {
                        show_message_line(0x15, "Already been targeted");
                    }
                    redraw_combat_cell((s16)combatant_x(aim.who),
                                       (s16)combatant_y(aim.who));
                }
            } else {
                stop = 1;
            }
        } while (!stop && limit != 0);
        break;
    case 8: case 9: case 0x0A: case 0x0B: case 0x0C: case 0x0D: case 0x0E:
        if (find_spell_target(spell, flag, 1, &aim)) {
            /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518:
             * (word) y of the chosen target square (spells, breaths, telep.) */
            find_in_area((s16)H005_W(0x251A), (s16)H005_W(0x2518),
                         mask_byte(SPELL_B(spell, 6), 7), 0xFF, 1,
                         g_combat_area);
            targets_from_area();
        } else {
            *ok = 0;
        }
        break;
    case 0x0F:
        if (find_spell_target(spell, flag, 0, &aim)) {
            if (TURN(g_current_char)->target != NULL) {
                g_spell_targets[0] = TURN(g_current_char)->target;
                /* $246C: number of spell targets in g_spell_targets ($2520) */
                H005_B(0x246C) = 1;
            } else {
                /* $251A: (word) x of the chosen target square (spells, breaths, telep.); $2518: (word) y of the
                 * chosen target square (spells, breaths, telep.) */
                find_in_area((s16)H005_W(0x251A), (s16)H005_W(0x2518),
                             (u16)(mask_byte(SPELL_B(spell, 6), 0x0F) >> 4),
                             0xFF, 1, g_combat_area);
                targets_from_area();
            }
        } else {
            *ok = 0;
        }
        break;
    default:
        count = (s16)(mask_byte(SPELL_B(spell, 6), 3) + 1);
        cnt = 0;
        while (count > 0) {
            if (find_spell_target(spell, flag, 0, &aim)) {
                stop = already_targeted(aim.who, cnt);
                if ((spell == 0x17 || spell == 0x31) &&
                    aim.who == g_current_char) {
                    stop = 1;
                }
                if (!stop) {
                    ++cnt;
                    g_spell_targets[cnt - 1] = aim.who;
                    --count;
                    /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
                    H005_SET_W(0x251A, combatant_x(aim.who));
                    /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
                    H005_SET_W(0x2518, combatant_y(aim.who));
                } else {
                    if (!flag) {
                        if (aim.who == g_current_char) {
                            show_message_line(0x16, "Cannot target yourself");
                        } else {
                            show_message_line(0x15, "Already been targeted");
                        }
                    } else {
                        --count;
                    }
                    redraw_combat_cell((s16)combatant_x(aim.who),
                                       (s16)combatant_y(aim.who));
                }
            } else {
                count = 0;
            }
            /* $246C: number of spell targets in g_spell_targets ($2520) */
            H005_B(0x246C) = (u8)cnt;
            if (cnt == 0) {
                *ok = 0;
            } else {
                /* $251A: (word) x of the chosen target square (spells, breaths, telep.) */
                H005_SET_W(0x251A, combatant_x(g_spell_targets[cnt - 1]));
                /* $2518: (word) y of the chosen target square (spells, breaths, telep.) */
                H005_SET_W(0x2518, combatant_y(g_spell_targets[cnt - 1]));
            }
        }
        break;
    }
}

/*
 * PORT H096+$3100 (Cast in combat): chooses the spell
 * (H065+$34FC) if not given, refuses the camp-only ones; without a casting
 * time (+$C / 3) it casts it at once (H033+$1426), otherwise "Begins
 * Casting": the spell in the turn, initiative reduced by the time and
 * repositioning in the turn order.
 */
void combat_cast(u16 spell, u8 flag, u8 *done)
{
    Character *c;                       /* -$10(a5) */
    u8 found = 1;                       /* -$B(a5) */
    s16 sp = -1;                        /* -$A(a5) */
    u16 s;                              /* -$2(a5) */
    u16 delay;                          /* -$6(a5) */
    u16 i;                              /* -$8(a5) */
    Character *p;                       /* -$14(a5) */

    c = g_current_char;
    *done = 0;
    s = spell;
    if (s == 0) {
        s = choose_spell_of_kind(0, 1, &sp, &found);
    }
    if (s > 0 && SPELL_B(s, 0x0B) == 0) {
        show_message_line(0x0F, "Camp Only Spell");
        s = 0;
    }
    if (!flag) {
        redraw_combat_screen();
        H005_B(0x24C6) = 1; /* $24C6: 1 if the combatant's actions must be drawn (visible) */
        H005_B(0x24C7) = 1; /* $24C7: 1: combatant panel on the right to be redrawn */
        show_combatant_cursor(c, 3, 1);
        draw_combat_status(c);
    }
    if (s == 0) {
        return;
    }
    delay = (u16)(SPELL_B(s, 0x0C) / 3);
    if (delay == 0) {
        cast_spell(s, flag, 1, done);
        *done = end_combat_turn(c);
        return;
    }
    *done = 1;
    show_char_message(c, 0x0E, "Begins Casting", 0x0A, 1);
    TURN(c)->b[0] = (u8)s; /* turn+$0: spell being prepared, cast at the start of the turn */
    if (TURN_W(c, 4) > delay) { /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
        /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
        TURN_PUTW(c, 4, (u16)(TURN_W(c, 4) - delay));
    } else {
        TURN_PUTW(c, 4, 1); /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
    }
    i = H005_B(0x2480); /* $2480: current position in the turn order (1..$48, g_turn_order) */
    p = g_turn_order[i];
    while (p != NULL) {
        /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
        if ((s16)TURN_W(p, 4) > (s16)TURN_W(c, 4) ||
            /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
            ((s16)TURN_W(p, 4) == (s16)TURN_W(c, 4) && roll_dice(1, 2) == 1)) {
            g_turn_order[i - 1] = p;
            ++i;
            p = g_turn_order[i];
        } else {
            break;
        }
    }
    g_turn_order[i - 1] = c;
    /* $2480: current position in the turn order (1..$48, g_turn_order) */
    add_to_byte(&H005_B(0x2480), 0xFFFF);
    *done = 1;
}

/*
 * PORT H096+$3358: backstab?  A thief (+$104, or +$10C if
 * it can use the previous class) without a weapon or with a suitable weapon ($43,
 * 3, 4, $11..$13), next to a target already attacked (+$11 > 1), not
 * large (+$D3 & $7F <= 1) and that turns its back on it.
 */
static u8 is_backstab(Character *a, Character *t)
{
    u8 ok = 0;                          /* -$B(a5) */
    CokItem *w;                         /* -$4(a5) */
    u16 type = 0;                       /* -$A(a5) */

    w = a->readied[0];
    if (w != NULL) {
        type = w->b[0x30]; /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    }
    /* ch+$104: thief level; ch+$10C: previous thief level */
    if (a->b[0x104] > 0 || (a->b[0x10C] > 0 && h073_130a(a))) {
        if (w == NULL || type == 0x43 || type == 3 || type == 4 ||
            (type > 0x10 && type < 0x14)) {
            ok = 1;
        }
    }
    if (ok && TURN(t)->b[0x11] > 1 && combat_distance(a, t) < 2 && /* turn+$11: attacks received in the round */
        /* ch+$D3: shape/size on the combat map (bits 0-2, >1 large) */
        mask_byte(t->b[0xD3], 0x7F) <= 1 &&
        /* turn+$B: facing/frame of the combatant (direction 0..7) */
        TURN(t)->b[0x0B] == direction_toward(a, t)) {
        return 1;
    }
    return 0;
}

/*
 * PORT H096+$3492: animation of the weapon's missile (according to the type
 * +$30) from a to t, with the sound.
 */
static void missile_attack(Character *a, Character *t, CokItem *item)
{
    u16 dir;                            /* -$6(a5) */
    u16 frames = 1;                     /* -$4(a5) */
    u16 speed = 2;                      /* -$8(a5) */
    u16 base = 0x0D;                    /* -$2(a5) */

    dir = direction_toward(a, t);
    switch (item->b[0x30]) { /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    case 5:
        if (dir & 1) {
            if (dir == 3 || dir == 5) {
                copy_sprite_frame(0x1B, 1, 0, (u8)(dir == 5));
            } else {
                copy_sprite_frame(0x1B, 0, 0, (u8)(dir == 7));
            }
        } else {
            copy_sprite_frame((u16)((dir & 3) + 0x1A), (u16)(dir >> 2), 0, 0);
        }
        h043_190e(0x14);
        break;
    case 7: case 0x0C: case 0x1E:
        if (dir & 1) {
            if (dir == 3 || dir == 5) {
                copy_sprite_frame((u16)(base + 1), 1, 0, (u8)(dir == 5));
            } else {
                copy_sprite_frame((u16)(base + 1), 0, 0, (u8)(dir == 7));
            }
        } else {
            copy_sprite_frame((u16)((dir & 3) + base), (u16)(dir >> 2), 0, 0);
        }
        h043_190e(0x14);
        break;
    case 2: case 3: case 6:
        load_missile_frames((u16)(base + 3));
        frames = 4;
        speed = 5;
        h043_190e(0x10);
        break;
    case 0x36: case 0x37:
        load_missile_frames((u16)(base + 4));
        frames = 4;
        speed = 5;
        h043_190e(0x0D);
        break;
    case 0x1C: case 0x1D: case 0x43:
        ++base;
        copy_sprite_frame((u16)(base + 7), 0, 0, 0);
        copy_sprite_frame((u16)(base + 7), 1, 1, 0);
        frames = 2;
        speed = 2;
        h043_190e(0x0D);
        break;
    default:
        copy_sprite_frame((u16)(base + 7), 0, 0, 0);
        copy_sprite_frame((u16)(base + 7), 1, 1, 0);
        frames = 2;
        speed = 2;
        h043_190e(0x10);
        break;
    }
    animate_missile((s16)combatant_x(a), (s16)combatant_y(a),
                    (s16)combatant_x(t), (s16)combatant_y(t), frames, speed);
}

/*
 * PORT H096+$3852: the best movement (half of H096+$023E) among the
 * standing opponents of c.
 */
u16 enemy_distance_points(Character *c)
{
    u16 best = 0;                       /* -$2(a5) */
    u16 v;                              /* -$4(a5) */
    Character *p;                       /* -$8(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        /* ch+$199: side in combat (0 party, 1 opponents); ch+$198: active/standing (0 down or
         * out of the combat) */
        if (p->b[0x199] == other_side(c) && p->b[0x198]) {
            v = (u16)(movement_points(p) >> 1);
            if (v > best) {
                best = v;
            }
        }
    }
    return best;
}

/*
 * PORT H096+$38DC: is attacking t allowed?  Yes for an opponent or with
 * +$19A; for an ally it asks "Attack Ally:" and with Y the
 * computer-controlled allies (+$EC > $7F, not $B3) go over to the enemy.
 */
u8 confirm_attack(Character *a, Character *t)
{
    Character *p;                       /* -$4(a5) */

    /* ch+$199: side in combat (0 party, 1 opponents); ch+$19A: automatic control in combat (1
     * = AI) */
    if (a->b[0x199] == other_side(t) || a->b[0x19A]) {
        return 1;
    }
    if (ask_yes_no(0x0D, "Attack Ally: ", 0x0D, 0x0A, 0x0F) != 'Y') {
        return 0;
    }
    H005_B(0x24DB) = 1; /* $24DB: use: 1 after confirming "Attack Ally", never read */
    COK_PUT16(g_state_b + 0x666, 1); /* B+$666: (word) 1 if the attack on an ally was confirmed */
    for (p = g_party_head; p != NULL; p = p->next) {
        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down; ch+$EC:
         * control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
        if (p->b[0x197] == 0 && p->b[0xEC] != 0xB3 && p->b[0xEC] > 0x7F) {
            p->b[0x199] = 1; /* ch+$199: side in combat (0 party, 1 opponents) */
            TURN(p)->target = NULL;
        }
    }
    count_sides();
    return 1;
}

/*
 * PORT H096+$39D0: row of the aim: distance in sight (H077+$0378, on
 * $2ADE with +$8 at 1) and, within range, "Target" if c can hit cand;
 * then the menu "Next Prev Manual [Target] Center Exit" (returns the
 * key).
 */
static u8 aim_menu(Character *c, Character *cand, u16 range, u16 mode,
                   u8 b14, u8 b12, u8 flag, s16 x, s16 y)
{
    char line[0x2A];                    /* -$2A(a5) */
    u16 dist = 0xFF;                    /* -$32(a5) */
    u8 save;                            /* -$34(a5) */
    u8 special;                         /* -$2B(a5) */
    CokItem *w;                         /* -$30(a5) */

    (void)b14;
    (void)b12;
    line[0] = '\0';
    save = AREA_B(8);
    AREA_B(8) = 1;
    (void)line_of_sight((s16)combatant_x(c), (s16)combatant_y(c), &x, &y,
                        &dist, g_combat_area);
    AREA_B(8) = save;
    dist = (u16)(dist >> 1);
    if (mode != 0) {
        strcpy(line, "Range = ");
        /* $3C82: generic 80-character text buffer (TEXT_BUF) */
        format_number(0x50, (char *)&g_h005[0x3C82], (s32)dist, 0, 0x0A, 2,
                      ' ');
        /* $3C82: generic 80-character text buffer (TEXT_BUF) */
        h026_append(0x28, line, 0x50, (const char *)&g_h005[0x3C82]);
        h026_append(0x28, line, 2, "  ");
        ui_draw_text(0, 0x17, 0x0A, 0, 0x28, line);
    }
    g_h005[0x3C82] = 0; /* $3C82: generic 80-character text buffer (TEXT_BUF) */
    if (dist <= range && flag) {
        if (mode == 0) {
            /* $3C82: generic 80-character text buffer (TEXT_BUF) */
            strcpy((char *)&g_h005[0x3C82], "Target ");
        } else if (c != cand) {
            if (!has_ranged_weapon(c)) {
                /* $3C82: generic 80-character text buffer (TEXT_BUF) */
                strcpy((char *)&g_h005[0x3C82], "Target ");
            } else if (find_weapon(c, &w)) {
                if (count_enemies_near(c, 1) == 0 || weapon_melee_ok(c)) {
                    /* $3C82: generic 80-character text buffer (TEXT_BUF) */
                    strcpy((char *)&g_h005[0x3C82], "Target ");
                }
            }
        }
    }
    strcpy(line, "Next Prev Manual ");
    /* $3C82: generic 80-character text buffer (TEXT_BUF) */
    h026_append(0x28, line, 0x50, (const char *)&g_h005[0x3C82]);
    h026_append(0x28, line, 0x0B, "Center Exit");
    if (cand != NULL) {
        show_combatant_cursor(cand, 3, 1);
        H005_B(0x24C7) = 1; /* $24C7: 1: combatant panel on the right to be redrawn */
        draw_combat_status(cand);
    }
    return ui_request_choice(4, "Aim:", 0x28, line, 0x0D, 0x0A, 0x0F, 1, 0,
                             &special);
}

/*
 * PORT H096+$3C48: confirms the target t of the aim (for an attack,
 * mode 1, also towards an ally, H096+$38DC); with mode 1 it attacks: a
 * sweep (H096+$1340) or normally, with the ranged weapon if it is not
 * adjacent.  Otherwise the aim is cleared.
 */
static void aim_confirm(Character *a, Character *t, u16 mode, u8 *found,
                        CokAim *out)
{
    CokItem *w = NULL;                  /* -$6(a5) */

    *found = 1;
    if (mode == 1 && !confirm_attack(a, t)) {
        *found = 0;
    }
    if (!*found) {
        memset(out, 0, sizeof(*out));
        return;
    }
    out->who = t;
    aim_set_pos(out, t);
    AREA_B(6) = 0;
    center_view((s16)(AREA_X0 + 3), (s16)(AREA_Y0 + 3), 3, 8);
    if (mode == 1) {
        if (combat_sweep(a, t)) {
            *found = end_combat_turn(a);
        } else {
            record_attack(a, t);
            if (has_ranged_weapon(a) && find_weapon(a, &w) &&
                weapon_melee_ok(a) && combat_distance(a, t) == 1) {
                w = NULL;
            }
            combat_attack(a, t, 0, w, found);
        }
    }
}

/*
 * PORT H096+$3DBA (Manual): cursor on the combat map
 * ($2438/$2436, within 50x25) moved with the keypad; for the square in
 * sight it shows the distance and the combatant or the body; *ok if it is a
 * valid target (range, terrain, attackable target, b1c/b1e, and
 * for an attack the weapon).  Target/Enter confirms (*done = 1 and the aim),
 * E or Esc cancel going back to (x, y).
 */
static void aim_manual(Character *c, Character **cand, u16 range, u16 mode,
                       u8 b1e, u8 b1c, u8 *ok, u8 *done, CokAim *out,
                       s16 x, s16 y)
{
    char line[0x2A];                    /* -$2A(a5) */
    u8 key = 0x20;                      /* -$2B(a5) */
    u16 dir = 8;                        /* -$32(a5) */
    u16 v;                              /* -$3A(a5) */
    u16 tile;                           /* -$3C(a5) */
    u16 dist;                           /* -$42(a5) */
    s16 tx;                             /* -$36(a5) */
    s16 ty;                             /* -$38(a5) */
    u16 i;                              /* -$34(a5) */
    CokItem *w;                         /* -$30(a5) */

    H005_B(0x24CC) = 1; /* $24CC: 1 in Manual mode: cursor on the combat map */
    H005_SET_W(0x2438, (u16)x); /* $2438: cursor X on the combat map (word, 0..49) */
    H005_SET_W(0x2436, (u16)y); /* $2436: cursor Y on the combat map (word, 0..24) */
    memset(out, 0, sizeof(*out));
    AREA_B(6) = 1;
    AREA_B(7) = 1;
    H005_B(0x24C5) = 0; /* $24C5: outcome of the target choice (breaths, effect $42) */
    while (key && key != 0x0D && key != 'T' && key != 'E') {
        /* $2438: cursor X on the combat map (word, 0..49); $2436: cursor Y on the combat map
         * (word, 0..24) */
        center_view((s16)H005_W(0x2438), (s16)H005_W(0x2436), 2, dir);
        /* $2438: cursor X on the combat map (word, 0..49); $3EE2: (word) x offset for
         * direction d (step 2) */
        H005_SET_W(0x2438, (u16)((s16)H005_W(0x2438) + DX(dir)));
        /* $2436: cursor Y on the combat map (word, 0..24); $3ED0: (word) y offset for
         * direction d (step 2) */
        H005_SET_W(0x2436, (u16)((s16)H005_W(0x2436) + DY(dir)));
        /* $2438: cursor X on the combat map (word, 0..49) */
        if ((s16)H005_W(0x2438) < 0) H005_SET_W(0x2438, 0);
        /* $2436: cursor Y on the combat map (word, 0..24) */
        if ((s16)H005_W(0x2436) < 0) H005_SET_W(0x2436, 0);
        /* $2438: cursor X on the combat map (word, 0..49) */
        if ((s16)H005_W(0x2438) > 0x31) H005_SET_W(0x2438, 0x31);
        /* $2436: cursor Y on the combat map (word, 0..24) */
        if ((s16)H005_W(0x2436) > 0x18) H005_SET_W(0x2436, 0x18);
        /* $2438: cursor X on the combat map (word, 0..49); $2436: cursor Y on the combat map
         * (word, 0..24) */
        combat_map_cell((s16)H005_W(0x2438), (s16)H005_W(0x2436), &v, &tile);
        *ok = 0;
        dist = 0xFF;
        tx = (s16)H005_W(0x2438); /* $2438: cursor X on the combat map (word, 0..49) */
        ty = (s16)H005_W(0x2436); /* $2436: cursor Y on the combat map (word, 0..24) */
        if (line_of_sight((s16)combatant_x(c), (s16)combatant_y(c), &tx, &ty,
                          &dist, g_combat_area)) {
            *ok = 1;
            if (mode != 0) {
                strcpy(line, "Range = ");
                /* $3C82: generic 80-character text buffer (TEXT_BUF) */
                format_number(0x50, (char *)&g_h005[0x3C82],
                              (s32)(dist >> 1), 0, 0x0A, 2, ' ');
                /* $3C82: generic 80-character text buffer (TEXT_BUF) */
                h026_append(0x28, line, 0x50, (const char *)&g_h005[0x3C82]);
                h026_append(0x28, line, 2, "  ");
                ui_draw_text(0, 0x17, 0x0A, 0, 0x28, line);
            }
        } else if (mode != 0) {
            clear_text_cells(0, 0x17, 0x27, 0x17);
        }
        dist = (u16)(dist >> 1);
        *cand = NULL;
        if (*ok) {
            if (v > 0) {
                *cand = COMBATANT(v);
            } else if (tile == 0x1F) {
                /* $247A: number of bodies in the table +$2AE2 (max 8) */
                for (i = 1; i <= H005_B(0x247A); ++i) {
                    /* $2438: cursor X on the combat map (word, 0..49) */
                    if (g_bodies[i - 1].x == H005_W(0x2438) &&
                        /* $2436: cursor Y on the combat map (word, 0..24) */
                        g_bodies[i - 1].y == H005_W(0x2436)) {
                        *cand = g_bodies[i - 1].who;
                    }
                }
            }
        }
        if (*cand != NULL) {
            H005_B(0x24C7) = 1; /* $24C7: 1: combatant panel on the right to be redrawn */
            draw_combat_status(*cand);
        } else {
            clear_text_cells(0x17, 1, 0x26, 0x15);
        }
        /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
        if (dist > range || H005_B(0x3EF4 + (tile - 1) * 4) == 0xFF) {
            *ok = 0;
        }
        if (*cand != NULL) {
            if (!can_attack(c, *cand) || !b1c) {
                *ok = 0;
            }
            if (mode == 1) {
                if (c == *cand || (v == 0 && tile == 0x1F)) {
                    *ok = 0;
                } else if (has_ranged_weapon(c)) {
                    if (!find_weapon(c, &w)) {
                        *ok = 0;
                    } else if (count_enemies_near(c, 1) > 0 &&
                               !weapon_melee_ok(c)) {
                        *ok = 0;
                    }
                }
            }
        } else if (!b1e) {
            *ok = 0;
        }
        strcpy(line, *ok ? "Target" : "Exit");
        key = ui_request_choice(0x12, "(Use Cursor keys) ", 0x28, line, 0x0D,
                                /* $249F: use: scratch byte for *special and outcomes in the
                                 * combat menus */
                                0x0A, 0x0F, 1, 0, &H005_B(0x249F));
        switch (key) {
        case 0x0D:
        case 'T':
            *done = 1;
            out->x = H005_W(0x2438); /* $2438: cursor X on the combat map (word, 0..49) */
            out->y = H005_W(0x2436); /* $2436: cursor Y on the combat map (word, 0..24) */
            out->who = *cand;
            AREA_B(6) = 0;
            /* $2438: cursor X on the combat map (word, 0..49); $2436: cursor Y on the combat
             * map (word, 0..24) */
            redraw_combat_cell((s16)H005_W(0x2438), (s16)H005_W(0x2436));
            H005_B(0x24C5) = 0; /* $24C5: outcome of the target choice (breaths, effect $42) */
            break;
        case 'H': dir = 0; break;
        case 'I': dir = 1; break;
        case 'M': dir = 2; break;
        case 'Q': dir = 3; break;
        case 'P': dir = 4; break;
        case 'O': dir = 5; break;
        case 'K': dir = 6; break;
        case 'G': dir = 7; break;
        case ' ':
            /* $2438: cursor X on the combat map (word, 0..49); $2436: cursor Y on the combat
             * map (word, 0..24) */
            center_view((s16)H005_W(0x2438), (s16)H005_W(0x2436), 0, 8);
            dir = 8;
            break;
        case 0:
        case 'E':
            *done = 0;
            /* $2438: cursor X on the combat map (word, 0..49); $2436: cursor Y on the combat
             * map (word, 0..24) */
            redraw_combat_cell((s16)H005_W(0x2438), (s16)H005_W(0x2436));
            memset(out, 0, sizeof(*out));
            out->x = (u16)x;
            out->y = (u16)y;
            center_view(x, y, 0, 8);
            AREA_B(6) = 0;
            H005_B(0x24C5) = 0; /* $24C5: outcome of the target choice (breaths, effect $42) */
            break;
        default:
            dir = 8;
            break;
        }
    }
    H005_B(0x24CC) = 0; /* $24CC: 1 in Manual mode: cursor on the combat map */
}

/* State of the aim (locals of H096+$4448 used by the nested ones). */
typedef struct AimState {
    u8 list[0x28][4];                   /* -$A0(a5): entries of $2A3E */
    u16 count;                          /* -$A4(a5) */
    u16 idx;                            /* -$A6(a5) */
    s16 px, py;                         /* -$AC, -$AE(a5) */
    s16 nx, ny;                         /* -$B0, -$B2(a5) */
} AimState;

/*
 * PORT H096+$4456: nested: the combatants in the area around c
 * (H077+$08AC) that c can attack.
 */
static void aim_build_list(AimState *s, Character *c)
{
    u16 i;                              /* -$2(a5) */

    find_in_area((s16)combatant_x(c), (s16)combatant_y(c), 0x7F, 0xFF,
                 combatant_size(c), g_combat_area);
    s->count = 0;
    /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
    for (i = 1; i <= H005_B(0x2479); ++i) {
        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
        if (can_attack(c, COMBATANT(H005_B(0x2A3E + (i - 1) * 4)))) {
            ++s->count;
            /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
            memcpy(s->list[s->count - 1], &g_h005[0x2A3E + (i - 1) * 4], 4);
        }
    }
}

/*
 * PORT H096+$4530: nested: moves to the next target (step +1/-1,
 * wrapping) and, with draw, slides the cursor from the previous one.  With
 * an empty list the original would read entry -1: here c stays.
 */
static Character *aim_next(AimState *s, Character *c, s16 step, u8 draw)
{
    Character *r;                       /* -$C(a5) */

    if (s->count == 0) {
        return c;
    }
    if (draw) {
        /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
        s->px = (s16)POS_X(s->list[s->idx - 1][0]);
        /* $3156: combatant positions +2: row on the map (word) */
        s->py = (s16)POS_Y(s->list[s->idx - 1][0]);
    } else {
        redraw_combat_cell(s->px, s->py);
    }
    s->idx = (u16)(s->idx + step);
    if (s->idx == 0) {
        s->idx = s->count;
    }
    if (s->idx > s->count) {
        s->idx = 1;
    }
    r = COMBATANT(s->list[s->idx - 1][0]);
    /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
    s->nx = (s16)POS_X(s->list[s->idx - 1][0]);
    s->ny = (s16)POS_Y(s->list[s->idx - 1][0]); /* $3156: combatant positions +2: row on the map (word) */
    if (draw) {
        animate_missile(s->px, s->py, s->nx, s->ny, 1, 0);
        s->px = s->nx;
        s->py = s->ny;
    }
    return r;
}

/*
 * PORT H096+$4448 (body at $46E4): aim of c within range ($FF: the
 * range of the readied weapon, or 1): Next/Prev among the possible targets,
 * Manual with the cursor, Target confirms (with mode 1 it attacks, H096+$3C48),
 * Center, Exit.  *found and out describe the choice.
 */
void aim_target(Character *c, u16 range, u16 mode, u8 b16, u8 b14,
                u8 *found, CokAim *out)
{
    AimState s;
    s16 step;                           /* -$A8(a5) */
    Character *cand;                    /* -$B6(a5) */
    u8 key;                             /* -$B7(a5) */
    u8 ok;                              /* -$B8(a5) */
    u8 done = 0;                        /* -$B9(a5) */
    s16 x, y;                           /* -$BC, -$BE(a5) */
    s16 x0, y0;                         /* -$C0, -$C2(a5) */
    u16 r;                              /* -$A2(a5) */

    memset(&s, 0, sizeof s);
    copy_sprite_frame(0x19, 0, 0, 0);
    memset(out, 0, sizeof(*out));
    *found = 0;
    r = range;
    if (r == 0xFF) {
        if (c->readied[0] != NULL) {
            /* $337A: item types +$E: weapon range (>1 = ranged); ogg+$30: type of the item
             * (index into the table H005+$336C, $12 bytes per entry) */
            r = (u16)(H005_B(0x336C + c->readied[0]->b[0x30] * 0x12 + 0x0E) -
                      1);
        } else {
            r = 1;
        }
    }
    if (r == 0 || r >= 0xFF) {
        r = 1;
    }
    aim_build_list(&s, c);
    s.idx = 1;
    step = 0;
    cand = aim_next(&s, c, step, 1);
    key = 0x20;
    x = (s16)combatant_x(cand);
    y = (s16)combatant_y(cand);
    x0 = x;
    y0 = y;
    ok = 1;
    while (key && key != 0x0D && key != 'T' && key != 'E') {
        key = aim_menu(c, cand, r, mode, b16, b14, ok, x, y);
        if (!H005_B(0x249D)) { /* $249D: 1 if the last UI_RequestChoice gave a special key */
            switch (key) {
            case 'N':
                step = 1;
                ok = 1;
                cand = aim_next(&s, c, 1, 1);
                break;
            case 'P':
                step = -1;
                ok = 1;
                cand = aim_next(&s, c, -1, 1);
                break;
            case 'M':
                aim_manual(c, &cand, r, mode, b16, b14, &ok, &done, out, x,
                           y);
                cand = out->who;
                x = (s16)out->x;
                y = (s16)out->y;
                if (ok && done) {
                    key = 'T';
                    /* $2483: index of the selected option in the row menus (persistent) */
                    H005_B(0x2483) = 4;
                    out->who = cand;
                    *found = 1;
                    if (mode == 1) {
                        aim_confirm(c, cand, mode, found, out);
                    }
                    if (!*found) {
                        AREA_B(6) = 0;
                        center_view(x, y, 0, 8);
                    }
                } else {
                    /* $2483: index of the selected option in the row menus (persistent) */
                    H005_B(0x2483) = 3;
                }
                break;
            case 'T':
                out->x = (u16)x;
                out->y = (u16)y;
                out->who = cand;
                *found = 1;
                if (mode == 1) {
                    aim_confirm(c, cand, mode, found, out);
                }
                if (!*found) {
                    AREA_B(6) = 0;
                    center_view(x, y, 0, 8);
                }
                break;
            case 'C':
                AREA_B(6) = 1;
                AREA_B(7) = 1;
                center_view(x, y, 0, 8);
                AREA_B(6) = 0;
                break;
            case 'E':
                AREA_B(6) = 0;
                center_view(x, y, 0, 8);
                break;
            case 0:
                AREA_B(6) = 0;
                redraw_combat_cell(x, y);
                center_view(x0, y0, 0, 8);
                break;
            default:
                break;
            }
        }
        (void)step;
        /* With Manual on an empty square the original reads from NULL: not here. */
        if ((key == 'N' || key == 'P' || key == 'T') && cand != NULL) {
            x = (s16)combatant_x(cand);
            y = (s16)combatant_y(cand);
        }
    }
    if (mode != 0) {
        clear_text_cells(0, 0x17, 0x27, 0x17);
    }
}

/*
 * PORT H096+$4B86: AI target: keeps the one of the turn if it is an
 * attackable standing opponent (with b0 it is discarded anyway); otherwise
 * up to 20 draws among the enemies within the radius (with effect $5B the
 * favourite $2432 first), discarding the non-attackable ones; on the second
 * round (without b0) also out of sight ($2ADE+8).
 */
u8 ai_pick_target(Character *c, u16 radius, u8 b_any, u8 b0)
{
    CokEffect *e = NULL;                /* -$12(a5) */
    u8 retry = 0;                       /* -$9(a5) */
    u8 found = 0;                       /* -$8(a5) */
    u8 done = 0;                        /* -$7(a5) */
    u16 tries;                          /* -$4(a5) */
    u16 cnt;                            /* -$2(a5) */
    u16 k;                              /* -$6(a5) */
    u16 i;
    Character *t;                       /* -$E(a5) */

    t = TURN(c)->target;
    /* ch+$199: side in combat (0 party, 1 opponents); ch+$198: active/standing (0 down or out of
     * the combat) */
    if (b0 || (t != NULL && (t->b[0x199] == c->b[0x199] || !t->b[0x198] ||
                             !can_attack(c, t)))) {
        TURN(c)->target = NULL;
    }
    if (TURN(c)->target != NULL) {
        found = 1;
    }
    while (!found && !done) {
        done = retry;
        if (retry && !b0) {
            AREA_B(8) = 1;
        }
        tries = 0x14;
        cnt = count_enemies_near(c, radius);
        while (tries > 0 && !found && cnt > 0) {
            --tries;
            if (find_effect(c, 0x5B, &e) &&
                /* $2444: list of the nearby enemies (combatant number, 1 byte per entry) */
                COMBATANT(H005_B(0x2444)) == g_h005_2432 && tries == 0x13) {
                k = 1;
            } else {
                k = roll_dice(1, cnt);
            }
            if (NEAR(k) == 0) { /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
                continue;
            }
            t = COMBATANT(NEAR(k)); /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
            if ((b_any && AREA_B(8)) || can_attack(c, t)) {
                found = 1;
                TURN(c)->target = t;
            } else {
                /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
                H005_B(0x2444 + k - 1) = 0;
                for (i = 1; i <= cnt; ++i) {
                    /* $2444..: list of the nearby enemies ($2444+i-1, i from 1) */
                    if (NEAR(i) > 0) {
                        found = 1;
                    }
                }
                if (found) {
                    found = 0;
                } else {
                    cnt = 0;
                }
            }
        }
        if (!retry) {
            retry = 1;
        }
    }
    AREA_B(8) = 0;
    return found;
}

/* PORT H096+$4DE8: (Bandage command or similar) always "does not work": 0. */
u8 combat_bandage(void)
{
    return 0;
}
