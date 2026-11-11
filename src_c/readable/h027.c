/* H027: Handler di effetti/abilità del gioco; la mappa completa resta parziale. */
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

/* PORT H027+$0206: link/unlk, nessun effetto. */
void h027_init(void)
{
}

/*
 * PORT H027+$0286: annulla l'effetto in arrivo ($2475) e il danno ($2474)
 * se type e' 0 o coincide con l'effetto.
 */
static void cancel_incoming(u16 type)
{
    if (type == 0 || H005_B(0x2475) == type) {
        H005_B(0x2474) = 0;
        H005_B(0x2475) = 0;
    }
}

/* PORT H027+$0A00 (effetto $12): 30% di annullare $B e $35. */
static void effect_12(Character **cp, void *obj, u8 flag)
{
    (void)cp; (void)obj; (void)flag;
    if (roll_dice(1, 0x64) <= 0x1E) {
        cancel_incoming(0x0B);
        cancel_incoming(0x35);
    }
}

/* PORT H027+$3A46 (effetto $5F): 90% di annullare $35 e $B. */
static void effect_5f(Character **cp, void *obj, u8 flag)
{
    (void)cp; (void)obj; (void)flag;
    if (roll_dice(1, 0x64) <= 0x5A) {
        cancel_incoming(0x35);
        cancel_incoming(0x0B);
    }
}

/* PORT H027+$41F6 (effetto $5C e altri): nessun effetto. */
static void effect_none(Character **cp, void *obj, u8 flag)
{
    (void)cp; (void)obj; (void)flag;
}

#define EH(name) static void name(Character **cp, void *obj, u8 flag)
#define UNUSED_ARGS (void)cp; (void)obj; (void)flag
#define EFF ((CokEffect *)obj)
#define SPELL_B(s, k)   H005_B(0x66 + ((int)(s) - 1) * 16 + (k))

/* PORT H027+$0312 (effetti $1B, $1F, $33-$35): fine del turno. */
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
    add_to_byte(&H005_B(0x2478), 5);
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 1));
}

/* PORT H027+$0390 (effetto 2): -5 a $2478 (minimo 0), +1 a $2A1A. */
EH(effect_02)
{
    UNUSED_ARGS;
    if (H005_B(0x2478) < 5) {
        H005_B(0x2478) = 0;
    } else {
        add_to_byte(&H005_B(0x2478), 0xFFFB);
    }
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 1));
}

/*
 * PORT H027+$03D6 (effetto 3, serpenti): i colpi +$19E/+$19F consumano
 * l'effetto (+$4); "is fighting with snakes" e fine del turno.
 */
EH(effect_03)
{
    u8 hits;                            /* -$1(a5) */
    u8 r;                               /* -$2(a5) */

    (void)flag;
    hits = (u8)((*cp)->b[0x19E] + (*cp)->b[0x19F]);
    if (EFF->b[4] > hits) {
        add_to_byte(&EFF->b[4], (u16)-(s16)hits);
    } else {
        remove_effect(*cp, 3, NULL);
    }
    show_effect_message(*cp, 1, 0x17, "is fighting with snakes");
    clear_message_area();
    r = end_combat_turn(*cp);
    (void)r;
}

/* Bonus +2 al tiro salvezza e al tiro per colpire. */
static void bonus_2(void)
{
    add_to_byte(&H005_B(0x2476), 2);
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 2));
}

/* PORT H027+$05C6 (effetti 8, $2D): +2 se +$10F del corrente e' 2, 5 o 8. */
EH(effect_08)
{
    u8 a = g_current_char->b[0x10F];
    UNUSED_ARGS;
    if (a == 2 || a == 5 || a == 8) {
        bonus_2();
    }
}

/* PORT H027+$0622 (effetti 9, $2E): +2 se +$10F del corrente e' 0, 3 o 6. */
EH(effect_09)
{
    u8 a = g_current_char->b[0x10F];
    UNUSED_ARGS;
    if (a == 0 || a == 3 || a == 6) {
        bonus_2();
    }
}

/* PORT H027+$067C (effetto $A): danno da freddo dimezzato, +3 al salvezza. */
EH(effect_0a)
{
    UNUSED_ARGS;
    if (mask_byte(H005_B(0x2473), 2)) {
        H005_B(0x2474) = (u8)(H005_B(0x2474) >> 1);
        add_to_byte(&H005_B(0x2476), 3);
    }
}

/* PORT H027+$07F4: nulla (usato anche per $08FC, $098E, $1CF6, $2D30, $38E2,
 * $3C14, $3E9C, $4012 e $40EE, identici). */
EH(effect_nothing)
{
    UNUSED_ARGS;
}

/*
 * PORT H027+$02BE: aggiunge a *cp l'effetto type (valore value, +$4 b4)
 * salvo con $24AA attivo; restituisce 1 se aggiunto.
 */
static u8 add_effect_unless_quiet(Character **cp, u8 type, u8 b4, u16 value)
{
    if (H005_B(0x24AA)) {
        return 0;
    }
    add_effect(*cp, type, value, b4, 1);
    return 1;
}

/* PORT H027+$0912 (effetto $F): veleno lento, 1 punto di danno. */
EH(effect_0f)
{
    (void)flag;
    if (add_effect_unless_quiet(cp, 0x0F, EFF->b[4], 0x0A) &&
        (*cp)->b[0x1A8] > 1) {
        H005_B(0x2473) = 0;
        apply_damage(*cp, 1, 0, 0);
        if (H005_B(0x3DE3) != 5) {
            draw_party(g_current_char);
        }
    }
}

/* PORT H027+$09A4 (effetto $11): CA almeno $39, +1 al salvezza. */
EH(effect_11)
{
    (void)obj; (void)flag;
    if ((*cp)->b[0x19C] < 0x39) {
        (*cp)->b[0x19C] = 0x39;
    }
    add_to_byte(&H005_B(0x2476), 1);
    if (H005_B(0x2471) == 0x0F) {
        H005_B(0x2474) = 0;
    }
}

/* PORT H027+$0A3E (effetto $14): danno da fuoco dimezzato, +3 al salvezza. */
EH(effect_14)
{
    (void)cp; (void)obj;
    if (!flag && mask_byte(H005_B(0x2473), 1)) {
        H005_B(0x2474) = (u8)(H005_B(0x2474) >> 1);
        add_to_byte(&H005_B(0x2476), 3);
    }
}

/* PORT H027+$0A9E (effetto $15): "is silenced", annulla l'incantesimo. */
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

