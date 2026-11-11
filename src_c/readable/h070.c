/* H070: esito del combattimento, esperienza e tesoro. */
#include <string.h>
#include "cok.h"
#include "h070.h"
#include "globals.h"
#include "unported.h"
#include "h003_exec.h"
#include "h008.h"
#include "h015_runtime.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h033.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h053.h"
#include "h061.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include "h067.h"
#include "h071.h"

/* $2A1E: cassa del party: 7 long, monete per tipo 0..6 (4 = acciaio) */
#define POOL(k)         H005_L(0x2A1E + (k) * 4)
/* $2A1E: cassa del party: 7 long, monete per tipo 0..6 (4 = acciaio) */
#define SET_POOL(k, v)  H005_SET_L(0x2A1E + (k) * 4, (v))
#define TURN(c)         ((c)->block_192)

static u8 s_enemies;                    /* -$1(a4): c'erano nemici */
static u8 s_fled;                       /* -$2(a4): il party e' fuggito */

/* PORT H070+$0272: link/unlk, nessun effetto. */
void h070_init(void)
{
}

/* Libera la lista del tesoro ($2A3A). */
static void free_treasure(void)
{
    CokItem *it = g_treasure_items;     /* -$4(a5) */
    CokItem *n;                         /* -$8(a5) */

    while (it != NULL) {
        n = it;
        it = it->next;
        exec_free_mem(n, sizeof(CokItem));
    }
    g_treasure_items = NULL;
}

/*
 * PORT H070+$0280: esperienza per personaggio: per ogni nemico sconfitto
 * (lato 1, stato non 0 ne' 3) il suo valore (+$13C piu' +$13E per i dadi
 * vita +$123), le sue monete (se +$15 del turno = 1) nella cassa e i suoi
 * oggetti nel tesoro (salvo $3E00+$5C6 = 1); poi il valore della cassa e
 * degli oggetti magici del tesoro; diviso per i personaggi rimasti
 * ($3E00+$67C - $2499).  Con divisore 0 l'originale ha un'eccezione: qui
 * il totale.
 */
static void compute_experience(u32 *out)
{
    u32 xp = 0;                         /* -$A(a5) */
    Character *p;                       /* -$4(a5) */
    CokItem *it;                        /* -$12(a5) */
    CokItem *n;                         /* -$E(a5) */
    u16 count = 0;                      /* -$14(a5) */
    u8 k;                               /* -$5(a5) */
    s32 div;

    for (p = g_party_head; p != NULL; p = p->next) {
        it = p->items;
        /* pg+$199: lato in combattimento (0 party, 1 avversari); pg+$197: stato: 0 ok, 4
         * incosciente, 5 morente, 6-8 morto, $0A a terra */
        if (p->b[0x199] != 1 || p->b[0x197] == 0 || p->b[0x197] == 3) {
            continue;
        }
        s_enemies = 1;
        /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
        if (TURN(p)->b[0x15] == 1) {
            for (k = 0; k <= 6; ++k) {
                /* $2A1E: cassa del party: 7 long, monete per tipo 0..6 (4 = acciaio); pg+$F0:
                 * monete, 7 word passo 2 (0..4 monete, 4 acciaio, 5 gemme, 6 gioielli); $2A20: word
                 * bassa del long della cassa per il tipo di moneta 0 */
                SET_POOL(k, POOL(k) + CH_W(p, 0xF0 + k * 2));
            }
        }
        /* pg+$13C: esperienza data dal mostro sconfitto (word); pg+$13E: esperienza del mostro per
         * punto ferita (moltiplica +$123); pg+$123: PF massimi senza costituzione; base -1 slot
         * incantesimi +$124 */
        xp = xp + CH_W(p, 0x13C) + h015_mulu32(p->b[0x13E], p->b[0x123]);
        /* B+$5C6: (word) 1: oggetti dei nemici non vanno nel tesoro */
        if (COK_GET16(g_state_b + 0x5C6) == 1) {
            continue;
        }
        for (; it != NULL; it = it->next) {
            ++count;
            n = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
            build_item_name(p, it, 0, 0, 0, 0);
            memcpy(n->b, it->b, 0x48);
            n->b[0x3A] = 0; /* ogg+$3A: flag oggetto pronto all'uso (Ready) */
            n->next = g_treasure_items;
            g_treasure_items = n;
        }
    }
    (void)count;
    /* $2A1E: cassa del party: 7 long, monete per tipo 0..6 (4 = acciaio) */
    xp += (u32)h015_divs32((s32)POOL(0), 0x64, NULL);
    /* $2A22: (long) cassa, monete del tipo 1 (xp: quantita' / 20) */
    xp += (u32)h015_divs32((s32)POOL(1), 0x14, NULL);
    /* $2A26: (long) cassa, monete del tipo 2 (xp: quantita' / 10) */
    xp += (u32)h015_divs32((s32)POOL(2), 0x0A, NULL);
    xp += POOL(3); /* $2A2A: (long) cassa, monete del tipo 3 (xp: quantita' x 1) */
    xp += POOL(4) << 1; /* $2A2E: (long) cassa, pezzi d'acciaio (tipo 4; xp: quantita' x 2) */
    xp += h015_mulu32(POOL(5), 0xFA); /* $2A32: (long) cassa, monete del tipo 5 (xp: quantita' x 250) */
    xp += h015_mulu32(POOL(6), 0x898); /* $2A36: (long) cassa, monete del tipo 6 (xp: quantita' x 2200) */
    for (it = g_treasure_items; it != NULL && it != g_thrown_tail;
         it = it->next) {
        /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
        if ((s16)COK_GET16(it->b + 0x36) > 0) {
            /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
            xp += (u32)((s32)(s16)COK_GET16(it->b + 0x36) * 0x190);
        }
    }
    /* B+$67C: (word) numero dei membri del party (max 8); $2499: personaggi caduti a fine
     * combattimento (tolti dal divisore XP) */
    div = (s32)COK_GET16(g_state_b + 0x67C) - (s32)H005_B(0x2499);
    *out = div != 0 ? (u32)h015_divs32((s32)xp, div, NULL) : xp;
}

