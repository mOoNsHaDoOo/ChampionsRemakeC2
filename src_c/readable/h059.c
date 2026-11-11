/* H059: ciclo del combattimento tattico e turni degli attori. */
#include "h059.h"
#include "globals.h"
#include "unported.h"
#include "h003_exec.h"
#include "h008.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h033.h"
#include "h036.h"
#include "h045.h"
#include "h048.h"
#include "h058.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include "h095.h"
#include "h096.h"
#include "h097.h"
#include <string.h>

/*
 * Ordine dei turni del round (H005+$2392).  L'originale azzera 40 voci
 * ($A0 byte) ma scorre fino a $48: le voci oltre la 40 coincidono con
 * $2432..; la lista e' chiusa da NULL e non le raggiunge con al massimo
 * 40 combattenti.  Qui 72 voci.
 */
Character *g_turn_order[0x48];

/* PORT H059+$0122: link/unlk, nessun effetto. */
void h059_init(void)
{
}

/*
 * PORT H059+$0130: ordina i personaggi per iniziativa (+$4 del turno,
 * dalla piu' alta; a parita' a caso) in H005+$2392.
 */
static void build_turn_order(void)
{
    Character *p;                       /* -$6(a5) */
    Character *moved;                   /* -$A(a5) */
    Character *next;                    /* -$E(a5) */
    s16 v;                              /* -$10(a5) */
    s16 w;                              /* -$12(a5) */
    u16 i;                              /* -$14(a5) */
    u16 j;                              /* -$16(a5) */
    u8 go;                              /* -$1(a5) */

    memset(g_turn_order, 0, 0xA0 / 4 * sizeof(Character *));
    for (p = g_party_head; p != NULL; p = p->next) {
        i = 1;
        go = 1;
        v = (s16)COK_GET16(&p->block_192->b[4]);
        while (i < 0x41 && go) {
            if (g_turn_order[i - 1] != NULL) {
                w = (s16)COK_GET16(&g_turn_order[i - 1]->block_192->b[4]);
            } else {
                w = -1;
            }
            if (v > w || (v == w && roll_dice(1, 2) == 1)) {
                go = 0;
            } else {
                ++i;
            }
        }
        moved = g_turn_order[i - 1];
        g_turn_order[i - 1] = p;
        if (moved != NULL) {
            j = i;
            go = 1;
            while (j < 0x48 && go) {
                ++j;
                next = g_turn_order[j - 1];
                g_turn_order[j - 1] = moved;
                moved = next;
                if (next == NULL) {
                    go = 0;
                }
            }
        }
    }
}

/*
 * PORT H059+$02AA: fine del combattimento: libera nubi e pozze, chi era
 * incantato torna (stato 3 se restano piu' nemici), gli effetti legati
 * al combattimento cadono, si liberano la mappa e le icone; il gestore
 * $276C torna quello degli incantesimi fuori combattimento.
 */
static void end_combat_cleanup(void)
{
    CokCloud *next;                     /* -$4(a5) */
    Character *p;                       /* -$8(a5) */
    CokEffect *e;                       /* -$C(a5) */

    while (g_clouds != NULL) {
        next = g_clouds->next;
        exec_free_mem(g_clouds, sizeof(CokCloud));
        g_clouds = next;
    }
    while (g_acid_pools != NULL) {
        next = g_acid_pools->next;
        exec_free_mem(g_acid_pools, sizeof(CokCloud));
        g_acid_pools = next;
    }
    for (p = g_party_head; p != NULL; p = p->next) {
        if (find_effect(p, 0x0B, &e) && p->b[0x197] == 0) {
            if (H005_B(0x2A1D) > 1) {
                p->b[0x197] = 3;
            } else {
                p->b[0x197] = 0;
            }
        }
        drop_effects(p);
    }
    exec_free_mem(g_combat_area, 0x9CE);
    g_combat_area = NULL;
    free_gfx_record(&g_gfx_243a);
    g_handlers_25c0[107] = (CokHandler)select_spell_target;   /* H033+$12D4 */
}

