/* H063: Helper per personaggi, inventario e aggiornamento UI; mappa parziale. */
#include <string.h>

#include "h063.h"
#include "h008.h"
#include "h003_exec.h"
#include "h056.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h045.h"
#include "h073.h"
#include "globals.h"
#include "h044_tiles.h"
#include "unported.h"
#include "h042_seq.h"
#include "h060.h"
#include "h016_gfx.h"
#include "h049.h"
#include "h077.h"
#include "h048.h"
#include "h036.h"

/* PORT H063+$0104: link/unlk, nessun effetto. */
void h063_init(void)
{
}

/* -$2(a4): peso degli oggetti pronti (H063+$13BE). */
static u16 s_ready_weight;

/* Copia con dbeq: al massimo max + 1 byte, NUL compreso. */
static void copy_text(char *dst, const char *src, u16 max)
{
    u16 i;

    for (i = 0; i <= max; ++i) {
        dst[i] = src[i];
        if (src[i] == 0) {
            break;
        }
    }
}

/* Riga della tabella dei tipi di oggetto H005+$336C ($12 byte). */
/* $336C: tabella dei tipi di oggetto (ogg+$30), $12 byte per tipo; off = campo */
#define ITEM_TYPE(t, off) H005_B(0x336C + (t) * 0x12 + (off))
#define ITEM_W(it, off)   ((s16)COK_GET16((it)->b + (off)))

/* PORT H063+$0112: toglie gli spazi iniziali (sul posto). */
void trim_leading_spaces(u16 len, char *s)
{
    u16 i;

    (void)len;
    while (s[0] == ' ') {
        for (i = 0; s[i] != 0; ++i) {
            s[i] = s[i + 1];
        }
    }
}

/* PORT H063+$016A: correzione di destrezza (+$17) per le armi da lancio. */
s16 dex_missile_adj(Character *c)
{
    /* pg+$17: destrezza corrente */
    s16 dex = c->b[0x17];               /* -$2(a5) */

    switch (dex) {
    case 0: case 1: case 2:
        return -4;
    case 3: case 4: case 5:
        return (s16)(dex - 6);
    case 16: case 17: case 18:
        return (s16)(dex - 0x0F);
    case 19: case 20:
        return 3;
    case 21: case 22: case 23:
        return 4;
    case 24: case 25:
        return 5;
    default:
        return 0;
    }
}

/*
 * PORT H063+$0228: forza effettiva: 0..17 come e', 18 secondo la
 * percentuale (+$1C) in 18..23, 19..25 piu' 5.  Oltre 25 l'originale
 * restituisce un valore non inizializzato; qui 0.
 */
static s16 effective_strength(Character *c)
{
    u8 s = c->b[0x11]; /* pg+$11: caratteristiche correnti, 6 voci passo 2 da +$11; forza corrente */

    if (s <= 17) {
        return s;
    }
    if (s == 18) {
        if (c->b[0x1C] == 0) { /* pg+$1C: forza eccezionale corrente (18/xx, 1..100) */
            return 0x12;
        }
        if (c->b[0x1C] < 0x33) { /* pg+$1C: forza eccezionale corrente (18/xx, 1..100) */
            return 0x13;
        }
        if (c->b[0x1C] < 0x4C) { /* pg+$1C: forza eccezionale corrente (18/xx, 1..100) */
            return 0x14;
        }
        if (c->b[0x1C] < 0x5B) { /* pg+$1C: forza eccezionale corrente (18/xx, 1..100) */
            return 0x15;
        }
        if (c->b[0x1C] < 0x64) { /* pg+$1C: forza eccezionale corrente (18/xx, 1..100) */
            return 0x16;
        }
        return 0x17;
    }
    if (s <= 25) {
        return (s16)(s + 5);
    }
    return 0;
}

/* PORT H063+$0354: bonus della forza per colpire (con +$11B). */
s16 str_hit_bonus(Character *c)
{
    s16 bonus = 0;                      /* -$4(a5) */
    s16 s = effective_strength(c);      /* -$2(a5) */

    if (!c->b[0x11B]) { /* pg+$11B: applica i bonus della forza a colpire e ai danni (1 per i PG) */
        return bonus;
    }
    switch (s) {
    case 1: case 2: case 3:
        bonus = -3;
        break;
    case 4: case 5:
        bonus = -2;
        break;
    case 6: case 7:
        bonus = -1;
        break;
    case 17: case 18: case 19:
        bonus = 1;
        break;
    case 20: case 21: case 22:
        bonus = 2;
        break;
    case 23: case 24: case 25:
        bonus = 3;
        break;
    case 26: case 27:
        bonus = 4;
        break;
    case 28: case 29: case 30:
        bonus = (s16)(s - 0x17);
        break;
    default:
        break;
    }
    return bonus;
}

/* PORT H063+$18F8: correzione di destrezza alla classe d'armatura. */
static s16 dex_ac_adj(Character *c)
{
    /* pg+$17: destrezza corrente */
    s16 dex = c->b[0x17];               /* -$2(a5) */

    switch (dex) {
    case 1: case 2: case 3:
        return -4;
    case 4: case 5: case 6:
        return (s16)(dex - 7);
    case 15: case 16: case 17: case 18:
        return (s16)(dex - 0x0E);
    case 19: case 20:
        return 4;
    case 21: case 22: case 23:
        return 5;
    case 24: case 25:
        return 6;
    default:
        return 0;
    }
}

/* PORT H063+$19B6: bonus della forza ai danni (con +$11B). */
s16 str_damage_bonus(Character *c)
{
    s16 bonus = 0;                      /* -$2(a5) */
    s16 s = effective_strength(c);      /* -$4(a5) */

    if (!c->b[0x11B]) { /* pg+$11B: applica i bonus della forza a colpire e ai danni (1 per i PG) */
        return bonus;
    }
    switch (s) {
    case 1: case 2:
        bonus = -2;
        break;
    case 3: case 4: case 5:
        bonus = -1;
        break;
    case 16:
        bonus = 1;
        break;
    case 17: case 18: case 19:
        bonus = (s16)(s - 0x10);
        break;
    case 20: case 21: case 22: case 23: case 24:
    case 25: case 26: case 27: case 28: case 29:
        bonus = (s16)(s - 0x11);
        break;
    case 30:
        bonus = 0x0E;
        break;
    default:
        break;
    }
    return bonus;
}

/* PORT H063+$1A8A: peso trasportabile in piu' per la forza. */
s16 str_weight_allowance(Character *c)
{
    s16 s = effective_strength(c);      /* -$4(a5) */

    switch (s) {
    case 1: case 2: case 3:
        return -350;
    case 4: case 5:
        return -250;
    case 6: case 7:
        return -150;
    case 12: case 13:
        return 100;
    case 14: case 15:
        return 200;
    case 16:
        return 350;
    case 17: case 18: case 19: case 20: case 21:
        return (s16)((s - 0x11) * 0xFA + 0x1F4);
    case 22: case 23: case 24: case 25: case 26:
        return (s16)((s - 0x16) * 0x3E8 + 0x7D0);
    case 27:
        return 0x1D4C;
    case 28: case 29: case 30:
        return (s16)((s - 0x1C) * 0xBB8 + 0x2328);
    default:
        return 0;
    }
}

/*
 * PORT H063+$0432: valori dell'arma pronta (slot 0): THAC0 base (+$19B da
 * +$5A) con destrezza o forza secondo i bit di H005+$336C+$10, danno
 * (+$1A0, +$1A2, +$1A4) e bonus magici, compresi quelli degli oggetti
 * degli slot 11 e 12 e di razza.
 */
static void weapon_stats(Character *c)
{
    CokItem *w = c->readied[0];         /* -$4(a5) */
    u16 t;                              /* -$6(a5) */
    s16 bonus;                          /* -$8(a5) */

    if (w == NULL) {
        return;
    }
    t = w->b[0x30]; /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
    /* pg+$19B: THAC0 corrente codificato (60 - THAC0); pg+$5A: THAC0 base codificato (60 - THAC0)
     * dalla tabella per livello */
    c->b[0x19B] = c->b[0x5A];
    /* $337C: tipi di oggetto +$10: flag arma (des/for, munizioni, mischia) */
    if (mask_byte(ITEM_TYPE(t, 0x10), 2)) {
        /* pg+$19B: THAC0 corrente codificato (60 - THAC0) */
        c->b[0x19B] = (u8)(c->b[0x19B] + dex_missile_adj(c));
    }
    /* $3378: tipi di oggetto +$C: (word) bonus al danno, in +$1A4; pg+$1A4: bonus ai danni, 2 word
     * (attacco 1 e 2) */
    CH_PUTW(c, 0x1A4, COK_GET16(&g_h005[0x336C + t * 0x12 + 0x0C]));
    /* $337C: tipi di oggetto +$10: flag arma (des/for, munizioni, mischia) */
    if (mask_byte(ITEM_TYPE(t, 0x10), 4)) {
        /* pg+$19B: THAC0 corrente codificato (60 - THAC0) */
        c->b[0x19B] = (u8)(c->b[0x19B] + str_hit_bonus(c));
        /* pg+$1A4: bonus ai danni, 2 word (attacco 1 e 2) */
        CH_PUTW(c, 0x1A4, (u16)(str_damage_bonus(c) + CH_W(c, 0x1A4)));
    }
    bonus = ITEM_W(w, 0x36); /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
    /* $337C: tipi di oggetto +$10: flag arma (des/for, munizioni, mischia) */
    if (ITEM_TYPE(t, 0x10) > 0x7F && c->readied[12] != NULL) {
        /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
        bonus = (s16)(bonus + ITEM_W(c->readied[12], 0x36));
    }
    /* $337C: tipi di oggetto +$10: flag arma (des/for, munizioni, mischia) */
    if (mask_byte(ITEM_TYPE(t, 0x10), 1) && c->readied[11] != NULL) {
        /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
        bonus = (s16)(bonus + ITEM_W(c->readied[11], 0x36));
    }
    CH_PUTW(c, 0x1A4, (u16)(CH_W(c, 0x1A4) + bonus)); /* pg+$1A4: bonus ai danni, 2 word (attacco 1 e 2) */
    if (c->b[0x5B] == 0 || c->b[0x5B] == 1) { /* pg+$5B: razza (0..6, nomi H005+$4D04) */
        /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
        if ((w->b[0x30] > 0x15 && w->b[0x30] < 0x1B) || w->b[0x30] == 0x13 ||
            /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
            w->b[0x30] == 0x12) {
            ++bonus;
        }
    }
    /* pg+$5B: razza (0..6, nomi H005+$4D04); ogg+$30: tipo dell'oggetto (indice tabella H005+$336C,
     * $12 byte per voce) */
    if (c->b[0x5B] == 5 && w->b[0x30] == 0x43) {
        bonus = (s16)(bonus + 2);
    }
    c->b[0x19B] = (u8)(c->b[0x19B] + bonus); /* pg+$19B: THAC0 corrente codificato (60 - THAC0) */
    /* pg+$1A0: numero di dadi dell'attacco 1 (2 voci +$1A0..+$1A1); $3376: tipi di oggetto +$A:
     * dato di danno copiato in +$1A0 */
    c->b[0x1A0] = ITEM_TYPE(t, 0x0A);
    /* pg+$1A2: facce del dado dell'attacco 1 (2 voci +$1A2..+$1A3); $3377: tipi di oggetto +$B:
     * dato di danno copiato in +$1A2 */
    c->b[0x1A2] = ITEM_TYPE(t, 0x0B);
}

