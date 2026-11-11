/* H073: disegno di interfaccia e composizione di schermate. */
#include "h073.h"
#include "h029_gfx.h"
#include "globals.h"

/* PORT H073+$0004: link/unlk, nessun effetto. */
void h073_init(void)
{
}

/*
 * PORT H073+$09BA: incantesimi da chierico per livello (+$124..+$128).  Il
 * livello e' quello da chierico (+$FE); la tabella H005+$1946 ($9A byte per
 * riga) dipende da +$5E > 4; la saggezza (+$15) da' incantesimi in piu'.
 */
void cleric_spell_slots(Character *c)
{
    /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico */
    u8 level = c->b[0xFE];              /* -$3(a5) */
    u8 high;                            /* -$4(a5) */
    u8 i;                               /* -$2(a5) */
    u8 l;                               /* -$1(a5) */

    if (level == 0) {
        return;
    }
    /* pg+$5E: divinita' del chierico (0 nessuna, 1..7; 6 per le razze 3-4) */
    high = (u8)(c->b[0x5E] > 4 ? 1 : 0);
    for (i = 2; i <= 5; ++i) {
        c->b[0x124 + i - 1] = 0; /* pg+$123: PF massimi senza costituzione; base -1 slot incantesimi +$124 */
    }
    /* pg+$124: slot incantesimi, 24 byte: tipo*6 + livello-1; chierico liv. 1 */
    c->b[0x124] = (u8)(high ? 2 : 1);
    for (l = 2; l <= level; ++l) {
        for (i = 1; i <= 5; ++i) {
            /* pg+$123: PF massimi senza costituzione; base -1 slot incantesimi +$124 */
            c->b[0x124 + i - 1] = (u8)(c->b[0x124 + i - 1] +
                /* $1972: slot incantesimi della tab. classe +$2C: 5 word per livello 2..12 */
                H005_W(0x1946 + high * 0x9A + 0x2C + (l - 2) * 0x0A +
                       (i - 1) * 2));
        }
        if (l == 0xFF) {
            break;              /* addq.b/bcc */
        }
    }
    /* pg+$15: saggezza corrente; pg+$124: slot incantesimi, 24 byte: tipo*6 + livello-1; chierico
     * liv. 1 */
    if (c->b[0x15] > 12 && c->b[0x124] > 0) {
        ++c->b[0x124]; /* pg+$124: slot incantesimi, 24 byte: tipo*6 + livello-1; chierico liv. 1 */
    }
    /* pg+$15: saggezza corrente; pg+$124: slot incantesimi, 24 byte: tipo*6 + livello-1; chierico
     * liv. 1 */
    if (c->b[0x15] > 13 && c->b[0x124] > 0) {
        ++c->b[0x124]; /* pg+$124: slot incantesimi, 24 byte: tipo*6 + livello-1; chierico liv. 1 */
    }
    /* pg+$15: saggezza corrente; pg+$125: slot incantesimi da chierico di livello 2 */
    if (c->b[0x15] > 14 && c->b[0x125] > 0) {
        ++c->b[0x125]; /* pg+$125: slot incantesimi da chierico di livello 2 */
    }
    /* pg+$15: saggezza corrente; pg+$125: slot incantesimi da chierico di livello 2 */
    if (c->b[0x15] > 15 && c->b[0x125] > 0) {
        ++c->b[0x125]; /* pg+$125: slot incantesimi da chierico di livello 2 */
    }
    /* pg+$15: saggezza corrente; pg+$126: slot incantesimi da chierico di livello 3 */
    if (c->b[0x15] > 16 && c->b[0x126] > 0) {
        ++c->b[0x126]; /* pg+$126: slot incantesimi da chierico di livello 3 */
    }
    /* pg+$15: saggezza corrente; pg+$127: slot incantesimi da chierico di livello 4 (Cure Serious) */
    if (c->b[0x15] > 17 && c->b[0x127] > 0) {
        ++c->b[0x127]; /* pg+$127: slot incantesimi da chierico di livello 4 (Cure Serious) */
    }
}

/* Riga della tabella dei tiri salvezza (H005+$1566): classe, livello, tiro. */
static u16 save_table(u8 cls, u8 level, u8 save)
{
    /* level - 1 con livello 0 da' -1 (muls con segno): riga precedente. */
    /* $1566: tiri salvezza: $78 byte per classe, $A per livello, word per tipo */
    return H005_W((u16)(0x1566 + cls * 0x78 + ((s16)level - 1) * 0x0A +
                        save * 2));
}

