/* H058: Riposo, memorizzazione e scorrere del tempo; dettaglio parziale. */
#include "h058.h"
#include "globals.h"
#include "h029_gfx.h"
#include "h034.h"
#include "h062.h"
#include "h008.h"
#include "h010_input.h"
#include "h030.h"
#include "h033.h"
#include "h045.h"
#include "h063.h"

/*
 * Dati del modulo sotto a4: -$28..-$1 un flag per personaggio del party
 * (ha ancora effetti a tempo).  g_h058_bss[0x28 - off] e' -off(a4).
 */
u8 g_h058_bss[0x28];
#define H058_FLAG(i)    g_h058_bss[(i)]   /* -$28 + i */

/* Contatore del tempo: word di g_state_a + 2*idx (idx $C6..$CC, $1FC..). */
#define STATE_W(idx)    COK_GET16(g_state_a + (idx) * 2)
#define STATE_SETW(idx, v) COK_PUT16(g_state_a + (idx) * 2, (u16)(v))

/* PORT H058+$00CE: link/unlk, nessun effetto. */
void h058_init(void)
{
}

/*
 * PORT H058+$018A (annidata in $017C): il contatore idx arriva a limit:
 * il ciclo di idx-3 avanza (0..3), la sua icona (tile 8x8 nella riga 0)
 * cambia e il contatore torna 0; altrimenti avanza.  Per un idx diverso
 * l'originale userebbe tile e colonna non inizializzate (qui 0).
 */
static void cycle_icon(u16 idx, u16 limit)
{
    u16 tile = 0;                       /* -$6 del chiamante */
    u16 col = 0;                        /* -$4 del chiamante */

    if (STATE_W(idx) < limit) {
        STATE_SETW(idx, STATE_W(idx) + 1);
        return;
    }
    if (STATE_W(idx - 3) >= 3) {
        STATE_SETW(idx - 3, 0);
    } else {
        STATE_SETW(idx - 3, STATE_W(idx - 3) + 1);
    }
    switch (idx) {
    case 0x1FC:
        /* A+$3F2: (word) fase (0..3) del ciclo 1: icona cornice colonna 8 */
        tile = (u16)(COK_GET16(g_state_a + 0x3F2) + 0x0A);
        col = 8;
        break;
    case 0x1FD:
        /* A+$3F4: (word) fase (0..3) del ciclo 2: icona cornice colonna $13 */
        tile = (u16)(COK_GET16(g_state_a + 0x3F4) + 6);
        col = 0x13;
        break;
    case 0x1FE:
        /* A+$3F6: (word) fase (0..3) del ciclo 3: icona cornice colonna $1E */
        tile = (u16)(COK_GET16(g_state_a + 0x3F6) + 0x0E);
        col = 0x1E;
        break;
    default:
        break;
    }
    draw_8x8_tile(col, 0, (u16)(tile + 0x114), 0, 0);
    STATE_SETW(idx, 0);
}

/* PORT H058+$017C: a ogni ora avanzano i tre cicli delle icone della cornice. */
static void hourly_icons(void)
{
    cycle_icon(0x1FC, 8);
    cycle_icon(0x1FD, 1);
    cycle_icon(0x1FE, 6);
}

/*
 * PORT H058+$052C: riporta il tempo t[0..6] nei limiti di H005+$500A
 * (riporto all'unita' successiva; a ogni ora le icone; all'ultima unita'
 * ogni personaggio invecchia di uno, +$62).
 */
static void normalize_time(u8 *t)
{
    u8 i;                               /* -$1(a5) */
    Character *p;                       /* -$6(a5) */

    for (i = 0; i <= 6; ++i) {
        /* $500A: (word) limiti delle unita' di tempo t[0..6] (riporto) */
        if (COK_GET16(t + i * 2) < H005_W(0x500A + i * 2)) {
            continue;
        }
        if (i != 6) {
            COK_PUT16(t + (i + 1) * 2, COK_GET16(t + (i + 1) * 2) + 1);
            COK_PUT16(t + i * 2, /* $500A: (word) limiti delle unita' di tempo t[0..6] (riporto) */
                      COK_GET16(t + i * 2) - H005_W(0x500A + i * 2));
            if (i == 3) {
                hourly_icons();
            }
        } else {
            for (p = g_party_head; p != NULL; p = p->next) {
                COK_PUT16(&p->b[0x62], COK_GET16(&p->b[0x62]) + 1); /* pg+$62: eta' (word) */
            }
        }
    }
}