/* PORT H063+$06AE: movimento (+$1A9) con l'armatura indossata. */
static void armor_movement(Character *c, CokItem *it)
{
    /* $336C: tipi di oggetto, $12 byte per tipo (+$30): +0 slot/genere; ogg+$30: tipo dell'oggetto
     * (indice tabella H005+$336C, $12 byte per voce) */
    if (ITEM_TYPE(it->b[0x30], 0) != 2) {
        return;
    }
    if (COK_GET16(it->b + 0x3E) < 0x97) { /* ogg+$3E: (word) peso unitario dell'oggetto */
        /* pg+$1A9: movimento corrente (armatura e ingombro); pg+$DA: movimento base (12 alla
         * creazione) */
        c->b[0x1A9] = c->b[0xDA];
    } else if (COK_GET16(it->b + 0x3E) < 0x190) { /* ogg+$3E: (word) peso unitario dell'oggetto */
        c->b[0x1A9] = 9; /* pg+$1A9: movimento corrente (armatura e ingombro) */
    } else {
        c->b[0x1A9] = 6; /* pg+$1A9: movimento corrente (armatura e ingombro) */
    }
    /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno; pg+$1A9: movimento corrente
     * (armatura e ingombro) */
    if (COK_GET16(it->b + 0x36) != 0 && c->b[0x1A9] <= 9) {
        c->b[0x1A9] = (u8)(c->b[0x1A9] + 3); /* pg+$1A9: movimento corrente (armatura e ingombro) */
    }
}

/*
 * PORT H063+$0758: contributo dell'oggetto pronto alla classe d'armatura
 * (array ac[0..4] di H063+$13BE) e al peso +$18A.
 */
static void armor_class_part(Character *c, CokItem *it, s16 *ac, u8 *flag)
{
    /* $3373: tipi di oggetto +7: CA dell'oggetto (bit 7 = la fornisce); ogg+$30: tipo dell'oggetto
     * (indice tabella H005+$336C, $12 byte per voce) */
    u16 v = ITEM_TYPE(it->b[0x30], 7); /* -$2(a5) */
    u8 kind;                            /* -$3(a5) */

    if (v <= 0x7F) {
        return;
    }
    v = mask_byte((u8)v, 0x7F);
    /* $336C: tipi di oggetto, $12 byte per tipo (+$30): +0 slot/genere; ogg+$30: tipo dell'oggetto
     * (indice tabella H005+$336C, $12 byte per voce) */
    kind = ITEM_TYPE(it->b[0x30], 0);
    if (kind == 1) {
        ac[1] = (s16)(v + ITEM_W(it, 0x36)); /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
    } else if (v == 0) {
        if (kind == 9) {
            if (ITEM_W(it, 0x36) > ac[3]) { /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
                ac[3] = ITEM_W(it, 0x36); /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
            }
        } else {
            /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
            ac[2] = (s16)(ac[2] + ITEM_W(it, 0x36));
        }
        /* pg+$18A: bonus ai tiri salvezza dagli oggetti pronti (word, +$38); ogg+$38: (word)
         * secondo bonus, sommato a CH +$18A quando pronto */
        CH_PUTW(c, 0x18A, (u16)(CH_W(c, 0x18A) + ITEM_W(it, 0x38)));
    /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
    } else if ((s16)(v + ITEM_W(it, 0x36)) > ac[4]) {
        ac[4] = (s16)(v + ITEM_W(it, 0x36)); /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
        /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
        if (ITEM_W(it, 0x36) > 0 && kind == 2) {
            *flag = 1;
        }
    }
}

/* PORT H063+$08A2: movimento ridotto dall'ingombro (+$18C). */
static void encumbrance_movement(Character *c)
{
    /* pg+$18C: ingombro: peso di oggetti e monete (word) */
    s16 extra = (s16)(CH_W(c, 0x18C) - str_weight_allowance(c));
    u16 move;                           /* -$4(a5) */

    if (extra < 0) {
        extra = 0;
    }
    if (extra < 0x201) {
        move = c->b[0x1A9]; /* pg+$1A9: movimento corrente (armatura e ingombro) */
    } else if (extra < 0x301) {
        move = 9;
    } else if (extra < 0x401) {
        move = 6;
    } else {
        move = 3;
    }
    if (move < c->b[0x1A9]) { /* pg+$1A9: movimento corrente (armatura e ingombro) */
        c->b[0x1A9] = (u8)move; /* pg+$1A9: movimento corrente (armatura e ingombro) */
    }
}

/* PORT H063+$0946: cerca nella lista +$E8 un effetto di tipo type. */
u8 find_effect(Character *c, u16 type, CokEffect **out)
{
    u8 found = 0;                       /* -$1(a5) */

    *out = c->effects;
    while (*out != NULL && !found) {
        if ((*out)->b[0] == type) { /* eff+$0: tipo dell'effetto (codice del gestore) */
            found = 1;
        } else {
            *out = (*out)->next;
        }
    }
    return found;
}

/*
 * PORT H063+$09B2: compone in it->b[0..] il nome dell'oggetto (" Yes"/
 * " No" se pronto, "* " per gli oggetti magici quando un membro del party
 * ha l'effetto 5, quantita', parti del nome da H005+$406E con l'eventuale
 * plurale) e, con draw, lo scrive a (col, row).  c non e' usato.
 */
void build_item_name(Character *c, CokItem *it, u16 col, u16 row,
                     u8 ready_mark, u8 draw)
{
    char tmp[0x51];                     /* -$60(a5) */
    Character *m;                       /* -$e(a5) */
    CokEffect *eff;                     /* -$8(a5) */
    u8 found = 0;                       /* -$9(a5) */
    u8 plural;                          /* -$a(a5) */
    u16 mask = 0;                       /* -$4(a5) */
    u16 i;                              /* -$2(a5) */
    char *name = (char *)it->b;

    (void)c;
    copy_text(name, "", 0x28);
    if (ready_mark) {
        /* ogg+$3A: flag oggetto pronto all'uso (Ready) */
        copy_text(name, it->b[0x3A] ? " Yes  " : " No   ", 0x28);
    }
    for (m = g_party_head; m != NULL && !found; m = m->next) {
        if (find_effect(m, 5, &eff)) {
            found = 1;
        }
    }
    /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno; ogg+$38: (word) secondo bonus,
     * sommato a CH +$18A quando pronto */
    if (found && (ITEM_W(it, 0x36) > 0 || ITEM_W(it, 0x38) > 0 ||
                  it->b[0x3C] != 0)) { /* ogg+$3C: flag oggetto maledetto */
        h026_append(0x28, name, 2, "* ");
    }
    if (it->b[0x40] > 0) { /* ogg+$40: quantita' (pezzi uguali raggruppati, max 255) */
        /* ogg+$40: quantita' (pezzi uguali raggruppati, max 255) */
        format_number(0x50, tmp, it->b[0x40], 0, 0x0A, 4, ' ');
        for (i = 0; i <= 2; ++i) {
            if (tmp[0] == ' ') {
                h026_delete(0x50, tmp, 0, 1);
            }
        }
        h026_append(0x28, name, 0x50, tmp);
        h026_append(0x28, name, 1, " ");
    }
    for (i = 1; i <= 3; ++i) {
        if (it->b[0x32 + i - 1] != 0 && /* ogg+$31: base tabella 3 parole del nome +$32..+$34 (indice 1..3) */
            /* ogg+$3B: bit 0..2 parole del nome non identificate; bit 5/4 pergamena cl.1/2 */
            !mask_byte((u8)(it->b[0x3B] >> (3 - i)), 1)) {
            mask = (u16)(mask + (u8)(1 << (i - 1)));
        }
    }
    plural = 0;
    for (i = 3; i >= 1; --i) {
        if (!mask_byte((u8)(mask >> (i - 1)), 1)) {
            continue;
        }
        /* $406E: parti del nome degli oggetti, $16 byte per voce (da 1) */
        h026_append(0x28, name, 0x14, (const char *)&g_h005[0x406E +
                    /* ogg+$31: base tabella 3 parole del nome +$32..+$34 (indice 1..3) */
                    ((s16)it->b[0x32 + i - 1] - 1) * 0x16]);
        if (it->b[0x40] < 2 || plural) { /* ogg+$40: quantita' (pezzi uguali raggruppati, max 255) */
            h026_append(0x28, name, 1, " ");
            continue;
        }
        if ((u16)(u8)(1 << (i - 1)) == mask ||
            /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
            (i == 1 && mask > 4 && it->b[0x30] != 0x37) ||
            (i == 2 && (mask & 1) == 0) ||
            /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
            (i == 3 && it->b[0x30] == 0x37) ||
            /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
            ((it->b[0x30] == 0x1E || it->b[0x30] == 5 ||
              /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce); ogg+$34:
               * parola 3 del nome (indice in H005+$406E); nome base del tipo */
              it->b[0x30] == 0x0C) && it->b[0x34] != 0x5D)) {
            h026_append(0x28, name, 2, "s ");
            plural = 1;
        } else {
            h026_append(0x28, name, 1, " ");
        }
    }
    if (draw) {
        ui_draw_text(col, row, 0x0A, 0, 0x28, name);
    }
}

/* PORT H063+$0FA0: classe d'armatura 60 - +$19C (negativa con "-"). */
void draw_armor_class(Character *c, u16 col, u16 row)
{
    char text[0x51];                    /* -$52(a5) */
    s16 v = (s16)(c->b[0x19C] - 0x3C); /* pg+$19C: classe d'armatura corrente codificata (60 - CA) */

    format_number(0x50, text, v < 0 ? -v : v, 0, 0x0A, 3, ' ');
    trim_leading_spaces(0x50, text);
    if (c->b[0x19C] > 0x3C) { /* pg+$19C: classe d'armatura corrente codificata (60 - CA) */
        h026_insert(0x50, text, 1, "-", 0);
    }
    ui_draw_text(col, row, 0x0A, 0, 0x50, text);
}

