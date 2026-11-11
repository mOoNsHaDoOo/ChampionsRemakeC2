/* H097: IA dei combattenti guidati dal computer. */
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

/* Dati del modulo sotto a4: g_h097_bss[0x42 - off] e' -off(a4). */
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
#define NEAR(i)         H005_B(0x2444 + (i) - 1)
#define COMBATANT(n)    g_combatants[(n) - 1]
#define POS_X(n)        H005_W(0x3154 + ((n) - 1) * 6)
#define POS_Y(n)        H005_W(0x3154 + ((n) - 1) * 6 + 2)
#define SPELL_B(s, o)   H005_B(0x66 + ((s) - 1) * 16 + (o))
#define WTAB(t, o)      H005_B(0x336C + (t) * 0x12 + (o))
#define H097_W(off)     COK_GET16(&g_h097_bss[0x42 - (off)])
#define H097_SETW(off, v) COK_PUT16(&g_h097_bss[0x42 - (off)], (v))

/*
 * PORT H097+$00B0: tasto premuto durante il turno di un mostro ($5305):
 * '2' magia on/off, spazio toglie il controllo del computer al party
 * (e il turno corrente finisce), 4 (H096+$4DE8).  Restituisce se un
 * tasto e' stato gestito.
 */
static u8 monster_keys(Character *c)
{
    u8 handled = 0;                     /* -$6(a5) */
    u8 key;                             /* -$5(a5) */
    u8 unused;                          /* -$7(a5) */
    Character *p;                       /* -$4(a5) */

    poll_intuition_events();
    if (!G_KEY) {
        return 0;
    }
    key = G_KEY;
    handled = 1;
    switch (key) {
    case '2':
        H005_B(0x24A0) = (u8)(H005_B(0x24A0) == 0);
        if (H005_B(0x24A0)) {
            show_message_line(8, "Magic On");
        } else {
            show_message_line(9, "Magic Off");
        }
        break;
    case ' ':
        for (p = g_party_head; p != NULL; p = p->next) {
            if (p->b[0xEC] < 0x80 && p->b[0x197] != 1) {
                p->b[0x19A] = 0;
            }
        }
        if (!c->b[0x19A]) {
            TURN_PUTW(c, 4, 0x14);
            if (TURN(c)->b[8] > 0) {
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
 * PORT H097+$0244: fine del turno del mostro: in guardia (H063+$2F5A) se
 * puo' ancora agire e non e' inerme ne' armato a distanza.
 */
static u8 monster_end(Character *c)
{
    clear_message_area();
    if (is_helpless(c) || has_ranged_weapon(c) || TURN_W(c, 4) == 0) {
        return end_combat_turn(c);
    }
    return guard_turn(c);
}

/*
 * PORT H097+$02B2: valore dell'arma it per c (tabella $336C): danno
 * medio, bonus, gittata, piu' 3 se a una mano; 0 se le mani non bastano,
 * se e' di un altro allineamento (+$46 = $84), del tipo $53 o
 * maledetta (+$3C).  La lancia $36 contro un non morto vale 8.
 */
static u16 weapon_value(Character *c, CokItem *it)
{
    u8 tab[0x12];                       /* -$14(a5) */
    u16 v;                              /* -$2(a5) */

    exec_copy_mem(&g_h005[0x336C + it->b[0x30] * 0x12], tab, 0x12);
    v = (u16)(tab[0x0B] * tab[0x0A]);
    if ((s16)COK_GET16(it->b + 0x36) > 0) {
        v = (u16)(v + COK_GET16(it->b + 0x36) * 8);
    }
    if ((s16)COK_GET16(tab + 0x0C) > 0) {
        v = (u16)(v + COK_GET16(tab + 0x0C) * 2);
    }
    if (it->b[0x30] == 0x36 && TURN(c)->target != NULL &&
        TURN(c)->target->b[0xDF] > 0) {
        v = 8;
    }
    if (mask_byte(tab[0x10], 8)) {
        v = (u16)(v + (tab[6] - 1) * 2);
    }
    if (tab[1] <= 1) {
        v = (u16)(v + 3);
    }
    if ((u16)(tab[1] + c->b[0x188]) > 3) {
        v = 0;
    }
    if (it->b[0x46] == 0x84 && mask_byte(it->b[0x45], 0x0F) != c->b[0x10F]) {
        v = 0;
    }
    if (it->b[0x45] == 0x53) {
        v = 0;
    }
    if (it->b[0x3C]) {
        v = 0;
    }
    return v;
}

/*
 * PORT H097+$043A: morale del mostro: costretto a fuggire (+$12 del
 * turno), o per i mostri (+$EC > $7F) tiri contro le ferite e la forza
 * del gruppo ($2481): fugge se e' piu' veloce dei nemici (togliendo gli
 * effetti $4A e $4B), altrimenti con +$13 > 5 si arrende.  Con il massimo
 * dei punti ferita a 0 l'originale divide per 0: qui conta come illeso.
 */
static u8 monster_morale(Character *c)
{
    u16 saved;                          /* -$4(a5) */
    u16 best;                           /* -$2(a5) */
    u16 hurt;

    TURN(c)->b[0x16] = 0;
    h062_nop_1898();
    if (TURN(c)->b[0x12]) {
        TURN(c)->b[0x16] = 1;
        show_char_message(c, 0x11, "is forced to flee", 0x0A, 1);
        return 0;
    }
    if (c->b[0xEC] <= 0x7F) {
        return 0;
    }
    H005_B(0x2478) = (u8)(mask_byte(c->b[0xEC], 0x7F) * 2);
    if (H005_B(0x2478) > 0x66) {
        H005_B(0x2478) = 0;
    }
    trigger_event(&c, 0x11);
    hurt = (u16)(c->b[0x64] ? (u16)(c->b[0x1A8] * 0x64) / c->b[0x64] : 0x64);
    if (!(H005_B(0x2478) < (u16)(0x64 - hurt)) && H005_B(0x2478) != 0) {
        return 0;
    }
    saved = H005_B(0x2478);
    (void)saved;
    H005_B(0x2478) = H005_B(0x2481);
    trigger_event(&c, 0x11);
    if (!(H005_B(0x2478) < (u16)(0x64 - COK_GET16(g_state_b + 0x58C))) &&
        H005_B(0x2478) != 0 && c->b[0x199]) {
        return 0;
    }
    best = enemy_distance_points(c);
    if ((u16)(movement_points(c) >> 1) >= best) {
        TURN(c)->b[0x16] = 1;
        remove_effect(c, 0x4A, NULL);
        remove_effect(c, 0x4B, NULL);
        return 0;
    }
    if (c->b[0x13] > 5) {
        fall_down(c, 4, 0x0A, "Surrenders");
        return end_combat_turn(c);
    }
    return 0;
}

/*
 * PORT H097+$062E: annidata: un alleato nell'area dell'incantesimo
 * attorno a (x, y) che fallisce il tiro salvezza (bonus -2 per il party,
 * 8 per i mostri) sarebbe colpito?
 */
static u8 spell_hits_ally(u16 spell, s16 x, s16 y)
{
    s16 bonus;                          /* -$4(a5) */
    u16 i;                              /* -$2(a5) */
    Character *e;

    bonus = (s16)(g_current_char->b[0x199] == 0 ? -2 : 8);
    find_in_area(x, y, SPELL_B(spell, 0x0F), 0xFF, 1, g_combat_area);
    for (i = 1; i <= H005_B(0x2479); ++i) {
        e = COMBATANT(H005_B(0x2A3E + (i - 1) * 4));
        if (e->b[0x199] != other_side(g_current_char) &&
            SPELL_B(spell, 8) != 1 &&
            !saving_throw_roll(e, SPELL_B(spell, 9), bonus)) {
            return 1;
        }
    }
    return 0;
}

/*
 * PORT H097+$0620 (corpo a $075C): l'incantesimo spell (livello +$D
 * almeno level) e' utile a c?  Senza bersaglio o di cura (se c'e' un
 * ferito) si'; altrimenti servono nemici nella gittata e, per un'area
 * (+$F), che nessun alleato attorno a loro ne sia colpito.  Dove
 * l'originale restituisce un registro non impostato qui 0.
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
        if (spell_hits_ally(spell, (s16)POS_X(NEAR(i)), (s16)POS_Y(NEAR(i)))) {
            return 0;
        }
    }
    return 1;
}

/*
 * PORT H097+$0890: il mostro usa un oggetto magico pronto (non una
 * pergamena, +$46 < $80) con un incantesimo utile: 1d7 tentativi con
 * livello minimo da 7 in giu'.  Gli incantesimi oltre $38 valgono -$17.
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
    if (TURN(c)->b[2] && H005_B(0x2A1C + other_side(c)) > 0 &&
        COK_GET16(g_state_a + 0x1CA) == 0) {
        for (i = 1; i <= tries; ++i) {
            for (it = c->items; it != NULL && found == NULL; it = it->next) {
                sp = it->b[0x45];
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
 * PORT H097+$0A04: il mostro chierico scaccia i non morti se ne vede e
 * non l'ha gia' fatto $248F volte.  Il tipo massimo passato a H096+$1B04
 * nell'originale non e' inizializzato: qui $FF.
 */
static u8 monster_turn_undead(Character *c)
{
    Character *t;                       /* -$4(a5) */
    u8 max = 0xFF;                      /* -$5(a5) */

    if (TURN(c)->b[0x13] < H005_B(0x248F) &&
        (c->b[0xFE] > 0 || c->b[0x106] > c->b[0xDC]) &&
        find_undead(c, &t, &max)) {
        turn_undead(c);
        return 1;
    }
    return 0;
}

/*
 * PORT H097+$0A88: il mostro lancia un incantesimo memorizzato utile
 * (con la magia attiva per il party): 1d7 giri da 3 estrazioni, livello
 * minimo da 7 in giu'.
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

    if (TURN(c)->b[1]) {
        for (k = 1; k <= 0x39; ++k) {
            if (c->b[0x1E + k] > 0) {
                list[n] = c->b[0x1E + k];
                ++n;
            }
        }
    }
    tries = roll_dice(1, 7);
    i = 1;
    if (n > 0 && (c->b[0xEC] > 0x7F || H005_B(0x24A0)) &&
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
 * PORT H097+$0C14: il mostro sceglie le armi: la migliore da lancio o a
 * distanza (con munizioni), la migliore da mischia, lo scudo migliore
 * (classe d'armatura +$36); le prepara (H065+$2C04) se diverse da quelle
 * pronte e non maledette, rispettando le mani (+$188).
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
        c->b[0x188] = (u8)(c->b[0x188] - WTAB(c->readied[0]->b[0x30], 1));
    }
    if (c->readied[1] != NULL) {
        c->b[0x188] = (u8)(c->b[0x188] - WTAB(c->readied[1]->b[0x30], 1));
    }
    s2 = (u16)(c->b[0x114] * c->b[0x112]);
    if ((s16)CH_W(c, 0x116) > 0) {
        s2 = (u16)(s2 + CH_W(c, 0x116) * 2);
    }
    for (it = c->items; it != NULL; it = it->next) {
        t = it->b[0x30];
        if (WTAB(t, 0) == 0 && mask_byte(WTAB(t, 0x0F), c->b[0x122])) {
            v = weapon_value(c, it);
            if (mask_byte(WTAB(t, 0x10), 8) || mask_byte(WTAB(t, 0x10), 0x10)) {
                if (v > s1) {
                    best = it;
                    s1 = v;
                }
            }
            if (!mask_byte(WTAB(t, 0x10), 8) && v > s2) {
                melee = it;
                s2 = v;
            }
        }
        if (WTAB(t, 0) == 1 && mask_byte(WTAB(t, 0x0F), c->b[0x122]) > 0) {
            if ((s16)COK_GET16(it->b + 0x36) >= 0) {
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
    ranged = (u8)(best != NULL && WTAB(best->b[0x30], 0x0E) > 1 &&
                  mask_byte(WTAB(best->b[0x30], 0x10), 0x14) == 0x14);
    if (best != NULL) {
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
        (c->readied[0] == chosen || c->readied[0]->b[0x3C])) {
        need = 0;
    }
    if (need) {
        if (c->readied[0] != NULL) {
            ready_item(c->readied[0]);
        }
        recompute_stats(c);
        if (c->readied[1] != NULL && !c->readied[1]->b[0x3C]) {
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
        (c->readied[1] == shield || c->readied[1]->b[0x3C])) {
        need = 0;
    }
    if (c->b[0x188] > 2) {
        if (c->readied[1] == NULL || c->readied[1]->b[0x3C]) {
            if (chosen != NULL) {
                ready_item(chosen);
            }
            changed = 1;
        } else {
            ready_item(c->readied[1]);
            changed = 1;
        }
    } else if (c->b[0x188] < 2 && need) {
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
 * PORT H097+$11EE: il passo k (della sequenza +$17 del turno nella
 * tabella del modulo) dalla direzione dir e' possibile?  Il costo del
 * terreno (x3 in diagonale) deve stare nei punti movimento; nuvole e
 * acido lo rendono impossibile senza protezione.  *edge = 1 fuori mappa.
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
    d = (u16)((dir + H097_W(0x3C - (TURN(c)->b[0x17] - 1) * 10 - (k - 1) * 2))
              & 7);
    probe_move(c, d, &blk, &tile, &cloud, &acid);
    if (tile == 0) {
        *edge = 1;
        return ok;
    }
    if (H005_B(0x3EF4 + (tile - 1) * 4) == 0xFF) {
        return 0;
    }
    if (d & 1) {
        cost = (u16)(H005_B(0x3EF4 + (tile - 1) * 4) * 3);
    } else {
        cost = (u16)(H005_B(0x3EF4 + (tile - 1) * 4) * 2);
    }
    if (blk != 0 || !(cost < TURN(c)->b[8])) {
        return ok;
    }
    if (cloud && !find_effect(c, 0x20, &e) && !find_effect(c, 0x1E, &e) &&
        !find_effect(c, 0x63, &e) && !find_effect(c, 0x3F, &e) &&
        !TURN(c)->b[0x12] && !saving_throw_roll(c, 0, 0)) {
        cost = (u16)(TURN(c)->b[8] + 1);
    }
    if (acid && c->b[0xDB] < 7 && !find_effect(c, 0x63, &e) &&
        !TURN(c)->b[0x12]) {
        cost = (u16)(TURN(c)->b[8] + 1);
    }
    if (TURN(c)->b[8] >= cost) {
        ok = 1;
    }
    return ok;
}

/*
 * PORT H097+$142C: un passo del mostro verso il bersaglio (o in fuga,
 * lontano dal party) provando fino a 5 direzioni della sequenza +$17;
 * tornare indietro o non trovare passi cambia sequenza e alla lunga
 * bersaglio o turno.  Mostra "Move/Attack, Move Left = n".
 */
static u8 monster_move(Character *c)
{
    char num[0x52];                     /* -$60(a5) */
    u16 dir = 0;                        /* -$2(a5) */
    u16 ndir = 0;                       /* -$4(a5) */
    u16 k;                              /* -$6(a5) */
    u8 edge = 0;                        /* -$7(a5) */
    u8 done = 0;                        /* -$8(a5) */

    strcpy((char *)&g_h005[0x3C82], "Move/Attack, Move Left = ");
    format_number(0x50, num, (s32)(TURN(c)->b[8] >> 1), 0, 0x0A, 2, ' ');
    h026_append(0x50, num, 1, " ");
    h026_append(0x50, (char *)&g_h005[0x3C82], 0x50, num);
    ui_draw_text(0, 0x18, 0x0A, 0, 0x50, (const char *)&g_h005[0x3C82]);
    if (monster_keys(c)) {
        return done;
    }
    if (!((TURN(c)->b[8] >> 1) > 0 && (s16)TURN_W(c, 4) > 0)) {
        return monster_end(c);
    }
    if (c->b[0xEC] >= 0x80 &&
        (u16)(roll_dice(1, 0x64) + H005_B(0x2478)) < H005_B(0x2481) &&
        c->b[0x199] != 1) {
        return monster_end(c);
    }
    if (!TURN(c)->b[0x16] && c->readied[2] == NULL && c->b[0x5C] == 5) {
        return monster_end(c);
    }
    if (!TURN(c)->b[0x16]) {
        dir = direction_toward(c, TURN(c)->target);
    } else {
        TURN(c)->b[0x17] = (u8)roll_dice(1, 2);
        dir = (u16)(H005_B(0x2820) - (((H005_B(0x2820) + 2) & 3) >> 1));
        if (!c->b[0x199]) {
            dir = (u16)(dir + 4);
        }
        dir &= 7;
    }
    k = 1;
    while (k < 6 && !done) {
        if (monster_step_ok(c, k, dir, &edge)) {
            break;
        }
        if (TURN(c)->b[0x16] && edge) {
            done = combat_flee(c);
        } else {
            ++k;
        }
    }
    if (done) {
        TURN(c)->b[8] = 0;
        TURN(c)->b[0x16] = 0;
        return end_combat_turn(c);
    }
    if (k < 6) {
        ndir = (u16)((dir + H097_W(0x3C - (TURN(c)->b[0x17] - 1) * 10 -
                                   (k - 1) * 2)) & 7);
    }
    if (k == 6 || ((ndir + 4) & 7) == H097_W(0x3E)) {
        H097_SETW(0x40, (u16)(H097_W(0x40) + 1));
        TURN(c)->b[0x17] = (u8)(TURN(c)->b[0x17] % 6 + 1);
        if (H097_W(0x40) > 1) {
            TURN(c)->target = NULL;
            if (H097_W(0x40) > 2) {
                TURN(c)->b[8] = 0;
                done = 1;
            } else if (!ai_pick_target(c, 0xFF, 1, 0)) {
                done = monster_end(c);
            }
        }
    }
    if (k < 6) {
        H097_SETW(0x3E, ndir);
    } else {
        done = 1;
    }
    if (done) {
        return done;
    }
    H005_B(0x24C6) = (u8)(H005_B(0x24C8) || combatant_visible(c, 0) ||
                          c->b[0x199] == 0);
    set_combatant_frame(c, (u8)ndir, 0, 0);
    combat_leave_attacks(c, TURN(c)->b[0x0B]);
    if (!c->b[0x198]) {
        return end_combat_turn(c);
    }
    if (TURN(c)->b[8] > 0) {
        combat_step(c, TURN(c)->b[0x0B]);
    }
    if (!c->b[0x198] || is_helpless(c)) {
        done = end_combat_turn(c);
    }
    check_cloud(c, 1);
    return done;
}

/*
 * PORT H097+$18D2: il mostro attacca: fugge se deve, poi finche' ha
 * azioni (al massimo 20 giri) cerca il bersaglio nella gittata
 * dell'arma (in vista) o un nemico vicino; altrimenti si avvicina
 * (H097+$142C).  Attacco a spazzata o normale, con l'arma a distanza se
 * non e' accanto.  Restituisce 1 se il turno e' finito.
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

    H097_SETW(0x3E, 8);
    H097_SETW(0x40, 0);
    H097_SETW(0x42, 0);
    trigger_event(&c, 0x0E);
    if (!c->b[0x199] && bandage_dying(1)) {
        TURN_PUTW(c, 4, 0);
    }
    if (TURN_W(c, 4) == 0) {
        cont = 0;
    }
    while (!done && cont) {
        while (TURN(c)->b[0x16] && TURN(c)->b[8] > 0 &&
               (s16)TURN_W(c, 4) > 0 && (s16)TURN_W(c, 4) < 0x14) {
            (void)monster_move(c);
        }
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
        H005_B(0x24C8) = 0;
        range = 1;
        if (c->readied[0] != NULL) {
            range = (u16)(WTAB(c->readied[0]->b[0x30], 0x0E) - 1);
        }
        if (range == 0 || range >= 0xFF) {
            range = 1;
        }
        t = TURN(c)->target;
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
                H005_B(0x24C8) = 1;
            }
        }
        if (!H005_B(0x24C8)) {
            n = count_enemies_near(c, range);
            if (n == 0) {
                if (ai_pick_target(c, 0xFF, 0, 0)) {
                    (void)monster_move(c);
                } else {
                    done = monster_end(c);
                }
            } else {
                t = COMBATANT(NEAR(roll_dice(1, n)));
                if (has_ranged_weapon(c) && !weapon_melee_ok(c) &&
                    count_enemies_near(c, 1) > 0) {
                    monster_choose_weapons(c);
                    done = 1;
                } else if (combat_distance(c, t) == 1 || can_attack(c, t)) {
                    H005_B(0x24C8) = 1;
                }
            }
        }
        if (H005_B(0x24C8)) {
            center_view((s16)combatant_x(c), (s16)combatant_y(c), 2,
                        direction_toward(c, t));
        }
        if (!H005_B(0x24C8)) {
            continue;
        }
        if (combat_sweep(c, t)) {
            done = end_combat_turn(c);
            continue;
        }
        record_attack(c, t);
        w = NULL;
        if (has_ranged_weapon(c)) {
            H005_B(0x24C8) = find_weapon(c, &w);
            if (weapon_melee_ok(c) && combat_distance(c, t) == 1) {
                w = NULL;
            }
        }
        combat_attack(c, t, 0, w, &done);
        if (done) {
            TURN(c)->b[8] = 0;
            cont = 0;
        } else if (!t->b[0x198]) {
            done = 1;
        }
    }
    return (u8)(cont == 0);
}

/*
 * PORT H097+$1D68: turno di un combattente guidato dal computer: tasti,
 * sequenza di movimento (+$17), morale ("flees in panic"), poi nell'ordine
 * oggetto magico, incantesimo in corso, Turn Undead, incantesimo, e
 * infine scelta delle armi e attacco o fine turno.
 */
void monster_turn(Character *c)
{
    u8 done;                            /* -$3(a5) */
    u16 m;                              /* -$2(a5) */

    done = monster_keys(c);
    clear_message_line();
    clear_message_area();
    if (!c->b[0x198]) {
        done = end_combat_turn(c);
    }
    m = TURN(c)->b[0x17];
    if (m == 0 || m > 4 || roll_dice(1, 4) == 1) {
        m = roll_dice(1, 8);
        if (m == 8) {
            m = (u16)(roll_dice(1, 2) + 4);
        } else {
            m = roll_dice(1, 4);
        }
    }
    TURN(c)->b[0x17] = (u8)m;
    if (!done) {
        done = monster_morale(c);
    }
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
    if (TURN(c)->b[0] > 0) {
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
        if (ai_pick_target(c, 0xFF, 1, 0) && (s16)TURN_W(c, 4) > 0 &&
            c->b[0x198]) {
            done = monster_attack(c);
        } else {
            done = monster_end(c);
        }
    }
}