/*
 * PORT H059+$03BE: menu del turno: Move (se ha movimento), View Aim, Use
 * (se ha oggetti), Cast (se ha incantesimi e puo'), Turn (chierici che
 * possono scacciare), Yell (paladini senza bersaglio scelto), Done.
 * Restituisce in *key la scelta (lettere, spazio o un tasto speciale
 * 1/2/3/4/$13).
 */
static void combat_menu(Character *c, u8 *key)
{
    char line[0x29];                    /* -$2A(a5) */
    u16 i;                              /* -$2C(a5) */
    u8 flag;                            /* -$2D(a5) */

    line[0] = '\0';
    if (c->block_192->b[8] > 0) {
        h026_copy(0x28, line, 5, "Move ");
    }
    h026_append(0x28, line, 9, "View Aim ");
    if (c->b[0x14F] > 0) {
        h026_append(0x28, line, 4, "Use ");
    }
    flag = 0;
    for (i = 0; i <= 0x39; ++i) {
        if (c->b[0x1E + i] > 0) {
            flag = 1;
        }
    }
    if (flag && c->block_192->b[1] && COK_GET16(g_state_a + 0x1CA) == 0) {
        h026_append(0x28, line, 5, "Cast ");
    }
    if (c->b[0xFE] > 0 && c->block_192->b[0x13] < H005_B(0x248F)) {
        h026_append(0x28, line, 5, "Turn ");
    }
    if (c->b[0x5B] == 5 && g_h005_2432 == NULL) {
        h026_append(0x28, line, 5, "Yell ");
    }
    h026_append(0x28, line, 4, "Done");
    do {
        *key = ui_request_choice(0, "", 0x28, line, 0x0D, 0x0A, 0x0F, 1, 0,
                                 &flag);
        if (flag && *key != 3 && *key != 1 && *key != 2 && *key != 4 &&
            *key != 0x13) {
            *key = 0;
        }
    } while (*key != 'M' && *key != 'V' && *key != 'A' && *key != 'U' &&
             *key != 'C' && *key != 'T' && *key != 'Q' && *key != 'D' &&
             *key != 'Y' && *key != 2 && *key != ' ' && *key != 3 &&
             *key != 1 && *key != 4 && *key != 0x13);
    clear_message_line();
}

/*
 * PORT H059+$0670: attacco di actor a target (dal movimento): un'arma a
 * distanza che non colpisce da vicino non serve; altrimenti, se puo'
 * attaccare, target diventa il bersaglio e parte l'attacco.
 */
static void melee_attack(Character *actor, Character *target, u8 *done)
{
    if (has_ranged_weapon(actor) && !weapon_melee_ok(actor)) {
        show_message_line(0x14, "Not with that weapon");
        return;
    }
    if (!confirm_attack(actor, target)) {
        return;
    }
    actor->block_192->target = target;
    if (combat_sweep(actor, target)) {
        *done = 1;
        return;
    }
    record_attack(actor, target);
    combat_attack(actor, target, 0, NULL, done);
}

/* Variabili di H059+$0726 lette dalla procedura annidata $0734. */
typedef struct MoveFrame {
    Character *c;                       /* $12(a5) */
    u8 *done;                           /* $C(a5) */
    u16 moves;                          /* -$2(a5) */
    u16 facing;                         /* -$4(a5) */
    s16 x0;                             /* -$6(a5) */
    s16 y0;                             /* -$8(a5) */
    u16 dir;                            /* -$E(a5) */
} MoveFrame;

/*
 * PORT H059+$0734 (annidata in $0726): Esc annulla il movimento: c torna
 * dov'era con il movimento e la direzione di prima.
 */
static void cancel_move(MoveFrame *f)
{
    f->c->block_192->b[8] = (u8)f->moves;
    redraw_ground(0, 0, combatant_index(f->c));
    *f->done = (u8)!place_combatant(f->c, (u8)f->x0, (u8)f->y0, 0);
    center_view((s16)combatant_x(f->c), (s16)combatant_y(f->c), 0, 8);
    f->c->block_192->b[0x0B] = (u8)f->facing;
    f->dir = 8;
}

