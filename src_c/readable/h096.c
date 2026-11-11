/* H096: azioni, attacchi, mira e calcoli del combattimento. */
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

/* Funzioni statiche usate prima della definizione. */
u16 movement_points(Character *c);
u8 can_attack(Character *a, Character *t);
static u8 is_backstab(Character *a, Character *t);
static void attack_damage(Character *a, Character *d, u16 k);
static void range_penalty(Character *a, Character *t, s16 *ac);
static void missile_attack(Character *a, Character *t, CokItem *item);
u16 enemy_distance_points(Character *c);
u8 find_heal_target(Character *c, Character **out);
u8 ai_pick_target(Character *c, u16 radius, u8 b_any, u8 b0);

/* PORT H096+$01F2: link/unlk, nessun effetto. */
void h096_init(void)
{
}

/*
 * PORT H096+$37C2: forza rimasta dei nemici (lato 1): punti ferita dei
 * vivi sul totale massimo, in H005+$2481 come (vivi * 20 / totale) * 5.
 */
void enemy_strength(void)
{
    u16 total = 0;                      /* -$2(a5) */
    u16 alive = 0;                      /* -$4(a5) */
    Character *p;                       /* -$8(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0x199] == 1) {
            if (p->b[0x198]) {
                alive = (u16)(alive + p->b[0x1A8]);
            }
            total = (u16)(total + p->b[0x64]);
        }
    }
    if (total > 0) {
        H005_B(0x2481) = (u8)((u16)((u32)alive * 0x14 / total) * 5);
    }
}

#define TURN(c)         ((c)->block_192)
#define TURN_W(c, o)    COK_GET16(TURN(c)->b + (o))
#define TURN_PUTW(c, o, v) COK_PUT16(TURN(c)->b + (o), (v))
#define NEAR(i)         H005_B(0x2444 + (i) - 1)     /* elenco di H063+$2BDE */
#define COMBATANT(n)    g_combatants[(n) - 1]
#define POS_X(n)        H005_W(0x3154 + ((n) - 1) * 6)
#define POS_Y(n)        H005_W(0x3154 + ((n) - 1) * 6 + 2)
#define POS_SIZE(n)     H005_B(0x3154 + ((n) - 1) * 6 + 5)
#define DX(d)           ((s16)H005_W(0x3EE2 + (d) * 2))
#define DY(d)           ((s16)H005_W(0x3ED0 + (d) * 2))
#define AREA_X0         ((s16)COK_GET16(g_combat_area + 2))
#define AREA_Y0         ((s16)COK_GET16(g_combat_area + 4))

/* PORT H096+$0200: meta' arrotondata secondo il bit 0 del round ($247C). */
static u16 half_round(u16 v)
{
    u16 r = v;                          /* -$2(a5) */

    if (H005_B(0x247C) & 1) {
        ++r;
    }
    return (u16)(r >> 1);
}

/*
 * PORT H096+$023E: movimento del turno: velocita' (+$1A9, per il party
 * piu' il bonus $3E00+$6E4), fuori da 1..$60 vale 1; il doppio passa
 * dall'evento $12 (che puo' cambiarlo in $2472) e viene restituito.
 */
u16 movement_points(Character *c)
{
    u16 v;                              /* -$2(a5) */

    v = c->b[0x1A9];
    if (!c->b[0x199]) {
        v = (u16)(v + COK_GET16(g_state_b + 0x6E4));
    }
    H005_B(0x24AC) = 1;
    if (v < 1 || v > 0x60) {
        v = 1;
    }
    H005_B(0x2472) = (u8)(v * 2);
    trigger_event(&c, 0x12);
    H005_B(0x24AC) = 0;
    return H005_B(0x2472);
}

/*
 * PORT H096+$02CE: prepara il turno del combattente: blocco del turno
 * azzerato in parte, attacchi (H096+$11D4) e mezzi attacchi (+$19F),
 * iniziativa (d6 + destrezza, -6 se il lato e' sorpreso, 0 fuori da
 * 0..20; 0 per chi e' a terra) e punti movimento.
 */
void combat_prepare_turn(Character *c)
{
    CokTurn *t;                         /* a3 */
    u16 blocker;                        /* -$4(a5) */
    u8 in_cloud;                        /* -$5(a5) */
    u8 in_acid;                         /* -$6(a5) */
    s16 v;

    t = TURN(c);
    t->b[0] = 0;
    probe_move(c, 8, &blocker, &blocker, &in_cloud, &in_acid);
    t->b[1] = (u8)(in_cloud == 0);
    t->b[2] = 1;
    t->b[0x0A] = 0;
    t->b[6] = 2;
    combat_attacks(c);
    H005_B(0x2472) = c->b[0x111];
    H005_B(0x24AC) = 0;
    trigger_event(&c, 0x12);
    c->b[0x19F] = (u8)half_round(H005_B(0x2472));
    t->b[7] = c->b[0xD2];
    if (c->b[0x198]) {
        v = (s16)(roll_dice(1, 6) + dex_missile_adj(c));
        if (v < 1) {
            v = 1;
        }
        if (mask_byte((u8)COK_GET16(g_state_b + 0x596),
                      (u16)(c->b[0x199] + 1))) {
            v = (s16)(v - 6);
        }
        if (v < 0 || v > 0x14) {
            v = 0;
        }
        COK_PUT16(t->b + 4, (u16)v);
    } else {
        COK_PUT16(t->b + 4, 0);
    }
    TURN(c)->b[8] = (u8)movement_points(c);
}

/*
 * PORT H096+$0434: danno dell'attacco k (1 o 2) di a su d: dadi
 * (+$1A0/+$1A2) piu' il bonus (+$1A4) in $2474, eventi 4 e 5; alla
 * pugnalata alle spalle (H096+$3358) moltiplicato per 2 + (livello di
 * ladro - 1) / 4.
 */
static void attack_damage(Character *a, Character *d, u16 k)
{
    u16 v;

    v = (u16)(roll_damage_dice(a->b[0x1A0 + k - 1], a->b[0x1A2 + k - 1]) +
              CH_W(a, 0x1A4 + (k - 1) * 2));
    H005_B(0x2474) = (u8)v;
    trigger_event(&a, 4);
    trigger_event(&d, 5);
    if (is_backstab(a, d)) {
        v = (u16)(a->b[0x104] + a->b[0x10C] * h073_130a(a));
        v = (u16)(((u16)(v - 1) >> 2) + 2);
        H005_B(0x2474) = (u8)(H005_B(0x2474) * v);
    }
    H005_B(0x2473) = 0;
}

/*
 * PORT H096+$0530: messaggio dell'attacco: "Attacks" ("-Backstabs-" per
 * kind 2, "slays helpless" per 3) col nome del bersaglio, poi "Hitting
 * for n point(s) of damage" (applicando dmg_applied) o "and Misses"; se
 * il bersaglio perde un incantesimo o cade, i messaggi relativi.
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
            format_number(0x50, (char *)&g_h005[0x3C82], (s32)dmg, 0, 0x0A,
                          3, ' ');
            trim_leading_spaces(0x50, (char *)&g_h005[0x3C82]);
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
    if (t->b[0x197] != 8) {
        word_wrap_text(0x17, row, 0x26, (u16)(row + 3), 0x0A, 0, 1, 0x50,
                       text);
    }
    row = (u16)(H005_W(0x334C) + 1);
    if (dmg_applied > 0) {
        TURN(t)->b[1] = 0;
        if (TURN(t)->b[0] > 0) {
            message_delay();
            show_char_message(t, 0x0C, "lost a spell", 0x0C, 1);
            forget_spell(t, TURN(t)->b[0]);
            (void)end_combat_turn(t);
        } else {
            message_delay();
        }
    } else {
        message_delay();
    }
    if (!t->b[0x198]) {
        show_char_message(t, 9, "goes down", row, 0);
        row = (u16)(row + 2);
        if (t->b[0x197] == 5) {
            ui_draw_text(0x17, row, 0x0A, 0, 0x0C, "and is Dying");
        }
        if (t->b[0x197] == 6 || t->b[0x197] == 8 || t->b[0x197] == 7) {
            show_char_message(t, 9, "is killed", row, 0);
        }
        row = (u16)(row + 2);
        drop_effects(t);
        trigger_event(&t, 0x0D);
        if (!t->b[0x198] && t->b[0x197] != 0x0A) {
            combatant_falls(t);
        } else {
            message_delay();
        }
    }
    clear_message_area();
}

/*
 * PORT H096+$08B2: chi si muove accanto a nemici pronti ad attaccare
 * (+$9 del turno) e non inermi subisce il loro attacco.
 */
static void opportunity_attacks(Character *c)
{
    u16 n;                              /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    Character *e;                       /* -$8(a5) */
    u8 done;                            /* -$9(a5) */

    n = count_enemies_near(c, 1);
    for (i = 1; i <= n; ++i) {
        if (!c->b[0x198]) {
            continue;
        }
        e = COMBATANT(NEAR(i));
        if (TURN(e)->b[9] && !is_helpless(e)) {
            center_view((s16)combatant_x(c), (s16)combatant_y(c), 2, 8);
            TURN(e)->b[9] = 0;
            record_attack(e, c);
            combat_attack(e, c, 0, NULL, &done);
        }
    }
}

/*
 * PORT H096+$099C: un passo del combattente in direzione dir: costo
 * del terreno (x3 in diagonale, x2 altrimenti) dai punti movimento,
 * spostamento con ridisegno e vista centrata, suono e attacchi di chi
 * resta accanto (H096+$08B2).
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
    x0 = (s16)POS_X(n);
    y0 = (s16)POS_Y(n);
    nx = (s16)(x0 + DX(dir));
    ny = (s16)(y0 + DY(dir));
    top = g_combat_area[0x0A + (s32)ny * 0x64 + nx * 2 + 1];
    if (dir & 1) {
        cost = (u16)(H005_B(0x3EF4 + (top - 1) * 4) * 3);
    } else {
        cost = (u16)(H005_B(0x3EF4 + (top - 1) * 4) * 2);
    }
    if (cost > TURN(c)->b[8]) {
        TURN(c)->b[8] = 0;
    } else {
        add_to_byte(&TURN(c)->b[8], (u16)(0 - cost));
    }
    cost = 2;
    if (c->b[0x19A]) {
        cost = 3;
        if (!in_view((s16)(nx - AREA_X0), (s16)(ny - AREA_Y0)) &&
            H005_B(0x24C6)) {
            center_view(x0, y0, 2, 8);
        }
    }
    if (H005_B(0x24C6)) {
        begin_screen_update();
        redraw_ground(0, 0, n);
    }
    H005_SET_W(0x3154 + (n - 1) * 6, (u16)nx);
    H005_SET_W(0x3154 + (n - 1) * 6 + 2, (u16)ny);
    rebuild_occupancy();
    if (H005_B(0x24C6)) {
        center_view(nx, ny, cost, 8);
        end_screen_update();
    }
    TURN(c)->b[0x11] = 0;
    TURN(c)->b[0x14] = 0;
    if (POS_SIZE(n) == 1) {
        h043_190e(0x11);
    } else {
        h043_190e(0x12);
    }
    opportunity_attacks(c);
    if (!c->b[0x198] || is_helpless(c)) {
        TURN(c)->b[8] = 0;
    }
}

/*
 * PORT H096+$0C3C: prima di spostarsi in dir, i nemici accanto che non
 * lo saranno piu' (non inermi, senza +$12 del turno, che possono
 * attaccare e non hanno solo armi a distanza) attaccano se il
 * combattente e' alle loro spalle o in una delle direzioni +6..+10 dal
 * loro orientamento (+$B), con l'arma migliore.
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
    u8 party_flag = 0;                  /* -$39(a5): mai letto */
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
        e = COMBATANT(NEAR(j));
        if (!is_helpless(e) && !TURN(e)->b[0x12]) {
            list[i - 1] = NEAR(j);
            ++i;
        }
    }
    cnt = (u16)(i - 1);
    H005_SET_W(0x3154 + (n - 1) * 6, (u16)(POS_X(n) + DX(dir)));
    H005_SET_W(0x3154 + (n - 1) * 6 + 2, (u16)(POS_Y(n) + DY(dir)));
    cnt2 = count_enemies_near(c, 1);
    H005_SET_W(0x3154 + (n - 1) * 6, (u16)(POS_X(n) - DX(dir)));
    H005_SET_W(0x3154 + (n - 1) * 6 + 2, (u16)(POS_Y(n) - DY(dir)));
    for (i = 1; i <= cnt; ++i) {
        found = 0;
        for (j = 1; j <= cnt2; ++j) {
            if (NEAR(j) == list[i - 1]) {
                found = 1;
            }
        }
        if (found) {
            list[i - 1] = 0;
        }
    }
    if (!c->b[0x199]) {
        for (i = 1; i <= cnt; ++i) {
            if (list[i - 1] > 0 && c->b[0x198]) {
                party_flag = 1;
            }
        }
    }
    (void)party_flag;
    for (i = 1; i <= cnt; ++i) {
        if (!(list[i - 1] > 0 && c->b[0x198])) {
            continue;
        }
        H005_B(0x24C7) = 1;
        H005_B(0x24C6) = 1;
        done = 0;
        e = COMBATANT(list[i - 1]);
        if (!can_attack(e, c)) {
            continue;
        }
        if (has_ranged_weapon(e) && !weapon_melee_ok(e)) {
            continue;
        }
        for (d = (u16)(TURN(e)->b[0x0B] + 6);
             d <= (u16)(TURN(e)->b[0x0B] + 0x0A); ++d) {
            if (done) {
                continue;
            }
            if (!((s16)TURN_W(e, 4) > 0 || TURN(e)->b[0x11] == 0 ||
                  in_direction((s16)combatant_x(e), (s16)combatant_y(e),
                               (s16)combatant_x(c), (s16)combatant_y(c),
                               (u16)(d & 7)))) {
                continue;
            }
            k = 1;
            if (e->b[0x110] == 0) {
                k = 2;
            }
            for (s = 1; s <= 2; ++s) {
                if (e->b[0x19E + s - 1] > 0) {
                    k = s;
                }
            }
            if (e->b[0x19E + k - 1] == 0) {
                e->b[0x19E + k - 1] = 1;
            }
            TURN(e)->b[6] = (u8)k;
            saved = TURN(e)->target;
            combat_attack(e, c, 1, NULL, &H005_B(0x249F));
            done = 1;
            TURN(e)->target = saved;
            if (c->b[0x198]) {
                H005_B(0x24C7) = 1;
                draw_combat_status(c);
            }
        }
    }
}