/* PORT H027+$0D70 (effetto $19): senza l'effetto $18, -4 al colpire. */
EH(effect_19)
{
    CokEffect *e;                       /* -$4(a5) */

    (void)cp; (void)obj;
    if (!flag && !find_effect(g_current_char, 0x18, &e)) {
        H005_B(0x24AB) = 1;
        H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 4));
    }
}

/*
 * PORT H027+$0E18 (effetto $1C, immagini): un colpo distrugge
 * un'immagine ("lost an image"); finite le immagini l'effetto va via.
 */
EH(effect_1c)
{
    (void)flag;
    if (roll_dice(1, (u16)((EFF->b[4] >> 4) + 1)) > 1 &&
        !(H005_B(0x2471) > 0 && H005_B(0x24A9))) {
        cancel_incoming(0);
        show_char_message(*cp, 0x0D, "lost an image", 0x0A, 1);
        add_to_byte(&EFF->b[4], 0xFFFF);
        if (EFF->b[4] == 0) {
            remove_effect(*cp, 0x1C, NULL);
        }
    }
}

/* PORT H027+$0EC6 (effetto $1D): danno ridotto di un quarto. */
EH(effect_1d)
{
    UNUSED_ARGS;
    H005_B(0x2474) = (u8)(H005_B(0x2474) - (H005_B(0x2474) >> 2));
}

/* PORT H027+$10CC (effetto $21, cecita'): -4 a colpire, CA e salvezza. */
EH(effect_21)
{
    (void)obj; (void)flag;
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 4));
    add_to_byte(&(*cp)->b[0x19C], 0xFFFC);
    add_to_byte(&(*cp)->b[0x19D], 0xFFFC);
    add_to_byte(&H005_B(0x2476), 0xFFFC);
}

/* PORT H027+$1120 (effetto $22): gestori $2B e $2C. */
EH(effect_22)
{
    call_effect_handler(0x2B, cp, obj, flag);
    call_effect_handler(0x2C, cp, obj, flag);
}

/* PORT H027+$1310 (effetto $24, maledizione): -4 a colpire e salvezza. */
EH(effect_24)
{
    UNUSED_ARGS;
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 4));
    add_to_byte(&H005_B(0x2476), 0xFFFC);
}

/* PORT H027+$133C (effetto $25): senza movimento non si attacca. */
EH(effect_25)
{
    (void)obj; (void)flag;
    if (COK_GET16((*cp)->block_192->b + 4) == 0) {
        H005_B(0x24AB) = 1;
        H005_SET_W(0x2A1A, 0xFFFF);
    }
}

/* PORT H027+$1374 (effetto $27): invecchia una volta ("ages"). */
EH(effect_27)
{
    (void)flag;
    if (mask_byte(EFF->b[4], 0x10) == 0) {
        EFF->b[4] = (u8)(EFF->b[4] + 0x10);
        show_char_message(*cp, 4, "ages", 0x0A, 1);
        CH_PUTW(*cp, 0x62, (u16)(CH_W(*cp, 0x62) + 1));
    }
    H005_B(0x2472) = (u8)(H005_B(0x2472) << 1);
}

/* PORT H027+$1878 (effetto $2A): dimezza $2472. */
EH(effect_2a)
{
    UNUSED_ARGS;
    H005_B(0x2472) = (u8)(H005_B(0x2472) >> 1);
}

/* PORT H027+$1A0A (effetto $2F): -4 a colpire con il bit 2 di +$14C. */
EH(effect_2f)
{
    UNUSED_ARGS;
    if (mask_byte(g_current_char->b[0x14C], 4)) {
        H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 4));
    }
}

/* PORT H027+$1BFE (effetto $32): freddo +2 salvezza, fuoco doppio senza salvezza. */
EH(effect_32)
{
    UNUSED_ARGS;
    if (mask_byte(H005_B(0x2473), 2)) {
        add_to_byte(&H005_B(0x2476), 2);
    } else if (mask_byte(H005_B(0x2473), 1) && !H005_B(0x24A5)) {
        H005_B(0x2474) = (u8)(H005_B(0x2474) << 1);
    }
}

/* PORT H027+$1C7A (effetto $36): fuoco +2 salvezza, freddo doppio. */
EH(effect_36)
{
    UNUSED_ARGS;
    if (mask_byte(H005_B(0x2473), 1)) {
        add_to_byte(&H005_B(0x2476), 2);
    } else if (mask_byte(H005_B(0x2473), 2) && !H005_B(0x24A3)) {
        H005_B(0x2474) = (u8)(H005_B(0x2474) << 1);
    }
}

/* PORT H027+$1D0C (effetto $38): aggiunge l'effetto $19 (valore 1, $C). */
EH(effect_38)
{
    (void)obj; (void)flag;
    add_effect(*cp, 0x19, 1, 0x0C, 0);
}

/* PORT H027+$1D3C (effetto $39): +2 a colpire, CA e +$19D. */
EH(effect_39)
{
    (void)obj; (void)flag;
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 2));
    add_to_byte(&(*cp)->b[0x19C], 2);
    add_to_byte(&(*cp)->b[0x19D], 2);
}

/* PORT H027+$1E1A (effetto $3B): annulla effetto e danno. */
EH(effect_3b)
{
    UNUSED_ARGS;
    cancel_incoming(0);
    H005_B(0x2474) = 0;
}

/* PORT H027+$2138 (effetto $3F): annulla gli incantesimi sotto il 4o livello. */
EH(effect_3f)
{
    UNUSED_ARGS;
    if (H005_B(0x2471) > 0 &&
        H005_B(0x66 + (H005_B(0x2471) - 1) * 16 + 1) < 4) {
        cancel_incoming(0);
    }
}

/* PORT H027+$2CA6 (effetto $49): immune al bit 5 del danno. */
EH(effect_49)
{
    (void)obj; (void)flag;
    if (mask_byte(H005_B(0x2473), 0x20) > 0) {
        cancel_incoming(0);
        show_char_message(*cp, 0x0D, "is unaffected", 0x0A, 1);
    }
}

/* PORT H027+$2CFA (effetto $4A): 1 su 20 attiva il gestore di $2660. */
EH(effect_4a)
{
    UNUSED_ARGS;
    if (roll_dice(1, 0x14) == 1) {
        g_handlers_25c0[40]();
    }
}

/*
 * PORT H027+$3842 (effetto $59): in combattimento, senza $247C e $2A1A,
 * azzera il nibble alto di +$4; altrimenti il bit 4 annulla il colpo.
 */
EH(effect_59)
{
    (void)cp;
    if (flag || H005_B(0x3DE3) != 5) {
        return;
    }
    if (H005_B(0x247C) == 0 && H005_W(0x2A1A) == 0) {
        EFF->b[4] = mask_byte(EFF->b[4], 0x0F);
    } else {
        if (mask_byte(EFF->b[4], 0x10) == 0) {
            H005_SET_W(0x2A1A, 0xFFFF);
        }
        EFF->b[4] = or_byte(EFF->b[4], 0x10);
    }
}