/*
 * PORT H063+$103A: punti ferita attuali (+$1A8; colore $0E se feriti, $0D
 * con highlight) e, con with_max, "/massimo" (+$64).
 */
void draw_hit_points(Character *c, u16 col, u16 row, u8 highlight,
                     u8 with_max)
{
    char text[0x51];                    /* -$52(a5) */
    u16 pen;                            /* -$54(a5) */
    u16 n;                              /* -$56(a5) */

    /* pg+$1A8: punti ferita correnti; pg+$64: punti ferita massimi */
    pen = (u16)(c->b[0x1A8] < c->b[0x64] ? 0x0E : 0x0A);
    if (highlight) {
        pen = 0x0D;
    }
    format_number(0x50, text, c->b[0x1A8], 0, 0x0A, 6, ' '); /* pg+$1A8: punti ferita correnti */
    trim_leading_spaces(0x50, text);
    ui_draw_text(col, row, pen, 0, 0x50, text);
    if (with_max) {
        n = h026_strlen(0x50, text);
        format_number(0x50, text, c->b[0x64], 0, 0x0A, 6, ' '); /* pg+$64: punti ferita massimi */
        trim_leading_spaces(0x50, text);
        h026_insert(0x50, text, 1, "/", 0);
        ui_draw_text((u16)(col + n), row, 0x0A, 0, 0x50, text);
    }
}

/*
 * PORT H063+$13BE: ricalcola i valori derivati: oggetti pronti per slot
 * (H005+$336C), numero di oggetti +$14F, ingombro +$18C, danni, THAC0
 * +$19B, classe d'armatura +$19C/+$19D, movimento +$1A9 e +$D2.
 */
void recompute_stats(Character *c)
{
    s16 ac[5];                          /* -$14(a5) */
    CokItem *it;                        /* -$8(a5) */
    u16 w;                              /* -$1a(a5) */
    u16 slot;                           /* -$1c(a5) */
    u8 flag9 = 0;                       /* -$9(a5) */
    u8 flag_a = 0;                      /* -$a(a5): mai impostata */
    u8 i;

    for (i = 0; i <= 0x0C; ++i) {
        c->readied[i] = NULL;
    }
    c->b[0x14F] = 0; /* pg+$14F: numero di oggetti posseduti (max 16) */
    it = c->items;
    c->b[0x188] = 0; /* pg+$188: mani occupate dagli oggetti pronti (max 2) */
    CH_PUTW(c, 0x18C, 0); /* pg+$18C: ingombro: peso di oggetti e monete (word) */
    s_ready_weight = 0;
    while (it != NULL) {
        add_to_byte(&c->b[0x14F], 1); /* pg+$14F: numero di oggetti posseduti (max 16) */
        w = COK_GET16(it->b + 0x3E); /* ogg+$3E: (word) peso unitario dell'oggetto */
        if (it->b[0x40] > 0) { /* ogg+$40: quantita' (pezzi uguali raggruppati, max 255) */
            w = (u16)(it->b[0x40] * w); /* ogg+$40: quantita' (pezzi uguali raggruppati, max 255) */
        }
        CH_PUTW(c, 0x18C, (u16)(CH_W(c, 0x18C) + w)); /* pg+$18C: ingombro: peso di oggetti e monete (word) */
        if (it->b[0x3A]) { /* ogg+$3A: flag oggetto pronto all'uso (Ready) */
            s_ready_weight = (u16)(s_ready_weight + w);
            /* $336C: tipi di oggetto, $12 byte per tipo (+$30): +0 slot/genere; ogg+$30: tipo
             * dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
            slot = ITEM_TYPE(it->b[0x30], 0);
            if (slot <= 8) {
                c->readied[slot] = it;
            } else if (slot == 9) {
                if (c->readied[9] != NULL) {
                    if (c->readied[10] == NULL) {
                        c->readied[10] = it;
                    }
                } else {
                    c->readied[9] = it;
                }
            }
            /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
            if (it->b[0x30] == 0x1E) {
                c->readied[11] = it;
            }
            /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
            if (it->b[0x30] == 0x0C) {
                c->readied[12] = it;
            }
            /* pg+$188: mani occupate dagli oggetti pronti (max 2); $336D: tipi di oggetto +1: mani
             * occupate (si somma a +$188, max 2); ogg+$30: tipo dell'oggetto (indice tabella
             * H005+$336C, $12 byte per voce) */
            c->b[0x188] = (u8)(c->b[0x188] + ITEM_TYPE(it->b[0x30], 1));
        }
        it = it->next;
    }
    for (i = 1; i <= 6; ++i) {
        /* pg+$18C: ingombro: peso di oggetti e monete (word); pg+$F0: monete, 7 word passo 2 (0..4
         * monete, 4 acciaio, 5 gemme, 6 gioielli) */
        CH_PUTW(c, 0x18C, (u16)(CH_W(c, 0x18C) + CH_W(c, 0xF0 + i * 2)));
    }
    for (i = 1; i <= 2; ++i) {
        /* pg+$19F: attacchi del round, attacco 2; base -1 dadi +$1A0..; pg+$111: attacchi ogni 2
         * round dell'attacco 2; base -1 dadi +$112.. */
        c->b[0x1A0 + i - 1] = c->b[0x112 + i - 1];
        /* pg+$1A1: numero di dadi dell'attacco 2; base -1 facce +$1A2..; pg+$113: numero di dadi
         * dell'attacco 2; base -1 facce +$114.. */
        c->b[0x1A2 + i - 1] = c->b[0x114 + i - 1];
        /* pg+$116: bonus ai danni base, 2 word (attacco 1 e 2); pg+$1A4: bonus ai danni, 2 word
         * (attacco 1 e 2) */
        CH_PUTW(c, 0x1A4 + (i - 1) * 2, CH_W(c, 0x116 + (i - 1) * 2));
    }
    for (i = 0; i <= 4; ++i) {
        ac[i] = 0;
    }
    CH_PUTW(c, 0x18A, 0); /* pg+$18A: bonus ai tiri salvezza dagli oggetti pronti (word, +$38) */
    /* pg+$19C: classe d'armatura corrente codificata (60 - CA); pg+$11A: classe d'armatura base
     * codificata (50 = CA 10) */
    c->b[0x19C] = c->b[0x11A];
    /* pg+$1A9: movimento corrente (armatura e ingombro); pg+$DA: movimento base (12 alla creazione) */
    c->b[0x1A9] = c->b[0xDA];
    /* pg+$19B: THAC0 corrente codificato (60 - THAC0); pg+$5A: THAC0 base codificato (60 - THAC0)
     * dalla tabella per livello */
    c->b[0x19B] = c->b[0x5A];
    ac[0] = dex_ac_adj(c);
    if (c->readied[0] == NULL) {
        /* pg+$19B: THAC0 corrente codificato (60 - THAC0) */
        c->b[0x19B] = (u8)(c->b[0x19B] + str_hit_bonus(c));
        /* pg+$1A4: bonus ai danni, 2 word (attacco 1 e 2) */
        CH_PUTW(c, 0x1A4, (u16)(str_damage_bonus(c) + CH_W(c, 0x1A4)));
    }
    weapon_stats(c);
    for (it = c->items; it != NULL; it = it->next) {
        if (it->b[0x3A]) { /* ogg+$3A: flag oggetto pronto all'uso (Ready) */
            armor_movement(c, it);
            armor_class_part(c, it, ac, &flag9);
        }
    }
    if (flag9) {
        ac[3] = 0;
    }
    if (flag_a) {
        if (CH_W(c, 0x18C) < 0x1388) { /* pg+$18C: ingombro: peso di oggetti e monete (word) */
            CH_PUTW(c, 0x18C, 0); /* pg+$18C: ingombro: peso di oggetti e monete (word) */
        } else {
            /* pg+$18C: ingombro: peso di oggetti e monete (word) */
            CH_PUTW(c, 0x18C, (u16)(CH_W(c, 0x18C) - 0x1388));
        }
        if (CH_W(c, 0x18C) < s_ready_weight) { /* pg+$18C: ingombro: peso di oggetti e monete (word) */
            CH_PUTW(c, 0x18C, s_ready_weight); /* pg+$18C: ingombro: peso di oggetti e monete (word) */
        }
    }
    encumbrance_movement(c);
    if (ac[4] < (s16)c->b[0x19C]) { /* pg+$19C: classe d'armatura corrente codificata (60 - CA) */
        ac[4] = c->b[0x19C]; /* pg+$19C: classe d'armatura corrente codificata (60 - CA) */
    }
    c->b[0x19C] = 0; /* pg+$19C: classe d'armatura corrente codificata (60 - CA) */
    for (i = 0; i <= 4; ++i) {
        /* pg+$19C: classe d'armatura corrente codificata (60 - CA) */
        c->b[0x19C] = (u8)(c->b[0x19C] + ac[i]);
    }
    /* pg+$19D: CA da dietro (senza destrezza); base -1 attacchi +$19E.. */
    c->b[0x19D] = (u8)(ac[4] + ac[2] + ac[3] - 2);
    /* pg+$100: livello da guerriero; pg+$108: livello precedente da guerriero */
    if ((c->b[0x100] > 0 || (c->b[0x108] > 0 && h073_130a(c)) ||
         /* pg+$105: livello da cavaliere; pg+$102: livello da ranger; pg+$5B: razza (0..6, nomi
          * H005+$4D04) */
         c->b[0x105] > 0 || c->b[0x102] > 0) && c->b[0x5B] < 7) {
        /* pg+$D2: livello da combattente (max +$100/+$105/+$102, o 1): spazzate; pg+$100: livello
         * da guerriero */
        c->b[0xD2] = c->b[0x100];
        /* pg+$105: livello da cavaliere; pg+$D2: livello da combattente (max +$100/+$105/+$102, o
         * 1): spazzate */
        if (c->b[0x105] > c->b[0xD2]) {
            /* pg+$D2: livello da combattente (max +$100/+$105/+$102, o 1): spazzate; pg+$105:
             * livello da cavaliere */
            c->b[0xD2] = c->b[0x105];
        }
        /* pg+$102: livello da ranger; pg+$D2: livello da combattente (max +$100/+$105/+$102, o 1):
         * spazzate */
        if (c->b[0x102] > c->b[0xD2]) {
            /* pg+$D2: livello da combattente (max +$100/+$105/+$102, o 1): spazzate; pg+$102:
             * livello da ranger */
            c->b[0xD2] = c->b[0x102];
        }
    } else {
        c->b[0xD2] = 1; /* pg+$D2: livello da combattente (max +$100/+$105/+$102, o 1): spazzate */
    }
}