/*
 * PORT H058+$02F4: fa scorrere amount unita' unit sugli effetti a tempo
 * dei personaggi (a passi di 10): quelli scaduti si tolgono.  Fuori dal
 * campo (contesto diverso da 2) tutti i personaggi vanno controllati;
 * al campo solo quelli che hanno ancora effetti.
 */
static void age_effects(u16 amount, u8 unit)
{
    u16 i;                              /* -$4(a5) */
    u16 step;                           /* -$6(a5) */
    u16 left;                           /* -$8(a5) */
    Character *p;                       /* -$C(a5) */
    u8 found;                           /* -$E(a5) */
    u8 done;                            /* -$D(a5) */
    CokEffect *e;                       /* -$12(a5) */
    CokEffect *last;                    /* -$16(a5) */
    CokEffect *next;                    /* -$1A(a5) */
    u8 u;                               /* -$1(a5) */

    if (H005_B(0x3DE3) != 2) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        h029_fill_bytes(0x27, g_h058_bss, 0x28, 1);
    } else {
        found = 0;
        i = 1;
        do {
            if (H058_FLAG(i - 1)) {
                found = 1;
            }
            ++i;
        /* B+$67C: (word) numero dei membri del party (max 8) */
        } while (!found && i <= COK_GET16(g_state_b + 0x67C));
        if (!found) {
            return;
        }
    }
    left = amount;
    for (u = unit; u > 1; --u) {
        /* $500A: (word) limiti delle unita' di tempo t[0..6] (riporto) */
        left = (u16)(left * H005_W(0x500A + (u - 1) * 2));
    }
    while (left > 0) {
        step = (u16)(left > 0x0A ? 0x0A : left);
        i = 1;
        for (p = g_party_head; p != NULL; p = p->next) {
            if (H058_FLAG(i - 1)) {
                H058_FLAG(i - 1) = 0;
                e = p->effects;
                if (e != NULL) {
                    last = e;
                    while (last->next != NULL) {
                        last = last->next;
                    }
                    done = 0;
                    while (e != NULL && !done) {
                        next = e->next;
                        if (e == last) {
                            done = 1;
                        }
                        /* eff+$2: (word) durata residua dell'effetto, scalata col tempo; 0 =
                         * permanente */
                        if (COK_GET16(&e->b[2]) != 0) {
                            /* eff+$2: (word) durata residua dell'effetto, scalata col tempo; 0 =
                             * permanente */
                            if (COK_GET16(&e->b[2]) > step) {
                                /* eff+$2: (word) durata residua dell'effetto, scalata col tempo; 0
                                 * = permanente */
                                COK_PUT16(&e->b[2], COK_GET16(&e->b[2]) - step);
                                H058_FLAG(i - 1) = 1;
                            } else {
                                /* eff+$0: tipo dell'effetto (codice del gestore) */
                                remove_effect(p, e->b[0], e);
                            }
                        }
                        e = next;
                    }
                    while (e != NULL) {
                        /* eff+$2: (word) durata residua dell'effetto, scalata col tempo; 0 =
                         * permanente */
                        if (COK_GET16(&e->b[2]) > 0) {
                            H058_FLAG(i - 1) = 1;
                        }
                        e = e->next;
                    }
                }
            }
            ++i;
        }
        left = (u16)(left > 0x0A ? left - 0x0A : 0);
    }
}

/*
 * PORT H058+$064A: avanza il tempo di gioco (g_state_a +$18C, 7 word) di
 * amount unita' unit, poi gli effetti a tempo.
 */
void advance_time(u16 amount, u8 unit)
{
    u8 t[0x0E];                         /* -$E(a5) */
    u8 i;                               /* -$F(a5) */
    u16 k;                              /* -$12(a5) */

    for (i = 0; i <= 6; ++i) {
        /* A+$18C: tempo di gioco: 7 word da qui (secondi, minuti, decine, ore, giorni) */
        COK_PUT16(&t[i * 2], STATE_W(0xC6 + i));
    }
    for (k = 1; k <= amount; ++k) {
        COK_PUT16(&t[unit * 2], COK_GET16(&t[unit * 2]) + 1);
        normalize_time(t);
    }
    for (i = 0; i <= 6; ++i) {
        /* A+$18C: tempo di gioco: 7 word da qui (secondi, minuti, decine, ore, giorni) */
        STATE_SETW(0xC6 + i, COK_GET16(&t[i * 2]));
    }
    age_effects(amount, unit);
}