/* PORT H027+$3A84 (effetto $60): annulla $B e $35. */
EH(effect_60)
{
    UNUSED_ARGS;
    cancel_incoming(0x0B);
    cancel_incoming(0x35);
}

/* PORT H027+$3AAA (effetto $61): annulla $34. */
EH(effect_61)
{
    UNUSED_ARGS;
    cancel_incoming(0x34);
}

/* PORT H027+$3AC8 (effetto $62): annulla tutto col freddo. */
EH(effect_62)
{
    UNUSED_ARGS;
    if (mask_byte(H005_B(0x2473), 2)) {
        cancel_incoming(0);
    }
}

/* PORT H027+$3AFC (effetto $63): annulla $37 e $34; salvezza $64 per il tipo 0. */
EH(effect_63)
{
    UNUSED_ARGS;
    cancel_incoming(0x37);
    cancel_incoming(0x34);
    if (H005_B(0x2A13) == 0) {
        H005_B(0x2476) = 0x64;
    }
}

/* PORT H027+$3BC0 (effetto $65): danno 1d6+1 con l'arma $36. */
EH(effect_65)
{
    CokItem *w = g_current_char->readied[0];   /* +$154 */
    UNUSED_ARGS;
    if (w != NULL && w->b[0x30] == 0x36) {
        H005_B(0x2474) = (u8)(roll_damage_dice(1, 6) + 1);
    }
}

/* PORT H027+$3D02 (effetto $6A): fine del turno. */
EH(effect_6a)
{
    u8 r;
    UNUSED_ARGS;
    r = end_combat_turn(*cp);
    (void)r;
}

/* PORT H027+$3E6C (effetto $6C): aggiunge l'effetto $19. */
EH(effect_6c)
{
    (void)obj; (void)flag;
    add_effect(*cp, 0x19, 0xFF, 0xFF, 0);
}

/* PORT H027+$3EB2 (effetto $6E): rimosso, ricalcola +$60 dal livello. */
EH(effect_6e)
{
    Character *c = *cp;

    (void)obj;
    if (flag) {
        c->b[0x60] = (u8)((u16)(c->b[0x105] + c->b[0x10D] * h073_130a(c) - 1)
                          / 5 + 1);
    }
}

/* PORT H027+$3F1E (effetto $6F): rimosso, libera dal controllo. */
EH(effect_6f)
{
    Character *c = *cp;

    (void)obj;
    if (flag) {
        if (c->b[0xEC] == 0xB3) {
            c->b[0xEC] = 0;
            c->b[0x19A] = 0;
        }
        (c->block_192->b)[0x12] = 0;
    }
}

/* PORT H027+$418E (effetto $76): -2 a colpire. */
EH(effect_76)
{
    UNUSED_ARGS;
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 2));
}

/* PORT H027+$41AA (effetto $77): -1 a colpire. */
EH(effect_77)
{
    UNUSED_ARGS;
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 1));
}

/*
 * PORT H027+$420C (vettore $2A0E, oggetti magici): pronto aggiunge
 * l'effetto +$45 dell'oggetto, tolto lo rimuove.
 */
EH(effect_item)
{
    CokItem *it = (CokItem *)obj;       /* -$4(a5) */

    H005_B(0x24E0) = 0;
    if (flag) {
        remove_effect(*cp, it->b[0x45], NULL);
    } else {
        add_effect(*cp, it->b[0x45], 0, 0xFF, 1);
    }
}

/*
 * PORT H027+$0214: se il bersaglio del turno (blocco +$192, +$C) non
 * salva (bonus) resta paralizzato ($34, durata dur).
 */
static void paralyze_turn_target(Character **cp, u16 dur, s16 bonus)
{
    g_h005_2a14 = (*cp)->block_192->target;
    if (!saving_throw_roll(g_h005_2a14, 0, bonus)) {
        show_effect_message(g_h005_2a14, 1, 0x0C, "is Paralyzed");
        add_effect(g_h005_2a14, 0x34, dur, 0x0C, 0);
    }
}

/* PORT H027+$0338: +1 al tiro salvezza e al tiro per colpire. */
EH(effect_bonus_1)
{
    UNUSED_ARGS;
    add_to_byte(&H005_B(0x2476), 1);
    H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 1));
}

/*
 * PORT H027+$2182: veleno sul bersaglio del turno: se non salva (bonus,
 * piu' l'effetto $74) muore avvelenato.
 */
static void poison_turn_target(Character **cp, s16 bonus)
{
    CokEffect *e;                       /* -$4(a5) */

    g_h005_2a14 = (*cp)->block_192->target;
    if (find_effect(g_h005_2a14, 0x74, &e)) {
        if (bonus < 0) {
            bonus = 0;
        } else {
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
 * PORT H027+$0B7A (effetto $17, Spiritual Hammer): da' (o toglie, alla
 * rimozione) il martello magico (tipo 6, +$34 = $79).  Come nell'originale
 * la ricerca dopo l'aggiunta lascia in it l'oggetto seguente al martello.
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
        if (it->b[0x30] == 6 && it->b[0x34] == 0x79) {
            found = 1;
        } else {
            it = it->next;
        }
    }
    if (flag && it != NULL) {
        delete_item(*cp, it);
    }
    if (!flag && !found && (*cp)->b[0x14F] < 0x10) {
        it = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
        it->b[0x30] = 6;
        it->b[0x33] = 6;
        it->b[0x34] = 0x79;
        COK_PUT16(&it->b[0x36], 1);
        it->b[0x45] = 0x17;
        it->b[0x46] = 0x80;
        give_item_copy(*cp, it);
        exec_free_mem(it, sizeof(CokItem));     /* FreeMem($48) */
        it = (*cp)->items;
        found = 0;
        while (it != NULL && !found) {
            found = (u8)(it->b[0x34] == 0x79 && it->b[0x30] == 6);
            it = it->next;
        }
        saved = g_current_char;
        g_current_char = *cp;
        if (it != NULL && (*cp)->readied[0] == NULL) {
            ready_item(it);
            it->b[0x3A] = 1;
        }
        g_current_char = saved;
        if ((*cp)->b[0x197] == 0) {
            show_char_message(*cp, 0x0D, "Gains an item", 0x0A, 1);
        }
    }
    recompute_stats(*cp);
}