/*
 * PORT H063+$1F34: nome del personaggio a (col, row): colore $0C se
 * +$198 = 0, $0E se +$199 = 1 durante il combattimento ($3DE3 = 5),
 * altrimenti $0B; con possessive aggiunge "'s".
 */
void draw_character_name(Character *c, u16 col, u16 row, u8 possessive)
{
    u16 pen;                            /* -$2(a5) */

    if (c->b[0x198] == 0) { /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
        pen = 0x0C;
    /* pg+$199: lato in combattimento (0 party, 1 avversari); $3DE3: modo/contesto di gioco corrente
     * (0 menu, 1 vista, 5 combattimento) */
    } else if (c->b[0x199] == 1 && H005_B(0x3DE3) == 5) {
        pen = 0x0E;
    } else {
        pen = 0x0B;
    }
    ui_draw_text(col, row, pen, 0, 0x0F, (const char *)c->b);
    if (possessive) {
        ui_draw_text((u16)(h026_strlen(0x0F, (const char *)c->b) + col), row,
                     pen, 0, 2, "'s");
    }
}

/*
 * PORT H063+$3F72: riga della tabella dell'esperienza H005+$1946 ($9A
 * byte per riga) per la classe cls: secondo +$5E (chierico), +$5D (classe
 * 7), +$5F (classe 5).  Per le classi 1 e 3, e per +$5D fuori da 1..3,
 * l'originale restituisce un valore non inizializzato; qui 0.
 */
u8 class_xp_row(Character *c, u8 cls)
{
    u8 row = 0;                         /* -$1(a5) */

    switch (cls) {
    case 0:
        /* pg+$5E: divinita' del chierico (0 nessuna, 1..7; 6 per le razze 3-4) */
        row = (u8)(c->b[0x5E] > 4 ? 1 : 0);
        break;
    case 2:
        row = 2;
        break;
    case 4:
        row = 6;
        break;
    case 5:
        /* pg+$5F: ordine del mago (1 allineam. 0/3/6, 2 per 1/4/7, 0 nessuno) */
        row = (u8)(c->b[0x5F] == 1 ? 7 : 8);
        break;
    case 6:
        row = 9;
        break;
    case 7:
        switch (c->b[0x5D]) { /* pg+$5D: ordine di cavalleria (1 Corona, 2 Spada, 3 Rosa) */
        case 1:
            row = 3;
            break;
        case 2:
            row = 4;
            break;
        case 3:
            row = 5;
            break;
        default:
            break;
        }
        break;
    default:
        break;
    }
    return row;
}

/*
 * PORT H063+$1D44: messaggio sulla riga $18 (testo per valore), pausa
 * dei messaggi, poi riga cancellata.
 */
void show_message_line(u16 len, const char *text)
{
    char copy[0x100];
    u16 i;

    for (i = 0; i <= len && i < sizeof(copy) - 1; ++i) {
        copy[i] = text[i];
    }
    copy[i] = 0;
    clear_text_cells(0, 0x18, 0x27, 0x18);
    ui_draw_text(0, 0x18, 0x0A, 0, len, copy);
    message_delay();
    clear_text_cells(0, 0x18, 0x27, 0x18);
}

/*
 * PORT H063+$0D80: elenco del party (nome, CA, PF) dalla riga 4, nella
 * colonna 1 (fuori dal combattimento) o $11; il personaggio current in
 * bianco.  Imposta l'area cliccabile H005+$248A..$248D.  Non disegna in
 * combattimento senza H005 stato A +$270, ne' con $24AE.
 */
void draw_party(Character *current)
{
    Character *m;                       /* -$4(a5) */
    u16 col;                            /* -$6(a5) */
    u16 row;                            /* -$8(a5) */
    u16 off;                            /* -$a(a5) */

    /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento); A+$270: (word)
     * area citta': niente ridisegno vista ne' EXIT dal campo */
    if ((H005_B(0x3DE3) == 3 && COK_GET16(g_state_a + 0x270) == 0) ||
        H005_B(0x24AE)) { /* $24AE: 1 con un'immagine grande a tutto schermo: niente elenco party */
        return;
    }
    /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    col = (u16)(H005_B(0x3DE3) == 0 ? 1 : 0x11);
    H005_B(0x248D) = (u8)col; /* $248D: area cliccabile del party: prima colonna (1 o $11) */
    H005_B(0x248B) = 4; /* $248B: area cliccabile del party: prima riga (4) */
    H005_B(0x248C) = 0x26; /* $248C: area cliccabile del party: ultima colonna ($26) */
    H005_B(0x248A) = 3; /* $248A: area cliccabile del party: ultima riga (3 + membri) */
    row = 2;
    ui_draw_text(col, row, 0x0F, 0, 4, "Name");
    ui_draw_text(0x21, row, 0x0F, 0, 6, "AC  HP");
    row = (u16)(row + 2);
    for (m = g_party_head; m != NULL; m = m->next) {
        add_to_byte(&H005_B(0x248A), 1); /* $248A: area cliccabile del party: ultima riga (3 + membri) */
        clear_text_cells(col, row, 0x26, row);
        if (m == current) {
            ui_draw_text(col, row, 0x0F, 0, 0x0F, (const char *)m->b);
        } else {
            draw_character_name(m, col, row, 0);
        }
        if (m->b[0x19C] < 0x33) { /* pg+$19C: classe d'armatura corrente codificata (60 - CA) */
            off = 1;
        } else if (m->b[0x19C] < 0x3D) { /* pg+$19C: classe d'armatura corrente codificata (60 - CA) */
            off = 2;
        } else if (m->b[0x19C] < 0x46) { /* pg+$19C: classe d'armatura corrente codificata (60 - CA) */
            off = 1;
        } else {
            off = 0;
        }
        draw_armor_class(m, (u16)(off + 0x20), row);
        if (m->b[0x1A8] < 0x0A) { /* pg+$1A8: punti ferita correnti */
            off = 2;
        } else if (m->b[0x1A8] < 0x64) { /* pg+$1A8: punti ferita correnti */
            off = 1;
        } else {
            off = 0;
        }
        draw_hit_points(m, (u16)(off + 0x24), row, 0, 0);
        ++row;
    }
    clear_text_cells(col, row, 0x26, row);
}

/*
 * PORT H063+$321A (corpo a $3384): ridisegna la schermata secondo il modo
 * di gioco $3DE3 (0 cornice del menu, 1 vista, 2 e 6 immagini "PIC" $3B e
 * $3C, 3 e 4 combattimento/accampamento) e il party; $24E1 = 1.
 */
void redraw_game_screen(void)
{
    H005_B(0x24E1) = 1; /* $24E1: 1: immagine/vista dell'esplorazione da ridisegnare */
    switch (H005_B(0x3DE3)) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    case 0:                             /* H063+$3238 */
        draw_screen_frame(1);
        break;
    case 1:                             /* H063+$3244 */
        if (H005_B(0x24C2)) { /* $24C2: 1: nel contesto 1 il ridisegno include la cornice esplorazione */
            draw_explore_frame();
        }
        /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto */
        if (COK_GET16(g_state_a + 0x1CC) == 0) {
            show_picture(3, 3, 1, g_pic_rec_27c2);
        } else {
            /* $2488: testa del ritratto testa+corpo mostrato (per il ridisegno); $2487: corpo del
             * ritratto testa+corpo mostrato (per il ridisegno) */
            load_head_body(H005_B(0x2488), H005_B(0x2487));
            draw_head_body(3, 3, 1);
        }
        draw_party(g_current_char);
        draw_status_line();
        break;
    case 2:                             /* H063+$32BC */
        draw_explore_frame();
        load_sequence(3, "PIC", 0x3B, 0);
        draw_party(g_current_char);
        draw_status_line();
        break;
    case 4:                             /* H063+$32EE */
        draw_explore_frame();
        /* A+$270: (word) area citta': niente ridisegno vista ne' EXIT dal campo */
        if (COK_GET16(g_state_a + 0x270) == 0) {
            refresh_view();
        }
        draw_party(g_current_char);
        draw_status_line();
        H005_B(0x24B2) = 0; /* $24B2: 1: cornice dell'esplorazione da ridisegnare (dopo LOAD FILES) */
        break;
    case 3:                             /* H063+$3320 */
        /* $2486: id della sequenza caricata in $27BC (nome a $27A6), $FF nessuna; A+$270: (word)
         * area citta': niente ridisegno vista ne' EXIT dal campo */
        if (H005_B(0x2486) != 9 && COK_GET16(g_state_a + 0x270) == 0) {
            refresh_view();
        }
        break;
    case 6:                             /* H063+$3346 */
        draw_explore_frame();
        load_sequence(3, "PIC", 0x3C, 0);
        draw_party(g_current_char);
        break;
    default:
        break;
    }
}

/*
 * PORT H063+$1BE8: toglie l'oggetto it dalla lista di c e lo libera
 * (messaggi d'errore se it e' nullo o non e' nella lista).
 */
void delete_item(Character *c, CokItem *it)
{
    CokItem *p;                         /* -$4(a5) */

    debug_trace(0x0F, (const char *)c->b, 0, 0, 0);
    if (it == NULL) {
        show_message_wait(0x0E, 0, 0x13, "Nil Item pointer...");
        return;
    }
    p = c->items;
    if (p == it) {
        c->items = it->next;
    } else {
        while (p != NULL && p->next != it) {
            p = p->next;
        }
    }
    if (p == NULL) {
        show_message_wait(0x0E, 0, 0x26,
                          "Tried to Lose item & couldn't find it!");
        return;
    }
    p->next = it->next;
    it->next = NULL;
    exec_free_mem(it, sizeof(CokItem));
}

/*
 * PORT H063+$1DC2: nome del personaggio e testo (a capo automatico) nella
 * zona dei messaggi: in combattimento a destra da ($17, row), altrimenti
 * in basso dalla riga $11 ($12 con $24E2); wait: attesa e pulizia.
 */
