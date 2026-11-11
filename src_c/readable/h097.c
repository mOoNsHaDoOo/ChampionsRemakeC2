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
/* $2444: lista dei nemici vicini (numero del combattente, 1 byte per voce, i da 1) */
#define NEAR(i)         H005_B(0x2444 + (i) - 1)
#define COMBATANT(n)    g_combatants[(n) - 1]
/* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word) */
#define POS_X(n)        H005_W(0x3154 + ((n) - 1) * 6)
/* $3156: posizioni combattenti +2: riga sulla mappa (word) */
#define POS_Y(n)        H005_W(0x3154 + ((n) - 1) * 6 + 2)
/* $66: tabella incantesimi, 16 byte per incantesimo (da 1); k/o = campo */
#define SPELL_B(s, o)   H005_B(0x66 + ((s) - 1) * 16 + (o))
/* $336C: tabella dei tipi di oggetto (ogg+$30), $12 byte per tipo; off = campo */
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
    if (!G_KEY) { /* $5305: tasto/azione pendente dall'input (G_KEY) */
        return 0;
    }
    key = G_KEY; /* $5305: tasto/azione pendente dall'input (G_KEY) */
    handled = 1;
    switch (key) {
    case '2':
        /* $24A0: Magic On/Off (tasto 2): i personaggi in automatico lanciano magie */
        H005_B(0x24A0) = (u8)(H005_B(0x24A0) == 0);
        if (H005_B(0x24A0)) { /* $24A0: Magic On/Off (tasto 2): i personaggi in automatico lanciano magie */
            show_message_line(8, "Magic On");
        } else {
            show_message_line(9, "Magic Off");
        }
        break;
    case ' ':
        for (p = g_party_head; p != NULL; p = p->next) {
            /* pg+$EC: controllo: <$80 PG, >$7F PNG/IA ($B3 = charme o confuso); pg+$197: stato: 0
             * ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
            if (p->b[0xEC] < 0x80 && p->b[0x197] != 1) {
                p->b[0x19A] = 0; /* pg+$19A: controllo automatico in combattimento (1 = IA) */
            }
        }
        if (!c->b[0x19A]) { /* pg+$19A: controllo automatico in combattimento (1 = IA) */
            /* turno+$4: (word) iniziativa del round (1d6+destrezza); <=0 turno finito */
            TURN_PUTW(c, 4, 0x14);
            if (TURN(c)->b[8] > 0) { /* turno+$8: punti movimento rimasti nel turno */
                /* $2480: posizione corrente nell'ordine dei turni (1..$48, g_turn_order) */
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
    /* turno+$4: (word) iniziativa del round (1d6+destrezza); <=0 turno finito */
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

    /* $336C: tipi di oggetto, $12 byte per tipo (+$30): +0 slot/genere; ogg+$30: tipo dell'oggetto
     * (indice tabella H005+$336C, $12 byte per voce) */
    exec_copy_mem(&g_h005[0x336C + it->b[0x30] * 0x12], tab, 0x12);
    v = (u16)(tab[0x0B] * tab[0x0A]);
    if ((s16)COK_GET16(it->b + 0x36) > 0) { /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
        /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
        v = (u16)(v + COK_GET16(it->b + 0x36) * 8);
    }
    if ((s16)COK_GET16(tab + 0x0C) > 0) {
        v = (u16)(v + COK_GET16(tab + 0x0C) * 2);
    }
    /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
    if (it->b[0x30] == 0x36 && TURN(c)->target != NULL &&
        /* pg+$DF: tipo di non morto (0 = no); base -1 abilita' da ladro +$E0..+$E7 */
        TURN(c)->target->b[0xDF] > 0) {
        v = 8;
    }
    if (mask_byte(tab[0x10], 8)) {
        v = (u16)(v + (tab[6] - 1) * 2);
    }
    if (tab[1] <= 1) {
        v = (u16)(v + 3);
    }
    if ((u16)(tab[1] + c->b[0x188]) > 3) { /* pg+$188: mani occupate dagli oggetti pronti (max 2) */
        v = 0;
    }
    /* ogg+$46: tipo dell'effetto magico: bit7 = effetto passivo, bit 0..6 tipo; ogg+$45:
     * incantesimo/parametro dell'oggetto magico (bit 7 escluso); pg+$10F: allineamento (0..8,
     * malvagi 2/5/8; nomi H005+$4C62) */
    if (it->b[0x46] == 0x84 && mask_byte(it->b[0x45], 0x0F) != c->b[0x10F]) {
        v = 0;
    }
    if (it->b[0x45] == 0x53) { /* ogg+$45: incantesimo/parametro dell'oggetto magico (bit 7 escluso) */
        v = 0;
    }
    if (it->b[0x3C]) { /* ogg+$3C: flag oggetto maledetto */
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

    TURN(c)->b[0x16] = 0; /* turno+$16: flag mostro in fuga (morale) */
    h062_nop_1898();
    if (TURN(c)->b[0x12]) { /* turno+$12: flag costretto a fuggire (paura, confusione) */
        TURN(c)->b[0x16] = 1; /* turno+$16: flag mostro in fuga (morale) */
        show_char_message(c, 0x11, "is forced to flee", 0x0A, 1);
        return 0;
    }
    if (c->b[0xEC] <= 0x7F) { /* pg+$EC: controllo: <$80 PG, >$7F PNG/IA ($B3 = charme o confuso) */
        return 0;
    }
    /* $2478: morale del mostro (0..100) passato agli eventi $11; pg+$EC: controllo: <$80 PG, >$7F
     * PNG/IA ($B3 = charme o confuso) */
    H005_B(0x2478) = (u8)(mask_byte(c->b[0xEC], 0x7F) * 2);
    if (H005_B(0x2478) > 0x66) { /* $2478: morale del mostro (0..100) passato agli eventi $11 */
        H005_B(0x2478) = 0; /* $2478: morale del mostro (0..100) passato agli eventi $11 */
    }
    trigger_event(&c, 0x11);
    /* pg+$64: punti ferita massimi; pg+$1A8: punti ferita correnti */
    hurt = (u16)(c->b[0x64] ? (u16)(c->b[0x1A8] * 0x64) / c->b[0x64] : 0x64);
    /* $2478: morale del mostro (0..100) passato agli eventi $11 */
    if (!(H005_B(0x2478) < (u16)(0x64 - hurt)) && H005_B(0x2478) != 0) {
        return 0;
    }
    saved = H005_B(0x2478); /* $2478: morale del mostro (0..100) passato agli eventi $11 */
    (void)saved;
    /* $2478: morale del mostro (0..100) passato agli eventi $11; $2481: forza dei nemici in % (PF
     * vivi/massimi, passi di 5) per la fuga */
    H005_B(0x2478) = H005_B(0x2481);
    trigger_event(&c, 0x11);
    /* $2478: morale del mostro (0..100) passato agli eventi $11; B+$58C: uso: IA ($80+v) dei PNG
     * fuori lotta; tolto da 100 nel test fuga */
    if (!(H005_B(0x2478) < (u16)(0x64 - COK_GET16(g_state_b + 0x58C))) &&
        /* $2478: morale del mostro (0..100) passato agli eventi $11; pg+$199: lato in combattimento
         * (0 party, 1 avversari) */
        H005_B(0x2478) != 0 && c->b[0x199]) {
        return 0;
    }
    best = enemy_distance_points(c);
    if ((u16)(movement_points(c) >> 1) >= best) {
        TURN(c)->b[0x16] = 1; /* turno+$16: flag mostro in fuga (morale) */
        remove_effect(c, 0x4A, NULL);
        remove_effect(c, 0x4B, NULL);
        return 0;
    }
    if (c->b[0x13] > 5) { /* pg+$13: intelligenza corrente */
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

    /* pg+$199: lato in combattimento (0 party, 1 avversari) */
    bonus = (s16)(g_current_char->b[0x199] == 0 ? -2 : 8);
    find_in_area(x, y, SPELL_B(spell, 0x0F), 0xFF, 1, g_combat_area);
    /* $2479: numero di voci della lista dell'area +$2A3E (4 byte per voce) */
    for (i = 1; i <= H005_B(0x2479); ++i) {
        /* $2A3E: lista dell'area: voci da 4 byte ($2479), byte 0 = n. combattente */
        e = COMBATANT(H005_B(0x2A3E + (i - 1) * 4));
        /* pg+$199: lato in combattimento (0 party, 1 avversari) */
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
        /* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word); $2444..: nemici
         * vicini ($2444+i-1); $3156: posizioni combattenti +2:
         * riga sulla mappa (word) */
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
    /* turno+$2: flag puo' usare oggetti (azzerato tossendo nella nube); $2A1C: combattenti attivi
     * del lato 0; tabella byte indicizzata dal lato */
    if (TURN(c)->b[2] && H005_B(0x2A1C + other_side(c)) > 0 &&
        /* A+$1CA: (word) se non nullo nell'area non si lanciano incantesimi */
        COK_GET16(g_state_a + 0x1CA) == 0) {
        for (i = 1; i <= tries; ++i) {
            for (it = c->items; it != NULL && found == NULL; it = it->next) {
                sp = it->b[0x45]; /* ogg+$45: incantesimo/parametro dell'oggetto magico (bit 7 escluso) */
                /* ogg+$46: tipo dell'effetto magico: bit7 = effetto passivo, bit 0..6 tipo;
                 * ogg+$3A: flag oggetto pronto all'uso (Ready) */
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

    /* turno+$13: Turn Undead gia' usati nel combattimento (max H005+$248F); $248F: mostri caricati
     * con +$DF: limite di Turn Undead (turno +$13) */
    if (TURN(c)->b[0x13] < H005_B(0x248F) &&
        /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico; pg+$106: livelli
         * della classe precedente, 8 voci come +$FE; chierico; pg+$DC: uso: soglia per i livelli
         * +$106..+$10D e i PF; !=0 vieta Modify */
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

    if (TURN(c)->b[1]) { /* turno+$1: flag puo' lanciare incantesimi (non in nube; azzerato attaccando) */
        for (k = 1; k <= 0x39; ++k) {
            /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
            if (c->b[0x1E + k] > 0) {
                /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
                list[n] = c->b[0x1E + k];
                ++n;
            }
        }
    }
    tries = roll_dice(1, 7);
    i = 1;
    /* pg+$EC: controllo: <$80 PG, >$7F PNG/IA ($B3 = charme o confuso); $24A0: Magic On/Off (tasto
     * 2): i personaggi in automatico lanciano magie */
    if (n > 0 && (c->b[0xEC] > 0x7F || H005_B(0x24A0)) &&
        /* $2A1C: combattenti attivi del lato 0; tabella byte indicizzata dal lato */
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
        /* pg+$188: mani occupate dagli oggetti pronti (max 2); $336D: tipi di oggetto +1: mani
         * occupate (si somma a +$188, max 2); ogg+$30: tipo dell'oggetto (indice tabella
         * H005+$336C, $12 byte per voce) */
        c->b[0x188] = (u8)(c->b[0x188] - WTAB(c->readied[0]->b[0x30], 1));
    }
    if (c->readied[1] != NULL) {
        /* pg+$188: mani occupate dagli oggetti pronti (max 2); $336D: tipi di oggetto +1: mani
         * occupate (si somma a +$188, max 2); ogg+$30: tipo dell'oggetto (indice tabella
         * H005+$336C, $12 byte per voce) */
        c->b[0x188] = (u8)(c->b[0x188] - WTAB(c->readied[1]->b[0x30], 1));
    }
    /* pg+$114: facce del dado base dell'attacco 1 (2 voci +$114..+$115); pg+$112: numero di dadi
     * base dell'attacco 1 (2 voci +$112..+$113) */
    s2 = (u16)(c->b[0x114] * c->b[0x112]);
    if ((s16)CH_W(c, 0x116) > 0) { /* pg+$116: bonus ai danni base, 2 word (attacco 1 e 2) */
        s2 = (u16)(s2 + CH_W(c, 0x116) * 2); /* pg+$116: bonus ai danni base, 2 word (attacco 1 e 2) */
    }
    for (it = c->items; it != NULL; it = it->next) {
        t = it->b[0x30]; /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
        /* $336C: tipi di oggetto, $12 byte per tipo (+$30): +0 slot/genere; $337B: tipi di oggetto
         * +$F: maschera delle classi ammesse (vs +$122); pg+$122: maschera delle armi usabili
         * (somma H005+$5040 per classe) */
        if (WTAB(t, 0) == 0 && mask_byte(WTAB(t, 0x0F), c->b[0x122])) {
            v = weapon_value(c, it);
            /* $337C: tipi di oggetto +$10: flag arma (des/for, munizioni, mischia) */
            if (mask_byte(WTAB(t, 0x10), 8) || mask_byte(WTAB(t, 0x10), 0x10)) {
                if (v > s1) {
                    best = it;
                    s1 = v;
                }
            }
            /* $337C: tipi di oggetto +$10: flag arma (des/for, munizioni, mischia) */
            if (!mask_byte(WTAB(t, 0x10), 8) && v > s2) {
                melee = it;
                s2 = v;
            }
        }
        /* $336C: tipi di oggetto, $12 byte per tipo (+$30): +0 slot/genere; $337B: tipi di oggetto
         * +$F: maschera delle classi ammesse (vs +$122); pg+$122: maschera delle armi usabili
         * (somma H005+$5040 per classe) */
        if (WTAB(t, 0) == 1 && mask_byte(WTAB(t, 0x0F), c->b[0x122]) > 0) {
            /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
            if ((s16)COK_GET16(it->b + 0x36) >= 0) {
                /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
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
    /* $337A: tipi di oggetto +$E: gittata dell'arma (>1 = a distanza); ogg+$30: tipo dell'oggetto
     * (indice tabella H005+$336C, $12 byte per voce) */
    ranged = (u8)(best != NULL && WTAB(best->b[0x30], 0x0E) > 1 &&
                  /* $337C: tipi di oggetto +$10: flag arma (des/for, munizioni, mischia); ogg+$30:
                   * tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
                  mask_byte(WTAB(best->b[0x30], 0x10), 0x14) == 0x14);
    if (best != NULL) {
        /* $337C: tipi di oggetto +$10: flag arma (des/for, munizioni, mischia); ogg+$30: tipo
         * dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
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
        (c->readied[0] == chosen || c->readied[0]->b[0x3C])) { /* ogg+$3C: flag oggetto maledetto */
        need = 0;
    }
    if (need) {
        if (c->readied[0] != NULL) {
            ready_item(c->readied[0]);
        }
        recompute_stats(c);
        if (c->readied[1] != NULL && !c->readied[1]->b[0x3C]) { /* ogg+$3C: flag oggetto maledetto */
            /* pg+$188: mani occupate dagli oggetti pronti (max 2); $336D: tipi di oggetto +1: mani
             * occupate (si somma a +$188, max 2); ogg+$30: tipo dell'oggetto (indice tabella
             * H005+$336C, $12 byte per voce) */
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
        (c->readied[1] == shield || c->readied[1]->b[0x3C])) { /* ogg+$3C: flag oggetto maledetto */
        need = 0;
    }
    if (c->b[0x188] > 2) { /* pg+$188: mani occupate dagli oggetti pronti (max 2) */
        if (c->readied[1] == NULL || c->readied[1]->b[0x3C]) { /* ogg+$3C: flag oggetto maledetto */
            if (chosen != NULL) {
                ready_item(chosen);
            }
            changed = 1;
        } else {
            ready_item(c->readied[1]);
            changed = 1;
        }
    } else if (c->b[0x188] < 2 && need) { /* pg+$188: mani occupate dagli oggetti pronti (max 2) */
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
    /* H097_bss+$6: tabella 6 sequenze x 5 word: deviazioni di direzione dei passi; turno+$17:
     * sequenza di deviazione dei passi (1..6, tabella H097 bss +$6) */
    d = (u16)((dir + H097_W(0x3C - (TURN(c)->b[0x17] - 1) * 10 - (k - 1) * 2))
              & 7);
    probe_move(c, d, &blk, &tile, &cloud, &acid);
    if (tile == 0) {
        *edge = 1;
        return ok;
    }
    /* $3EF4: terreno, $41 voci da 4 byte (da 1): +0 costo ($FF invalicabile) */
    if (H005_B(0x3EF4 + (tile - 1) * 4) == 0xFF) {
        return 0;
    }
    if (d & 1) {
        /* $3EF4: terreno, $41 voci da 4 byte (da 1): +0 costo ($FF invalicabile) */
        cost = (u16)(H005_B(0x3EF4 + (tile - 1) * 4) * 3);
    } else {
        /* $3EF4: terreno, $41 voci da 4 byte (da 1): +0 costo ($FF invalicabile) */
        cost = (u16)(H005_B(0x3EF4 + (tile - 1) * 4) * 2);
    }
    if (blk != 0 || !(cost < TURN(c)->b[8])) { /* turno+$8: punti movimento rimasti nel turno */
        return ok;
    }
    if (cloud && !find_effect(c, 0x20, &e) && !find_effect(c, 0x1E, &e) &&
        !find_effect(c, 0x63, &e) && !find_effect(c, 0x3F, &e) &&
        /* turno+$12: flag costretto a fuggire (paura, confusione) */
        !TURN(c)->b[0x12] && !saving_throw_roll(c, 0, 0)) {
        cost = (u16)(TURN(c)->b[8] + 1); /* turno+$8: punti movimento rimasti nel turno */
    }
    /* pg+$DB: livello massimo fra le classi (usato anche come dadi vita) */
    if (acid && c->b[0xDB] < 7 && !find_effect(c, 0x63, &e) &&
        !TURN(c)->b[0x12]) { /* turno+$12: flag costretto a fuggire (paura, confusione) */
        cost = (u16)(TURN(c)->b[8] + 1); /* turno+$8: punti movimento rimasti nel turno */
    }
    if (TURN(c)->b[8] >= cost) { /* turno+$8: punti movimento rimasti nel turno */
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

    /* $3C82: buffer di testo generico di 80 caratteri (TEXT_BUF) */
    strcpy((char *)&g_h005[0x3C82], "Move/Attack, Move Left = ");
    /* turno+$8: punti movimento rimasti nel turno */
    format_number(0x50, num, (s32)(TURN(c)->b[8] >> 1), 0, 0x0A, 2, ' ');
    h026_append(0x50, num, 1, " ");
    /* $3C82: buffer di testo generico di 80 caratteri (TEXT_BUF) */
    h026_append(0x50, (char *)&g_h005[0x3C82], 0x50, num);
    /* $3C82: buffer di testo generico di 80 caratteri (TEXT_BUF) */
    ui_draw_text(0, 0x18, 0x0A, 0, 0x50, (const char *)&g_h005[0x3C82]);
    if (monster_keys(c)) {
        return done;
    }
    /* turno+$8: punti movimento rimasti nel turno; turno+$4: (word) iniziativa del round
     * (1d6+destrezza); <=0 turno finito */
    if (!((TURN(c)->b[8] >> 1) > 0 && (s16)TURN_W(c, 4) > 0)) {
        return monster_end(c);
    }
    if (c->b[0xEC] >= 0x80 && /* pg+$EC: controllo: <$80 PG, >$7F PNG/IA ($B3 = charme o confuso) */
        /* $2478: morale del mostro (0..100) passato agli eventi $11; $2481: forza dei nemici in %
         * (PF vivi/massimi, passi di 5) per la fuga */
        (u16)(roll_dice(1, 0x64) + H005_B(0x2478)) < H005_B(0x2481) &&
        c->b[0x199] != 1) { /* pg+$199: lato in combattimento (0 party, 1 avversari) */
        return monster_end(c);
    }
    /* turno+$16: flag mostro in fuga (morale); pg+$5C: classe o combinazione di classi (0..16, nomi
     * H005+$4D84) */
    if (!TURN(c)->b[0x16] && c->readied[2] == NULL && c->b[0x5C] == 5) {
        return monster_end(c);
    }
    if (!TURN(c)->b[0x16]) { /* turno+$16: flag mostro in fuga (morale) */
        dir = direction_toward(c, TURN(c)->target);
    } else {
        /* turno+$17: sequenza di deviazione dei passi (1..6, tabella H097 bss +$6) */
        TURN(c)->b[0x17] = (u8)roll_dice(1, 2);
        /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        dir = (u16)(H005_B(0x2820) - (((H005_B(0x2820) + 2) & 3) >> 1));
        if (!c->b[0x199]) { /* pg+$199: lato in combattimento (0 party, 1 avversari) */
            dir = (u16)(dir + 4);
        }
        dir &= 7;
    }
    k = 1;
    while (k < 6 && !done) {
        if (monster_step_ok(c, k, dir, &edge)) {
            break;
        }
        if (TURN(c)->b[0x16] && edge) { /* turno+$16: flag mostro in fuga (morale) */
            done = combat_flee(c);
        } else {
            ++k;
        }
    }
    if (done) {
        TURN(c)->b[8] = 0; /* turno+$8: punti movimento rimasti nel turno */
        TURN(c)->b[0x16] = 0; /* turno+$16: flag mostro in fuga (morale) */
        return end_combat_turn(c);
    }
    if (k < 6) {
        /* H097_bss+$6: tabella 6 sequenze x 5 word: deviazioni di direzione dei passi; turno+$17:
         * sequenza di deviazione dei passi (1..6, tabella H097 bss +$6) */
        ndir = (u16)((dir + H097_W(0x3C - (TURN(c)->b[0x17] - 1) * 10 -
                                   (k - 1) * 2)) & 7);
    }
    /* H097_bss+$4: (word) direzione dell'ultimo passo del mostro (8 = nessuna) */
    if (k == 6 || ((ndir + 4) & 7) == H097_W(0x3E)) {
        /* H097_bss+$2: (word) passi del mostro falliti/invertiti nel turno */
        H097_SETW(0x40, (u16)(H097_W(0x40) + 1));
        /* turno+$17: sequenza di deviazione dei passi (1..6, tabella H097 bss +$6) */
        TURN(c)->b[0x17] = (u8)(TURN(c)->b[0x17] % 6 + 1);
        if (H097_W(0x40) > 1) { /* H097_bss+$2: (word) passi del mostro falliti/invertiti nel turno */
            TURN(c)->target = NULL;
            if (H097_W(0x40) > 2) { /* H097_bss+$2: (word) passi del mostro falliti/invertiti nel turno */
                TURN(c)->b[8] = 0; /* turno+$8: punti movimento rimasti nel turno */
                done = 1;
            } else if (!ai_pick_target(c, 0xFF, 1, 0)) {
                done = monster_end(c);
            }
        }
    }
    if (k < 6) {
        H097_SETW(0x3E, ndir); /* H097_bss+$4: (word) direzione dell'ultimo passo del mostro (8 = nessuna) */
    } else {
        done = 1;
    }
    if (done) {
        return done;
    }
    /* $24C6: 1 se le azioni del combattente vanno disegnate (visibile); $24C8: 1 se il mostro puo'
     * attaccare il bersaglio ora (in gittata) */
    H005_B(0x24C6) = (u8)(H005_B(0x24C8) || combatant_visible(c, 0) ||
                          c->b[0x199] == 0); /* pg+$199: lato in combattimento (0 party, 1 avversari) */
    set_combatant_frame(c, (u8)ndir, 0, 0);
    /* turno+$B: orientamento/fotogramma del combattente (direzione 0..7) */
    combat_leave_attacks(c, TURN(c)->b[0x0B]);
    if (!c->b[0x198]) { /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
        return end_combat_turn(c);
    }
    if (TURN(c)->b[8] > 0) { /* turno+$8: punti movimento rimasti nel turno */
        /* turno+$B: orientamento/fotogramma del combattente (direzione 0..7) */
        combat_step(c, TURN(c)->b[0x0B]);
    }
    if (!c->b[0x198] || is_helpless(c)) { /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
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

    H097_SETW(0x3E, 8); /* H097_bss+$4: (word) direzione dell'ultimo passo del mostro (8 = nessuna) */
    H097_SETW(0x40, 0); /* H097_bss+$2: (word) passi del mostro falliti/invertiti nel turno */
    H097_SETW(0x42, 0); /* H097_bss+$0: uso: (word) azzerato all'inizio dell'attacco del mostro */
    trigger_event(&c, 0x0E);
    if (!c->b[0x199] && bandage_dying(1)) { /* pg+$199: lato in combattimento (0 party, 1 avversari) */
        TURN_PUTW(c, 4, 0); /* turno+$4: (word) iniziativa del round (1d6+destrezza); <=0 turno finito */
    }
    if (TURN_W(c, 4) == 0) { /* turno+$4: (word) iniziativa del round (1d6+destrezza); <=0 turno finito */
        cont = 0;
    }
    while (!done && cont) {
        /* turno+$16: flag mostro in fuga (morale); turno+$8: punti movimento rimasti nel turno */
        while (TURN(c)->b[0x16] && TURN(c)->b[8] > 0 &&
               /* turno+$4: (word) iniziativa del round (1d6+destrezza); <=0 turno finito */
               (s16)TURN_W(c, 4) > 0 && (s16)TURN_W(c, 4) < 0x14) {
            (void)monster_move(c);
        }
        /* turno+$4: (word) iniziativa del round (1d6+destrezza); <=0 turno finito */
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
        H005_B(0x24C8) = 0; /* $24C8: 1 se il mostro puo' attaccare il bersaglio ora (in gittata) */
        range = 1;
        if (c->readied[0] != NULL) {
            /* $337A: tipi di oggetto +$E: gittata dell'arma (>1 = a distanza); ogg+$30: tipo
             * dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
            range = (u16)(WTAB(c->readied[0]->b[0x30], 0x0E) - 1);
        }
        if (range == 0 || range >= 0xFF) {
            range = 1;
        }
        t = TURN(c)->target;
        /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento); pg+$199: lato in
         * combattimento (0 party, 1 avversari) */
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
                H005_B(0x24C8) = 1; /* $24C8: 1 se il mostro puo' attaccare il bersaglio ora (in gittata) */
            }
        }
        if (!H005_B(0x24C8)) { /* $24C8: 1 se il mostro puo' attaccare il bersaglio ora (in gittata) */
            n = count_enemies_near(c, range);
            if (n == 0) {
                if (ai_pick_target(c, 0xFF, 0, 0)) {
                    (void)monster_move(c);
                } else {
                    done = monster_end(c);
                }
            } else {
                /* $2444..: lista dei nemici vicini ($2444+i-1, i da 1) */
                t = COMBATANT(NEAR(roll_dice(1, n)));
                if (has_ranged_weapon(c) && !weapon_melee_ok(c) &&
                    count_enemies_near(c, 1) > 0) {
                    monster_choose_weapons(c);
                    done = 1;
                } else if (combat_distance(c, t) == 1 || can_attack(c, t)) {
                    /* $24C8: 1 se il mostro puo' attaccare il bersaglio ora (in gittata) */
                    H005_B(0x24C8) = 1;
                }
            }
        }
        if (H005_B(0x24C8)) { /* $24C8: 1 se il mostro puo' attaccare il bersaglio ora (in gittata) */
            center_view((s16)combatant_x(c), (s16)combatant_y(c), 2,
                        direction_toward(c, t));
        }
        if (!H005_B(0x24C8)) { /* $24C8: 1 se il mostro puo' attaccare il bersaglio ora (in gittata) */
            continue;
        }
        if (combat_sweep(c, t)) {
            done = end_combat_turn(c);
            continue;
        }
        record_attack(c, t);
        w = NULL;
        if (has_ranged_weapon(c)) {
            /* $24C8: 1 se il mostro puo' attaccare il bersaglio ora (in gittata) */
            H005_B(0x24C8) = find_weapon(c, &w);
            if (weapon_melee_ok(c) && combat_distance(c, t) == 1) {
                w = NULL;
            }
        }
        combat_attack(c, t, 0, w, &done);
        if (done) {
            TURN(c)->b[8] = 0; /* turno+$8: punti movimento rimasti nel turno */
            cont = 0;
        } else if (!t->b[0x198]) { /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
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
    if (!c->b[0x198]) { /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
        done = end_combat_turn(c);
    }
    m = TURN(c)->b[0x17]; /* turno+$17: sequenza di deviazione dei passi (1..6, tabella H097 bss +$6) */
    if (m == 0 || m > 4 || roll_dice(1, 4) == 1) {
        m = roll_dice(1, 8);
        if (m == 8) {
            m = (u16)(roll_dice(1, 2) + 4);
        } else {
            m = roll_dice(1, 4);
        }
    }
    TURN(c)->b[0x17] = (u8)m; /* turno+$17: sequenza di deviazione dei passi (1..6, tabella H097 bss +$6) */
    if (!done) {
        done = monster_morale(c);
    }
    /* turno+$16: flag mostro in fuga (morale); turno+$12: flag costretto a fuggire (paura,
     * confusione) */
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
    if (TURN(c)->b[0] > 0) { /* turno+$0: incantesimo in preparazione da lanciare all'inizio del turno */
        /* turno+$0: incantesimo in preparazione da lanciare all'inizio del turno */
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
        /* turno+$4: (word) iniziativa del round (1d6+destrezza); <=0 turno finito */
        if (ai_pick_target(c, 0xFF, 1, 0) && (s16)TURN_W(c, 4) > 0 &&
            c->b[0x198]) { /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
            done = monster_attack(c);
        } else {
            done = monster_end(c);
        }
    }
}