/* PORT H027+$18A4 (effetto $2B, debolezza): -1 alla forza fino a 3. */
EH(effect_2b)
{
    CokEffect *e;                       /* -$4(a5) */

    (void)flag;
    if (!add_effect_unless_quiet(cp, 0x2B, EFF->b[4], 0x3C)) {
        return;
    }
    if ((*cp)->b[0x11] > 3) {
        show_char_message(*cp, 0x0B, "is weakened", 0x0A, 1);
        add_to_byte(&(*cp)->b[0x11], 0xFFFF);
    } else if (!find_effect(*cp, 0x1F, &e)) {
        add_effect(*cp, 0x1F, 0, 0xFF, 0);
    }
}

/* PORT H027+$1956 (effetto $2C, malattia): 1 punto di danno. */
EH(effect_2c)
{
    CokEffect *e;                       /* -$4(a5) */

    (void)flag;
    if (!add_effect_unless_quiet(cp, 0x2C, EFF->b[4], 0x0A)) {
        return;
    }
    if ((*cp)->b[0x1A8] > 1) {
        H005_B(0x2473) = 0;
        apply_damage(*cp, 1, 0, 0);
        if (H005_B(0x3DE3) != 5) {
            draw_party(g_current_char);
        }
    } else if (!find_effect(*cp, 0x1F, &e)) {
        add_effect(*cp, 0x1F, 0, 0xFF, 0);
    }
}

/*
 * PORT H027+$1A42 (effetto $30): "immolates": 1d6 di danno ai
 * combattenti attivi dell'area attorno.
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
    n = (u16)(H005_B(0x2479) - 1);
    for (j = 2; j <= H005_B(0x2479); ++j) {
        list[j - 2] = H005_B(0x2A3E + (j - 1) * 4);
    }
    for (j = 1; j <= n; ++j) {
        p = g_combatants[list[j - 1] - 1];
        if (p->b[0x198]) {
            apply_damage(p, roll_damage_dice(1, 6), 0, 0);
        }
    }
}

/* PORT H027+$1B88 (effetto $31): +1 al proprio lato (+$4 bit 4), -1 agli altri. */
EH(effect_31)
{
    u8 side;                            /* -$1(a5) */

    side = (u8)(mask_byte(EFF->b[4], 0x10) >> 4);
    if ((*cp)->b[0x199] == side) {
        effect_bonus_1(cp, obj, flag);
    } else {
        H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) - 1));
        add_to_byte(&H005_B(0x2476), 0xFFFF);
    }
}

/* PORT H027+$1D80 (effetto $3A): alla rimozione, effetti $3B/$3C e via 4, $20, $30, $39. */
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

/* PORT H027+$0AFE (effetto $16): l'avvelenato ($37) muore; via $F. */
EH(effect_16)
{
    CokEffect *e;                       /* -$4(a5) */

    (void)obj; (void)flag;
    if (find_effect(*cp, 0x37, &e)) {
        knock_out(*cp, 6, 0x10, "dies from poison");
        remove_effect(*cp, 0x37, NULL);
    }
    H005_B(0x24AA) = 1;
    remove_effect(*cp, 0x0F, NULL);
    H005_B(0x24AA) = 0;
}

/* PORT H027+$0DB8 (effetto $1A): +1 a colpire un bersaglio col bit 7 di +$14C. */
EH(effect_1a)
{
    (void)obj; (void)flag;
    g_h005_2a14 = (*cp)->block_192->target;
    if (mask_byte(g_h005_2a14->b[0x14C], 0x80)) {
        H005_SET_W(0x2A1A, (u16)(H005_W(0x2A1A) + 1));
    }
}

/*
 * PORT H027+$2028 (effetto $3D): il fuoco perde 2 punti per dado (minimo
 * un punto per dado, $2470), +4 al salvezza; senza magia annulla.
 */
EH(effect_3d)
{
    u16 j;                              /* -$2(a5) */

    UNUSED_ARGS;
    if (!mask_byte(H005_B(0x2473), 1)) {
        return;
    }
    for (j = 1; j <= H005_B(0x2470); ++j) {
        add_to_byte(&H005_B(0x2474), 0xFFFE);
        if (H005_B(0x2474) < H005_B(0x2470)) {
            H005_B(0x2474) = H005_B(0x2470);
        }
    }
    add_to_byte(&H005_B(0x2476), 4);
    if (mask_byte(H005_B(0x2473), 8) == 0) {
        cancel_incoming(0);
    }
}

/* PORT H027+$20DA (effetto $3E, rigenerazione): +1 PF. */
EH(effect_3e)
{
    (void)flag;
    if (add_effect_unless_quiet(cp, 0x3E, EFF->b[4], 0x3C) &&
        heal_character(*cp, 1, 1)) {
        heal_message(*cp);
    }
}

/* PORT H027+$224C (effetto $40): veleno sul bersaglio del turno. */
EH(effect_40) { (void)obj; (void)flag; poison_turn_target(cp, 0); }

/* PORT H027+$226C (effetto $41): veleno, +4 al salvezza. */
EH(effect_41) { (void)obj; (void)flag; poison_turn_target(cp, 4); }

/* PORT H027+$37C2 (effetto $56): veleno, -2 al salvezza. */
EH(effect_56) { (void)obj; (void)flag; poison_turn_target(cp, -2); }

/* PORT H027+$37E4 (effetto $57): veleno, +1 al salvezza. */
EH(effect_57) { (void)obj; (void)flag; poison_turn_target(cp, 1); }

/*
 * PORT H027+$228E (effetto $42): il primo combattente nemico dell'area
 * "gets zapped!" (2d6); fine del turno.
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
    H005_B(0x24C5) = 0;
    j = 2;
    do {
        if (j <= H005_B(0x2479)) {
            p = g_combatants[H005_B(0x2A3E + (j - 1) * 4) - 1];
            if (p != NULL && p->b[0x199] != (*cp)->b[0x199]) {
                target = p;
                H005_B(0x24C5) = 1;
            }
        }
        ++j;
    } while (!H005_B(0x24C5) && j <= H005_B(0x2479));
    if (target != NULL) {
        show_char_message(target, 0x0C, "gets zapped!", 0x0A, 1);
        apply_damage(target, roll_damage_dice(2, 6), 0, 0);
        r = end_combat_turn(*cp);
        (void)r;
    }
}

/* PORT H027+$25BA (effetto $44): a terra, entra nella lista H005+$16. */
EH(effect_44)
{
    (void)obj; (void)flag;
    if ((*cp)->b[0x198]) {
        return;
    }
    (*cp)->b[0x197] = 0x0A;
    H005_SET_W(0x14, (u16)(H005_W(0x14) + 1));
    if (H005_W(0x14) < 1) {
        H005_SET_W(0x14, 1);
    }
    if (H005_W(0x14) <= 0x14) {
        g_h005_0016[H005_W(0x14) - 1] = *cp;
    } else {
        H005_SET_W(0x14, 0x14);
    }
    remove_effect(*cp, 0x44, NULL);
}