/*
 * PORT H070+$0558: dà xp punti esperienza a chi e' in piedi: il 10% in
 * piu' a chi ha la caratteristica principale della classe oltre 15 (14
 * per la saggezza del chierico), meta' o un terzo alle classi multiple.
 */
static void award_experience(u32 xp)
{
    Character *p;                       /* -$4(a5) */
    u32 v;                              /* -$8(a5) */
    u8 bonus;

    if (COK_GET16(g_state_a + 0x3EA)) { /* A+$3EA: (word) esito e' un prelievo in banca: niente esperienza */
        return;
    }
    for (p = g_party_head; p != NULL; p = p->next) {
        /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento); pg+$197: stato: 0 ok, 4
         * incosciente, 5 morente, 6-8 morto, $0A a terra */
        if (!p->b[0x198] || p->b[0x197] == 1) {
            continue;
        }
        v = xp;
        bonus = 0;
        switch (p->b[0x5C]) { /* pg+$5C: classe o combinazione di classi (0..16, nomi H005+$4D84) */
        case 0: bonus = (u8)(p->b[0x15] > 0x0E); break; /* pg+$15: saggezza corrente */
        /* pg+$11: caratteristiche correnti, 6 voci passo 2 da +$11; forza corrente */
        case 2: bonus = (u8)(p->b[0x11] > 0x0F); break;
        /* pg+$11: caratteristiche correnti, 6 voci passo 2 da +$11; forza corrente; pg+$15:
         * saggezza corrente */
        case 3: bonus = (u8)(p->b[0x11] > 0x0F && p->b[0x15] > 0x0F); break;
        case 4:
            /* pg+$11: caratteristiche correnti, 6 voci passo 2 da +$11; forza corrente; pg+$13:
             * intelligenza corrente */
            bonus = (u8)(p->b[0x11] > 0x0F && p->b[0x13] > 0x0F &&
                         p->b[0x15] > 0x0F); /* pg+$15: saggezza corrente */
            break;
        case 5: bonus = (u8)(p->b[0x13] > 0x0F); break; /* pg+$13: intelligenza corrente */
        case 6: bonus = (u8)(p->b[0x17] > 0x0F); break; /* pg+$17: destrezza corrente */
        case 8: case 0x0A: case 0x0B: case 0x0C: case 0x0D: case 0x0E:
        case 0x10:
            v = (u32)h015_divs32((s32)xp, 2, NULL);
            break;
        case 9: case 0x0F:
            v = (u32)h015_divs32((s32)xp, 3, NULL);
            break;
        default:
            break;
        }
        if (bonus) {
            v = (u32)h015_divs32((s32)xp, 0x0A, NULL) + xp;
        }
        CH_PUTL(p, 0x11E, CH_L(p, 0x11E) + v); /* pg+$11E: punti esperienza (long) */
    }
}