void show_char_message(Character *c, u16 len, const char *text, u16 row,
                       u8 wait)
{
    u16 top;                            /* -$2(a5) */

    if (H005_B(0x3DE3) == 5) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        clear_text_cells(0x17, row, 0x26, 0x15);
        draw_character_name(c, 0x17, row, 0);
        word_wrap_text(0x17, (u16)(row + 1), 0x26, 0x15, 0x0A, 0, 1, len,
                       text);
    } else {
        if (H005_B(0x24E2)) { /* $24E2: 1 durante il riposo: puntatore d'attesa, messaggi dalla riga $12 */
            top = 0x12;
        } else {
            top = 0x11;
        }
        clear_text_cells(1, top, 0x26, 0x16);
        draw_character_name(c, 1, (u16)(top + 1), 0);
        word_wrap_text(1, (u16)(top + 2), 0x26, 0x16, 0x0A, 0, 1, len, text);
    }
    if (wait) {
        message_delay();
        clear_message_area();
    }
}

/* PORT H063+$1EE8: cancella la zona dei messaggi. */
void clear_message_area(void)
{
    if (H005_B(0x3DE3) == 5) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        clear_text_cells(0x17, 0x0A, 0x26, 0x15);
    } else {
        clear_text_cells(1, 0x12, 0x26, 0x16);
    }
}

/* PORT H063+$2F12: azzera il turno di combattimento (blocco +$192). */
u8 end_combat_turn(Character *c)
{
    u8 *turn = c->block_192->b;

    COK_PUT16(&turn[4], 0);
    turn[0] = 0;
    turn[9] = 0;
    turn[8] = 0;
    return 1;
}

/*
 * PORT H063+$3A26: sceglie un membro del party in *out con
 * "Select [Exit]": le frecce (codici speciali 'H' su, 'P' giu') cambiano
 * personaggio; with_exit: Exit o 0 annullano (*out = NULL).
 */
void choose_party_member(u16 len, const char *text, u8 with_exit,
                         u8 mode, Character **out)
{
    char prompt[0x52];                  /* testo per valore + " " */
    char options[0x2A];                 /* -$5c(a5) */
    char tail[0x2A];                    /* -$32(a5) */
    Character *node;                    /* -$8(a5) */
    /* $24A2: 1: il clic su un nome del party sceglie il personaggio */
    u8 saved = H005_B(0x24A2);          /* -$5d(a5) */
    u8 animate;                         /* -$3(a5) */
    u8 special;                         /* -$2(a5) */
    u8 key;                             /* -$1(a5) */

    h026_copy(sizeof(prompt) - 1, prompt, len, text);
    H005_B(0x24D8) = mode; /* $24D8: modo di scelta membro: il clic va in $2508 e non nel corrente */
    g_h005_2508 = g_current_char;
    key = ' ';
    strcpy(tail, "");
    h026_append(len, prompt, 1, " ");
    if (with_exit) {
        strcpy(tail, " Exit");
    }
    while (key != 'E' && key != 0x1B && key != 'S' && key != '\r') {
        draw_party(*out);
        /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        if (H005_B(0x3DE3) == 2 || H005_B(0x3DE3) == 6) {
            animate = 1;
        } else {
            animate = 0;
        }
        /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        if (H005_B(0x3DE3) == 0) {
            H005_B(0x24A2) = 1; /* $24A2: 1: il clic su un nome del party sceglie il personaggio */
        }
        strcpy(options, "Select");
        h026_append(0x28, options, 0x28, tail);
        key = ui_request_choice(len, prompt, 0x28, options, 0x0D, 0x0A, 0x0F,
                                1, animate, &special);
        H005_B(0x24A2) = saved; /* $24A2: 1: il clic su un nome del party sceglie il personaggio */
        node = *out;
        if (special) {
            switch (key) {
            case 'P':                   /* $3B94: freccia giu' */
                node = node->next;
                if (node == NULL) {
                    node = g_party_head;
                }
                break;
            case 'H':                   /* $3BB0: freccia su */
                if (H005_B(0x249E)) { /* $249E: 1 se il tasto viene dal mouse (clic) */
                    /* $24D8: modo di scelta membro: il clic va in $2508 e non nel corrente */
                    if (H005_B(0x24D8)) {
                        node = g_h005_2508;
                    } else {
                        node = g_current_char;
                    }
                } else {
                    node = g_party_head;
                    if (*out == g_party_head) {
                        while (node->next != NULL) {
                            node = node->next;
                        }
                    } else {
                        while (node->next != *out) {
                            node = node->next;
                        }
                    }
                }
                break;
            default:
                break;
            }
        } else if (with_exit) {
            if (key == 'E' || key == 0) {
                node = NULL;
            }
        }
        *out = node;
    }
    H005_B(0x24D8) = 0; /* $24D8: modo di scelta membro: il clic va in $2508 e non nel corrente */
}

/* PORT H063+$1CC0: accoda a c una copia dell'oggetto it. */
void give_item_copy(Character *c, CokItem *it)
{
    CokItem *copy;                      /* -$8(a5) */
    CokItem *p;                         /* -$4(a5) */

    copy = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
    memcpy(copy->b, it->b, 0x48);       /* CopyMem($48) */
    copy->next = NULL;
    p = c->items;
    if (p == NULL) {
        c->items = copy;
    } else {
        while (p->next != NULL) {
            p = p->next;
        }
        p->next = copy;
    }
}

/* PORT H063+$2ACC: "is fully healed" o "is partially healed". */
void heal_message(Character *c)
{
    char text[0x2A];                    /* -$2a(a5) */

    if (c->b[0x1A8] == c->b[0x64]) { /* pg+$1A8: punti ferita correnti; pg+$64: punti ferita massimi */
        strcpy(text, "is fully healed");
    } else {
        strcpy(text, "is partially healed");
    }
    show_char_message(c, 0x28, text, 0x0A, 1);
    if (H005_B(0x3DE3) != 5) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        draw_party(g_current_char);
    }
}

/*
 * PORT H063+$2FAA: livello d'incantatore del personaggio corrente per
 * spell (dalla classe dell'incantesimo); 6 per chi non e' incantatore e
 * per gli oggetti ($24D9) tranne la classe 4.  Per una classe oltre 4
 * l'originale restituisce la parola non inizializzata; qui 0.
 */
s16 caster_level(u16 spell)
{
    Character *c = g_current_char;
    s16 a;                              /* -$2(a5) */
    s16 b;                              /* -$4(a5) */
    s16 level = 0;                      /* -$8(a5) */

    /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico; pg+$103: livello da
     * mago; pg+$105: livello da cavaliere */
    if (c->b[0xFE] == 0 && c->b[0x103] == 0 && c->b[0x105] < 9 &&
        c->b[0x102] < 8) { /* pg+$102: livello da ranger */
        level = 6;
    } else {
        switch (H005_B(0x66 + (spell - 1) * 16)) {
        case 0:
        case 2:                         /* $3012 */
            /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico; pg+$106:
             * livelli della classe precedente, 8 voci come +$FE; chierico */
            a = (s16)(c->b[0xFE] + c->b[0x106] * h073_130a(c));
            /* pg+$105: livello da cavaliere; pg+$10D: livello precedente da cavaliere */
            b = (s16)(c->b[0x105] + c->b[0x10D] * h073_130a(c) - 8);
            level = a > b ? a : b;
            break;
        case 1:                         /* $30A6 */
            level = 0;
            break;
        case 3:                         /* $30AC */
            /* pg+$103: livello da mago; pg+$10B: livello precedente da mago */
            a = (s16)(c->b[0x103] + c->b[0x10B] * h073_130a(c));
            /* pg+$102: livello da ranger; pg+$10A: livello precedente da ranger */
            b = (s16)(c->b[0x102] + c->b[0x10A] * h073_130a(c) - 8);
            /* pg+$103: livello da mago; pg+$5F: ordine del mago (1 allineam. 0/3/6, 2 per 1/4/7, 0
             * nessuno) */
            if (c->b[0x103] > 0 && c->b[0x5F] > 0) {
                /* A+$3F0: tab. word fasi cicli (idx CH+$5F, 1..3); voce 0 posta a 1 da H070;
                 * pg+$5F: ordine del mago (1 allineam. 0/3/6, 2 per 1/4/7, 0 nessuno) */
                switch (COK_GET16(g_state_a + (c->b[0x5F] + 0x1F8) * 2)) {
                case 0:
                    --a;
                    break;
                case 2:
                    ++a;
                    break;
                default:
                    break;
                }
            }
            level = a > b ? a : b;
            break;
        case 4:                         /* $31B4 */
            level = 0x0C;
            break;
        default:
            break;
        }
    }
    /* $24D9: 1 se l'incantesimo viene da un oggetto (non si dimentica) */
    if (H005_B(0x24D9) && H005_B(0x66 + (spell - 1) * 16) != 4) {
        level = 6;
    }
    return level;
}

/* PORT H063+$1B90: toglie da c il primo incantesimo memorizzato spell. */
void forget_spell(Character *c, u16 spell)
{
    u16 i;                              /* -$2(a5) */

    for (i = 0; i <= 0x39; ++i) {
        /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
        if (c->b[0x1E + i] == spell) {
            /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
            c->b[0x1E + i] = 0;
            i = 0x3A;
        }
    }
}

/*
 * PORT H063+$2760: messaggio di un effetto su c.  In combattimento
 * ridisegna, suona e fa lampeggiare l'icona del bersaglio (per $3DF6 volte
 * se flag); altrimenti come H063+$1DC2 con attesa.
 */
void show_effect_message(Character *c, u8 flag, u16 len, const char *text)
{
    s16 x;                              /* -$2(a5) */
    s16 y;                              /* -$4(a5) */
    u16 frame;                          /* -$8(a5) */
    u16 n;                              /* -$a(a5) */
    u16 times;                          /* -$c(a5) */
    u16 k;                              /* indice di c, letto una volta */

    if (H005_B(0x3DE3) != 5) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        show_char_message(c, len, text, 0x0A, 1);
        return;
    }
    load_missile_frames(flag ? 0x16 : 0x17);
    if (!combatant_visible(c, 1)) {
        x = (s16)combatant_x(c);
        y = (s16)combatant_y(c);
        center_view((u16)x, (u16)y, 3, 8);
    }
    if (flag) {
        h043_190e(7);
    /* $2475: effetto in arrivo (0 = annullato dai gestori) */
    } else if (H005_B(0x2475) == 0x42 || H005_B(0x2475) == 0x55 ||
               H005_B(0x2471) == 0x33) { /* $2471: incantesimo in corso di lancio (0 = nessuno) */
        h043_190e(3);
    } else {
        h043_190e(0x13);
    }
    show_char_message(c, len, text, 0x0A, 0);
    if (flag) {
        times = H005_W(0x3DF6); /* $3DF6: (word) velocita' del gioco 0..9 (pausa dei messaggi) */
    } else {
        times = 0;
    }
    k = combatant_index(c);
    /* $3104: (word) colonna nella vista per combattente n (passo 2, da 1) */
    x = (s16)(H005_W(0x3104 + (k - 1) * 2) * 3);
    /* $30B4: (word) riga nella vista per combattente n (passo 2, da 1) */
    y = (s16)(H005_W(0x30B4 + (k - 1) * 2) * 3);
    for (n = 0; n <= times; ++n) {
        for (frame = 0; frame <= 3; ++frame) {
            draw_tile24_saving((u16)(x * 8), (u16)(y * 8), (u8)frame, 5,
                               g_gfx_243a, g_gfx_3d8e);
            dos_delay(3);
            draw_tile24_saving((u16)(x * 8), (u16)(y * 8), 0, 0,
                               g_gfx_3d8a, g_gfx_3d8e);
        }
    }
    if (times == 0) {
        message_delay();
    }
}