/* PORT H027+$2646 (effetto $45): paralisi del bersaglio. */
EH(effect_45) { (void)obj; (void)flag; paralyze_turn_target(cp, 0x64, 0); }

/* PORT H027+$3612 (effetto $51): paralisi del bersaglio. */
EH(effect_51) { (void)obj; (void)flag; paralyze_turn_target(cp, 0x64, 0); }

/* PORT H027+$3806 (effetto $58): paralisi se il bersaglio ha +$5B > 1. */
EH(effect_58)
{
    (void)obj; (void)flag;
    if ((*cp)->block_192->target->b[0x5B] > 1) {
        paralyze_turn_target(cp, 0x64, 0);
    }
}

/* PORT H027+$4028 (effetto $72): danno pari ai PF col bit 0 di +$14D. */
EH(effect_72)
{
    Character *t;                       /* -$4(a5) */

    (void)obj;
    if (flag || H005_B(0x3DE3) != 5) {
        return;
    }
    t = (*cp)->block_192->target;
    if (mask_byte(t->b[0x14D], 1)) {
        H005_B(0x2474) = (*cp)->b[0x1A8];
    }
}

/* PORT H027+$408A (effetto $73): +3 danni col bit 5 di +$14C. */
EH(effect_73)
{
    Character *t;                       /* -$4(a5) */

    (void)obj;
    if (flag || H005_B(0x3DE3) != 5) {
        return;
    }
    t = (*cp)->block_192->target;
    if (mask_byte(t->b[0x14C], 0x20)) {
        add_to_byte(&H005_B(0x2474), 3);
    }
}

/* PORT H027+$4104 (effetto $75): contro il bit 1 di +$14C distrugge o raddoppia. */
EH(effect_75)
{
    Character *t;                       /* -$4(a5) */

    (void)obj;
    if (flag || H005_B(0x3DE3) != 5) {
        return;
    }
    t = (*cp)->block_192->target;
    if (mask_byte(t->b[0x14C], 2)) {
        if (t->b[0xDF]) {
            knock_out(t, 8, 0x0C, "is disrupted");
        } else {
            H005_B(0x2474) = (u8)(H005_B(0x2474) << 1);
        }
    }
}

/* PORT H027+$17DE: arma con cui combatte c (H063+$37B2, o quella in mano). */
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

/* PORT H027+$0EFC (effetto $1E, nube): "is coughing", CA verso 50. */
EH(effect_1e)
{
    Character *c = *cp;

    (void)obj; (void)flag;
    if (c->block_192->b[2]) {
        show_char_message(c, 0x0B, "is coughing", 0x0A, 1);
    }
    c->block_192->b[2] = 0;
    c->block_192->b[1] = 0;
    recompute_stats(c);
    if (c->b[0x19D] > 0x34) {
        add_to_byte(&c->b[0x19D], 0xFFFE);
    } else {
        c->b[0x19D] = 0x32;
    }
    c->b[0x19C] = c->b[0x19D];
    if (c == g_current_char) {
        draw_combat_status(c);
    }
}

/* PORT H027+$3916 (effetto $5D): meta' danno da armi coi bit $81. */
EH(effect_5d)
{
    CokItem *w;                         /* -$4(a5) */

    UNUSED_ARGS;
    w = combat_weapon(g_current_char);
    if (w != NULL && mask_byte(H005_B(0x336C + w->b[0x30] * 0x12 + 8), 0x81)) {
        H005_B(0x2474) = (u8)(H005_B(0x2474) >> 1);
    }
}

/* PORT H027+$3B34 (effetto $64): meta' danno da armi senza bit o col bit 0. */
EH(effect_64)
{
    CokItem *w;                         /* -$4(a5) */
    u8 v;

    UNUSED_ARGS;
    w = combat_weapon(g_current_char);
    if (w == NULL) {
        return;
    }
    v = H005_B(0x336C + w->b[0x30] * 0x12 + 8);
    if (v == 0 || mask_byte(v, 1)) {
        H005_B(0x2474) = (u8)(H005_B(0x2474) >> 1);
    }
}

/* PORT H027+$3C2A (effetto $66): solo armi magiche (+$36) o mostri forti feriscono. */
EH(effect_66)
{
    CokItem *w;                         /* -$4(a5) */

    UNUSED_ARGS;
    w = combat_weapon(g_current_char);
    if ((w == NULL || COK_GET16(&w->b[0x36]) == 0) &&
        (g_current_char->b[0x5B] < 7 || g_current_char->b[0xDB] < 4)) {
        H005_B(0x2474) = 0;
    }
}

/* PORT H027+$3C88 (effetto $69): +livello ($102) di danno a distanza 1 sul bit 3. */
EH(effect_69)
{
    (void)obj; (void)flag;
    g_h005_2a14 = (*cp)->block_192->target;
    if (mask_byte(g_h005_2a14->b[0x14C], 8) &&
        combat_distance(*cp, g_h005_2a14) == 1) {
        add_to_byte(&H005_B(0x2474), (*cp)->b[0x102]);
    }
}

/* PORT H027+$3F72 (effetto $70): chi colpisce da vicino "gets zapped" (doppio). */
EH(effect_70)
{
    u8 dmg;                             /* -$1(a5) */
    u8 kind;                            /* -$2(a5) */

    (void)obj; (void)flag;
    if (combat_distance(g_current_char, *cp) >= 2) {
        return;
    }
    dmg = H005_B(0x2474);
    H005_B(0x2474) = (u8)(H005_B(0x2474) << 1);
    kind = H005_B(0x2473);
    H005_B(0x2473) = 8;
    show_char_message(g_current_char, 0x0B, "gets zapped", 0x0A, 1);
    apply_damage(g_current_char, H005_B(0x2474), 0, 0);
    H005_B(0x2474) = dmg;
    H005_B(0x2473) = kind;
}

/*
 * PORT H027+$0492 (effetto 7, attacco naturale): da vicino 1d6+2 piu' la
 * forza, a distanza 1d4+1 piu' la destrezza; +$36 dell'arma si aggiunge.
 * Senza arma l'originale usa la parola non inizializzata; qui 0.
 */