/*
 * Tempo di riposo: 7 word a $24F4 (0 secondi, 1 minuti, 2 decine di
 * minuti, 3 ore, 4 giorni, 5..6 oltre), limiti a $500A.
 */
/* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre) */
#define REST_T(i)       H005_W(0x24F4 + (i) * 2)
/* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre) */
#define REST_SET_T(i, v) H005_SET_W(0x24F4 + (i) * 2, (u16)(v))
#define REST_TIMER(i)   H005_B(0x24EC + (i))  /* per personaggio */

/*
 * PORT H058+$05F4: normalizza il tempo di riposo; il riporto oltre i
 * giorni torna nei giorni, al massimo 99.
 */
static void rest_normalize(void)
{
    /* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre) */
    normalize_time(&g_h005[0x24F4]);
    if (REST_T(5) > 0) { /* $24FE: tempo di riposo: riporto oltre i giorni (word, voce 5) */
        /* $5012: (word) limite dell'unita' 4 (giorni) per il riporto; $24FE: tempo di riposo:
         * riporto oltre i giorni (word, voce 5); $24FC: tempo di riposo: giorni, al massimo 99
         * (word, voce 4) */
        REST_SET_T(4, H005_W(0x5012) * REST_T(5) + REST_T(4));
        REST_SET_T(5, 0); /* $24FE: tempo di riposo: riporto oltre i giorni (word, voce 5) */
        if (REST_T(4) > 0x63) { /* $24FC: tempo di riposo: giorni, al massimo 99 (word, voce 4) */
            REST_SET_T(4, 0x63); /* $24FC: tempo di riposo: giorni, al massimo 99 (word, voce 4) */
        }
    }
}

/*
 * PORT H058+$070E: toglie amount unita' unit dal tempo di riposo,
 * prendendo in prestito dalle unita' maggiori; se non bastano il tempo
 * si azzera.
 */
static void rest_subtract(u16 amount, u8 unit)
{
    u8 j;                               /* -$1(a5) */
    u8 k;                               /* -$2(a5) */

    /* $24FC: tempo di riposo: giorni, al massimo 99 (word, voce 4); $24FA: tempo di riposo: ore
     * (word, voce 3); $24F8: tempo di riposo: decine di minuti (word, voce 2) */
    if (REST_T(4) == 0 && REST_T(3) == 0 && REST_T(2) == 0 &&
        REST_T(1) == 0) { /* $24F6: tempo di riposo: minuti (word, voce 1) */
        return;
    }
    /* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre) */
    while (amount > REST_T(unit)) {
        j = (u8)(unit + 1);
        /* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre) */
        while (REST_T(j) == 0 && j < 5) {
            j = (u8)(j + 1);
        }
        if (j == 5) {
            /* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre) */
            h029_fill_bytes(0x0D, &g_h005[0x24F4], 0x0E, 0);
            amount = 0;
        } else {
            for (k = j; k >= (u8)(unit + 1); --k) {
                /* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre) */
                REST_SET_T(k, REST_T(k) - 1);
                /* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre); $500A:
                 * (word) limiti delle unita' di tempo t[0..6] (riporto) */
                REST_SET_T(k - 1, REST_T(k - 1) + H005_W(0x500A + (k - 1) * 2));
                if (k == 0) {
                    break;
                }
            }
        }
    }
    /* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre) */
    REST_SET_T(unit, REST_T(unit) - amount);
    rest_normalize();
}

/*
 * PORT H058+$084C: riga "Rest Time : gg : hh : mm" (riga $11); il campo
 * sel (4 giorni, 3 ore, 2 minuti) in colore 15.
 */
static void rest_display(u8 sel)
{
    char buf[0x2A];                     /* -$2A(a5) */
    u8 i;                               /* -$2F(a5) */
    u16 color[7];                       /* -$3E(a5) */
    u16 col;                            /* -$40(a5) */

    for (i = 0; i <= 6; ++i) {
        color[i] = 0x0A;
    }
    color[sel] = 0x0F;
    ui_draw_text(1, 0x11, 0x0A, 0, 0x0C, "Rest Time : ");
    col = 0x0B;
    for (i = 4; i >= 3; --i) {
        /* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre) */
        format_number(0x28, buf, (s32)REST_T(i), 0, 0x0A, 2, '0');
        ui_draw_text((u16)(col + 1), 0x11, color[i], 0, 0x28, buf);
        ui_draw_text((u16)(col + 1 + 2), 0x11, 0x0A, 0, 3, " : ");
        col = (u16)(col + 3);
    }
    /* $24F8: tempo di riposo: decine di minuti (word, voce 2); $24F6: tempo di riposo: minuti
     * (word, voce 1) */
    format_number(0x28, buf, (s32)(u16)(REST_T(2) * 0x0A + REST_T(1)), 0,
                  0x0A, 2, '0');
    ui_draw_text((u16)(col + 1), 0x11, color[2], 0, 0x28, buf);
}