/*
 * PORT H073+$0BA8: tiri salvezza +$D4..+$D8: il minimo tra 20 e i valori
 * delle classi (livello attuale +$FE e precedente +$106).  Per il primo
 * tiro i bonus di costituzione (+$19) di nani/halfling (razze 3, 4, 5) o
 * con l'oggetto speciale di tipo 6, e quelli per costituzione oltre 18,
 * sono sommati a ogni giro sulle 8 classi, come nell'originale.
 */
void saving_throws(Character *c)
{
    u8 special = 0;                     /* -$9(a5) */
    CokItem *item = c->items;           /* -$8(a5) */
    u8 s;                               /* -$1(a5) */
    u8 k;                               /* -$2(a5) */

    while (item != NULL && !special) {
        /* ogg+$46: tipo dell'effetto magico: bit7 = effetto passivo, bit 0..6 tipo; ogg+$3A: flag
         * oggetto pronto all'uso (Ready) */
        if (item->b[0x46] > 0x80 && item->b[0x3A] != 0) {
            /* ogg+$46: tipo dell'effetto magico: bit7 = effetto passivo, bit 0..6 tipo */
            special = (u8)(mask_byte(item->b[0x46], 0x7F) == 6);
        }
        item = item->next;
    }
    for (s = 0; s <= 4; ++s) {
        c->b[0xD4 + s] = 0x14; /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
        for (k = 0; k <= 7; ++k) {
            /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico */
            if (c->b[0xFE + k] > 0) {
                /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico */
                u16 t = save_table(k, c->b[0xFE + k], s);

                /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                if (c->b[0xD4 + s] > t) {
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    c->b[0xD4 + s] = (u8)t;
                }
            }
            /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico; pg+$106:
             * livelli della classe precedente, 8 voci come +$FE; chierico */
            if (c->b[0xFE + k] > c->b[0x106 + k]) {
                /* pg+$106: livelli della classe precedente, 8 voci come +$FE; chierico */
                u16 t = save_table(k, c->b[0x106 + k], s);

                /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                if (c->b[0xD4 + s] > t) {
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    c->b[0xD4 + s] = (u8)t;
                }
            }
            if (s == 0 && (c->b[0x5B] == 3 || c->b[0x5B] == 5 || /* pg+$5B: razza (0..6, nomi H005+$4D04) */
                           c->b[0x5B] == 4 || special)) { /* pg+$5B: razza (0..6, nomi H005+$4D04) */
                switch (c->b[0x19]) { /* pg+$19: costituzione corrente */
                case 4: case 5: case 6:
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    add_to_byte(&c->b[0xD4 + s], 1);
                    break;
                case 7: case 8: case 9: case 10:
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    add_to_byte(&c->b[0xD4 + s], 2);
                    break;
                case 11: case 12: case 13:
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    add_to_byte(&c->b[0xD4 + s], 3);
                    break;
                case 14: case 15: case 16: case 17:
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    add_to_byte(&c->b[0xD4 + s], 4);
                    break;
                case 18:
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    add_to_byte(&c->b[0xD4 + s], 5);
                    break;
                default:
                    break;
                }
            }
            if (s == 0) {
                switch (c->b[0x19]) { /* pg+$19: costituzione corrente */
                case 19: case 20:
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    add_to_byte(&c->b[0xD4 + s], 1);
                    break;
                case 21: case 22:
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    add_to_byte(&c->b[0xD4 + s], 2);
                    break;
                case 23: case 24:
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    add_to_byte(&c->b[0xD4 + s], 3);
                    break;
                case 25:
                    /* pg+$D4: tiri salvezza, 5 voci (+$D4..+$D8) per tipo; valore minimo d20 */
                    add_to_byte(&c->b[0xD4 + s], 4);
                    break;
                default:
                    break;
                }
            }
        }
    }
}

/* PORT H073+$1294: restituisce sempre $11. */
u8 h073_1294(Character *c)
{
    (void)c;
    return 0x11;
}

/* PORT H073+$12AE: restituisce sempre $11. */
u8 h073_12ae(Character *c)
{
    (void)c;
    return 0x11;
}