EH(effect_07)
{
    Character *c = *cp;
    Character *t;                       /* -$4(a5) */
    u16 dist;                           /* -$6(a5) */
    u16 bonus = 0;                      /* -$8(a5) */
    u16 dmg;

    (void)obj;
    if (flag || H005_B(0x3DE3) != 5) {
        return;
    }
    if (c->readied[0] != NULL) {
        bonus = COK_GET16(&c->readied[0]->b[0x36]);
    }
    t = c->block_192->target;
    dist = combat_distance(c, t);
    c->b[0x19B] = c->b[0x5A];
    if (dist < 2) {
        dmg = roll_damage_dice(1, 6);
        dmg = (u16)(dmg + str_damage_bonus(c) + 2 + bonus);
        H005_B(0x2474) = (u8)dmg;
        c->b[0x19B] = (u8)(c->b[0x19B] + str_hit_bonus(c));
    } else {
        dmg = roll_damage_dice(1, 4);
        H005_B(0x2474) = (u8)(dmg + 1 + bonus);
        c->b[0x19B] = (u8)(c->b[0x19B] + dex_missile_adj(c));
    }
}

/*
 * PORT H027+$06D4 (effetto $B, charme): passa al lato del lanciatore
 * (+$4 bit 6/7) e torna al suo alla rimozione.
 */
EH(effect_0b)
{
    Character *c = *cp;

    if (flag) {
        c->b[0x199] = (u8)(mask_byte(EFF->b[4], 0x40) >> 6);
        if (c->b[0xEC] == 0xB3) {
            c->b[0xEC] = 0;
            c->b[0x19A] = 0;
        }
        return;
    }
    if (mask_byte(EFF->b[4], 0x20) == 0) {
        EFF->b[4] = (u8)(EFF->b[4] + 0x20 + (c->b[0x199] << 6));
        c->b[0x199] = (u8)(EFF->b[4] >> 7);
        c->b[0x19A] = 1;
        if (c->b[0xEC] <= 0x7F) {
            c->b[0xEC] = 0xB3;
        }
        c->block_192->target = NULL;
        count_sides();
    }
    H005_B(0x2478) = 0x64;
}

/* PORT H027+$080A (effetto $D): rinasce furioso ("goes mad!"), senza incantesimi. */
EH(effect_0d)
{
    Character *c = *cp;

    (void)flag;
    if (c->b[0x197] == 0) {
        return;
    }
    c->b[0x197] = 0;
    c->b[0x198] = 1;
    if (!revive(*cp, 0x14, 9, "goes mad!")) {
        return;
    }
    add_effect(*cp, 0x20, 0, 0xFF, 0);
    add_effect(*cp, 0x30, 0, 0xFF, 0);
    add_effect(*cp, 0x39, 0, 0xFF, 0);
    add_effect(*cp, 0x3A, 6, 0xFF, 1);
    remove_effect(*cp, 0x0D, EFF);
    h029_fill_bytes(0x39, &(*cp)->b[0x1E], 0x3A, 0);
}