/*
 * PORT H063+$2984: toglie dmg punti ferita (+$1A8) a c: oltre 9 sotto
 * zero (o un morente a 0) muore (6), sotto zero sta morendo (5), a 0 e'
 * incosciente (4).  Chi non e' piu' attivo va a 0 PF.
 */
void damage_hit_points(Character *c, u16 dmg)
{
    u16 below = 0;                      /* -$2(a5) */
    u16 left = 0;                       /* -$4(a5) */

    if (c->b[0x1A8] >= dmg) { /* pg+$1A8: punti ferita correnti */
        left = (u16)(c->b[0x1A8] - dmg); /* pg+$1A8: punti ferita correnti */
    } else {
        below = (u16)(dmg - c->b[0x1A8]); /* pg+$1A8: punti ferita correnti */
    }
    /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
    if (below > 9 || (left == 0 && c->b[0x197] == 1)) {
        c->b[0x197] = 6; /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
    } else if (below > 0) {
        c->b[0x197] = 5; /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
        /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        if (H005_B(0x3DE3) == 5) {
            /* turno+$10: round passati sotto zero punti ferita (oltre 9 muore) */
            (c->block_192->b)[0x10] = (u8)below;
        }
    } else if (left == 0) {
        c->b[0x197] = 4; /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
    }
    /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
    if (c->b[0x197] != 0 && c->b[0x197] != 1) {
        c->b[0x198] = 0; /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
        c->b[0x1A8] = 0; /* pg+$1A8: punti ferita correnti */
        /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        if (H005_B(0x3DE3) == 5) {
            /* $2A1C: combattenti attivi del lato 0; tabella byte indicizzata dal lato; pg+$199:
             * lato in combattimento (0 party, 1 avversari) */
            H005_B(0x2A1C + c->b[0x199]) =
                /* $2A1C: combattenti attivi del lato 0; tabella byte indicizzata dal lato; pg+$199:
                 * lato in combattimento (0 party, 1 avversari) */
                (u8)(H005_B(0x2A1C + c->b[0x199]) - 1);
            /* turno+$4: (word) iniziativa del round (1d6+destrezza); <=0 turno finito */
            COK_PUT16(c->block_192->b + 4, 0);
        }
    } else {
        c->b[0x1A8] = (u8)left; /* pg+$1A8: punti ferita correnti */
    }
}

/* PORT H063+$2B7C: conta i combattenti attivi per lato in $2A1C/$2A1D. */
void count_sides(void)
{
    Character *p;                       /* -$4(a5) */

    H005_B(0x2A1C) = 0; /* $2A1C: combattenti attivi del lato 0; tabella byte indicizzata dal lato */
    H005_B(0x2A1D) = 0; /* $2A1D: combattenti attivi del lato 1 (voce 2 di $2A1C) */
    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0x198]) { /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
            /* $2A1C: combattenti attivi del lato 0; tabella byte indicizzata dal lato; pg+$199:
             * lato in combattimento (0 party, 1 avversari) */
            add_to_byte(&H005_B(0x2A1C + p->b[0x199]), 1);
        }
    }
}

/* PORT H063+$135A: c ha uno degli effetti H005+$4066..$4069 (indifeso)? */
u8 is_helpless(Character *c)
{
    CokEffect *e;                       /* -$6(a5) */
    u16 i;                              /* -$2(a5) */
    u8 found = 0;                       /* -$7(a5) */

    for (i = 1; i <= 4; ++i) {
        /* $4065: base i-1 dei 4 effetti di impotenza ($4066..$4069) */
        if (find_effect(c, H005_B(0x4066 + i - 1), &e)) {
            found = 1;
        }
    }
    return found;
}

/*
 * PORT H063+$1160: pannello del combattente c a destra (nome, punti
 * ferita, CA, arma pronta e stato), se $24C7 lo chiede.
 */
void draw_combat_status(Character *c)
{
    u16 row;                            /* -$4(a5) */

    if (!H005_B(0x24C7)) { /* $24C7: 1: pannello del combattente a destra da ridisegnare */
        return;
    }
    H005_B(0x24C7) = 0; /* $24C7: 1: pannello del combattente a destra da ridisegnare */
    clear_text_cells(0x17, 1, 0x26, 0x15);
    row = 1;
    show_char_message(c, 1, " ", row, 0);
    ++row;
    ui_draw_text(0x17, (u16)(row + 1), 0x0A, 0, 9, "Hitpoints");
    draw_hit_points(c, 0x21, (u16)(row + 1), 0, 0);
    row = (u16)(row + 2);
    ui_draw_text(0x17, (u16)(row + 1), 0x0A, 0, 2, "AC");
    draw_armor_class(c, 0x1A, (u16)(row + 1));
    H005_SET_W(0x334C, (u16)(row + 1)); /* $334C: (word) cursore del testo: riga */
    if (c->readied[0] != NULL) {
        row = (u16)(row + 2);
        build_item_name(c, c->readied[0], 0, 0, 0, 0);
        word_wrap_text(0x17, (u16)(row + 1), 0x26, (u16)(row + 1 + 2), 0x0A, 0,
                       1, 0x28, (const char *)c->readied[0]->b);
    }
    row = (u16)(H005_W(0x334C) + 1); /* $334C: (word) cursore del testo: riga */
    if (!c->b[0x198]) { /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
        ui_draw_text(0x17, (u16)(row + 1), 0x0F, 0, 0x0C,
                     /* $4B00: nomi dello stato del personaggio (+$197), $0E byte; base var ECL;
                      * pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                     (const char *)&H005_B(0x4B00 + c->b[0x197] * 0x0E));
    } else if (is_helpless(c)) {
        ui_draw_text(0x17, (u16)(row + 1), 0x0F, 0, 0x0A, "(Helpless)");
    /* turno+$0: incantesimo in preparazione da lanciare all'inizio del turno */
    } else if (c->block_192->b[0] > 0) {
        ui_draw_text(0x17, (u16)(row + 1), 0x0F, 0, 9, "(Casting)");
    }
}

/*
 * PORT H063+$2DC6: distanza (meta' del byte di H005+$2A3E) fra c e t
 * nell'area di c sulla mappa del combattimento; $2A3E viene ripristinata.
 */
u16 combat_distance(Character *c, Character *t)
{
    u8 saved[0xA0];                     /* -$3fc(a5) */
    u16 i;                              /* -$3fe(a5) */
    u16 d;                              /* -$400(a5) */
    u16 a;
    u16 b;

    /* $2A3E: lista dell'area: voci da 4 byte ($2479), byte 0 = n. combattente */
    memcpy(saved, &H005_B(0x2A3E), 0xA0);
    g_combat_area[8] = 1;
    a = combatant_x(c);
    b = combatant_y(c);
    find_in_area((s16)a, (s16)b, 0xFF, 0xFF, combatant_size(c), g_combat_area);
    g_combat_area[8] = 0;
    i = 1;
    /* $2A3E: lista dell'area: voci da 4 byte ($2479), byte 0 = n. combattente */
    while (g_combatants[H005_B(0x2A3E + (i - 1) * 4) - 1] != t &&
           i < H005_B(0x2479)) { /* $2479: numero di voci della lista dell'area +$2A3E (4 byte per voce) */
        ++i;
    }
    /* $2A3F: lista dell'area, byte 1: distanza (costo, meta' = caselle) */
    d = (u16)(H005_B(0x2A3E + (i - 1) * 4 + 1) >> 1);
    /* $2A3E: lista dell'area: voci da 4 byte ($2479), byte 0 = n. combattente */
    memcpy(&H005_B(0x2A3E), saved, 0xA0);
    return d;
}

/*
 * PORT H063+$37B2: arma di c in *weapon (dalla mano, +$154, o dalle
 * munizioni +$180/+$184 secondo i bit di H005+$336C+tipo*$12+$10);
 * vero se c'e' o se quei bit valgono $A.
 */
u8 find_weapon(Character *c, CokItem **weapon)
{
    CokItem *it = c->readied[0];        /* -$4(a5) */
    u16 f = 0;                          /* -$6(a5) */

    *weapon = NULL;
    if (it != NULL) {
        /* $337C: tipi di oggetto +$10: flag arma (des/for, munizioni, mischia); ogg+$30: tipo
         * dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
        f = H005_B(0x336C + it->b[0x30] * 0x12 + 0x10);
        if (mask_byte((u8)f, 0x10)) {
            *weapon = it;
        }
        if (mask_byte((u8)f, 8)) {
            if (mask_byte((u8)f, 1)) {
                *weapon = c->readied[11];       /* +$180 */
            }
            if (mask_byte((u8)f, 0x80)) {
                *weapon = c->readied[12];       /* +$184 */
            }
        }
    }
    return (u8)(*weapon != NULL || f == 0x0A);
}

/*
 * PORT H063+$1FDC: copia il set which del posto slot ($3244) nel
 * fotogramma dest (colonna dest*24) di $243A, immagine e maschera;
 * con mirror passa da un record temporaneo specchiato (H049+$09D6).
 */