/*
 * PORT H096+$10FA: tentativo di fuga: riesce senza nemici, se la
 * distanza dai nemici (H096+$3852) supera meta' del movimento, o alla
 * pari con 1d2 = 1 ("Got Away"); altrimenti "Escape is blocked".
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
 * PORT H096+$11D4: attacchi del round (+$19E): da +$110, o per un'arma
 * a distanza la cadenza della tabella $336C (almeno 2) limitata dalle
 * munizioni (+$40); passati per l'evento $12 e dimezzati; con +$A del
 * turno non oltre i precedenti.
 */
void combat_attacks(Character *c)
{
    u8 ranged = 0;                      /* -$9(a5) */
    u16 was;                            /* -$4(a5) */
    u16 rate;                           /* -$8(a5) */
    u16 n;                              /* -$2(a5) */
    u16 k;                              /* -$6(a5) */
    CokItem *w = NULL;                  /* -$E(a5) */

    was = c->b[0x19E];
    c->b[0x19E] = c->b[0x110];
    if (has_ranged_weapon(c) && find_weapon(c, &w)) {
        ranged = 1;
        rate = H005_B(0x336C + c->readied[0]->b[0x30] * 0x12 + 6);
        if (rate < 2) {
            rate = 2;
        }
        H005_B(0x2472) = (u8)rate;
    } else {
        H005_B(0x2472) = c->b[0x19E];
    }
    H005_B(0x24AC) = 0;
    trigger_event(&c, 0x12);
    n = half_round(H005_B(0x2472));
    if (ranged && w != NULL) {
        k = 1;
        if (w != NULL && w->b[0x40] > k) {
            k = w->b[0x40];
        }
        if (k < n && w->b[0x40] > 0) {
            n = k;
        }
    }
    if (TURN(c)->b[0x0A] == 0 || n < was) {
        c->b[0x19E] = (u8)n;
    } else {
        c->b[0x19E] = (u8)was;
    }
}