/* PORT H027+$0FCE (effetto $20): "Arises in a new form". */
EH(effect_20)
{
    Character *c = *cp;

    (void)obj; (void)flag;
    if (c->b[0x197] == 0) {
        return;
    }
    c->b[0x197] = 0;
    c->b[0x198] = 1;
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
 * PORT H027+$1162 (effetto $23, confusione): d10: 1 fugge, 2-6 resta
 * confuso, 7-8 va in berserk, 9-10 si infuria; poi un tiro salvezza (-2)
 * puo' togliere la confusione.
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
        c->block_192->b[0x12] = 1;
        c->b[0x19A] = 1;
        if (c->b[0xEC] <= 0x7F) {
            c->b[0xEC] = 0xB3;
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

/* ---- Nubi ($2514) e pozze d'acido ($250C) sulla mappa del combattimento ---- */

/* Byte della casella (x, y) della mappa H005+$2ADE: +$A + y*$64 + x*2 + 1. */
static u8 *combat_cell(s16 x, s16 y)
{
    return g_combat_area + 0x0A + (s32)y * 0x64 + x * 2 + 1;
}

/* Casella i (1..4) di una nube: centro +$1C/+$1E piu' la direzione $5022. */
static s16 cloud_x(CokCloud *p, u16 i)
{
    return (s16)(COK_GET16(&p->b[0x1C - 8]) +
                 H005_W(0x3EE2 + H005_B(0x5022 + i - 1) * 2));
}

static s16 cloud_y(CokCloud *p, u16 i)
{
    return (s16)(COK_GET16(&p->b[0x1E - 8]) +
                 H005_W(0x3ED0 + H005_B(0x5022 + i - 1) * 2));
}

/* Un corpo della tabella H005+$2AE2 ($247A voci) e' su (x, y)? */
static u8 on_2ae2_table(u16 x, u16 y)
{
    u16 k;
    u8 found = 0;

    for (k = 1; k <= H005_B(0x247A); ++k) {
        if (g_bodies[k - 1].who != NULL && g_bodies[k - 1].x == x &&
            g_bodies[k - 1].y == y) {
            found = 1;
        }
    }
    return found;
}

/*
 * Toglie r dalla lista *head e lo libera ($22 byte nell'originale; qui la
 * dimensione del record C, con cui va allocato).  Come l'originale, se r e'
 * in testa la testa avanza e poi r->next = r->next.
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

/* Ridisegna le nubi rimaste ($1E) e le pozze d'acido ($1D). */
static void redraw_clouds_and_pools(void)
{
    CokCloud *p;
    u16 i;

    for (p = g_clouds; p != NULL; p = p->next) {
        for (i = 1; i <= 4; ++i) {
            if (p->b[0x12 - 8 + i - 1]) {
                *combat_cell(cloud_x(p, i), cloud_y(p, i)) = 0x1E;
            }
        }
    }
    for (p = g_acid_pools; p != NULL; p = p->next) {
        *combat_cell((s16)COK_GET16(&p->b[0x1C - 8]),
                     (s16)COK_GET16(&p->b[0x1E - 8])) = 0x1D;
    }
}

/*
 * PORT H027+$13F4 (effetto $28, nube): toglie la nube numero +$4>>4 di
 * questo personaggio: "The air clears a little...", le sue caselle tornano
 * al contenuto salvato (+$08..) o $1F se c'e' un corpo ($2AE2).
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
    id = (u16)(EFF->b[4] >> 4);
    p = g_clouds;
    while (p != NULL && !found) {
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
 * PORT H027+$3292 (effetto $50): toglie la pozza d'acido numero +$4 di
 * questo personaggio: "The acid drains away..", la casella torna al
 * contenuto salvato (+$08) o $1F se c'e' un corpo ($2AE2).
 */
EH(effect_50)
{
    u16 id;                             /* -$10(a5) */
    u8 found = 0;                       /* -$D(a5) */
    CokCloud *r;                        /* -$8(a5) */
    s16 x;
    s16 y;

    (void)flag;
    id = EFF->b[4];
    r = g_acid_pools;
    while (r != NULL && !found) {
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
    x = (s16)COK_GET16(&r->b[0x1C - 8]);
    y = (s16)COK_GET16(&r->b[0x1E - 8]);
    if (on_2ae2_table((u16)x, (u16)y)) {
        *combat_cell(x, y) = 0x1F;
    } else {
        *combat_cell(x, y) = r->b[0];
    }
    unlink_cloud(&g_acid_pools, r);
    redraw_clouds_and_pools();
}

/*
 * PORT H027+$266A (effetto $46): se a terra senza punti ferita o fuori
 * combattimento, "dissolves into acid!": una pozza ($1D) nella sua casella,
 * con l'effetto $50 (1d6 turni) per toglierla.  Nella lista l'originale non
 * conta l'ultimo record nel numero della pozza.  Con una casella $1F
 * l'indice di direzione -$10(a5) non e' inizializzato: qui 0.
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
    /* H029+$0312 su $22 byte: tutto il record. */
    memset(r, 0, sizeof(CokCloud));
    r->next = NULL;
    r->owner = *cp;
    r->b[0x20 - 8] = (u8)count;
    COK_PUT16(&r->b[0x1C - 8], combatant_x(*cp));
    COK_PUT16(&r->b[0x1E - 8], combatant_y(*cp));
    x = (s16)COK_GET16(&r->b[0x1C - 8]);
    y = (s16)COK_GET16(&r->b[0x1E - 8]);
    combat_map_cell(x, y, &value, &tile);
    if (tile == 0x1E) {
        for (q = g_clouds; q != NULL; q = q->next) {
            for (i = 1; i <= 4; ++i) {
                if (q->b[0x12 - 8 + i - 1] &&
                    cloud_x(q, i) == x && cloud_y(q, i) == y &&
                    q->b[i - 1] != 0x1E) {
                    tile = q->b[i - 1];
                }
            }
        }
    } else if (tile == 0x1F) {
        for (k = 1; k <= H005_B(0x247A); ++k) {
            if (g_bodies[k - 1].x ==
                    (u16)(H005_W(0x251A) + H005_W(0x3EE2 + dir * 2)) &&
                g_bodies[k - 1].y ==
                    (u16)(H005_W(0x2518) + H005_W(0x3ED0 + dir * 2))) {
                tile = g_bodies[k - 1].tile;
            }
        }
    }
    r->b[0] = (u8)tile;
    *combat_cell(x, y) = 0x1D;
    center_view(combatant_x(*cp), combatant_y(*cp), 0xFF, 8);
    show_char_message(*cp, 0x14, "dissolves into acid!", 0x0A, 0);
}

/*
 * PORT H027+$174E: chi combatte con un'arma in mano da distanza > 1 ha
 * chance% di schivare il colpo ("Avoids it"): danno 0, -1 al tiro.
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
    H005_B(0x2474) = 0;
    H005_SET_W(0x2A1A, 0xFFFF);
    add_to_byte(&H005_B(0x2A18), 0xFFFF);
}

/* PORT H027+$1836 (effetto $29): schiva sempre le armi senza bonus (+$36). */
EH(effect_29)
{
    CokItem *w;                         /* -$4(a5) */

    (void)obj; (void)flag;
    w = combat_weapon(g_current_char);
    if (w != NULL && COK_GET16(&w->b[0x36]) == 0) {
        avoid_missile(cp, 100);
    }
}

/*
 * PORT H027+$1E3C (effetto $3C): alla rimozione "explodes!": 3d6 ai
 * combattenti attivi attorno, stordimento ($6A) senza tiro salvezza; dopo
 * ogni vicino esplodono i personaggi a terra (H062+$2734).
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
    n = (u8)(H005_B(0x2479) - 1);
    for (j = 2; j <= H005_B(0x2479); ++j) {
        list[j - 2] = H005_B(0x2A3E + (j - 1) * 4);
    }
    for (j = 1; j <= n; ++j) {
        p = g_combatants[list[j - 1] - 1];
        if (p->b[0x198]) {
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
 * PORT H027+$2400 (effetto $43): chi attacca da vicino con un'arma non
 * maledetta (+$3C), su d20 >= FOR-3, "loses his weapon": l'arma passa alla
 * lista H005+$3360 (copia + chi l'ha persa) e lascia l'inventario.  Il
 * martello (tipo 6, +$34 = $79) non si perde.
 */
EH(effect_43)
{
    CokItem *w;                         /* -$4(a5) */
    CokDropped *d;                      /* -$8(a5) */

    (void)obj; (void)flag;
    w = combat_weapon(g_current_char);
    if (roll_dice(1, 0x14) < (u16)(g_current_char->b[0x17] - 3)) {
        return;
    }
    if (H005_B(0x2471) != 0 || w == NULL || w->b[0x3C] || H005_B(0x24AF)) {
        return;
    }
    if (combat_distance(g_current_char, *cp) != 1) {
        return;
    }
    show_char_message(g_current_char, 0x10, "loses his weapon", 0x0A, 1);
    d = g_dropped_items;
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
 * PORT H027+$29E2 (effetto $47): con d10 = 1 su un incantesimo di livello
 * (+6) < 8, o sempre sopra $E, "reflects the spell" verso il lanciatore.
 * Come l'originale, animazione e *cp = lanciatore si ripetono per ogni
 * bersaglio della lista, anche quelli non sostituiti.
 */
EH(effect_47)
{
    u16 i;                              /* -$2(a5) */

    (void)obj; (void)flag;
    if (!(roll_dice(1, 0x0A) == 1 && SPELL_B(H005_B(0x2471), 6) < 8) &&
        SPELL_B(H005_B(0x2471), 6) <= 0x0E) {
        return;
    }
    show_char_message(*cp, 0x12, "reflects the spell", 0x0A, 0);
    H005_SET_W(0x251A, combatant_x(g_current_char));
    H005_SET_W(0x2518, combatant_y(g_current_char));
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

/* Spavento: fugge ($19A, $EC = $B3), niente bersaglio, turno +$12. */
static void make_flee(Character *p)
{
    p->b[0x19A] = 1;
    if (p->b[0xEC] <= 0x7F) {
        p->b[0xEC] = 0xB3;
    }
    p->block_192->target = NULL;
    p->block_192->b[0x12] = 1;
}

/*
 * PORT H027+$2B3E (effetto $48): i nemici attorno senza $5C che falliscono
 * il tiro salvezza "is terrified" ($6F) e fuggono.
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
    for (j = 2; j <= H005_B(0x2479); ++j) {
        p = g_combatants[H005_B(0x2A3E + (j - 1) * 4) - 1];
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
 * PORT H027+$2D46 (effetto $4C, "gates in"): finche' ha meno di meta' dei
 * punti ferita, rimette in campo i personaggi in stato 9 nelle caselle
 * libere ($17) attorno ai personaggi dell'altro lato, poi toglie l'effetto.
 * L'originale non avanza la direzione per una casella fuori mappa (ciclo
 * senza fine al bordo) e legge +$199 di un successivo NULL; qui un NULL
 * chiude come il ritorno al lanciatore.
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
    if ((*cp)->b[0x1A8] >= (u16)((*cp)->b[0x64] >> 1)) {
        return;
    }
    s = g_party_head;
    anchor = g_party_head;
    while (anchor != NULL && anchor->b[0x199] == (*cp)->b[0x199]) {
        anchor = anchor->next;
    }
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
            x = (s16)(x0 + H005_W(0x3EE2 + dir * 2));
            y = (s16)(y0 + H005_W(0x3ED0 + dir * 2));
            if (x > 0x31 || x < 0 || y > 0x18 || y < 0) {
                continue;
            }
            combat_map_cell(x, y, &value, &tile);
            if (value == 0 && tile == 0x17) {
                n = combatant_index(s);
                H005_B(0x3154 + (n - 1) * 6 + 5) = mask_byte(s->b[0xD3], 7);
                H005_SET_W(0x3154 + (n - 1) * 6, (u16)x);
                H005_SET_W(0x3154 + (n - 1) * 6 + 2, (u16)y);
                h043_190e(0x16);
                revived = revive(s, s->b[0x64], 8, "gates in");
                s = s->next;
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
 * PORT H027+$2FE2 (effetto $4D, berserk): fugge dai compagni ($EC = $B3, o
 * $B2 per i mostri con IA propria); in combattimento prende per bersaglio
 * il primo dell'area ($2A42), passa al lato opposto e "goes berserk".  Alla
 * rimozione torna al lato 0.
 */
EH(effect_4d)
{
    Character *c = *cp;
    u16 a;
    u16 b;

    (void)obj;
    if (flag) {
        if (c->b[0xEC] == 0xB3) {
            c->b[0xEC] = 0;
            c->b[0x19A] = 0;
        }
        c->b[0x199] = 0;
        return;
    }
    c->b[0x19A] = 1;
    if (c->b[0xEC] <= 0x7F || c->b[0xEC] == 0xB3) {
        c->b[0xEC] = 0xB3;
    } else {
        c->b[0xEC] = 0xB2;
    }
    if (H005_B(0x3DE3) != 5) {
        return;
    }
    c->block_192->target = NULL;
    a = combatant_x(*cp);
    b = combatant_y(*cp);
    find_in_area((s16)a, (s16)b, 0xFF, 0xFF,
                 combatant_size(*cp), g_combat_area);
    (*cp)->block_192->target = g_combatants[H005_B(0x2A42) - 1];
    (*cp)->block_192->b[1] = 0;
    (*cp)->b[0x199] = xor_byte((*cp)->block_192->target->b[0x199], 1);
    show_char_message(*cp, 0x0C, "goes berserk", 0x0A, 1);
}

/*
 * PORT H027+$3D28 (effetto $6B): come $4D senza il controllo del
 * combattimento e senza messaggio; alla rimozione il lato torna a +$4
 * dell'effetto e $19A resta.
 */
EH(effect_6b)
{
    Character *c = *cp;
    u16 a;
    u16 b;

    if (flag) {
        if (c->b[0xEC] == 0xB3) {
            c->b[0xEC] = 0;
        }
        c->b[0x199] = EFF->b[4];
        return;
    }
    c->b[0x19A] = 1;
    if (c->b[0xEC] <= 0x7F || c->b[0xEC] == 0xB3) {
        c->b[0xEC] = 0xB3;
    } else {
        c->b[0xEC] = 0xB2;
    }
    c->block_192->target = NULL;
    a = combatant_x(*cp);
    b = combatant_y(*cp);
    find_in_area((s16)a, (s16)b, 0xFF, 0xFF,
                 combatant_size(*cp), g_combat_area);
    (*cp)->block_192->target = g_combatants[H005_B(0x2A42) - 1];
    (*cp)->b[0x199] = xor_byte((*cp)->block_192->target->b[0x199], 1);
}

/*
 * PORT H027+$3160 (effetto $4F): "emits an evil stench"; per ogni nemico
 * attorno che fallisce il tiro salvezza e non ha $76: "is affected" e,
 * come nell'originale, l'effetto $76 va a chi emette il fetore.
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
    for (j = 2; j <= H005_B(0x2479); ++j) {
        p = g_combatants[H005_B(0x2A3E + (j - 1) * 4) - 1];
        if (p->b[0x199] == (*cp)->b[0x199] || saving_throw_roll(p, 4, 0) ||
            find_effect(p, 0x76, &e)) {
            continue;
        }
        show_effect_message(p, 1, 0x0B, "is affected");
        add_effect(*cp, 0x76, 0, 0xFF, 0);
    }
}

/*
 * PORT H027+$3636 (effetto $52, aura di paura): i personaggi dell'altro
 * lato senza $5C/$6F/$77: fino a 3 dadi vita (+$DB) "is terrified" ($6F) e
 * fuggono, oltre "is afraid" ($77) se falliscono il tiro salvezza.
 */
EH(effect_52)
{
    CokEffect *e = NULL;                /* -$8(a5) */
    Character *p;                       /* -$4(a5) */

    (void)obj; (void)flag;
    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0x199] == (*cp)->b[0x199] || find_effect(p, 0x5C, &e) ||
            find_effect(p, 0x6F, &e) || find_effect(p, 0x77, &e)) {
            continue;
        }
        if (p->b[0xDB] <= 3) {
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
 * PORT H027+$3982 (effetto $5E): con $2A13 = 0, 2 o 4 aggiunge a $2476 un
 * bonus dalla costituzione (+$19): 4-6 +1, 7-10 +2, 11-13 +3, 14-17 +4,
 * 18-20 +5.  Fuori tabella l'originale somma un byte non inizializzato:
 * qui 0.
 */
EH(effect_5e)
{
    u8 bonus = 0;                       /* -$1(a5) */
    u8 con;

    (void)obj; (void)flag;
    if (H005_B(0x2A13) != 4 && H005_B(0x2A13) != 2 && H005_B(0x2A13) != 0) {
        return;
    }
    con = (*cp)->b[0x19];
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
    H005_B(0x2476) = (u8)(H005_B(0x2476) + bonus);
}

/*
 * PORT H027+$4276: installa i gestori degli effetti di H027 nella tabella
 * H005+$2832 (le altre voci le scrive H033+$1A50).
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