/*
 * PORT H059+$0726: modo movimento/attacco: "Move/Attack, Move Left = n"
 * e le frecce (codici speciali $47..$51 del tastierino): verso un
 * combattente attacca, verso fuori mappa chiede "Flee:", altrimenti si
 * muove se il costo della casella (doppio, triplo in diagonale) e'
 * coperto dal movimento rimasto.  Esc annulla, Invio o 'D' chiudono.
 */
static void move_mode(Character *c, u8 key, u8 *done)
{
    MoveFrame f;
    u16 blocker;                        /* -$10(a5) */
    u16 tile;                           /* -$12(a5) */
    u8 k;                               /* -$13(a5) */
    u8 in_cloud;                        /* -$14(a5) */
    u8 in_acid;                         /* -$15(a5) */
    u16 cost;                           /* -$18(a5) */
    char msg[0x51];                     /* -$6A(a5) */

    H005_B(0x24CB) = 1;
    f.c = c;
    f.done = done;
    f.moves = c->block_192->b[8];
    f.facing = c->block_192->b[0x0B];
    f.x0 = (s16)combatant_x(c);
    f.y0 = (s16)combatant_y(c);
    k = key;
    *done = 0;
    f.dir = 8;
    /*
     * L'originale ricontrolla all'uscita (k = ' ' senza *done): con la
     * condizione del ciclo quel caso non si presenta.
     */
    while (k != 0 && k != 0x0D && k != 'D' && !*done) {
        clear_text_cells(0x18, 0x18, 0x27, 0x18);
        if (k == ' ') {
            h026_copy(0x50, msg, 0x19, "Move/Attack, Move Left = ");
            format_number(0x50, (char *)&H005_B(0x3C82),
                          (s32)(c->block_192->b[8] >> 1), 0, 0x0A, 2, ' ');
            h026_append(0x50, msg, 0x50, (const char *)&H005_B(0x3C82));
            k = ui_request_choice(0x50, msg, 5, " Done", 0x0D, 0x0A, 0x0F, 1,
                                  0, &H005_B(0x249F));
        }
        switch (k) {
        case 0:    cancel_move(&f); break;
        case 0x48: f.dir = 0; break;
        case 0x49: f.dir = 1; break;
        case 0x4D: f.dir = 2; break;
        case 0x51: f.dir = 3; break;
        case 0x50: f.dir = 4; break;
        case 0x4F: f.dir = 5; break;
        case 0x4B: f.dir = 6; break;
        case 0x47: f.dir = 7; break;
        default:   f.dir = 8; break;
        }
        if (f.dir < 8) {
            set_combatant_frame(c, (u8)f.dir, 0, 0);
            probe_move(c, f.dir, &blocker, &tile, &in_cloud, &in_acid);
            if (blocker > 0) {
                melee_attack(c, g_combatants[blocker - 1], done);
            } else if (tile == 0) {
                switch (ask_yes_no(5, "Flee:", 0x0D, 0x0A, 0x0F)) {
                case 'Y': *done = combat_flee(c); break;
                case 'N': *done = 0; break;
                default: break;
                }
            } else {
                if (f.dir & 1) {
                    cost = (u16)(H005_B(0x3EF4 + (tile - 1) * 4) * 3);
                } else {
                    cost = (u16)(H005_B(0x3EF4 + (tile - 1) * 4) * 2);
                }
                if (H005_B(0x3EF4 + (tile - 1) * 4) == 0xFF) {
                    cost = 0xFF;
                }
                if (cost > c->block_192->b[8]) {
                    show_message_line(0x0E, "can't go there");
                } else {
                    combat_leave_attacks(c, f.dir);
                    if (!c->b[0x198]) {
                        *done = end_combat_turn(c);
                    } else {
                        if (c->block_192->b[8] > 0) {
                            combat_step(c, f.dir);
                        }
                        if (!c->b[0x198]) {
                            *done = end_combat_turn(c);
                        }
                        check_cloud(c, 1);
                        if (is_helpless(c)) {
                            *done = end_combat_turn(c);
                        }
                    }
                }
            }
        }
        if (k != 0 && k != 0x0D && k != 'D') {
            k = ' ';
        }
    }
    if (c->block_192->b[8] < 2) {
        c->block_192->b[8] = 0;
    }
    H005_B(0x24CB) = 0;
}