/*
 * PORT H058+$09AA: menu del tempo di riposo.  Su/giu' aggiungono e
 * tolgono, sinistra/destra cambiano campo; 1 se si sceglie Rest.
 */
static u8 rest_menu(void)
{
    u8 rest = 0;                        /* -$1(a5) */
    u8 special;                         /* -$2(a5) */
    u8 key;                             /* -$3(a5) */
    u8 sel = 2;                         /* -$4(a5) */

    do {
        rest_display(sel);
        key = ui_request_choice(0, "", 0x26,
                                "Rest Days Hours Mins Add Subtract Exit",
                                0x0D, 0x0A, 0x0F, 1, 0, &special);
        if (special) {
            switch (key) {
            case 'H':
                key = 'A';
                break;
            case 'P':
                key = 'S';
                break;
            case 'K':
                sel = (u8)(sel + 1);
                if (sel > 4) {
                    sel = 2;
                }
                key = 'X';
                break;
            case 'M':
                sel = (u8)(sel - 1);
                if (sel < 2) {
                    sel = 4;
                }
                key = 'X';
                break;
            default:
                key = 'X';
                break;
            }
        }
        if (key == 0x0D) {
            key = 'R';
        }
        switch (key) {
        case 'R':
            rest = 1;
            break;
        case 'D':
            sel = 4;
            break;
        case 'H':
            sel = 3;
            break;
        case 'M':
            sel = 2;
            break;
        case 'A':
            if (sel == 2) {
                REST_SET_T(1, REST_T(1) + 5); /* $24F6: tempo di riposo: minuti (word, voce 1) */
            } else {
                /* $24F4: tempo di riposo: 7 word (sec, min, decine, ore, giorni, oltre) */
                REST_SET_T(sel, REST_T(sel) + 1);
            }
            rest_normalize();
            break;
        case 'S':
            if (sel == 2) {
                rest_subtract(5, 1);
            } else {
                rest_subtract(1, sel);
            }
            rest_normalize();
            break;
        default:
            break;
        }
    } while (key != 'R' && key != 'E' && key != 0);
    return rest;
}

/*
 * PORT H058+$0B84: ogni $120 passi tutto il party recupera un punto
 * ferita.
 */
static void rest_heal(u8 show)
{
    u8 healed;                          /* -$1(a5) */
    Character *p;                       /* -$6(a5) */

    /* $24EA: contatore dei passi di riposo per +1 PF ogni $120 (word) */
    H005_SET_W(0x24EA, H005_W(0x24EA) + 1);
    if (H005_W(0x24EA) < 0x120) { /* $24EA: contatore dei passi di riposo per +1 PF ogni $120 (word) */
        return;
    }
    healed = 0;
    for (p = g_party_head; p != NULL; p = p->next) {
        if (heal_character(p, 1, 0)) {
            healed = 1;
        }
    }
    if (show) {
        rest_display(0);
    }
    ui_draw_text(1, 0x13, 0x0A, 0, 0x19, "The whole Party Is Healed");
    if (healed) {
        draw_party(g_current_char);
    }
    message_delay();
    clear_message_area();
    H005_SET_W(0x24EA, 0); /* $24EA: contatore dei passi di riposo per +1 PF ogni $120 (word) */
}

/*
 * PORT H058+$0C38: con *flag a 0 memorizza il primo incantesimo in
 * attesa (bit 7) e lo annuncia; con *flag a 1 restituisce il livello
 * del primo in attesa.  *flag diventa 1.
 */
static u16 memorize_next(Character *c, u8 *flag)
{
    u16 level = 0;                      /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    u16 spell;

    for (i = 0; i <= 0x39 && level == 0; ++i) {
        /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
        if (c->b[0x1E + i] > 0x7F) {
            if (*flag) {
                /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
                spell = mask_byte(c->b[0x1E + i], 0x7F);
                level = H005_B(0x66 + (spell - 1) * 16 + 1);
            } else {
                /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
                c->b[0x1E + i] = (u8)(c->b[0x1E + i] - 0x80);
                rest_display(0);
                /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
                announce_spell(c, 0x0D, "has memorized", c->b[0x1E + i]);
            }
            *flag = 1;
        }
    }
    return level;
}