/* PORT H073+$12C8: restituisce sempre 0. */
u8 h073_12c8(Character *c)
{
    (void)c;
    return 0;
}

/* PORT H073+$130A: +$DC < H073+$12C8 (cioe' mai: confronto senza segno con 0). */
u8 h073_130a(Character *c)
{
    /* pg+$DC: uso: soglia per i livelli +$106..+$10D e i PF; !=0 vieta Modify */
    return (u8)(c->b[0xDC] < h073_12c8(c));
}

/*
 * PORT H073+$0FC8: abilita' da ladro +$E0..+$E7.  Il livello effettivo e'
 * +$104 + +$10C * H073+$130A; la tabella per livello e' H005+$50F8 (8 byte
 * per livello), le correzioni di razza H005+$5088 (16 byte per razza) e,
 * per le prime 5, quelle di destrezza (+$17) H005+$3FF8.  L'oggetto
 * speciale di tipo $0B alza il livello delle prime due abilita'; quello di
 * tipo 2 porta il livello almeno a 4 o aggiunge 10 a tutte.
 *
 * bonus (-$4(a5)) nell'originale e' assegnato solo con l'oggetto di tipo
 * $0B; senza, il codice somma il valore rimasto nella memoria dello stack.
 * Qui parte da 0.
 */
void thief_skills(Character *c)
{
    u8 type_b = 0;                      /* -$d(a5) */
    u8 type_2 = 0;                      /* -$e(a5) */
    CokItem *item = c->items;           /* -$c(a5) */
    u8 level;                           /* -$6(a5) */
    u8 saved_level;                     /* -$7(a5) */
    s16 bonus = 0;                      /* -$4(a5) */
    u16 i;                              /* -$2(a5) */

    while (item != NULL && !type_b && !type_2) {
        /* ogg+$46: tipo dell'effetto magico: bit7 = effetto passivo, bit 0..6 tipo; ogg+$3A: flag
         * oggetto pronto all'uso (Ready) */
        if (item->b[0x46] > 0x80 && item->b[0x3A] != 0) {
            /* ogg+$46: tipo dell'effetto magico: bit7 = effetto passivo, bit 0..6 tipo */
            u8 t = mask_byte(item->b[0x46], 0x7F);      /* -$5(a5) */

            type_b = (u8)(t == 0x0B);
            type_2 = (u8)(t == 2);
        }
        item = item->next;
    }
    /* pg+$104: livello da ladro; pg+$10C: livello precedente da ladro */
    level = (u8)(c->b[0x104] + c->b[0x10C] * h073_130a(c));
    if (level < 4 && type_2) {
        level = 4;
        type_2 = 0;
    }
    saved_level = level;
    for (i = 1; i <= 8; ++i) {
        s16 race_adj;
        /* pg+$DF: tipo di non morto (0 = no); base -1 abilita' da ladro +$E0..+$E7 */
        u8 *skill = &c->b[0xE0 + i - 1];
        u8 base;

        if (type_b) {
            if (i == 1) {
                if (level < 5) {
                    level = 5;
                    bonus = 0;
                } else {
                    bonus = 5;
                }
            } else if (i == 2) {
                if (level < 7) {
                    level = 7;
                    bonus = 0;
                } else {
                    bonus = 5;
                }
            }
        }
        /* $5088: (word) correzioni abilita' ladro per razza, 16 byte per razza; pg+$5B: razza
         * (0..6, nomi H005+$4D04) */
        race_adj = (s16)H005_W(0x5088 + c->b[0x5B] * 16 + (i - 1) * 2);
        /* $50F8: abilita' ladro base per livello, 8 byte per livello */
        base = H005_B((u16)(0x50F8 + ((s16)level - 1) * 8 + (i - 1)));
        if (race_adj < 0 &&
            (s16)((race_adj < 0 ? -race_adj : race_adj) + bonus) >
            (s16)base) {
            *skill = 0;
        } else {
            *skill = (u8)(base + race_adj + bonus);
            if (i < 6) {
                *skill = (u8)(*skill +
                    /* $3FF8: (word) correzioni abilita' ladro per destrezza 9..19, 5 per riga;
                     * pg+$17: destrezza corrente */
                    H005_W((u16)(0x3FF8 + ((s16)c->b[0x17] - 9) * 0x0A +
                                 (i - 1) * 2)));
            }
        }
        if (type_2) {
            add_to_byte(skill, 0x0A);
        }
        level = saved_level;
    }
}