/*
 * PORT H096+$1340: attacco a spazzata: se l'attaccante ha meno attacchi
 * di +$7 del turno, il bersaglio e' accanto e non ha +$DB, e i nemici
 * accanto senza +$DB sono piu' degli attacchi, li colpisce tutti (al
 * massimo +$7), cominciando dal bersaglio ("sweeps").
 */
u8 combat_sweep(Character *a, Character *t)
{
    u8 res = 0;                         /* -$D(a5) */
    u16 cnt;                            /* -$2(a5) */
    u16 m = 0;                          /* -$4(a5) */
    u16 i;                              /* -$6(a5) */
    u16 idx = 0;                        /* -$8(a5) */
    Character *e;                       /* -$C(a5) */

    if (!(a->b[0x19E] < TURN(a)->b[7] && !t->b[0xDB] &&
          combat_distance(a, t) == 1)) {
        return 0;
    }
    cnt = count_enemies_near(a, 1);
    for (i = 1; i <= cnt; ++i) {
        e = COMBATANT(NEAR(i));
        if (e == t) {
            idx = i;
        }
        if (!e->b[0xDB]) {
            ++m;
        }
    }
    if (!(m > a->b[0x19E])) {
        return 0;
    }
    if (m > TURN(a)->b[7]) {
        m = TURN(a)->b[7];
    }
    show_char_message(a, 6, "sweeps", 0x0A, 1);
    e = COMBATANT(H005_B(0x2444));
    if (e != t) {
        H005_B(0x2444 + idx - 1) = H005_B(0x2444);
        H005_B(0x2444) = (u8)combatant_index(t);
    }
    for (i = 1; i <= cnt; ++i) {
        if (m == 0) {
            continue;
        }
        e = COMBATANT(NEAR(i));
        if (e->b[0xDB]) {
            continue;
        }
        record_attack(a, e);
        a->b[0x19E] = 1;
        combat_attack(a, e, 0, NULL, &H005_B(0x249F));
        --m;
    }
    res = 1;
    return res;
}