/*
 * PORT H070+$0778: esito del combattimento: il party ha perso ($24D0)
 * salvo chi e' rimasto (o rientra con $3E00+$5CC); fuga ($-2(a4)) se
 * qualcuno e' fuggito e nessuno ha vinto; vittoria ($24C0) se qualcuno e'
 * rimasto in piedi.  Toglie gli effetti del combattimento, dà
 * l'esperienza, rimette in piedi chi era fuggito o svenuto e toglie dal
 * party chi non c'e' piu'.  Dove l'originale legge il successivo di un
 * personaggio gia' tolto, qui lo legge prima.
 */
static void combat_outcome(void)
{
    static const u16 effects[11] = {
        3, 0x0B, 0x15, 0x17, 0x1B, 0x23, 0x28, 0x33, 0x34, 0x35, 0x1F
    };
    Character *p;                       /* -$1A(a5) */
    Character *n;
    u8 alive = 0;                       /* -$1F(a5) */
    u8 stop;                            /* -$1B(a5) */
    u16 k;                              /* -$1E(a5) */

    H005_B(0x2499) = 0; /* $2499: personaggi caduti a fine combattimento (tolti dal divisore XP) */
    H005_B(0x24D0) = 1; /* $24D0: 1 party perduto o uscito: ferma ECL e ciclo dell'esplorazione */
    s_fled = 0;
    /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
    for (p = g_party_head; p != NULL && TURN(p)->b[0x15] != 1; p = p->next) {
        if (p->b[0x197] == 3) { /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
            s_fled = 1;
        }
    }
    for (p = g_party_head; p != NULL && !alive; p = p->next) {
        /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento); pg+$197: stato: 0 ok, 4
         * incosciente, 5 morente, 6-8 morto, $0A a terra */
        if (p->b[0x198] || p->b[0x197] == 4 || p->b[0x197] == 3 ||
            p->b[0x197] == 5) { /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
            alive = 1;
        }
    }
    /* B+$5CC: (word) sconfitta non fatale: i caduti si rialzano a 1 PF */
    if (COK_GET16(g_state_b + 0x5CC) && alive) {
        H005_B(0x24D0) = 0; /* $24D0: 1 party perduto o uscito: ferma ECL e ciclo dell'esplorazione */
    }
    H005_B(0x24C0) = 0; /* $24C0: 1 se il party ha vinto l'ultimo combattimento */
    if (H005_B(0x24D7)) { /* $24D7: 1 se e' stata scelta la dimostrazione (Demo) */
        return;
    }
    /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
    for (p = g_party_head; p != NULL && TURN(p)->b[0x15] != 1; p = p->next) {
        /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
        if ((p->b[0x197] == 3 || p->b[0x197] == 1 || p->b[0x197] == 0) &&
            /* pg+$199: lato in combattimento (0 party, 1 avversari); pg+$EC: controllo: <$80 PG,
             * >$7F PNG/IA ($B3 = charme o confuso) */
            p->b[0x199] == 0 && p->b[0xEC] < 0x80) {
            H005_B(0x24D0) = 0; /* $24D0: 1 party perduto o uscito: ferma ECL e ciclo dell'esplorazione */
        }
        /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
        if (p->b[0x197] == 1 || p->b[0x197] == 0) {
            H005_B(0x24C0) = 1; /* $24C0: 1 se il party ha vinto l'ultimo combattimento */
            s_fled = 0;
        }
        /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento); pg+$197: stato: 0 ok, 4
         * incosciente, 5 morente, 6-8 morto, $0A a terra */
        if (!p->b[0x198] || p->b[0x197] == 1) {
            /* $2499: personaggi caduti a fine combattimento (tolti dal divisore XP) */
            add_to_byte(&H005_B(0x2499), 1);
        }
        for (k = 1; k <= 0x0B; ++k) {
            remove_effect(p, effects[k - 1], NULL);
        }
    }
    if (H005_B(0x24C0)) { /* $24C0: 1 se il party ha vinto l'ultimo combattimento */
        u32 xp = 0;

        compute_experience(&xp);
        H005_SET_L(0x236E, xp); /* $236E: esperienza guadagnata nel combattimento (long) */
        award_experience(H005_L(0x236E)); /* $236E: esperienza guadagnata nel combattimento (long) */
    }
    p = g_party_head;
    if (!H005_B(0x24D0)) { /* $24D0: 1 party perduto o uscito: ferma ECL e ciclo dell'esplorazione */
        /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
        while (p != NULL && TURN(p)->b[0x15] != 1) {
            if (!s_fled) {
                /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                switch (p->b[0x197]) {
                case 3:
                    /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                    p->b[0x197] = 0;
                    p->b[0x198] = 1; /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
                    break;
                case 4:
                    /* B+$5CC: (word) sconfitta non fatale: i caduti si rialzano a 1 PF */
                    if (COK_GET16(g_state_b + 0x5CC)) {
                        /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                        p->b[0x197] = 0;
                        p->b[0x198] = 1; /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
                        p->b[0x1A8] = 1; /* pg+$1A8: punti ferita correnti */
                    } else {
                        /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                        p->b[0x197] = 4;
                    }
                    break;
                case 5:
                    if (p->b[0x1A8] > 0) { /* pg+$1A8: punti ferita correnti */
                        /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                        p->b[0x197] = 0;
                        p->b[0x198] = 1; /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
                    /* B+$5CC: (word) sconfitta non fatale: i caduti si rialzano a 1 PF */
                    } else if (COK_GET16(g_state_b + 0x5CC)) {
                        /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                        p->b[0x197] = 0;
                        p->b[0x198] = 1; /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
                        p->b[0x1A8] = 1; /* pg+$1A8: punti ferita correnti */
                    }
                    break;
                default:
                    break;
                }
                p = p->next;
            } else {
                /* B+$58E: (word) esito lotta: 1 qualcuno fuggito, $80 sconfitta, $81 fuga party */
                COK_PUT16(g_state_b + 0x58E, 0x81);
                /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                if (p->b[0x197] == 3) {
                    /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                    p->b[0x197] = 0;
                    p->b[0x198] = 1; /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
                    p = p->next;
                } else {
                    g_current_char = p;
                    p = p->next;
                    remove_from_party(0, 1);
                }
            }
        }
    } else {
        stop = 0;
        while (p != NULL && !stop) {
            n = p->next;
            /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
            if (TURN(p)->b[0x15] != 1) {
                g_current_char = p;
                remove_from_party(0, 1);
            } else {
                stop = 1;
            }
            p = n;
        }
        COK_PUT16(g_state_b + 0x67C, 0); /* B+$67C: (word) numero dei membri del party (max 8) */
    }
}