/* Somma alle 5 celle da slots la riga del livello l della tabella row. */
static void add_spell_row(u8 *slots, u8 row, u8 l, u8 count)
{
    u8 i;

    for (i = 1; i <= count; ++i) {
        slots[i - 1] = (u8)(slots[i - 1] +
            /* $1972: slot incantesimi della tab. classe +$2C: 5 word per livello 2..12 */
            H005_W((u16)(0x1946 + row * 0x9A + 0x2C + ((s16)l - 2) * 0x0A +
                         (i - 1) * 2)));
    }
}

/*
 * Incantesimi da chierico noti per i livelli di incantesimo con slot
 * (H005+$1476: 10 word per livello, 0 = fine).
 */
static void learn_cleric_spells(Character *c)
{
    u8 sl;                              /* -$6(a5) */
    u16 j;                              /* -$2(a5) */
    u16 spell;                          /* -$a(a5) */

    for (sl = 1; sl <= 4; ++sl) {
        /* pg+$123: PF massimi senza costituzione; base -1 slot incantesimi +$124 */
        if (c->b[0x124 + sl - 1] == 0) {
            continue;
        }
        j = 1;
        spell = 0xFF;
        while (j <= 0x0A && spell != 0) {
            /* $1476: inc. per classe/livello: 3x4 righe di 10 word ($14), 0 = fine */
            spell = H005_W(0x1476 + (sl - 1) * 0x14 + (j - 1) * 2);
            if (spell != 0) {
                /* pg+$65: base -1 incantesimi noti +$66+s-1 (s = 1..$6B, flag per incantesimo) */
                c->b[0x66 + spell - 1] = 1;
            }
            ++j;
        }
    }
}

/*
 * PORT H073+$0012: slot degli incantesimi di tutte le classi (+$124..+$13B
 * azzerati, poi per classe: chierico 0, classe 7, mago 4 sopra il
 * livello 7, classe 5) e incantesimi noti; gli oggetti di tipo $81 pronti
 * raddoppiano gli slot +$136..+$138.
 */