/*
 * PORT H096+$1562: a puo' attaccare t?  Se stesso si', altrimenti gli
 * eventi 1 (di t) e 0 (di a, col bersaglio provvisorio) non devono
 * impostare $24AB.
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
    H005_B(0x24AB) = 0;
    trigger_event(&t, 1);
    if (!H005_B(0x24AB)) {
        saved = TURN(a)->target;
        TURN(a)->target = t;
        trigger_event(&a, 0);
        TURN(a)->target = saved;
    }
    return (u8)(H005_B(0x24AB) == 0);
}

/*
 * Tabella di Turn Undead (locale di H096+$160A, $9C word iniziate a
 * $6363): riga = tipo del non morto (+$DF) - 1, colonna = livello del
 * chierico - 1, 13 colonne.  Positivo: tiro d20 minimo per scacciarlo;
 * 0 o negativo: distrutto.  Le anomalie (una voce scritta due volte, $47,
 * voci lasciate a $6363) sono quelle dell'originale.
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
 * PORT H096+$1B04: fra i nemici (non fuggiti, +$12 del turno) il non
 * morto di tipo (+$DF) piu' alto non oltre *max; *max diventa quel tipo.
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
        e = COMBATANT(NEAR(i));
        if (!TURN(e)->b[0x12] && e->b[0xDF] > 0 && e->b[0xDF] > best &&
            e->b[0xDF] <= *max) {
            best = e->b[0xDF];
            *out = e;
            found = 1;
        }
    }
    *max = best;
    return found;
}

/*
 * PORT H096+$160A (Turn Undead): 1d12 non morti al piu' (6 in piu' se
 * distrutti), dal tipo piu' alto: con 1d20 almeno il valore della tabella
 * per il livello del chierico (+$FE, +2 per +$5E = 2) il non morto fugge
 * ("is turned") o e' distrutto ("Is destroyed"); altrimenti si prova il
 * tipo inferiore.  Un indice oltre la tabella leggerebbe lo stack: qui
 * vale $6363 (mai riuscito).
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
    add_to_byte(&TURN(c)->b[0x13], 1);
    max = 0x0D;
    extra = 6;
    count = roll_dice(1, 0x0C);
    r = roll_dice(1, 0x14);
    level = (u8)(c->b[0xFE] + c->b[0x106] * h073_130a(c));
    if (c->b[0x5E] == 2) {
        level = (u8)(level + 2);
    }
    while (find_undead(c, &t, &max) && count > 0) {
        idx = (u16)((t->b[0xDF] - 1) * 13 + (level - 1));
        v = (s16)(idx < 0x9C ? s_turn_table[idx] : 0x6363);
        if (r >= (u16)(v < 0 ? -v : v)) {
            turned = 1;
            show_combatant_cursor(t, 3, 0);
            H005_B(0x24C7) = 1;
            draw_combat_status(t);
            if (v > 0) {
                fall_down(t, 3, 9, "is turned");
                h043_190e(0x15);
            } else {
                show_char_message(t, 0x0C, "Is destroyed", 0x0A, 0);
                combatant_falls(t);
                t->b[0x197] = 8;
                t->b[0x198] = 0;
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
    H005_B(0x249F) = end_combat_turn(c);
    clear_message_area();
}

/*
 * PORT H096+$1BE0: risolve gli attacchi di a su t.  Su un bersaglio
 * inerme un colpo mortale ("slays helpless").  Altrimenti, con un'arma
 * pronta contro un grande bersaglio, dadi e bonus dalla tabella $336C;
 * classe d'armatura (alle spalle o pugnalata: +$19D - 4 / +$19C+1),
 * distanza (H096+$251C), poi per ogni gruppo di attacchi dal corrente al
 * primo: tiro (H062+$12F6), danno e messaggi, finche' il bersaglio cade.
 * *done = 1 se non restano attacchi (e il turno finisce).
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
    H005_B(0x2A18) = 0;
    H005_B(0x2A19) = 0;
    H005_B(0x2442) = 0;
    H005_B(0x2443) = 0;
    H005_B(0x2474) = 0;
    TURN(a)->b[0x0A] = 1;
    if (is_helpless(t)) {
        h043_190e(0x0E);
        while (a->b[0x19E + TURN(a)->b[6] - 1] == 0) {
            add_to_byte(&TURN(a)->b[6], 0xFFFF);
        }
        add_to_byte(&H005_B(0x2442 + TURN(a)->b[6] - 1), 1);
        attack_message(a, t, 3, (u16)(t->b[0x1A8] + 5), 1, 1);
        remove_effects_19(a);
        a->b[0x19E] = 0;
        a->b[0x19F] = 0;
        hit = 1;
        *done = 1;
    } else {
        if (a->readied[0] != NULL &&
            (t->b[0xD3] > 0x80 || mask_byte(t->b[0xD3], 7) > 1)) {
            exec_copy_mem(&g_h005[0x336C + a->readied[0]->b[0x30] * 0x12],
                          wtab, 0x12);
            a->b[0x1A0] = wtab[2];
            a->b[0x1A2] = wtab[3];
            CH_PUTW(a, 0x1A4, (u16)(CH_W(a, 0x1A4) - COK_GET16(wtab + 0x0C) +
                                    COK_GET16(wtab + 4)));
        }
        recompute_stats(t);
        trigger_event(&t, 0x0B);
        if (is_backstab(a, t)) {
            ac = (s16)(t->b[0x19D] - 4);
        } else {
            if (TURN(t)->b[0x11] > 1 &&
                direction_toward(a, t) == TURN(t)->b[0x0B] &&
                TURN(t)->b[0x14] > 4) {
                behind = 1;
            }
            if (behind) {
                rear = 1;
            }
            ac = t->b[0x19C + rear];
        }
        range_penalty(a, t, &ac);
        kind = 0;
        if (behind) {
            kind = 1;
        }
        if (is_backstab(a, t)) {
            kind = 2;
        }
        k0 = TURN(a)->b[6];
        for (k = (s16)k0; k >= 1; --k) {
            while (a->b[0x19E + k - 1] > 0 && !killed) {
                add_to_byte(&a->b[0x19E + k - 1], 0xFFFF);
                TURN(a)->b[6] = (u8)k;
                add_to_byte(&H005_B(0x2442 + k - 1), 1);
                if (attack_roll(a, t, (u16)ac) || is_helpless(t)) {
                    add_to_byte(&H005_B(0x2A18 + k - 1), 1);
                    h043_190e(0x0E);
                    hit = 1;
                    attack_damage(a, t, (u16)k);
                    if (t->b[0x198]) {
                        attack_message(a, t, kind, H005_B(0x2474),
                                       H005_B(0x2474), 1);
                    }
                    if (t->b[0x198] && H005_B(0x2474) > 0) {
                        trigger_event(&a, (u16)(k + 1));
                    }
                    if (!t->b[0x198]) {
                        killed = 1;
                    }
                    if (!a->b[0x198]) {
                        k0 = 0;
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
            if (a->b[0x19E + k - 1] > 0) {
                *done = 0;
            }
        }
        TURN(a)->b[7] = 0;
    }
    if (!a->b[0x198]) {
        *done = 1;
    }
    if (*done) {
        *done = end_combat_turn(a);
    }
}

/*
 * PORT H096+$20E6: t subisce un attacco da a: +$11 del turno conta gli
 * attacchi, +$14 accumula di quanto (0..4 ottavi di giro) a e' fuori dal
 * suo orientamento.
 */