void copy_sprite_frame(u16 slot, u16 which, u16 dest, u8 mirror)
{
    struct GfxRecord *tmp;              /* -$8(a5) */
    struct GfxRecord *src = g_sprite_sets[slot][which];

    if (mirror) {
        allocate_gfx_record(0x18, 3, 1, 1, &tmp);
        mirror_gfx_record(src, tmp);
        (void)graphics_blt_bitmap(tmp->image, 0, 0, g_gfx_243a->image,
                                  (u16)(dest * 0x18), 0, 0x18, 0x18, 0xC0,
                                  0xFF, NULL);
        (void)graphics_blt_bitmap(tmp->mask, 0, 0, g_gfx_243a->mask,
                                  (u16)(dest * 0x18), 0, 0x18, 0x18, 0xC0,
                                  0xFF, NULL);
        free_gfx_record(&tmp);
    } else {
        (void)graphics_blt_bitmap(src->image, 0, 0, g_gfx_243a->image,
                                  (u16)(dest * 0x18), 0, 0x18, 0x18, 0xC0,
                                  0xFF, NULL);
        (void)graphics_blt_bitmap(src->mask, 0, 0, g_gfx_243a->mask,
                                  (u16)(dest * 0x18), 0, 0x18, 0x18, 0xC0,
                                  0xFF, NULL);
    }
}

/*
 * PORT H063+$2178: prepara in $243A i 4 fotogrammi del proiettile slot:
 * set 0, set 0 specchiato, set 1 specchiato, set 1.
 */
void load_missile_frames(u16 slot)
{
    copy_sprite_frame(slot, 0, 0, 0);
    copy_sprite_frame(slot, 0, 1, 1);
    copy_sprite_frame(slot, 1, 2, 1);
    copy_sprite_frame(slot, 1, 3, 0);
}

/* Variabili di H063+$21D2 lette dalla procedura annidata $21E0. */
typedef struct MissileFrame {
    struct BitMap *dest;                /* -$42(a5) */
    s16 saved_x[2];                     /* -$34(a5) */
    s16 saved_y[2];                     /* -$38(a5) */
    u16 row;                            /* -$28(a5) */
} MissileFrame;

/*
 * PORT H063+$21E0 (annidata in $21D2): sulla bitmap in uso (fuori schermo
 * o schermo) rimette lo sfondo salvato in $3D8A (riga -$8*24) per il
 * buffer corrente, se c'e'.
 */
static void restore_missile_background(MissileFrame *f)
{
    f->row = (u16)(g_h029_m8 * 0x18);
    if (g_h029_m5) {
        f->dest = g_gfx_3d8e->image;
    } else {
        f->dest = &g_screen->BitMap;
    }
    if (f->saved_x[g_h029_m8] >= 0) {
        (void)graphics_blt_bitmap(g_gfx_3d8a->image, 0, f->row, f->dest,
                                  (u16)(f->saved_x[g_h029_m8] + 8),
                                  (u16)(f->saved_y[g_h029_m8] + 8), 0x18,
                                  0x18, 0xC0, 0xFF, NULL);
    }
}

/*
 * PORT H063+$21D2: proiettile da (x0, y0) a (x1, y1): segue la linea a
 * passi di 2 pixel con i fotogrammi 0..frames-1 di $243A (uno ogni 6
 * passi), alternando le due View; la vista si sposta quando il
 * proiettile ne esce.  unused non e' letto.
 */
void animate_missile(s16 x0, s16 y0, s16 x1, s16 y1, u16 frames, u16 unused)
{
    MissileFrame f;
    u8 offscreen;                       /* -$1(a5) */
    u8 major_x;                         /* -$2(a5) */
    s16 px;                             /* -$4(a5) */
    s16 py;                             /* -$6(a5) */
    s16 cx;                             /* -$8(a5) */
    s16 cy;                             /* -$A(a5) */
    s16 rx;                             /* -$C(a5) */
    s16 ry;                             /* -$E(a5) */
    s16 vx = 0;                         /* -$10(a5) */
    s16 vy = 0;                         /* -$12(a5) */
    s16 ddx;                            /* -$14(a5) */
    s16 ddy;                            /* -$16(a5) */
    s16 sx = 0;                         /* -$18(a5) */
    s16 sy = 0;                         /* -$1A(a5) */
    s16 a;                              /* -$1C(a5) */
    s16 b;                              /* -$1E(a5) */
    s16 step_a;                         /* -$20(a5) */
    s16 step_b;                         /* -$22(a5) */
    s16 acc;                            /* -$24(a5) */
    s16 minor;                          /* -$26(a5) */
    s16 k;                              /* -$2A(a5) */
    s16 n;                              /* -$2C(a5) */
    s16 half;                           /* -$2E(a5) */
    s16 count;                          /* -$30(a5) */
    u16 frame = 0;                      /* -$3A(a5) */

    (void)unused;
    f.dest = NULL;
    f.row = 0;
    f.saved_x[0] = f.saved_x[1] = -1;
    f.saved_y[0] = f.saved_y[1] = 0;
    px = (s16)(x0 * 0x18);
    py = (s16)(y0 * 0x18);
    ddx = (s16)((x1 - x0) * 0x18);
    ddy = (s16)((y1 - y0) * 0x18);
    major_x = (u8)((ddx < 0 ? -ddx : ddx) > (ddy < 0 ? -ddy : ddy));
    if (major_x) {
        a = px;
        b = py;
        step_a = (s16)(ddx > 0 ? 2 : -2);
        half = (s16)((ddx < 0 ? -ddx : ddx) / 2);
        minor = (s16)(ddy < 0 ? -ddy : ddy);
        step_b = (s16)(ddy > 0 ? 1 : -1);
    } else {
        a = py;
        b = px;
        step_a = (s16)(ddy > 0 ? 2 : -2);
        half = (s16)((ddy < 0 ? -ddy : ddy) / 2);
        minor = (s16)(ddx < 0 ? -ddx : ddx);
        step_b = (s16)(ddx > 0 ? 1 : -1);
    }
    count = (s16)(half - 1);
    acc = (s16)(minor / 4);
    offscreen = 0;
    while (count > 0) {
        cx = (s16)(px / 0x18);
        cy = (s16)(py / 0x18);
        rx = (s16)(x1 - cx);
        ry = (s16)(y1 - cy);
        if ((!in_view((s16)(cx - (s16)COK_GET16(g_combat_area + 2)),
                      (s16)(cy - (s16)COK_GET16(g_combat_area + 4))) ||
             !in_view((s16)(x1 - (s16)COK_GET16(g_combat_area + 2)),
                      (s16)(y1 - (s16)COK_GET16(g_combat_area + 4)))) &&
            (rx < 0 ? -rx : rx) <= 6 && (ry < 0 ? -ry : ry) <= 6) {
            vx = (s16)(rx / 2 + cx);
            vy = (s16)(ry / 2 + cy);
        } else if (offscreen) {
            if (sx < 0) {
                vx = (s16)(vx - 6);
            }
            if (sx > 0x90) {
                vx = (s16)(vx + 6);
            }
            if (sy < 0) {
                vy = (s16)(vy - 6);
            }
            if (sy > 0x90) {
                vy = (s16)(vy + 6);
            }
        } else {
            vx = (s16)((s16)COK_GET16(g_combat_area + 2) + 3);
            vy = (s16)((s16)COK_GET16(g_combat_area + 4) + 3);
        }
        center_view(vx, vy, 0xFF, 8);
        copy_screen_to_offscreen();
        offscreen = 0;
        sx = (s16)(px - (s16)COK_GET16(g_combat_area + 2) * 0x18);
        f.saved_x[0] = -1;
        f.saved_x[1] = -1;
        sy = (s16)(py - (s16)COK_GET16(g_combat_area + 4) * 0x18);
        do {
            swap_display_view();
            restore_missile_background(&f);
            f.saved_x[g_h029_m8] = sx;
            f.saved_y[g_h029_m8] = sy;
            (void)graphics_blt_bitmap(f.dest, (u16)(sx + 8), (u16)(sy + 8),
                                      g_gfx_3d8a->image, 0, f.row, 0x18,
                                      0x18, 0xC0, 0xFF, NULL);
            draw_tile24((u16)sx, (u16)sy, (u8)frame, 1, g_gfx_243a,
                        g_gfx_3d8e);
            if (count % 6 == 0) {
                ++frame;
                if (frame >= frames) {
                    frame = 0;
                }
            }
            --count;
            a = (s16)(a + step_a);
            acc = (s16)(acc + minor);
            while (acc >= half) {
                acc = (s16)(acc - half);
                b = (s16)(b + step_b);
            }
            if (major_x) {
                px = a;
                py = b;
            } else {
                px = b;
                py = a;
            }
            sx = (s16)(px - (s16)COK_GET16(g_combat_area + 2) * 0x18);
            sy = (s16)(py - (s16)COK_GET16(g_combat_area + 4) * 0x18);
            if (sx < 0 || sy < 0 || sx > 0x90 || sy > 0x90) {
                offscreen = 1;
            }
        } while (!offscreen && count > 0);
        n = (s16)(3 - g_h029_m8);
        for (k = 1; k <= n; ++k) {
            swap_display_view();
            restore_missile_background(&f);
        }
        g_h029_m5 = 0;
        g_h029_m6 = 1;
    }
}

/* PORT H063+$2B4C: lato opposto a quello di c (+$199). */
u8 other_side(Character *c)
{
    return (u8)(c->b[0x199] == 0); /* pg+$199: lato in combattimento (0 party, 1 avversari) */
}

/*
 * PORT H063+$2BDE: nemici di c entro radius (lista dell'area ridotta ai
 * combattenti del lato opposto, numeri anche in H005+$2444); con
 * l'effetto $5B il combattente $2432 passa in testa a $2444.
 */