static void spell_slots_all(Character *c)
{
    CokItem *it;                        /* -$e(a5) */
    u8 k;                               /* -$3(a5) */
    u8 lvl;                             /* -$5(a5) */
    u8 row;                             /* -$4(a5) */
    u8 l;                               /* -$6(a5) */
    u8 i;                               /* -$8(a5) */
    u16 s;                              /* -$a(a5) */

    /* pg+$124: slot incantesimi, 24 byte: tipo*6 + livello-1; chierico liv. 1 */
    h029_fill_bytes(0x17, &c->b[0x124], 0x18, 0);
    for (k = 0; k <= 7; ++k) {
        lvl = c->b[0xFE + k]; /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico */
        if (lvl == 0) {
            continue;
        }
        switch (k) {
        case 0:                 /* H073+$0068 */
            /* pg+$5E: divinita' del chierico (0 nessuna, 1..7; 6 per le razze 3-4) */
            row = (u8)(c->b[0x5E] > 4 ? 1 : 0);
            ++c->b[0x124]; /* pg+$124: slot incantesimi, 24 byte: tipo*6 + livello-1; chierico liv. 1 */
            for (l = 2; l <= lvl; ++l) {
                /* pg+$124: slot incantesimi, 24 byte: tipo*6 + livello-1; chierico liv. 1 */
                add_spell_row(&c->b[0x124], row, l, 5);
                if (l == 0xFF) {
                    break;
                }
            }
            cleric_spell_slots(c);
            learn_cleric_spells(c);
            break;
        case 7:                 /* H073+$01B6 */
            if (lvl > 5 && c->b[0x5D] != 1) { /* pg+$5D: ordine di cavalleria (1 Corona, 2 Spada, 3 Rosa) */
                /* pg+$5D: ordine di cavalleria (1 Corona, 2 Spada, 3 Rosa) */
                row = (u8)(c->b[0x5D] == 2 ? 4 : 5);
                for (l = 6; l <= lvl; ++l) {
                    /* pg+$124: slot incantesimi, 24 byte: tipo*6 + livello-1; chierico liv. 1 */
                    add_spell_row(&c->b[0x124], row, l, 5);
                    if (l == 0xFF) {
                        break;
                    }
                }
                learn_cleric_spells(c);
            }
            break;
        case 4:                 /* H073+$0304 */
            if (lvl > 7) {
                for (l = 8; l <= lvl; ++l) {
                    for (i = 1; i <= 3; ++i) {
                        /* pg+$129: base -1 slot del tipo 1 (+$12A..+$12C, dati al ranger) */
                        c->b[0x12A + i - 1] = (u8)(c->b[0x12A + i - 1] +
                            /* $1D0E: slot per livello della tabella classe 6 (+$2C): 5 word per
                             * livello */
                            H005_W((u16)(0x1D0E + (l - 2) * 0x0A +
                                         (i - 1) * 2)));
                    }
                    for (i = 4; i <= 5; ++i) {
                        u8 m = (u8)(i - 3);     /* -$7(a5) */

                        /* pg+$135: base -1 slot da mago (tipo 3, +$136..+$13B) per livello */
                        c->b[0x136 + m - 1] = (u8)(c->b[0x136 + m - 1] +
                            /* $1D0E: slot per livello della tabella classe 6 (+$2C): 5 word per
                             * livello */
                            H005_W((u16)(0x1D0E + (l - 2) * 0x0A +
                                         (i - 1) * 2)));
                    }
                    if (l == 0xFF) {
                        break;
                    }
                }
                for (s = 1; s <= 0x64; ++s) {
                    if (H005_B(0x66 + (s - 1) * 16) == 1) {
                        /* pg+$65: base -1 incantesimi noti +$66+s-1 (s = 1..$6B, flag per
                         * incantesimo) */
                        c->b[0x66 + s - 1] = 1;
                    }
                }
            }
            break;
        case 5:                 /* H073+$0430 */
            /* pg+$5F: ordine del mago (1 allineam. 0/3/6, 2 per 1/4/7, 0 nessuno) */
            row = (u8)(c->b[0x5F] == 0 ? 7 : 8);
            ++c->b[0x136]; /* pg+$136: slot incantesimi da mago di livello 1 */
            for (l = 2; l <= lvl; ++l) {
                add_spell_row(&c->b[0x136], row, l, 5); /* pg+$136: slot incantesimi da mago di livello 1 */
                if (l == 0xFF) {
                    break;
                }
            }
            break;
        default:
            break;
        }
    }
    for (it = c->items; it != NULL; it = it->next) {
        /* ogg+$46: tipo dell'effetto magico: bit7 = effetto passivo, bit 0..6 tipo; ogg+$3A: flag
         * oggetto pronto all'uso (Ready) */
        if (it->b[0x46] == 0x81 && it->b[0x3A]) {
            for (i = 1; i <= 3; ++i) {
                /* pg+$135: base -1 slot da mago (tipo 3, +$136..+$13B) per livello */
                c->b[0x136 + i - 1] = (u8)(c->b[0x136 + i - 1] * 2);
            }
        }
    }
}

/* Classi oltre il livello 6 (2 e 7) o 7 (4): +$110 = 3. */
static void check_level_limit(Character *c, u8 k, u8 lvl)
{
    switch (k) {
    case 2: case 7:
        if (lvl > 6) {
            c->b[0x110] = 3; /* pg+$110: attacchi ogni 2 round dell'attacco 1 (2 = 1/round, 3 = 3/2) */
        }
        break;
    case 4:
        if (lvl > 7) {
            c->b[0x110] = 3; /* pg+$110: attacchi ogni 2 round dell'attacco 1 (2 = 1/round, 3 = 3/2) */
        }
        break;
    default:
        break;
    }
}

/*
 * PORT H073+$05AE: valori che dipendono dal livello: +$5A (dalla tabella
 * H005+$5158), livello massimo +$DB, +$110, bonus della divinita',
 * incantesimi, tiri salvezza, abilita' da ladro, +$122 e oggetti pronti
 * non piu' ammessi; con H073+$130A anche le classi precedenti.
 */