/*
 * PORT H059+$0CCA: velocita' del gioco: "gameSpeed (n) :" con Slower (fino
 * a 9) e Faster (fino a 0) su H005+$3DF6.
 */
static void game_speed_menu(void)
{
    char title[0x29];                   /* -$54(a5) */
    char line[0x29];                    /* -$2A(a5) */
    u8 key = ' ';                       /* -$55(a5) */

    while (key != 'E' && key != 0) {
        h026_copy(0x28, title, 0x0B, "gameSpeed (");
        format_number(0x28, line, (s32)H005_W(0x3DF6), 0, 0x0A, 1, ' ');
        h026_append(0x28, line, 3, ") :");
        h026_append(0x28, title, 0x28, line);
        strcpy(line, " ");
        if (H005_W(0x3DF6) < 9) {
            h026_append(0x28, line, 7, "Slower ");
        }
        if (H005_W(0x3DF6) > 0) {
            h026_append(0x28, line, 7, "Faster ");
        }
        h026_append(0x28, line, 4, "Exit");
        key = ui_request_choice(0x28, title, 0x28, line, 0x0D, 0x0A, 0x0F, 0,
                                0, &H005_B(0x249F));
        switch (key) {
        case 'S': H005_SET_W(0x3DF6, H005_W(0x3DF6) + 1); break;
        case 'F': H005_SET_W(0x3DF6, H005_W(0x3DF6) - 1); break;
        default: break;
        }
    }
}

/* PORT H059+$0E4A: c passa al controllo automatico e lascia un bersaglio alleato. */
static void set_auto(Character *c)
{
    c->b[0x19A] = 1;
    if (c->block_192->target != NULL &&
        c->block_192->target->b[0x199] == c->b[0x199]) {
        c->block_192->target = NULL;
    }
}

/*
 * PORT H059+$0EA0: sottomenu "Done": Guard (se non ha un'arma solo a
 * distanza), Delay (passa in fondo all'ordine del round), Quit (fine
 * turno), Bandage (se un compagno muore), Auto (il computer gioca per
 * lui), Speed, Exit.
 */
static void done_menu(Character *c, u8 *done)
{
    char line[0x29];                    /* -$2A(a5) */
    u8 key = ' ';                       /* -$2B(a5) */
    Character *p;                       /* -$30(a5) */
    u16 i;                              /* -$32(a5) */

    *done = 0;
    line[0] = '\0';
    if (!has_ranged_weapon(c) || weapon_melee_ok(c)) {
        h026_copy(0x28, line, 6, "Guard ");
    }
    h026_append(0x28, line, 0x0B, "Delay Quit ");
    if (bandage_dying(0)) {
        h026_append(0x28, line, 8, "Bandage ");
    }
    h026_append(0x28, line, 0x0F, "Auto Speed Exit");
    while (key != 'E' && key != 0 && !*done) {
        key = ui_request_choice(0, "", 0x28, line, 0x0D, 0x0A, 0x0F, 0, 0,
                                &H005_B(0x249F));
        switch (key) {
        case 'G':
            *done = guard_turn(c);
            break;
        case 'D':
            COK_PUT16(&c->block_192->b[4], 1);
            i = H005_B(0x2480);
            p = g_turn_order[i];
            while (p != NULL && i < 0x48) {
                g_turn_order[i - 1] = p;
                ++i;
                /* l'originale legge anche la voce $48 (fuori tabella) */
                p = (i < 0x48) ? g_turn_order[i] : NULL;
            }
            g_turn_order[i - 1] = c;
            add_to_byte(&H005_B(0x2480), 0xFFFF);
            *done = 1;
            break;
        case 'Q':
            *done = end_combat_turn(c);
            break;
        case 'B':
            *done = bandage_dying(1);
            *done = end_combat_turn(c);
            break;
        case 'S':
            game_speed_menu();
            break;
        case 'A':
            set_auto(c);
            clear_message_line();
            dos_delay(0x0A);
            *done = 1;
            monster_turn(c);
            break;
        default:
            break;
        }
    }
}