void record_attack(Character *a, Character *t)
{
    u16 dir;                            /* -$4(a5) */
    u16 rel;                            /* -$2(a5) */

    add_to_byte(&TURN(t)->b[0x11], 1);
    dir = direction_toward(t, a);
    rel = (u16)((dir - TURN(t)->b[0x0B] + 8) & 7);
    if (rel > 4) {
        rel = (u16)(8 - rel);
    }
    TURN(t)->b[0x14] = (u8)((TURN(t)->b[0x14] + rel) & 7);
}

/*
 * PORT H096+$2182: a attacca t: orientamenti e figure, bersaglio del
 * turno, colpo dell'arma da lancio (H096+$3492, anche per i tipi $1C e
 * $1D); se restano attacchi li risolve (H096+$1BE0) come personaggio
 * corrente, consuma le munizioni (+$40 dell'arma, per gli attacchi
 * fatti) e un'arma da lancio esaurita finisce nel tesoro (dopo l'ultima
 * lanciata, $335C) o sparisce.  Con l'arma pronta mancante l'originale
 * legge comunque +$30 dall'indirizzo 0: qui si salta.
 */
void combat_attack(Character *a, Character *t, u8 flag, CokItem *item,
                   u8 *done)
{
    u16 dir = 0;                        /* -$E(a5) */
    Character *saved;                   /* -$C(a5) */
    CokItem *copy;                      /* -$4(a5) */
    CokItem *p;                         /* -$8(a5) */

    H005_B(0x24C6) = 1;
    H005_B(0x24C7) = 1;
    H005_B(0x2477) = (u8)(H005_B(0x247C) + 0x0F);
    if (TURN(t)->b[0x11] < 2 && !flag) {
        dir = direction_toward(t, a);
        TURN(t)->b[0x0B] = (u8)((dir + 4) & 7);
    } else if (combatant_visible(t, 0)) {
        dir = TURN(t)->b[0x0B];
        if (!flag) {
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
        (a->readied[0]->b[0x30] == 0x1C || a->readied[0]->b[0x30] == 0x1D)) {
        missile_attack(a, t, a->readied[0]);
    }
    *done = 1;
    if (a->b[0x19E] > 0 || a->b[0x19F] > 0) {
        saved = g_current_char;
        g_current_char = a;
        resolve_attacks(a, t, flag, done);
        if (item != NULL && !weapon_is_43(a)) {
            if (item->b[0x40] > 0) {
                add_to_byte(&item->b[0x40], (u16)(0 - H005_B(0x2442)));
            }
            if (item->b[0x40] == 0) {
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
                    copy->b[0x3A] = 0;
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
        set_combatant_frame(a, TURN(a)->b[0x0B], 1, 1);
        set_combatant_frame(a, TURN(a)->b[0x0B], 0, 0);
        end_screen_update();
    }
}

/*
 * PORT H096+$251C: penalita' di distanza: oltre la gittata dell'arma a
 * distanza ((tabella $336C +$E - 1) / 3, o la distanza stessa) la classe
 * d'armatura sale di 2, e di altri 3 oltre il doppio.
 */
static void range_penalty(Character *a, Character *t, s16 *ac)
{
    s16 dist;                           /* -$4(a5) */
    s16 r;                              /* -$2(a5) */

    dist = (s16)combat_distance(a, t);
    if (has_ranged_weapon(a)) {
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
 * PORT H096+$25DA: bersaglio di una cura vicino a c: l'alleato accanto
 * (o se stesso sotto meta') con meno punti ferita, se non al massimo;
 * con tutti sopra 7 un corpo caduto ($2AE2) su una casella vicina.
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
        x = (s16)(combatant_x(c) + DX(d));
        y = (s16)(combatant_y(c) + DY(d));
        combat_map_cell(x, y, &v, &tile);
        if (v > 0) {
            *out = p = COMBATANT(v);
            if (p->b[0x199] == c->b[0x199] && p->b[0x1A8] < p->b[0x64]) {
                if (p->b[0x1A8] < minhp ||
                    (p == c && p->b[0x1A8] < (u16)(p->b[0x64] >> 1))) {
                    best = p;
                    minhp = p->b[0x1A8];
                }
            }
        } else if (tile == 0x1F) {
            for (i = 1; i <= H005_B(0x247A); ++i) {
                p = g_bodies[i - 1].who;
                if (p != NULL && p->b[0x197] != 6 && p->b[0x197] != 8 &&
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

#define SPELL_B(s, o)   H005_B(0x66 + ((s) - 1) * 16 + (o))
#define AREA_B(o)       g_combat_area[o]

/* Posizione di who in aim. */
static void aim_set_pos(CokAim *aim, Character *who)
{
    aim->x = combatant_x(who);
    aim->y = combatant_y(who);
}

/*
 * PORT H096+$284C: bersaglio dell'incantesimo spell.  Manuale (b12 = 0)
 * con la mira (H096+$4448) nella sua gittata (H033+$11FC); altrimenti per
 * il personaggio corrente: se l'incantesimo non vuole un bersaglio (+$E
 * nullo) se stesso (per la cura $3 il ferito vicino, H096+$25DA), se no
 * il bersaglio dell'IA (H096+$4B86), purche' non inerme per gli
 * incantesimi della lista $4066.  Trovato: posizione in $251A/$2518.
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
        H005_SET_W(0x251A, out->x);
        H005_SET_W(0x2518, out->y);
        return 1;
    }
    memset(out, 0, sizeof(*out));
    return 0;
}

/* Copia in g_spell_targets i combattenti trovati da H077+$08AC ($2A3E). */
static void targets_from_area(void)
{
    u16 i;                              /* -$4(a5) */

    for (i = 1; i <= H005_B(0x2479); ++i) {
        g_spell_targets[i - 1] = COMBATANT(H005_B(0x2A3E + (i - 1) * 4));
    }
    H005_B(0x246C) = H005_B(0x2479);
    H005_B(0x24A9) = 1;
}

/* t e' gia' fra i primi n bersagli? */
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
 * PORT H096+$2A6C (vettore $276C in combattimento): bersagli
 * dell'incantesimo secondo la tabella (+$6 & $F): 0 chi lancia; 5 piu'
 * bersagli finche' i dadi vita (+$DB, o per $4F la taglia) superano 2d4
 * (o il livello per $4F); 8..$E un'area attorno al punto scelto; $F il
 * bersaglio o un'area; altrimenti (+$6 & 3) + 1 bersagli distinti.
 * Senza bersagli *ok = 0.  Con nessun bersaglio scelto l'originale legge
 * la posizione dalla voce prima della tabella: qui resta quella di prima.
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
    H005_B(0x246C) = 0;
    H005_B(0x24A9) = 0;
    H005_SET_W(0x251A, combatant_x(g_current_char));
    H005_SET_W(0x2518, combatant_y(g_current_char));
    switch (mask_byte(SPELL_B(spell, 6), 0x0F)) {
    case 0:
        g_spell_targets[0] = g_current_char;
        H005_B(0x246C) = 1;
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
                    H005_SET_W(0x251A, combatant_x(aim.who));
                    H005_SET_W(0x2518, combatant_y(aim.who));
                    add_to_byte(&H005_B(0x246C), 1);
                    t = g_spell_targets[cnt - 1];
                    if (spell != 0x4F) {
                        switch (t->b[0xDB]) {
                        case 0: case 1: n = (u16)(n + 1); break;
                        case 2: n = (u16)(n + 2); break;
                        case 3: n = (u16)(n + 4); break;
                        default: n = (u16)(n + 8); break;
                        }
                    } else {
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
                H005_B(0x246C) = 1;
            } else {
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
                    H005_SET_W(0x251A, combatant_x(aim.who));
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
            H005_B(0x246C) = (u8)cnt;
            if (cnt == 0) {
                *ok = 0;
            } else {
                H005_SET_W(0x251A, combatant_x(g_spell_targets[cnt - 1]));
                H005_SET_W(0x2518, combatant_y(g_spell_targets[cnt - 1]));
            }
        }
        break;
    }
}

/*
 * PORT H096+$3100 (Cast in combattimento): sceglie l'incantesimo
 * (H065+$34FC) se non dato, rifiuta quelli solo da campo; senza tempo di
 * lancio (+$C / 3) lo lancia subito (H033+$1426), altrimenti "Begins
 * Casting": l'incantesimo nel turno, iniziativa ridotta del tempo e
 * riposizionamento nell'ordine dei turni.
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
        H005_B(0x24C6) = 1;
        H005_B(0x24C7) = 1;
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
    TURN(c)->b[0] = (u8)s;
    if (TURN_W(c, 4) > delay) {
        TURN_PUTW(c, 4, (u16)(TURN_W(c, 4) - delay));
    } else {
        TURN_PUTW(c, 4, 1);
    }
    i = H005_B(0x2480);
    p = g_turn_order[i];
    while (p != NULL) {
        if ((s16)TURN_W(p, 4) > (s16)TURN_W(c, 4) ||
            ((s16)TURN_W(p, 4) == (s16)TURN_W(c, 4) && roll_dice(1, 2) == 1)) {
            g_turn_order[i - 1] = p;
            ++i;
            p = g_turn_order[i];
        } else {
            break;
        }
    }
    g_turn_order[i - 1] = c;
    add_to_byte(&H005_B(0x2480), 0xFFFF);
    *done = 1;
}

/*
 * PORT H096+$3358: pugnalata alle spalle?  Un ladro (+$104, o +$10C se
 * puo' usare la classe precedente) senz'arma o con un'arma adatta ($43,
 * 3, 4, $11..$13), accanto a un bersaglio gia' attaccato (+$11 > 1), non
 * grande (+$D3 & $7F <= 1) e che gli volta le spalle.
 */
static u8 is_backstab(Character *a, Character *t)
{
    u8 ok = 0;                          /* -$B(a5) */
    CokItem *w;                         /* -$4(a5) */
    u16 type = 0;                       /* -$A(a5) */

    w = a->readied[0];
    if (w != NULL) {
        type = w->b[0x30];
    }
    if (a->b[0x104] > 0 || (a->b[0x10C] > 0 && h073_130a(a))) {
        if (w == NULL || type == 0x43 || type == 3 || type == 4 ||
            (type > 0x10 && type < 0x14)) {
            ok = 1;
        }
    }
    if (ok && TURN(t)->b[0x11] > 1 && combat_distance(a, t) < 2 &&
        mask_byte(t->b[0xD3], 0x7F) <= 1 &&
        TURN(t)->b[0x0B] == direction_toward(a, t)) {
        return 1;
    }
    return 0;
}

/*
 * PORT H096+$3492: animazione del proiettile dell'arma (secondo il tipo
 * +$30) da a a t, col suono.
 */
static void missile_attack(Character *a, Character *t, CokItem *item)
{
    u16 dir;                            /* -$6(a5) */
    u16 frames = 1;                     /* -$4(a5) */
    u16 speed = 2;                      /* -$8(a5) */
    u16 base = 0x0D;                    /* -$2(a5) */

    dir = direction_toward(a, t);
    switch (item->b[0x30]) {
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
 * PORT H096+$3852: il miglior movimento (meta' di H096+$023E) fra gli
 * avversari in piedi di c.
 */
u16 enemy_distance_points(Character *c)
{
    u16 best = 0;                       /* -$2(a5) */
    u16 v;                              /* -$4(a5) */
    Character *p;                       /* -$8(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
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
 * PORT H096+$38DC: attaccare t e' permesso?  Si' per un avversario o con
 * +$19A; per un alleato chiede "Attack Ally:" e con Y gli alleati
 * controllati dal computer (+$EC > $7F, non $B3) passano al nemico.
 */
u8 confirm_attack(Character *a, Character *t)
{
    Character *p;                       /* -$4(a5) */

    if (a->b[0x199] == other_side(t) || a->b[0x19A]) {
        return 1;
    }
    if (ask_yes_no(0x0D, "Attack Ally: ", 0x0D, 0x0A, 0x0F) != 'Y') {
        return 0;
    }
    H005_B(0x24DB) = 1;
    COK_PUT16(g_state_b + 0x666, 1);
    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0x197] == 0 && p->b[0xEC] != 0xB3 && p->b[0xEC] > 0x7F) {
            p->b[0x199] = 1;
            TURN(p)->target = NULL;
        }
    }
    count_sides();
    return 1;
}

/*
 * PORT H096+$39D0: riga della mira: distanza in vista (H077+$0378, su
 * $2ADE con +$8 a 1) e, nella gittata, "Target" se c puo' colpire cand;
 * poi il menu "Next Prev Manual [Target] Center Exit" (restituisce il
 * tasto).
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
        format_number(0x50, (char *)&g_h005[0x3C82], (s32)dist, 0, 0x0A, 2,
                      ' ');
        h026_append(0x28, line, 0x50, (const char *)&g_h005[0x3C82]);
        h026_append(0x28, line, 2, "  ");
        ui_draw_text(0, 0x17, 0x0A, 0, 0x28, line);
    }
    g_h005[0x3C82] = 0;
    if (dist <= range && flag) {
        if (mode == 0) {
            strcpy((char *)&g_h005[0x3C82], "Target ");
        } else if (c != cand) {
            if (!has_ranged_weapon(c)) {
                strcpy((char *)&g_h005[0x3C82], "Target ");
            } else if (find_weapon(c, &w)) {
                if (count_enemies_near(c, 1) == 0 || weapon_melee_ok(c)) {
                    strcpy((char *)&g_h005[0x3C82], "Target ");
                }
            }
        }
    }
    strcpy(line, "Next Prev Manual ");
    h026_append(0x28, line, 0x50, (const char *)&g_h005[0x3C82]);
    h026_append(0x28, line, 0x0B, "Center Exit");
    if (cand != NULL) {
        show_combatant_cursor(cand, 3, 1);
        H005_B(0x24C7) = 1;
        draw_combat_status(cand);
    }
    return ui_request_choice(4, "Aim:", 0x28, line, 0x0D, 0x0A, 0x0F, 1, 0,
                             &special);
}

/*
 * PORT H096+$3C48: conferma il bersaglio t della mira (per un attacco,
 * mode 1, anche verso un alleato, H096+$38DC); con mode 1 attacca: a
 * spazzata (H096+$1340) o normalmente, con l'arma a distanza se non e'
 * accanto.  Altrimenti la mira viene azzerata.
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
 * PORT H096+$3DBA (Manual): cursore sulla mappa del combattimento
 * ($2438/$2436, entro 50x25) mosso col tastierino; per la casella in
 * vista mostra la distanza e il combattente o il corpo; *ok se e' un
 * bersaglio valido (gittata, terreno, bersaglio attaccabile, b1c/b1e, e
 * per un attacco l'arma).  Target/Invio conferma (*done = 1 e la mira),
 * E o Esc annulla tornando a (x, y).
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

    H005_B(0x24CC) = 1;
    H005_SET_W(0x2438, (u16)x);
    H005_SET_W(0x2436, (u16)y);
    memset(out, 0, sizeof(*out));
    AREA_B(6) = 1;
    AREA_B(7) = 1;
    H005_B(0x24C5) = 0;
    while (key && key != 0x0D && key != 'T' && key != 'E') {
        center_view((s16)H005_W(0x2438), (s16)H005_W(0x2436), 2, dir);
        H005_SET_W(0x2438, (u16)((s16)H005_W(0x2438) + DX(dir)));
        H005_SET_W(0x2436, (u16)((s16)H005_W(0x2436) + DY(dir)));
        if ((s16)H005_W(0x2438) < 0) H005_SET_W(0x2438, 0);
        if ((s16)H005_W(0x2436) < 0) H005_SET_W(0x2436, 0);
        if ((s16)H005_W(0x2438) > 0x31) H005_SET_W(0x2438, 0x31);
        if ((s16)H005_W(0x2436) > 0x18) H005_SET_W(0x2436, 0x18);
        combat_map_cell((s16)H005_W(0x2438), (s16)H005_W(0x2436), &v, &tile);
        *ok = 0;
        dist = 0xFF;
        tx = (s16)H005_W(0x2438);
        ty = (s16)H005_W(0x2436);
        if (line_of_sight((s16)combatant_x(c), (s16)combatant_y(c), &tx, &ty,
                          &dist, g_combat_area)) {
            *ok = 1;
            if (mode != 0) {
                strcpy(line, "Range = ");
                format_number(0x50, (char *)&g_h005[0x3C82],
                              (s32)(dist >> 1), 0, 0x0A, 2, ' ');
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
                for (i = 1; i <= H005_B(0x247A); ++i) {
                    if (g_bodies[i - 1].x == H005_W(0x2438) &&
                        g_bodies[i - 1].y == H005_W(0x2436)) {
                        *cand = g_bodies[i - 1].who;
                    }
                }
            }
        }
        if (*cand != NULL) {
            H005_B(0x24C7) = 1;
            draw_combat_status(*cand);
        } else {
            clear_text_cells(0x17, 1, 0x26, 0x15);
        }
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
                                0x0A, 0x0F, 1, 0, &H005_B(0x249F));
        switch (key) {
        case 0x0D:
        case 'T':
            *done = 1;
            out->x = H005_W(0x2438);
            out->y = H005_W(0x2436);
            out->who = *cand;
            AREA_B(6) = 0;
            redraw_combat_cell((s16)H005_W(0x2438), (s16)H005_W(0x2436));
            H005_B(0x24C5) = 0;
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
            center_view((s16)H005_W(0x2438), (s16)H005_W(0x2436), 0, 8);
            dir = 8;
            break;
        case 0:
        case 'E':
            *done = 0;
            redraw_combat_cell((s16)H005_W(0x2438), (s16)H005_W(0x2436));
            memset(out, 0, sizeof(*out));
            out->x = (u16)x;
            out->y = (u16)y;
            center_view(x, y, 0, 8);
            AREA_B(6) = 0;
            H005_B(0x24C5) = 0;
            break;
        default:
            dir = 8;
            break;
        }
    }
    H005_B(0x24CC) = 0;
}

/* Stato della mira (locali di H096+$4448 usate dalle annidate). */
typedef struct AimState {
    u8 list[0x28][4];                   /* -$A0(a5): voci di $2A3E */
    u16 count;                          /* -$A4(a5) */
    u16 idx;                            /* -$A6(a5) */
    s16 px, py;                         /* -$AC, -$AE(a5) */
    s16 nx, ny;                         /* -$B0, -$B2(a5) */
} AimState;

/*
 * PORT H096+$4456: annidata: i combattenti nell'area attorno a c
 * (H077+$08AC) che c puo' attaccare.
 */
static void aim_build_list(AimState *s, Character *c)
{
    u16 i;                              /* -$2(a5) */

    find_in_area((s16)combatant_x(c), (s16)combatant_y(c), 0x7F, 0xFF,
                 combatant_size(c), g_combat_area);
    s->count = 0;
    for (i = 1; i <= H005_B(0x2479); ++i) {
        if (can_attack(c, COMBATANT(H005_B(0x2A3E + (i - 1) * 4)))) {
            ++s->count;
            memcpy(s->list[s->count - 1], &g_h005[0x2A3E + (i - 1) * 4], 4);
        }
    }
}

/*
 * PORT H096+$4530: annidata: passa al bersaglio successivo (step +1/-1,
 * a giro) e, con draw, fa scorrere il cursore dal precedente.  Con
 * l'elenco vuoto l'originale leggerebbe la voce -1: qui c resta.
 */
static Character *aim_next(AimState *s, Character *c, s16 step, u8 draw)
{
    Character *r;                       /* -$C(a5) */

    if (s->count == 0) {
        return c;
    }
    if (draw) {
        s->px = (s16)POS_X(s->list[s->idx - 1][0]);
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
    s->nx = (s16)POS_X(s->list[s->idx - 1][0]);
    s->ny = (s16)POS_Y(s->list[s->idx - 1][0]);
    if (draw) {
        animate_missile(s->px, s->py, s->nx, s->ny, 1, 0);
        s->px = s->nx;
        s->py = s->ny;
    }
    return r;
}

/*
 * PORT H096+$4448 (corpo a $46E4): mira di c entro range ($FF: la
 * gittata dell'arma pronta, o 1): Next/Prev fra i bersagli possibili,
 * Manual col cursore, Target conferma (con mode 1 attacca, H096+$3C48),
 * Center, Exit.  *found e out descrivono la scelta.
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
        if (!H005_B(0x249D)) {
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
        /* Con Manual su una casella vuota l'originale legge da NULL: qui no. */
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
 * PORT H096+$4B86: bersaglio dell'IA: tiene quello del turno se e' un
 * avversario in piedi attaccabile (con b0 si scarta comunque); altrimenti
 * fino a 20 estrazioni fra i nemici nel raggio (con l'effetto $5B il
 * preferito $2432 alla prima), scartando i non attaccabili; al secondo
 * giro (senza b0) anche fuori vista ($2ADE+8).
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
                COMBATANT(H005_B(0x2444)) == g_h005_2432 && tries == 0x13) {
                k = 1;
            } else {
                k = roll_dice(1, cnt);
            }
            if (NEAR(k) == 0) {
                continue;
            }
            t = COMBATANT(NEAR(k));
            if ((b_any && AREA_B(8)) || can_attack(c, t)) {
                found = 1;
                TURN(c)->target = t;
            } else {
                H005_B(0x2444 + k - 1) = 0;
                for (i = 1; i <= cnt; ++i) {
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

/* PORT H096+$4DE8: (comando Bandage o simile) sempre "non funziona": 0. */
u8 combat_bandage(void)
{
    return 0;
}