/*
 * PORT H070+$0B9E: schermata dell'esito: "The party has fled." (tesoro e
 * cassa persi), "You have lost the fight.", "The party has won.", o senza
 * nemici "The party has found Treasure!" (o il prelievo dalla banca); poi
 * l'esperienza per personaggio.
 */
static void show_outcome(u32 xp)
{
    char num[0x0C];                     /* -$C(a5) */
    char line[0x52];                    /* -$5E(a5) */
    u8 special;                         /* -$65(a5) */

    draw_screen_frame(1);
    if (s_enemies) {
        if (s_fled) {
            ui_draw_text(1, 3, 0x0A, 0, 0x13, "The party has fled.");
            xp = 0;
            free_treasure();
            /* $2A1E: cassa del party: 7 long, monete per tipo 0..6 (4 = acciaio) */
            h029_fill_bytes(0x1B, &H005_B(0x2A1E), 0x1C, 0);
        /* $24C0: 1 se il party ha vinto l'ultimo combattimento; B+$5CC: (word) sconfitta non
         * fatale: i caduti si rialzano a 1 PF */
        } else if (!H005_B(0x24C0) && COK_GET16(g_state_b + 0x5CC)) {
            /* B+$58E: (word) esito lotta: 1 qualcuno fuggito, $80 sconfitta, $81 fuga party */
            COK_PUT16(g_state_b + 0x58E, 0x80);
            ui_draw_text(1, 3, 0x0A, 0, 0x18, "You have lost the fight.");
            xp = 0;
        } else {
            ui_draw_text(1, 3, 0x0A, 0, 0x12, "The party has won.");
        }
    /* A+$3EA: (word) esito e' un prelievo in banca: niente esperienza */
    } else if (COK_GET16(g_state_a + 0x3EA)) {
        ui_draw_text(1, 5, 0x0A, 0, 0x25,
                     "The party makes a withdrawl.  A small");
        ui_draw_text(1, 7, 0x0A, 0, 0x22,
                     "fee has been assessed by the bank.");
    } else {
        ui_draw_text(1, 3, 0x0A, 0, 0x1D, "The party has found Treasure!");
    }
    format_number(0x0A, num, (s32)xp, 0, 0x0A, 6, ' ');
    trim_leading_spaces(0x0A, num);
    strcpy(line, "Each character receives ");
    h026_append(0x50, line, 0x0A, num);
    if (!COK_GET16(g_state_a + 0x3EA)) { /* A+$3EA: (word) esito e' un prelievo in banca: niente esperienza */
        ui_draw_text(1, 5, 0x0A, 0, 0x50, line);
        ui_draw_text(1, 7, 0x0A, 0, 0x12, "experience points.");
    }
    (void)ui_request_choice(2, "", 0x22, "press <enter>/<return> to continue",
                            0x0F, 0x0F, 0x0F, 1, 0, &special);
}