void level_derived_values(Character *c)
{
    u8 k;                               /* -$1(a5) */
    u8 lvl;                             /* -$4(a5) */
    u8 s;                               /* -$6(a5) */

    c->b[0x5A] = 0; /* pg+$5A: THAC0 base codificato (60 - THAC0) dalla tabella per livello */
    for (k = 0; k <= 7; ++k) {
        u16 t;

        lvl = c->b[0xFE + k]; /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico */
        /* $5158: (word) valore +$5A per classe e livello, $1A byte per classe */
        t = H005_W(0x5158 + k * 0x1A + lvl * 2);
        if (c->b[0x5A] < t) { /* pg+$5A: THAC0 base codificato (60 - THAC0) dalla tabella per livello */
            c->b[0x5A] = (u8)t; /* pg+$5A: THAC0 base codificato (60 - THAC0) dalla tabella per livello */
        }
        if (c->b[0xDB] < lvl) { /* pg+$DB: livello massimo fra le classi (usato anche come dadi vita) */
            c->b[0xDB] = lvl; /* pg+$DB: livello massimo fra le classi (usato anche come dadi vita) */
        }
        check_level_limit(c, k, lvl);
    }
    /* pg+$5E: divinita' del chierico (0 nessuna, 1..7; 6 per le razze 3-4); pg+$5B: razza (0..6,
     * nomi H005+$4D04) */
    if ((c->b[0x5E] == 6 && (c->b[0x5B] == 3 || c->b[0x5B] == 4)) ||
        c->b[0x5E] == 3) { /* pg+$5E: divinita' del chierico (0 nessuna, 1..7; 6 per le razze 3-4) */
        ++c->b[0x5A]; /* pg+$5A: THAC0 base codificato (60 - THAC0) dalla tabella per livello */
    }
    spell_slots_all(c);
    saving_throws(c);
    if (c->b[0x104] > 0) { /* pg+$104: livello da ladro */
        thief_skills(c);
    }
    c->b[0x122] = 0; /* pg+$122: maschera delle armi usabili (somma H005+$5040 per classe) */
    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] > 0 || /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico */
            /* pg+$106: livelli della classe precedente, 8 voci come +$FE; chierico; pg+$DB: livello
             * massimo fra le classi (usato anche come dadi vita) */
            (c->b[0x106 + k] > 0 && c->b[0x106 + k] < c->b[0xDB])) {
            /* pg+$122: maschera delle armi usabili (somma H005+$5040 per classe); $5040: bit per
             * classe sommati in +$122 (classi per gli oggetti) */
            c->b[0x122] = (u8)(c->b[0x122] + H005_B(0x5040 + k));
        }
    }
    for (s = 0; s <= 0x0C; ++s) {
        CokItem *it = c->readied[s];

        if (it != NULL &&
            /* $337B: tipi di oggetto +$F: maschera delle classi ammesse (vs +$122); ogg+$30: tipo
             * dell'oggetto (indice tabella H005+$336C, $12 byte per voce) */
            !mask_byte(H005_B(0x336C + it->b[0x30] * 0x12 + 0x0F),
                       /* pg+$122: maschera delle armi usabili (somma H005+$5040 per classe) */
                       c->b[0x122]) &&
            !it->b[0x3C]) { /* ogg+$3C: flag oggetto maledetto */
            it->b[0x3A] = 0; /* ogg+$3A: flag oggetto pronto all'uso (Ready) */
        }
    }
    if (h073_130a(c)) {
        for (k = 0; k <= 7; ++k) {
            u16 t;

            lvl = c->b[0x106 + k]; /* pg+$106: livelli della classe precedente, 8 voci come +$FE; chierico */
            check_level_limit(c, k, lvl);
            /* $5158: (word) valore +$5A per classe e livello, $1A byte per classe */
            t = H005_W(0x5158 + k * 0x1A + lvl * 2);
            if (c->b[0x5A] < t) { /* pg+$5A: THAC0 base codificato (60 - THAC0) dalla tabella per livello */
                c->b[0x5A] = (u8)t; /* pg+$5A: THAC0 base codificato (60 - THAC0) dalla tabella per livello */
            }
        }
        /* pg+$108: livello precedente da guerriero; pg+$10A: livello precedente da ranger; pg+$10D:
         * livello precedente da cavaliere */
        if (c->b[0x108] > 6 || c->b[0x10A] > 7 || c->b[0x10D] > 6) {
            c->b[0x110] = 3; /* pg+$110: attacchi ogni 2 round dell'attacco 1 (2 = 1/round, 3 = 3/2) */
        }
        if (c->b[0x10C] > 0) { /* pg+$10C: livello precedente da ladro */
            thief_skills(c);
        }
    }
}