u16 count_enemies_near(Character *c, u16 radius)
{
    u16 n;                              /* -$2(a5) */
    u16 k = 0;                          /* -$4(a5) */
    u16 i;                              /* -$6(a5) */
    u16 result;                         /* -$8(a5) */
    CokEffect *e;                       /* -$C(a5) */
    u8 done;                            /* -$D(a5) */
    u16 t;

    find_in_area((s16)combatant_x(c), (s16)combatant_y(c), radius, 0xFF,
                 combatant_size(c), g_combat_area);
    n = H005_B(0x2479); /* $2479: numero di voci della lista dell'area +$2A3E (4 byte per voce) */
    if (n > 0) {
        for (i = 1; i <= n; ++i) {
            /* pg+$199: lato in combattimento (0 party, 1 avversari); $2A3E: lista dell'area: voci
             * da 4 byte ($2479), byte 0 = n. combattente */
            if (g_combatants[H005_B(0x2A3E + (i - 1) * 4) - 1]->b[0x199] ==
                other_side(c)) {
                ++k;
                /* $2A3E: lista dell'area: voci da 4 byte ($2479), byte 0 = n. combattente */
                memcpy(&H005_B(0x2A3E + (k - 1) * 4),
                       /* $2A3E: lista dell'area: voci da 4 byte ($2479), byte 0 = n. combattente */
                       &H005_B(0x2A3E + (i - 1) * 4), 4);
            }
        }
        n = k;
        H005_B(0x2479) = (u8)k; /* $2479: numero di voci della lista dell'area +$2A3E (4 byte per voce) */
    }
    result = n;
    for (i = 1; i <= n; ++i) {
        /* $2444..: lista dei nemici vicini ($2444+i-1, i da 1); $2A3E: lista
         * dell'area: voci da 4 byte ($2479), byte 0 = n. combattente */
        H005_B(0x2444 + i - 1) = H005_B(0x2A3E + (i - 1) * 4);
    }
    if (find_effect(c, 0x5B, &e)) {
        done = 0;
        for (i = 1; i <= n && !done; ++i) {
            /* $2444..: lista dei nemici vicini ($2444+i-1, i da 1) */
            if (g_combatants[H005_B(0x2444 + i - 1) - 1] == g_h005_2432) {
                /* $2444: lista dei nemici vicini (numero del combattente, 1 byte per voce) */
                t = H005_B(0x2444);
                /* $2444: lista dei nemici vicini (numero del combattente, 1 byte per voce);
                 * $2444..: nemici vicini ($2444+i-1) */
                H005_B(0x2444) = H005_B(0x2444 + i - 1);
                /* $2444..: lista dei nemici vicini ($2444+i-1, i da 1) */
                H005_B(0x2444 + i - 1) = (u8)t;
                done = 1;
            }
        }
    }
    return result;
}

/*
 * PORT H063+$33A0: riga di stato della mappa (riga $F, colonne $11..$26):
 * coordinate (se non nascoste, +$1F6), direzione, ora, "*" ($24D2) e
 * " camping" o " search".  Non nel contesto 3.
 */
void draw_status_line(void)
{
    char line[0x29];                    /* -$36(a5) */
    char hours[4];                      /* -$8(a5) */
    char minutes[4];                    /* -$C(a5) */
    char tmp[0x2A];                     /* -$60(a5) */
    u16 x;                              /* -$2(a5) */
    u16 y;                              /* -$4(a5) */
    u16 dir;                            /* -$62(a5) */

    if (H005_B(0x3DE3) == 3) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        return;
    }
    line[0] = '\0';
    x = H005_W(0x281C); /* $281C: (word) x del party sulla mappa dell'area 16x16 */
    y = H005_W(0x281E); /* $281E: (word) y del party sulla mappa dell'area 16x16 */
    /* A+$192: (word) ore del tempo di gioco */
    format_number(2, hours, (s32)COK_GET16(g_state_a + 0x192), 0, 0x0A, 2,
                  '0');
    format_number(2, minutes,
                  /* A+$190: (word) decine di minuti del tempo di gioco */
                  (s32)(u16)(COK_GET16(g_state_a + 0x190) * 0x0A +
                             /* A+$18E: (word) minuti (unita') del tempo di gioco */
                             COK_GET16(g_state_a + 0x18E)),
                  0, 0x0A, 2, '0');
    /* A+$1F6: (word) area senza mappa: coordinate nascoste, mappa "Not Here" */
    if (COK_GET16(g_state_a + 0x1F6) == 0) {
        format_number(0x28, line, (s32)x, 0, 0x0A, 2, '0');
        h026_append(0x28, line, 1, ",");
        format_number(0x28, tmp, (s32)y, 0, 0x0A, 2, '0');
        h026_append(0x28, line, 0x28, tmp);
        h026_append(0x28, line, 1, " ");
    }
    if (COK_GET16(g_state_a + 0x1CC) != 0) { /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto */
        /* A+$3FE: uso: forza l'animazione in attesa scelta; sommato alla direzione; $2820:
         * direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        dir = (u16)(COK_GET16(g_state_a + 0x3FE) * 2 + H005_B(0x2820));
    } else {
        /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest); A+$3FE: uso: forza
         * l'animazione in attesa scelta; sommato alla direzione */
        dir = (u16)(H005_B(0x2820) + COK_GET16(g_state_a + 0x3FE));
    }
    if (dir >= 8) {
        dir = (u16)(dir - 8);
    }
    /* $3DB2: nomi dei punti cardinali, 4 byte per direzione 0..7 */
    h026_append(0x28, line, 2, (const char *)&H005_B(0x3DB2 + dir * 4));
    h026_append(0x28, line, 1, " ");
    h026_append(0x28, line, 2, hours);
    h026_append(0x28, line, 1, ":");
    h026_append(0x28, line, 2, minutes);
    if (H005_B(0x24D2)) { /* $24D2: debug attivo ("*" in stato, valori extra) */
        h026_append(0x28, line, 1, "*");
    }
    if (H005_B(0x3DE3) == 2) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        h026_append(0x28, line, 8, " camping");
    /* B+$594: (word) bit 0 modo search, bit 1 Look in corso */
    } else if (mask_byte((u8)COK_GET16(g_state_b + 0x594), 1) > 0) {
        h026_append(0x28, line, 7, " search");
    }
    clear_text_cells(0x11, 0x0F, 0x26, 0x0F);
    ui_draw_text(0x11, 0x0F, 0x0A, 0, 0x28, line);
}

/* PORT H063+$3658: ridisegna la cornice e la vista del combattimento. */
void redraw_combat_screen(void)
{
    draw_combat_frame();
    center_view((s16)((s16)COK_GET16(g_combat_area + 2) + 3),
                (s16)((s16)COK_GET16(g_combat_area + 4) + 3), 0xFF, 8);
}

/*
 * PORT H063+$3CA0: direzione (0..7) da a verso b: prova 1, 3, 5, 7, 0,
 * 2, 4, 6... finche' il settore la contiene (pendenze $6A/$100 e
 * $26A/$100).
 */
u16 direction_toward(Character *a, Character *b)
{
    s16 ax;                             /* -$6(a5) */
    s16 ay;                             /* -$8(a5) */
    s16 bx;                             /* -$A(a5) */
    s16 by;                             /* -$C(a5) */
    s16 adx;                            /* -$E(a5) */
    s16 ady;                            /* -$10(a5) */
    s16 steep;
    s16 flat;
    u16 d = 1;                          /* -$2(a5) */
    u8 found = 0;                       /* -$3(a5) */

    ax = (s16)combatant_x(a);
    ay = (s16)combatant_y(a);
    bx = (s16)combatant_x(b);
    by = (s16)combatant_y(b);
    adx = (s16)(bx - ax < 0 ? ax - bx : bx - ax);
    ady = (s16)(by - ay < 0 ? ay - by : by - ay);
    steep = (s16)((s32)adx * 0x26A / 0x100);
    flat = (s16)((s32)adx * 0x6A / 0x100);
    while (!found) {
        switch (d) {
        case 0:
            found = (u8)(by <= ay && ady >= steep);
            break;
        case 1:
            found = (u8)(by < ay && bx > ax && ady <= steep && ady >= flat);
            break;
        case 2:
            found = (u8)(bx >= ax && ady <= flat);
            break;
        case 3:
            found = (u8)(by > ay && bx > ax && ady <= steep && ady >= flat);
            break;
        case 4:
            found = (u8)(by >= ay && ady >= steep);
            break;
        case 5:
            found = (u8)(by > ay && bx < ax && ady <= steep && ady >= flat);
            break;
        case 6:
            found = (u8)(bx <= ax && ady <= flat);
            break;
        case 7:
            found = (u8)(by < ay && bx < ax && ady <= steep && ady >= flat);
            break;
        default:
            break;
        }
        if (!found) {
            d = (u16)(d + 2);
            if (d > 7) {
                d = 0;
            }
        }
    }
    return d;
}

/* PORT H063+$3698: l'arma in mano tira a distanza (tabella $336C +$E > 1)? */
u8 has_ranged_weapon(Character *c)
{
    if (c->readied[0] != NULL &&
        /* $337A: tipi di oggetto +$E: gittata dell'arma (>1 = a distanza); ogg+$30: tipo
         * dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
        H005_B(0x336C + c->readied[0]->b[0x30] * 0x12 + 0x0E) > 1) {
        return 1;
    }
    return 0;
}

/* PORT H063+$36EE: l'arma in mano e' del tipo $43? */
u8 weapon_is_43(Character *c)
{
    /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
    if (c->readied[0] != NULL && c->readied[0]->b[0x30] == 0x43) {
        return 1;
    }
    return 0;
}

/*
 * PORT H063+$3734: l'arma in mano colpisce anche da vicino: a distanza
 * con i bit $14 della tabella $336C (+$10), o del tipo $43.  Senza arma
 * l'originale legge +$30 da NULL (memoria bassa); qui no.
 */
u8 weapon_melee_ok(Character *c)
{
    if (has_ranged_weapon(c) &&
        /* $337C: tipi di oggetto +$10: flag arma (des/for, munizioni, mischia); ogg+$30: tipo
         * dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
        mask_byte(H005_B(0x336C + c->readied[0]->b[0x30] * 0x12 + 0x10),
                  0x14) == 0x14) {
        return 1;
    }
    /* ogg+$30: tipo dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
    if (c->readied[0] != NULL && c->readied[0]->b[0x30] == 0x43) {
        return 1;
    }
    return 0;
}

/*
 * PORT H063+$3980: c'e' un compagno del party (lato 0, in combattimento)
 * che sta morendo (+$197 = 5)?  Con bandage il primo trovato viene
 * fasciato (stato 4, "is bandaged").
 */
u8 bandage_dying(u8 bandage)
{
    u8 found = 0;                       /* -$5(a5) */
    Character *p;                       /* -$4(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro; pg+$199:
         * lato in combattimento (0 party, 1 avversari) */
        if (p->block_192->b[0x15] == 0 && p->b[0x199] == 0 &&
            p->b[0x197] == 5) { /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
            found = 1;
            if (bandage) {
                p->b[0x197] = 4; /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                /* turno+$10: round passati sotto zero punti ferita (oltre 9 muore) */
                p->block_192->b[0x10] = 0;
                show_char_message(p, 0x0B, "is bandaged", 0x0A, 1);
                bandage = 0;
            }
        }
    }
    return found;
}

/* PORT H063+$2F5A (Guard): fine del turno; se puo', c resta in guardia. */
u8 guard_turn(Character *c)
{
    u8 r;                               /* -$1(a5) */

    r = end_combat_turn(c);
    if (c->block_192->b[0x12] == 0) { /* turno+$12: flag costretto a fuggire (paura, confusione) */
        c->block_192->b[9] = 1; /* turno+$9: flag in guardia (Guard), attacca chi si avvicina */
        show_message_line(8, "Guarding");
    }
    return r;
}