/*
 * Nell'originale la lista degli oggetti e' passata al menu a elenco
 * (forma compatibile con le voci); qui una lista di voci con gli stessi
 * nomi, e l'oggetto nella stessa posizione della voce scelta.
 */
static CokMenuItem *s_treasure_menu;

static CokMenuItem *treasure_as_menu(void)
{
    CokItem *it;
    CokMenuItem *tail = NULL;

    menu_free(&s_treasure_menu);
    for (it = g_treasure_items; it != NULL; it = it->next) {
        CokMenuItem *n = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                       COK_MEMF_CLEAR);

        memcpy(n->text, it->b, 0x2A);
        n->header = it->b[0x2A]; /* ogg+$2A: flag intestazione: copiato in header della voce di menu */
        if (tail == NULL) {
            s_treasure_menu = n;
        } else {
            tail->next = n;
        }
        tail = n;
    }
    return s_treasure_menu;
}

static CokItem *treasure_menu_item(CokMenuItem *node)
{
    CokMenuItem *m = s_treasure_menu;
    CokItem *it = g_treasure_items;

    while (m != NULL && it != NULL) {
        if (m == node) {
            return it;
        }
        m = m->next;
        it = it->next;
    }
    return NULL;
}

/*
 * PORT H070+$0DE0: elenco degli oggetti del tesoro ("Items:", Take):
 * restituisce il tasto e l'oggetto scelto.
 */
static void treasure_list(u16 *index, CokMenuItem **cursor, CokItem **out,
                          u8 *key)
{
    CokItem *it;                        /* -$20(a5) */
    u8 redraw = 1;                      /* -$1B(a5) */

    draw_screen_frame(1);
    for (it = g_treasure_items; it != NULL; it = it->next) {
        build_item_name(NULL, it, 0, 0, 0, 0);
    }
    *cursor = NULL;
    *key = list_menu(7, "Items: ", 4, "Take", 0x0D, 0x0A, 0x0F, 1, 1, 0x26,
                     0x16, treasure_as_menu(), 1, &redraw, index, cursor);
    *out = treasure_menu_item(*cursor);
}

/*
 * PORT H070+$0E94 (Take Items): il personaggio corrente prende oggetti
 * dal tesoro (H071+$047C) finche' esce o il tesoro e' vuoto.  Indice e
 * scelta si azzerano una volta sola, prima del ciclo (H070+$0E9E/$0EAA):
 * dopo un Take la selezione resta alla stessa riga.
 */
static void take_items(void)
{
    CokItem *chosen;                    /* -$4(a5) */
    CokItem *p;                         /* -$8(a5) */
    CokMenuItem *cursor;                /* -$E(a5) */
    u16 index;                          /* -$10(a5) */
    u8 key;                             /* -$9(a5) */
    u8 done;                            /* -$A(a5) */
    u8 fail;                            /* -$11(a5) */

    chosen = NULL;
    cursor = NULL;
    index = 0;
    do {
        treasure_list(&index, &cursor, &chosen, &key);
        if ((key != 'T' && key != 0x0D) || chosen == NULL) {
            done = 1;
            continue;
        }
        done = 0;
        take_item(chosen, &fail);
        if (fail) {
            continue;
        }
        if (g_treasure_items == chosen) {
            g_treasure_items = chosen->next;
        } else {
            for (p = g_treasure_items; p->next != chosen; p = p->next) {
            }
            p->next = chosen->next;
        }
        chosen->next = NULL;
        exec_free_mem(chosen, sizeof(CokItem));
        if (g_treasure_items == NULL) {
            done = 1;
        }
    } while (!done);
    menu_free(&s_treasure_menu);
    redraw_game_screen();
}

/*
 * PORT H070+$0F8A (Take): con monete e oggetti il menu "Money Items
 * Exit" (H e P cambiano personaggio) finche' resta tutto; solo monete
 * H067+$0F72, solo oggetti H070+$0E94.
 */