/*
 * PORT H058+$0D2C: come memorize_next per le pergamene da trascrivere:
 * l'incantesimo diventa noto (+$66) e si toglie dalla pergamena.
 */
static u16 scribe_next(Character *c, u8 *flag)
{
    u16 k;                              /* -$2(a5) */
    u16 spell;                          /* -$4(a5) */
    u16 level = 0;                      /* -$6(a5) */
    CokItem *it;                        /* -$A(a5) */
    u8 found = 0;                       /* -$B(a5) */

    for (it = c->items; it != NULL && level == 0; it = it->next) {
        k = 1;
        if (!is_scroll(it)) {
            continue;
        }
        for (; k <= 3 && level == 0; ++k) {
            /* ogg+$43: base tabella 3 incantesimi +$44..+$46 (indice 1..3, bit7=da scrivere) */
            if (it->b[0x44 + k - 1] <= 0x80) {
                continue;
            }
            found = 1;
            if (*flag) {
                /* ogg+$43: base tabella 3 incantesimi +$44..+$46 (indice 1..3, bit7=da scrivere) */
                spell = mask_byte(it->b[0x44 + k - 1], 0x7F);
                level = H005_B(0x66 + (spell - 1) * 16 + 1);
            } else {
                /* ogg+$43: base tabella 3 incantesimi +$44..+$46 (indice 1..3, bit7=da scrivere) */
                spell = mask_byte(it->b[0x44 + k - 1], 0x7F);
                /* pg+$65: base -1 incantesimi noti +$66+s-1 (s = 1..$6B, flag per incantesimo) */
                c->b[0x66 + spell - 1] = 1;
                remove_scroll_spell(c, it, spell);
                rest_display(0);
                announce_spell(c, 0x0B, "has scribed", spell);
                *flag = 1;
            }
        }
    }
    (void)found;
    return level;
}

/*
 * PORT H058+$0E80: scala i contatori dei personaggi; a zero (e senza
 * attesa iniziale +$58) trascrive o memorizza e fissa il prossimo
 * contatore a 3 volte il livello.
 */
static void rest_learn(void)
{
    u16 i = 1;                          /* -$2(a5) */
    u16 level;                          /* -$4(a5) */
    Character *p;                       /* -$8(a5) */
    u8 flag;                            /* -$9(a5) */

    for (p = g_party_head; p != NULL; p = p->next, ++i) {
        if (REST_TIMER(i - 1) > 0) { /* $24EC: contatori di studio per personaggio (8 byte, indice = posto) */
            /* $24EC: contatori di studio per personaggio (8 byte, indice = posto) */
            REST_TIMER(i - 1) = (u8)(REST_TIMER(i - 1) - 1);
        }
        /* $24EC: contatori di studio per personaggio (8 byte, indice = posto); pg+$58: ore di
         * studio residue (memorizzazione/trascrizione) (word) */
        if (REST_TIMER(i - 1) == 0 && COK_GET16(&p->b[0x58]) == 0) {
            flag = 0;
            level = scribe_next(p, &flag);
            if (level == 0) {
                level = memorize_next(p, &flag);
            }
            /* $24EC: contatori di studio per personaggio (8 byte, indice = posto) */
            REST_TIMER(i - 1) = (u8)(level * 3);
        }
    }
}

/*
 * PORT H058+$0F5C: ogni 12 passi scala l'attesa iniziale (+$58); quando
 * finisce fissa il contatore al livello del prossimo incantesimo.
 */
static void rest_wait(u16 *count)
{
    u16 i;                              /* -$2(a5) */
    u16 level;                          /* -$4(a5) */
    Character *p;                       /* -$8(a5) */
    u8 flag;                            /* -$9(a5) */

    *count = (u16)(*count + 1);
    if (*count < 0x0C) {
        return;
    }
    *count = 0;
    i = 1;
    for (p = g_party_head; p != NULL; p = p->next, ++i) {
        /* pg+$58: ore di studio residue (memorizzazione/trascrizione) (word) */
        if ((s16)COK_GET16(&p->b[0x58]) > 0) {
            /* pg+$58: ore di studio residue (memorizzazione/trascrizione) (word) */
            COK_PUT16(&p->b[0x58], COK_GET16(&p->b[0x58]) - 1);
            /* pg+$58: ore di studio residue (memorizzazione/trascrizione) (word) */
            if (COK_GET16(&p->b[0x58]) == 0) {
                flag = 1;
                level = scribe_next(p, &flag);
                if (level == 0) {
                    level = memorize_next(p, &flag);
                }
                /* $24EC: contatori di studio per personaggio (8 byte, indice = posto) */
                REST_TIMER(i - 1) = (u8)(level * 3);
            }
        }
    }
}

