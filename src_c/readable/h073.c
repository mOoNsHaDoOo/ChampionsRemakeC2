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
    u8 level = c->b[0xFE];              /* -$3(a5) */
    u8 high;                            /* -$4(a5) */
    u8 i;                               /* -$2(a5) */
    u8 l;                               /* -$1(a5) */

    if (level == 0) {
        return;
    }
    high = (u8)(c->b[0x5E] > 4 ? 1 : 0);
    for (i = 2; i <= 5; ++i) {
        c->b[0x124 + i - 1] = 0;
    }
    c->b[0x124] = (u8)(high ? 2 : 1);
    for (l = 2; l <= level; ++l) {
        for (i = 1; i <= 5; ++i) {
            c->b[0x124 + i - 1] = (u8)(c->b[0x124 + i - 1] +
                H005_W(0x1946 + high * 0x9A + 0x2C + (l - 2) * 0x0A +
                       (i - 1) * 2));
        }
        if (l == 0xFF) {
            break;              /* addq.b/bcc */
        }
    }
    if (c->b[0x15] > 12 && c->b[0x124] > 0) {
        ++c->b[0x124];
    }
    if (c->b[0x15] > 13 && c->b[0x124] > 0) {
        ++c->b[0x124];
    }
    if (c->b[0x15] > 14 && c->b[0x125] > 0) {
        ++c->b[0x125];
    }
    if (c->b[0x15] > 15 && c->b[0x125] > 0) {
        ++c->b[0x125];
    }
    if (c->b[0x15] > 16 && c->b[0x126] > 0) {
        ++c->b[0x126];
    }
    if (c->b[0x15] > 17 && c->b[0x127] > 0) {
        ++c->b[0x127];
    }
}