static void take_menu(u8 *money, u8 *items)
{
    u8 done = 0;                        /* -$2(a5) */
    u8 special;                         /* -$3(a5) */
    u8 key;                             /* -$1(a5) */

    if (!*money) {
        take_items();
        return;
    }
    if (!*items) {
        take_money_menu();
        redraw_game_screen();
        return;
    }
    do {
        key = ui_request_choice(6, "Take: ", 0x10, "Money Items Exit", 0x0D,
                                0x0A, 0x0F, 1, 1, &special);
        switch (key) {
        case 'M':
            take_money_menu();
            redraw_game_screen();
            break;
        case 'I':
            take_items();
            break;
        case 0:
        case 'E':
            done = 1;
            break;
        case 'H':
        case 'P':
            select_party_member(key);
            break;
        default:
            break;
        }
        draw_party(g_current_char);
        has_treasure(money, items);
        if (!*money || !*items) {
            done = 1;
        }
    } while (!done);
}

/*
 * PORT H070+$1136: schermata del tesoro: View, Take, Pool, Share, Detect
 * (se il corrente ha memorizzato un incantesimo di individuazione: 5, $B,
 * $4D, $67) ed Exit, che con tesoro rimasto chiede conferma.
 */
static void treasure_screen(void)
{
    char menu[0x52];                    /* -$56(a5) */
    char extra[0x10];                   /* -$76(a5) */
    u8 money = 0;                       /* -$1(a5) */
    u8 items = 0;                       /* -$2(a5) */
    u8 done = 0;                        /* -$58(a5) */
    u8 special;                         /* -$59(a5) */
    u8 key;                             /* -$57(a5) */
    u8 detect;                          /* -$65(a5) */
    u8 saved;                           /* -$77(a5) */
    u16 k;                              /* -$62(a5) */
    u16 spell = 0;                      /* -$64(a5) */
    u8 s;

    redraw_game_screen();
    do {
        money = 0;
        has_treasure(&money, &items);
        strcpy(menu, "View Pool Exit");
        strcpy(extra, " Exit");
        detect = 0;
        if (items) {
            for (k = 0; k <= 0x39 && !detect; ++k) {
                /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
                s = g_current_char->b[0x1E + k];
                if ((s == 5 || s == 0x0B || s == 0x4D || s == 0x67) &&
                    /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
                    g_current_char->b[0x198]) {
                    detect = 1;
                    spell = s;
                }
            }
        }
        if (detect) {
            strcpy(extra, " Detect Exit");
        }
        if (money) {
            strcpy(menu, "View Take Pool Share");
            h026_append(0x50, menu, 0x0F, extra);
        } else if (items) {
            strcpy(menu, "View Take Pool");
            h026_append(0x50, menu, 0x0F, extra);
        }
        key = ui_request_choice(2, "", 0x50, menu, 0x0D, 0x0A, 0x0F, 1, 1,
                                &special);
        if (special) {
            select_party_member(key);
            draw_party(g_current_char);
            continue;
        }
        saved = H005_B(0x2483); /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
        switch (key) {
        case 'V':
            view_character(&special);
            break;
        case 'T':
            take_menu(&money, &items);
            break;
        case 'P':
            if (!special) {
                pool_party_money();
            }
            break;
        case 'S':
            share_money();
            break;
        case 'D':
            cast_spell(spell, 0, 0, &special);
            break;
        case 0:
        case 'E':
            has_treasure(&money, &items);
            if (money || items) {
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x1F,
                               "There is still treasure left.  ");
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0F, 0, 0, 0x2F,
                               "Do you want to go back and claim your treasure?");
                strcpy(menu, "~Yes ~No");
                if (ecl_menu(2, "", 0x50, menu, 0x0D, 0x0A, 0x0F, 0, 0) == 1) {
                    done = 1;
                } else {
                    clear_text_cells(1, 0x11, 0x26, 0x16);
                }
            } else {
                done = 1;
            }
            break;
        default:
            break;
        }
        H005_B(0x2483) = saved; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
    } while (!done);
}

/*
 * PORT H070+$152E: a fine combattimento toglie dal party i nemici (+$15
 * del turno o lato 1), contando i caduti ($3E00+$590) e i fuggiti
 * ($3E00+$58E), e libera i blocchi del turno degli altri.
 */