/*
 * PORT H058+$1014: riposo per il tempo a $24F4 (interactive: prima il
 * menu e si puo' interrompere con un tasto) a passi di 5 minuti; puo'
 * capitare un incontro (g_state_b +$5A4/+$5A6).  1 se interrotto.
 */
u8 rest_party(u8 interactive)
{
    Character *p;                       /* -$4(a5) */
    u16 i;                              /* -$C(a5) */
    u16 wait_count;                     /* -$E(a5) */
    u16 steps;                          /* -$10(a5) */
    u8 stop;                            /* -$11(a5) */
    u8 interrupted = 0;                 /* -$13(a5) */

    i = 1;
    for (p = g_party_head; p != NULL; p = p->next) {
        REST_TIMER(i - 1) = 0; /* $24EC: contatori di studio per personaggio (8 byte, indice = posto) */
        ++i;
    }
    h029_fill_bytes(0x27, g_h058_bss, 0x28, 1);
    wait_count = 0;
    steps = 0;
    if (interactive) {
        clear_text_cells(1, 0x11, 0x26, 0x16);
        rest_display(0);
    }
    set_pointer_shape(9);
    H005_B(0x24E2) = 1; /* $24E2: 1 durante il riposo: puntatore d'attesa, messaggi dalla riga $12 */
    stop = (u8)(interactive ? !rest_menu() : 0);
    /* $24FC: tempo di riposo: giorni, al massimo 99 (word, voce 4); $24FA: tempo di riposo: ore
     * (word, voce 3); $24F8: tempo di riposo: decine di minuti (word, voce 2) */
    while (!stop && (REST_T(4) > 0 || REST_T(3) > 0 || REST_T(2) > 0 ||
                     REST_T(1) > 0)) { /* $24F6: tempo di riposo: minuti (word, voce 1) */
        poll_intuition_events();
        if (interactive && G_KEY) { /* $5305: tasto/azione pendente dall'input (G_KEY) */
            rest_display(0);
            if (ask_yes_no(0x0E, "Stop Resting? ", 0x0D, 0x0A, 0x0F) == 'Y') {
                stop = 1;
            } else {
                clear_message_line();
            }
        }
        if (stop) {
            continue;
        }
        rest_subtract(5, 1);
        ++steps;
        if (interactive && steps >= 5) {
            rest_display(0);
            steps = 0;
        }
        advance_time(5, 1);
        rest_heal(interactive);
        rest_learn();
        rest_wait(&wait_count);
        /* B+$5A4: (word) passi di riposo (5 min) fra i tiri d'incontro, 0 mai */
        if (COK_GET16(g_state_b + 0x5A4) > 0) {
            /* $3DDE: (word) passi di riposo dall'ultimo controllo incontri */
            H005_SET_W(0x3DDE, H005_W(0x3DDE) + 1);
            /* $3DDE: (word) passi di riposo dall'ultimo controllo incontri; B+$5A4: (word) passi di
             * riposo (5 min) fra i tiri d'incontro, 0 mai */
            if (H005_W(0x3DDE) >= COK_GET16(g_state_b + 0x5A4)) {
                H005_SET_W(0x3DDE, 0); /* $3DDE: (word) passi di riposo dall'ultimo controllo incontri */
                /* B+$5A6: (word) probabilita' % d'incontro durante il riposo */
                if (roll_dice(1, 0x64) <= COK_GET16(g_state_b + 0x5A6)) {
                    clear_message_area();
                    rest_display(0);
                    ui_draw_text(1, 0x13, 0x0F, 0, 0x24,
                                 "Your repose is suddenly interrupted!");
                    stop = 1;
                    interrupted = 1;
                    message_delay();
                }
            }
        }
    }
    clear_text_cells(1, 0x11, 0x26, 0x16);
    H005_B(0x24E2) = 0; /* $24E2: 1 durante il riposo: puntatore d'attesa, messaggi dalla riga $12 */
    set_pointer_shape(0x0A);
    return interrupted;
}