/*
 * PORT H059+$1110: turno di un personaggio del giocatore: un incantesimo
 * in corso (+$0 del turno) parte subito; altrimenti il menu finche' il
 * turno non finisce.  Tasti speciali: 1/3 tutti in automatico per il
 * resto del round, 2 magia on/off, 4 H096+$4DE8.
 */
static void player_turn(Character *c)
{
    u8 key;                             /* -$1(a5) */
    u8 done;                            /* -$2(a5) */
    CokAim area;                        /* -$10(a5): mira (9 byte) */
    u16 spell;                          /* -$12(a5) */
    Character *p;                       /* -$6(a5) */

    if (!c->b[0x198]) {
        done = end_combat_turn(c);
        return;
    }
    if (c->block_192->b[0] > 0) {
        spell = c->block_192->b[0];
        c->block_192->b[0] = 0;
        cast_spell(spell, 0, 1, &done);
        done = end_combat_turn(c);
        return;
    }
    done = 0;
    while (!done) {
        H005_B(0x2483) = 1;
        combat_menu(c, &key);
        if (H005_B(0x249D)) {
            switch (key) {
            case 1:
            case 3:
                add_to_byte(&H005_B(0x2480), 0xFFFF);
                COK_PUT16(&c->block_192->b[4], 0x14);
                for (p = g_party_head; p != NULL; p = p->next) {
                    set_auto(p);
                }
                clear_message_line();
                dos_delay(0x0A);
                done = 1;
                break;
            case 2:
                H005_B(0x24A0) = (u8)(H005_B(0x24A0) == 0);
                if (H005_B(0x24A0)) {
                    show_message_line(8, "Magic On");
                } else {
                    show_message_line(9, "Magic Off");
                }
                break;
            case 4:
                if (combat_bandage()) {
                    show_combatant_cursor(c, 3, 0);
                    done = 1;
                } else {
                    show_message_line(0x11, "That doesn't work");
                }
                break;
            default:
                break;
            }
        } else {
            switch (key) {
            case ' ':
                for (p = g_party_head; p != NULL; p = p->next) {
                    if (p->b[0xEC] < 0x80) {
                        p->b[0x19A] = 0;
                    }
                }
                break;
            case 'A':
                aim_target(c, 0xFF, 1, 0, 1, &done, &area);
                break;
            case 'C':
                combat_cast(0, 0, &done);
                break;
            case 'D':
                done_menu(c, &done);
                break;
            case 'M':
                move_mode(c, ' ', &done);
                break;
            case 'T':
                turn_undead(c);
                done = end_combat_turn(c);
                break;
            case 'U':
                H005_B(0x2483) = 2;
                show_items(&done);
                combat_attacks(c);
                if (!done) {
                    redraw_combat_screen();
                }
                break;
            case 'V':
                view_character(&done);
                combat_attacks(c);
                if (!done) {
                    redraw_combat_screen();
                }
                break;
            case 'Y':
                yell_challenge(c);
                done = end_combat_turn(c);
                break;
            default:
                break;
            }
        }
        if (!done) {
            show_combatant_cursor(c, 2, 1);
            H005_B(0x24C7) = 1;
            draw_combat_status(c);
        }
    }
}

/*
 * PORT H059+$1498 (Combat_ActorTurn): turno di c: eventi 7, $F e $15,
 * cursore e stato; chi ha ancora iniziativa (+$4 > 0) gioca: in
 * automatico (+$19A, H097+$1D68) o col menu.
 */