static void remove_combatants(void)
{
    u8 first = 1;                       /* -$9(a5) */
    Character *p;                       /* -$4(a5) */
    Character *n;                       /* -$8(a5) */

    COK_PUT16(g_state_b + 0x590, 0); /* B+$590: (word) nemici caduti contati a fine combattimento */
    p = g_party_head;
    while (p != NULL) {
        /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro; pg+$199:
         * lato in combattimento (0 party, 1 avversari) */
        if (TURN(p)->b[0x15] == 1 || p->b[0x199] == 1) {
            s_enemies = 1;
            if (p->b[0x198] != 1) { /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
                COK_PUT16(g_state_b + 0x590, /* B+$590: (word) nemici caduti contati a fine combattimento */
                          COK_GET16(g_state_b + 0x590) + 1);
                if (first) {
                    /* A+$3F0: tab. word fasi cicli (idx CH+$5F, 1..3); voce 0 posta a 1 da H070 */
                    COK_PUT16(g_state_a + 0x3F0, 1);
                }
            }
            /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra; B+$58E:
             * (word) esito lotta: 1 qualcuno fuggito, $80 sconfitta, $81 fuga party */
            if (p->b[0x197] == 3 && COK_GET16(g_state_b + 0x58E) == 0) {
                /* B+$58E: (word) esito lotta: 1 qualcuno fuggito, $80 sconfitta, $81 fuga party */
                COK_PUT16(g_state_b + 0x58E, 1);
            }
            first = 0;
            n = p->next;
            g_current_char = p;
            /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
            remove_from_party((u8)(TURN(p)->b[0x15] == 1), 1);
            p = n;
        } else {
            if (p->block_192 != NULL) {
                exec_free_mem(p->block_192, sizeof(CokTurn));
                p->block_192 = NULL;
            }
            p = p->next;
        }
    }
    g_current_char = g_party_head;
}

/*
 * PORT H070+$165C: i personaggi non giocanti (+$EC > $7F, in piedi) con
 * una quota (+$ED & 7) prendono la loro parte di ogni tipo di moneta
 * ("takes and hides his/her share").
 */
static void npc_shares(void)
{
    char text[0x52];                    /* -$6E(a5) */
    Character *p;                       /* -$4(a5) */
    u16 shares = 0;                     /* -$6(a5) */
    u16 total = 0;                      /* -$8(a5) */
    u16 per;                            /* -$A(a5) */
    u16 row;                            /* -$C(a5) */
    u8 hidden = 0;                      /* -$19(a5) */
    u8 special;                         /* -$1A(a5) */
    u8 k;                               /* -$D(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        /* pg+$EC: controllo: <$80 PG, >$7F PNG/IA ($B3 = charme o confuso); pg+$197: stato: 0 ok, 4
         * incosciente, 5 morente, 6-8 morto, $0A a terra */
        if (p->b[0xEC] > 0x7F && p->b[0x197] == 0) {
            /* pg+$ED: quota del PNG nella spartizione (bit 0-2); 1 dopo Modify */
            shares = (u16)(shares + mask_byte(p->b[0xED], 7));
            /* pg+$ED: quota del PNG nella spartizione (bit 0-2); 1 dopo Modify */
            total = (u16)(total + mask_byte(p->b[0xED], 7));
        } else {
            ++total;
        }
    }
    if (shares > 0) {
        for (k = 0; k <= 6; ++k) {
            if ((s32)POOL(k) > 0) { /* $2A1E: cassa del party: 7 long, monete per tipo 0..6 (4 = acciaio) */
                /* $2A1E: cassa del party: 7 long, monete per tipo 0..6 (4 = acciaio) */
                per = (u16)h015_divs32((s32)POOL(k), (s32)total, NULL);
                /* $2A1E: cassa del party: 7 long, monete per tipo 0..6 (4 = acciaio); $2A20: word
                 * bassa del long della cassa per il tipo di moneta 0 */
                SET_POOL(k, POOL(k) - (u32)shares * per);
                hidden = 1;
            }
        }
    }
    if (!hidden) {
        return;
    }
    draw_screen_frame(1);
    row = 0;
    for (p = g_party_head; p != NULL; p = p->next) {
        /* pg+$EC: controllo: <$80 PG, >$7F PNG/IA ($B3 = charme o confuso); pg+$197: stato: 0 ok, 4
         * incosciente, 5 morente, 6-8 morto, $0A a terra; pg+$ED: quota del PNG nella spartizione
         * (bit 0-2); 1 dopo Modify */
        if (p->b[0xEC] > 0x7F && p->b[0x197] == 0 && p->b[0xED] > 0) {
            h026_copy(0x50, text, 0x0F, (const char *)p->b);
            if (!p->b[0x10E]) { /* pg+$10E: sesso (0 maschio, 1 femmina; nomi H005+$4BD2) */
                h026_append(0x50, text, 0x1B, " takes and hides his share.");
            } else {
                h026_append(0x50, text, 0x1B, " takes and hides her share.");
            }
            word_wrap_text(5, (u16)(row + 5), 0x22, 0x16, 0x0A, 0, 1, 0x50,
                           text);
            row = (u16)(row + 2);
        }
    }
    (void)ui_request_choice(0, "", 0x22, "press <enter>/<return> to continue",
                            0x0F, 0x0F, 0x0F, 1, 0, &special);
}