/* Riga della tabella dei tiri salvezza (H005+$1566): classe, livello, tiro. */
static u16 save_table(u8 cls, u8 level, u8 save)
{
    /* level - 1 con livello 0 da' -1 (muls con segno): riga precedente. */
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
        if (item->b[0x46] > 0x80 && item->b[0x3A] != 0) {
            special = (u8)(mask_byte(item->b[0x46], 0x7F) == 6);
        }
        item = item->next;
    }
    for (s = 0; s <= 4; ++s) {
        c->b[0xD4 + s] = 0x14;
        for (k = 0; k <= 7; ++k) {
            if (c->b[0xFE + k] > 0) {
                u16 t = save_table(k, c->b[0xFE + k], s);

                if (c->b[0xD4 + s] > t) {
                    c->b[0xD4 + s] = (u8)t;
                }
            }
            if (c->b[0xFE + k] > c->b[0x106 + k]) {
                u16 t = save_table(k, c->b[0x106 + k], s);

                if (c->b[0xD4 + s] > t) {
                    c->b[0xD4 + s] = (u8)t;
                }
            }
            if (s == 0 && (c->b[0x5B] == 3 || c->b[0x5B] == 5 ||
                           c->b[0x5B] == 4 || special)) {
                switch (c->b[0x19]) {
                case 4: case 5: case 6:
                    add_to_byte(&c->b[0xD4 + s], 1);
                    break;
                case 7: case 8: case 9: case 10:
                    add_to_byte(&c->b[0xD4 + s], 2);
                    break;
                case 11: case 12: case 13:
                    add_to_byte(&c->b[0xD4 + s], 3);
                    break;
                case 14: case 15: case 16: case 17:
                    add_to_byte(&c->b[0xD4 + s], 4);
                    break;
                case 18:
                    add_to_byte(&c->b[0xD4 + s], 5);
                    break;
                default:
                    break;
                }
            }
            if (s == 0) {
                switch (c->b[0x19]) {
                case 19: case 20:
                    add_to_byte(&c->b[0xD4 + s], 1);
                    break;
                case 21: case 22:
                    add_to_byte(&c->b[0xD4 + s], 2);
                    break;
                case 23: case 24:
                    add_to_byte(&c->b[0xD4 + s], 3);
                    break;
                case 25:
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
        if (item->b[0x46] > 0x80 && item->b[0x3A] != 0) {
            u8 t = mask_byte(item->b[0x46], 0x7F);      /* -$5(a5) */

            type_b = (u8)(t == 0x0B);
            type_2 = (u8)(t == 2);
        }
        item = item->next;
    }
    level = (u8)(c->b[0x104] + c->b[0x10C] * h073_130a(c));
    if (level < 4 && type_2) {
        level = 4;
        type_2 = 0;
    }
    saved_level = level;
    for (i = 1; i <= 8; ++i) {
        s16 race_adj;
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
        race_adj = (s16)H005_W(0x5088 + c->b[0x5B] * 16 + (i - 1) * 2);
        base = H005_B((u16)(0x50F8 + ((s16)level - 1) * 8 + (i - 1)));
        if (race_adj < 0 &&
            (s16)((race_adj < 0 ? -race_adj : race_adj) + bonus) >
            (s16)base) {
            *skill = 0;
        } else {
            *skill = (u8)(base + race_adj + bonus);
            if (i < 6) {
                *skill = (u8)(*skill +
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
        if (c->b[0x124 + sl - 1] == 0) {
            continue;
        }
        j = 1;
        spell = 0xFF;
        while (j <= 0x0A && spell != 0) {
            spell = H005_W(0x1476 + (sl - 1) * 0x14 + (j - 1) * 2);
            if (spell != 0) {
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

    h029_fill_bytes(0x17, &c->b[0x124], 0x18, 0);
    for (k = 0; k <= 7; ++k) {
        lvl = c->b[0xFE + k];
        if (lvl == 0) {
            continue;
        }
        switch (k) {
        case 0:                 /* H073+$0068 */
            row = (u8)(c->b[0x5E] > 4 ? 1 : 0);
            ++c->b[0x124];
            for (l = 2; l <= lvl; ++l) {
                add_spell_row(&c->b[0x124], row, l, 5);
                if (l == 0xFF) {
                    break;
                }
            }
            cleric_spell_slots(c);
            learn_cleric_spells(c);
            break;
        case 7:                 /* H073+$01B6 */
            if (lvl > 5 && c->b[0x5D] != 1) {
                row = (u8)(c->b[0x5D] == 2 ? 4 : 5);
                for (l = 6; l <= lvl; ++l) {
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
                        c->b[0x12A + i - 1] = (u8)(c->b[0x12A + i - 1] +
                            H005_W((u16)(0x1D0E + (l - 2) * 0x0A +
                                         (i - 1) * 2)));
                    }
                    for (i = 4; i <= 5; ++i) {
                        u8 m = (u8)(i - 3);     /* -$7(a5) */

                        c->b[0x136 + m - 1] = (u8)(c->b[0x136 + m - 1] +
                            H005_W((u16)(0x1D0E + (l - 2) * 0x0A +
                                         (i - 1) * 2)));
                    }
                    if (l == 0xFF) {
                        break;
                    }
                }
                for (s = 1; s <= 0x64; ++s) {
                    if (H005_B(0x66 + (s - 1) * 16) == 1) {
                        c->b[0x66 + s - 1] = 1;
                    }
                }
            }
            break;
        case 5:                 /* H073+$0430 */
            row = (u8)(c->b[0x5F] == 0 ? 7 : 8);
            ++c->b[0x136];
            for (l = 2; l <= lvl; ++l) {
                add_spell_row(&c->b[0x136], row, l, 5);
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
        if (it->b[0x46] == 0x81 && it->b[0x3A]) {
            for (i = 1; i <= 3; ++i) {
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
            c->b[0x110] = 3;
        }
        break;
    case 4:
        if (lvl > 7) {
            c->b[0x110] = 3;
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

    c->b[0x5A] = 0;
    for (k = 0; k <= 7; ++k) {
        u16 t;

        lvl = c->b[0xFE + k];
        t = H005_W(0x5158 + k * 0x1A + lvl * 2);
        if (c->b[0x5A] < t) {
            c->b[0x5A] = (u8)t;
        }
        if (c->b[0xDB] < lvl) {
            c->b[0xDB] = lvl;
        }
        check_level_limit(c, k, lvl);
    }
    if ((c->b[0x5E] == 6 && (c->b[0x5B] == 3 || c->b[0x5B] == 4)) ||
        c->b[0x5E] == 3) {
        ++c->b[0x5A];
    }
    spell_slots_all(c);
    saving_throws(c);
    if (c->b[0x104] > 0) {
        thief_skills(c);
    }
    c->b[0x122] = 0;
    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] > 0 ||
            (c->b[0x106 + k] > 0 && c->b[0x106 + k] < c->b[0xDB])) {
            c->b[0x122] = (u8)(c->b[0x122] + H005_B(0x5040 + k));
        }
    }
    for (s = 0; s <= 0x0C; ++s) {
        CokItem *it = c->readied[s];

        if (it != NULL &&
            !mask_byte(H005_B(0x336C + it->b[0x30] * 0x12 + 0x0F),
                       c->b[0x122]) &&
            !it->b[0x3C]) {
            it->b[0x3A] = 0;
        }
    }
    if (h073_130a(c)) {
        for (k = 0; k <= 7; ++k) {
            u16 t;

            lvl = c->b[0x106 + k];
            check_level_limit(c, k, lvl);
            t = H005_W(0x5158 + k * 0x1A + lvl * 2);
            if (c->b[0x5A] < t) {
                c->b[0x5A] = (u8)t;
            }
        }
        if (c->b[0x108] > 6 || c->b[0x10A] > 7 || c->b[0x10D] > 6) {
            c->b[0x110] = 3;
        }
        if (c->b[0x10C] > 0) {
            thief_skills(c);
        }
    }
}