static void actor_turn(Character *c)
{
    c->block_192->b[0x11] = 0;
    c->block_192->b[0x14] = 0;
    c->block_192->b[9] = 0;
    trigger_event(&c, 7);
    if ((s16)COK_GET16(&c->block_192->b[4]) <= 0) {
        return;
    }
    if (COK_GET16(&c->block_192->b[4]) == 0x14) {
        COK_PUT16(&c->block_192->b[4], 0x13);
    }
    g_current_char = c;
    H005_B(0x24C6) = (u8)(c->b[0x199] == 0 || combatant_visible(c, 0));
    show_combatant_cursor(c, 2, 1);
    recompute_stats(c);
    H005_B(0x24C7) = 1;
    draw_combat_status(c);
    trigger_event(&c, 0x0F);
    if (c->block_192->b[0] == 0) {
        trigger_event(&c, 0x15);
    }
    if (COK_GET16(&c->block_192->b[4]) > 0) {
        if (c->b[0x19A]) {
            monster_turn(c);
        } else {
            player_turn(c);
        }
    }
    redraw_combat_cell((s16)combatant_x(c), (s16)combatant_y(c));
}

/*
 * PORT H059+$15EE: fine del round: un minuto di gioco, contatore dei
 * round, forza dei nemici, evento $13, nubi (solo acido) e chi muore
 * peggiora (morto dopo 10 round); "Your Teammate is Dying".  Il
 * combattimento finisce se un lato non c'e' piu' o dopo $2477 round; con
 * solo nemici rimasti si puo' scegliere di continuare.
 */
static void end_round(u8 *over)
{
    Character *p;                       /* -$4(a5) */
    u16 i;                              /* -$8(a5) */

    advance_time(1, 1);
    add_to_byte(&H005_B(0x247C), 1);
    enemy_strength();
    i = 1;
    for (p = g_party_head; p != NULL; p = p->next) {
        trigger_event(&p, 0x13);
        check_cloud(p, 0);
        if (p->b[0x197] == 5) {
            add_to_byte(&p->block_192->b[0x10], 1);
            if (p->block_192->b[0x10] > 9) {
                p->b[0x197] = 6;
            }
        }
        ++i;
    }
    if (bandage_dying(0)) {
        show_message_line(0x16, "Your Teammate is Dying");
    }
    count_sides();
    center_view((s16)((s16)COK_GET16(g_combat_area + 2) + 3),
                (s16)((s16)COK_GET16(g_combat_area + 4) + 3), 0xFF, 8);
    if (H005_B(0x2A1C) == 0 || H005_B(0x2A1D) == 0 ||
        H005_B(0x247C) >= H005_B(0x2477)) {
        *over = 1;
    }
    if (H005_B(0x2A1C) > 0 && H005_B(0x2A1D) == 0 && !H005_B(0x24D7) &&
        ask_yes_no(0x10, "Continue Battle:", 0x0D, 0x0A, 0x0F) == 'Y') {
        *over = 0;
    }
}

/*
 * PORT H059+$1782 (Combat_MainLoop), dal comando COMBAT: avvio (H095),
 * evento $18 per tutti, poi round finche' un lato resta: ordine dei
 * turni, turno di ognuno con le esplosioni dei caduti, fine del round;
 * infine la pulizia.
 */
void combat_main_loop(void)
{
    u8 over;                            /* -$1(a5) */
    Character *p;                       /* -$6(a5) */

    H005_B(0x3DE3) = 5;
    g_handlers_25c0[107] = (CokHandler)combat_spell_targets;
    start_combat();
    over = 0;
    if (H005_B(0x2A1C) == 0 || H005_B(0x2A1D) == 0) {
        over = 1;
    }
    for (p = g_party_head; p != NULL; p = p->next) {
        trigger_event(&p, 0x18);
    }
    while (!over) {
        count_sides();
        for (p = g_party_head; p != NULL; p = p->next) {
            combat_prepare_turn(p);
        }
        COK_PUT16(g_state_b + 0x596, 0);
        build_turn_order();
        p = g_turn_order[0];
        H005_B(0x2480) = 1;
        while (p != NULL) {
            actor_turn(p);
            explode_fallen();
            add_to_byte(&H005_B(0x2480), 1);
            if (H005_B(0x2480) > 0x48) {
                p = NULL;
            } else {
                p = g_turn_order[H005_B(0x2480) - 1];
            }
        }
        end_round(&over);
    }
    end_combat_cleanup();
    H005_B(0x24CE) = 1;
}