/*
 * PORT H070+$18BE: gli oggetti lasciati cadere in combattimento ($3360)
 * tornano a chi li aveva (H071+$047C).
 */
static void return_dropped_items(void)
{
    CokDropped *d;                      /* -$C(a5) */
    CokDropped *n;                      /* -$10(a5) */
    CokItem *copy;                      /* -$4(a5) */
    u8 fail;                            /* -$11(a5) */

    d = g_dropped_items;
    while (d != NULL) {
        copy = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
        g_current_char = d->owner;
        memcpy(copy->b, d->b, 0x48);
        copy->next = NULL;
        take_item(copy, &fail);
        exec_free_mem(copy, sizeof(CokItem));
        n = d;
        d = d->next;
        exec_free_mem(n, sizeof(CokDropped));
    }
    g_dropped_items = NULL;
}

/*
 * PORT H070+$1958: fine del combattimento: oggetti caduti, esito, nemici
 * tolti, valori ricalcolati; se il party c'e' ancora quote dei PNG,
 * esito, tesoro e cassa; altrimenti "The monsters rejoice for the party
 * has been destroyed.".  Nella dimostrazione ($24D7) esce subito.
 */
void combat_end(void)
{
    Character *p;                       /* -$C(a5) */

    return_dropped_items();
    /* B+$58E: (word) esito lotta: 1 qualcuno fuggito, $80 sconfitta, $81 fuga party */
    COK_PUT16(g_state_b + 0x58E, 0);
    s_enemies = 0;
    if (!H005_B(0x24D7)) { /* $24D7: 1 se e' stata scelta la dimostrazione (Demo) */
        combat_outcome();
    }
    H005_B(0x3DE3) = 6; /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    remove_combatants();
    if (H005_B(0x24D7)) { /* $24D7: 1 se e' stata scelta la dimostrazione (Demo) */
        return;
    }
    for (p = g_party_head; p != NULL; p = p->next) {
        recompute_stats(p);
    }
    /* $24D0: 1 party perduto o uscito: ferma ECL e ciclo dell'esplorazione; $24C1: uso: azzerato
     * all'avvio; con 1 esito e caduti trattati diversamente */
    if (!H005_B(0x24D0) || H005_B(0x24C1)) {
        if (s_fled) {
            free_treasure();
        }
        if (!H005_B(0x24D7)) { /* $24D7: 1 se e' stata scelta la dimostrazione (Demo) */
            npc_shares();
            show_outcome(H005_L(0x236E)); /* $236E: esperienza guadagnata nel combattimento (long) */
            treasure_screen();
        }
        free_treasure();
    } else {
        /* B+$58E: (word) esito lotta: 1 qualcuno fuggito, $80 sconfitta, $81 fuga party */
        COK_PUT16(g_state_b + 0x58E, 0x80);
        draw_screen_frame(1);
        H005_SET_W(0x334E, 2); /* $334E: (word) cursore del testo: colonna */
        H005_SET_W(0x334C, 6); /* $334C: (word) cursore del testo: riga */
        word_wrap_text(2, 5, 0x25, 0x16, 0x0A, 0, 1, 0x36,
                       "The monsters rejoice for the party has been destroyed.");
        show_message_wait(0x0D, 0, 0x19, "Press any key to continue");
    }
    H005_B(0x24CE) = 1; /* $24CE: 1: pausa per carattere nella scrittura del testo */
    COK_PUT16(g_state_b + 0x6E0, 0); /* B+$6E0: (word) bonus al tiro per colpire dei nemici (lato 1) */
    COK_PUT16(g_state_b + 0x6E2, 0); /* B+$6E2: (word) bonus al tiro per colpire del party (lato 0) */
    COK_PUT16(g_state_b + 0x6E4, 0); /* B+$6E4: (word) bonus al movimento del party in combattimento */
    COK_PUT16(g_state_b + 0x5C6, 0); /* B+$5C6: (word) 1: oggetti dei nemici non vanno nel tesoro */
    COK_PUT16(g_state_b + 0x5CC, 0); /* B+$5CC: (word) sconfitta non fatale: i caduti si rialzano a 1 PF */
    COK_PUT16(g_state_a + 0x3EA, 0); /* A+$3EA: (word) esito e' un prelievo in banca: niente esperienza */
}
