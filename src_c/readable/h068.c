/* H068: Esplorazione, scelte di movimento, porte e azioni del party. */
#include "cok.h"
#include "h068.h"
#include "globals.h"
#include "unported.h"
#include "h008.h"
#include "h011.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h036.h"
#include "h042_seq.h"
#include "h057.h"
#include "h058.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include "h069.h"
#include "h073.h"

#define DX(d) ((s16)H005_W(0x3EE2 + (d) * 2)) /* $3EE2: (word) spostamento x per direzione d (passo 2) */
#define DY(d) ((s16)H005_W(0x3ED0 + (d) * 2)) /* $3ED0: (word) spostamento y per direzione d (passo 2) */
#define POS_X ((s16)H005_W(0x281C)) /* $281C: (word) x del party sulla mappa dell'area 16x16 */
#define POS_Y ((s16)H005_W(0x281E)) /* $281E: (word) y del party sulla mappa dell'area 16x16 */
#define POS_DIR H005_B(0x2820) /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */

/* PORT H068+$00A4: link/unlk, nessun effetto. */
void h068_init(void)
{
}

/*
 * PORT H068+$00B2: chiamato quando la porta chiusa non offre azioni
 * (solo " Exit"); nell'originale il corpo e' vuoto.
 */
static void locked_no_action(s16 x, s16 y, u8 dir)
{
    (void)x;
    (void)y;
    (void)dir;
}

/*
 * PORT H068+$00CA: apre la porta del lato dir della casella (x, y): la
 * coppia di bit del lato nel piano GEO 3 diventa 1.
 */
static void open_door(s16 x, s16 y, u8 dir)
{
    u8 *b;

    if (x < 0 || x > 0x0F || y < 0 || y > 0x0F) {
        return;
    }
    b = &g_geo_planes[0x300 + y * 16 + x];
    switch (dir) {
    case 0: *b = or_byte(mask_byte(*b, 0xFC), 0x01); break;
    case 2: *b = or_byte(mask_byte(*b, 0xF3), 0x04); break;
    case 4: *b = or_byte(mask_byte(*b, 0xCF), 0x10); break;
    case 6: *b = or_byte(mask_byte(*b, 0x3F), 0x40); break;
    default: break;
    }
}

/* Apre la porta davanti al party da entrambi i lati. */
static void open_door_ahead(void)
{
    /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party sulla mappa
     * dell'area 16x16; $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    open_door(POS_X, POS_Y, POS_DIR);
    /* $281C: (word) x del party sulla mappa dell'area 16x16; $3EE2: (word) spostamento x per
     * direzione d (passo 2); $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest); $281E:
     * (word) y del party sulla mappa dell'area 16x16; $3ED0: (word) spostamento y per direzione d
     * (passo 2) */
    open_door((s16)(POS_X + DX(POS_DIR)), (s16)(POS_Y + DY(POS_DIR)),
              (u8)((POS_DIR + 4) & 7)); /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
}

/*
 * PORT H068+$02B8: qualcuno nel party ha livelli nella classe cls (+$FE)
 * o, dalla classe precedente (+$106), la puo' usare (H073+$130A)?
 */
static u8 party_has_class(u8 cls)
{
    u8 found = 0;                       /* -$5(a5) */
    Character *p;                       /* -$4(a5) */

    for (p = g_party_head; p != NULL && !found; p = p->next) {
        /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico */
        if (p->b[0xFE + cls] > 0) {
            found = 1;
        /* pg+$106: livelli della classe precedente, 8 voci come +$FE; chierico */
        } else if (p->b[0x106 + cls] > 0 && h073_130a(p)) {
            found = 1;
        }
    }
    return found;
}

/*
 * PORT H068+$0340 (Bash): ogni personaggio prova a sfondare la porta
 * secondo la forza (+$11, eccezionale +$1C); le porte di tipo 3 solo con
 * forza 18 e oltre, altrimenti l'opzione sparisce ($24E4).
 */
static u8 bash_door(void)
{
    u8 ok = 0;                          /* -$5(a5) */
    Character *p;                       /* -$4(a5) */

    for (p = g_party_head; p != NULL && !ok; p = p->next) {
        /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party sulla
         * mappa dell'area 16x16; $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        if (map_door(POS_X, POS_Y, POS_DIR) == 3) {
            /* pg+$11: caratteristiche correnti, 6 voci passo 2 da +$11; forza corrente */
            switch (p->b[0x11]) {
            case 0x12:
                if (p->b[0x1C] < 0x5B) { /* pg+$1C: forza eccezionale corrente (18/xx, 1..100) */
                    H005_B(0x24E4) = 0; /* $24E4: opzione Bash disponibile davanti alla porta chiusa */
                } else if (p->b[0x1C] < 0x64) { /* pg+$1C: forza eccezionale corrente (18/xx, 1..100) */
                    if (roll_dice(1, 6) == 1) ok = 1;
                } else {
                    if (roll_dice(1, 6) <= 2) ok = 1;
                }
                break;
            case 0x13: case 0x14:
                if (roll_dice(1, 6) <= 3) ok = 1;
                break;
            case 0x15: case 0x16:
                if (roll_dice(1, 6) <= 4) ok = 1;
                break;
            case 0x17:
                if (roll_dice(1, 6) <= 5) ok = 1;
                break;
            case 0x18:
                if (roll_dice(1, 8) <= 7) ok = 1;
                break;
            case 0x19:
                ok = 1;
                break;
            default:
                H005_B(0x24E4) = 0; /* $24E4: opzione Bash disponibile davanti alla porta chiusa */
                break;
            }
        } else {
            /* pg+$11: caratteristiche correnti, 6 voci passo 2 da +$11; forza corrente */
            switch (p->b[0x11]) {
            case 3: case 4: case 5: case 6: case 7:
                if (roll_dice(1, 6) == 1) ok = 1;
                break;
            case 8: case 9: case 0x0A: case 0x0B: case 0x0C: case 0x0D:
            case 0x0E: case 0x0F:
                if (roll_dice(1, 6) <= 2) ok = 1;
                break;
            case 0x10: case 0x11:
                if (roll_dice(1, 6) <= 3) ok = 1;
                break;
            case 0x12:
                if (p->b[0x1C] < 0x33) { /* pg+$1C: forza eccezionale corrente (18/xx, 1..100) */
                    if (roll_dice(1, 6) <= 3) ok = 1;
                } else if (p->b[0x1C] < 0x64) { /* pg+$1C: forza eccezionale corrente (18/xx, 1..100) */
                    if (roll_dice(1, 6) <= 4) ok = 1;
                } else {
                    if (roll_dice(1, 6) <= 5) ok = 1;
                }
                break;
            case 0x13: case 0x14:
                if (roll_dice(1, 8) <= 7) ok = 1;
                break;
            case 0x15:
                if (roll_dice(1, 0x0A) <= 9) ok = 1;
                break;
            case 0x16: case 0x17:
                if (roll_dice(1, 0x0C) <= 0x0B) ok = 1;
                break;
            case 0x18:
                if (roll_dice(1, 0x14) <= 0x13) ok = 1;
                break;
            case 0x19:
                ok = 1;
                break;
            default:
                break;
            }
        }
    }
    if (ok) {
        open_door_ahead();
    }
    return ok;
}

/*
 * PORT H068+$0748 (Pick): riesce chi tira 1d100 <= +$E1 (scassinare) e
 * non ha +$197; l'opzione comunque sparisce ($24E5).
 */
static u8 pick_lock(void)
{
    u8 ok = 0;                          /* -$5(a5) */
    Character *p;                       /* -$4(a5) */

    for (p = g_party_head; p != NULL && !ok; p = p->next) {
        /* pg+$E1: abilita' da ladro 2: scassinare (Pick, 1d100 <= valore); pg+$197: stato: 0 ok, 4
         * incosciente, 5 morente, 6-8 morto, $0A a terra */
        if (roll_dice(1, 0x64) <= p->b[0xE1] && !p->b[0x197]) {
            ok = 1;
        }
    }
    H005_B(0x24E5) = 0; /* $24E5: opzione Pick disponibile davanti alla porta chiusa */
    if (ok) {
        open_door_ahead();
    }
    return ok;
}

/* PORT H068+$082A: posizione dell'incantesimo s fra i memorizzati di c, $FF se manca. */
static u8 memorized_spell_index(u8 spell, Character *c)
{
    u16 k = 0;                          /* -$2(a5) */

    /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
    while (k <= 0x39 && c->b[0x1E + k] != spell) {
        ++k;
    }
    if (k <= 0x39) {
        return (u8)k;
    }
    return 0xFF;
}

/* PORT H068+$0890: il primo personaggio che ha memorizzato l'incantesimo. */
static Character *who_has_spell(u8 spell)
{
    Character *p;                       /* -$4(a5) */

    p = g_party_head;
    while (p != NULL && memorized_spell_index(spell, p) == 0xFF) {
        p = p->next;
    }
    return p;
}

/*
 * PORT H068+$08E2 (Knock): consuma l'incantesimo $1F del primo che l'ha
 * memorizzato.  Nell'originale la porta non viene aperta qui.
 */
static u8 cast_knock(void)
{
    Character *p;                       /* -$4(a5) */

    p = who_has_spell(0x1F);
    if (p != NULL) {
        /* pg+$1E: incantesimi memorizzati, $3A byte (+$1E..+$57); bit 7 = da memorizzare */
        p->b[0x1E + memorized_spell_index(0x1F, p)] = 0;
        return 1;
    }
    return 0;
}

/*
 * PORT H068+$0932: se davanti non c'e' parete e il passo uscirebbe dalla
 * mappa 16x16, la posizione viene bloccata al bordo e $3E00+$5AA = 1
 * (uscita dall'area).
 */
static void check_area_edge(void)
{
    /* $281C: (word) x del party sulla mappa dell'area 16x16 */
    s16 x = POS_X;                      /* -$2(a5) */
    /* $281E: (word) y del party sulla mappa dell'area 16x16 */
    s16 y = POS_Y;                      /* -$4(a5) */
    /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    u16 dir = POS_DIR;                  /* -$6(a5) */

    /* B+$5AA: (word) 1 se il passo esce dalla mappa 16x16 (uscita dall'area) */
    COK_PUT16(g_state_b + 0x5AA, 0);
    if (map_door(x, y, dir) == 0) {
        return;
    }
    x = (s16)(x + DX(dir)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
    y = (s16)(y + DY(dir)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    if (x > 0x0F) {
        H005_SET_W(0x281C, 0x0F); /* $281C: (word) x del party sulla mappa dell'area 16x16 */
        /* B+$5AA: (word) 1 se il passo esce dalla mappa 16x16 (uscita dall'area) */
        COK_PUT16(g_state_b + 0x5AA, 1);
    }
    if (x < 0) {
        H005_SET_W(0x281C, 0); /* $281C: (word) x del party sulla mappa dell'area 16x16 */
        /* B+$5AA: (word) 1 se il passo esce dalla mappa 16x16 (uscita dall'area) */
        COK_PUT16(g_state_b + 0x5AA, 1);
    }
    if (y > 0x0F) {
        H005_SET_W(0x281E, 0x0F); /* $281E: (word) y del party sulla mappa dell'area 16x16 */
        /* B+$5AA: (word) 1 se il passo esce dalla mappa 16x16 (uscita dall'area) */
        COK_PUT16(g_state_b + 0x5AA, 1);
    }
    if (y < 0) {
        H005_SET_W(0x281E, 0); /* $281E: (word) y del party sulla mappa dell'area 16x16 */
        /* B+$5AA: (word) 1 se il passo esce dalla mappa 16x16 (uscita dall'area) */
        COK_PUT16(g_state_b + 0x5AA, 1);
    }
}

/*
 * PORT H068+$0A1A: un passo avanti nel dungeon (la mappa si avvolge),
 * parete e flag della nuova casella, opzioni delle porte ripristinate e
 * un turno (o 2 se si cerca).
 */
static void explore_step(void)
{
    s16 x;
    s16 y;

    h043_190e(0x11);
    dos_delay(2);
    /* $281C: (word) x del party sulla mappa dell'area 16x16; $3EE2: (word) spostamento x per
     * direzione d (passo 2); $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    x = (s16)(POS_X + DX(POS_DIR));
    /* $281E: (word) y del party sulla mappa dell'area 16x16; $3ED0: (word) spostamento y per
     * direzione d (passo 2); $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    y = (s16)(POS_Y + DY(POS_DIR));
    if (x < 0) x = 0x0F;
    if (x > 0x0F) x = 0;
    if (y < 0) y = 0x0F;
    if (y > 0x0F) y = 0;
    H005_SET_W(0x281C, (u16)x); /* $281C: (word) x del party sulla mappa dell'area 16x16 */
    H005_SET_W(0x281E, (u16)y); /* $281E: (word) y del party sulla mappa dell'area 16x16 */
    /* $2821: muro davanti al party (map_wall sulla casella e direzione); $2820: direzione del party
     * (0 nord, 2 est, 4 sud, 6 ovest) */
    H005_B(0x2821) = (u8)map_wall(x, y, POS_DIR);
    h029_fill_bytes(2, &H005_B(0x24E4), 3, 1); /* $24E4: opzione Bash disponibile davanti alla porta chiusa */
    /* $2822: flag della casella del party (map_flags); bit 7 sceglie il cielo */
    H005_B(0x2822) = map_flags(x, y);
    /* B+$594: (word) bit 0 modo search, bit 1 Look in corso */
    if (mask_byte((u8)COK_GET16(g_state_b + 0x594), 1) > 0) {
        advance_time(1, 2);
    } else {
        advance_time(1, 1);
    }
}

/*
 * PORT H068+$0B2C: un passo sulla mappa all'aperto (38x15 caselle, senza
 * avvolgimento): ripristina lo sfondo sotto il segno del party, sposta e
 * ridisegna il segno, poi advance_time($C, 3).
 */
static void wild_step(void)
{
    s16 x;                              /* -$4(a5) */
    s16 y;                              /* -$6(a5) */

    h069_restore_marker();
    /* A+$186: (word) x del party sulla mappa all'aperto (38x15); A+$1E0: (word) x del party prima
     * del passo (per rilevare lo spostamento) */
    COK_PUT16(g_state_a + 0x1E0, COK_GET16(g_state_a + 0x186));
    /* A+$188: (word) y del party sulla mappa all'aperto (38x15); A+$1E2: (word) y del party prima
     * del passo (per rilevare lo spostamento) */
    COK_PUT16(g_state_a + 0x1E2, COK_GET16(g_state_a + 0x188));
    /* A+$186: (word) x del party sulla mappa all'aperto (38x15); $3EE2: (word) spostamento x per
     * direzione d (passo 2); $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    x = (s16)((s16)COK_GET16(g_state_a + 0x186) + DX(POS_DIR));
    /* A+$188: (word) y del party sulla mappa all'aperto (38x15); $3ED0: (word) spostamento y per
     * direzione d (passo 2); $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    y = (s16)((s16)COK_GET16(g_state_a + 0x188) + DY(POS_DIR));
    if (x < 0) x = 0;
    if (x > 0x25) x = 0x25;
    if (y < 0) y = 0;
    if (y > 0x0E) y = 0x0E;
    COK_PUT16(g_state_a + 0x186, (u16)x); /* A+$186: (word) x del party sulla mappa all'aperto (38x15) */
    COK_PUT16(g_state_a + 0x188, (u16)y); /* A+$188: (word) y del party sulla mappa all'aperto (38x15) */
    h069_draw_marker();
    advance_time(0x0C, 3);
}

/* Voci del menu nel dungeon (H068+$0C2E). */
static void dungeon_menu(u8 *key, u8 *done, u8 *special)
{
    u8 redraw;                          /* -$2(a5) */
    Character *c;

    *done = 0;
    *key = 0;
    if (!H005_B(0x24B0)) { /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
        *key = ui_request_choice(0, "", 0x26,
                                 "Move Area Cast View Encamp Search Look",
                                 0x0D, 0x0A, 0x0F, 1, 0, special);
        if (*special) {
            select_party_member(*key);
            draw_party(g_current_char);
            draw_status_line();
            return;
        }
        switch (*key) {
        case 'A':
            /* A+$1F6: (word) area senza mappa: coordinate nascoste, mappa "Not Here" */
            if (COK_GET16(g_state_a + 0x1F6) == 0 ||
                (g_argc > 2 &&
                 h026_compare_nocase(0xFF, g_argv[2], 0x14,
                                     /* $2358: parola d'ordine dei trucchi (stringa confrontata con
                                      * argv[2]) */
                                     (const char *)&g_h005[0x2358]) == 1)) {
                /* $2825: flag mappa dall'alto attiva al posto della vista 3D */
                H005_B(0x2825) = (u8)(H005_B(0x2825) == 0);
                /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party
                 * sulla mappa dell'area 16x16; $2820: direzione del party (0 nord, 2 est, 4 sud, 6
                 * ovest) */
                draw_3d_view(POS_X, POS_Y, POS_DIR);
            } else {
                show_message(8, "Not Here", 0x0E, 0);
            }
            break;
        case 'C':
            c = g_current_char;
            if (!c->b[0x197]) { /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
                H005_B(0x2483) = 1; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                cast_spells();
            }
            break;
        case 'E':
            *done = 1;
            H005_B(0x2483) = 1; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
            break;
        case 'L':
            COK_PUT16(g_state_b + 0x594, /* B+$594: (word) bit 0 modo search, bit 1 Look in corso */
                      or_byte((u8)COK_GET16(g_state_b + 0x594), 2));
            draw_status_line();
            advance_time(1, 2);
            /* $3DF2: (word) ingresso ECL dopo $3DF4; PC riportato qui dal passo all'aperto; $3DEA:
             * (word) PC logico del programma ECL (base $3500) */
            H005_SET_W(0x3DEA, H005_W(0x3DF2));
            *done = 1;
            break;
        case 'M':
            clear_message_line();
            H005_B(0x24B0) = 1; /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
            break;
        case 'S':
            COK_PUT16(g_state_b + 0x594, /* B+$594: (word) bit 0 modo search, bit 1 Look in corso */
                      xor_byte((u8)COK_GET16(g_state_b + 0x594), 1));
            draw_status_line();
            break;
        case 'V':
            H005_B(0x2483) = 1; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
            view_character(&redraw);
            break;
        default:
            break;
        }
        return;
    }
    *key = ui_request_choice(0, "", 4, "Exit", 0x0D, 0x0A, 0x0F, 1, 0,
                             special);
    if (!*special) {
        if (*key == 'E') {
            H005_B(0x24B0) = 0; /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
        }
        return;
    }
    switch (*key) {
    case 0x48:                          /* freccia su */
        check_area_edge();
        *done = 1;
        draw_status_line();
        *key = 0;
        break;
    case 0x50:                          /* freccia giu': dietro-front */
        POS_DIR = (u8)((POS_DIR + 4) & 7); /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        /* $2821: muro davanti al party (map_wall sulla casella e direzione); $281C: (word) x del
         * party sulla mappa dell'area 16x16; $281E: (word) y del party sulla mappa dell'area 16x16;
         * $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        H005_B(0x2821) = (u8)map_wall(POS_X, POS_Y, POS_DIR);
        /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party sulla
         * mappa dell'area 16x16; $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        draw_3d_view(POS_X, POS_Y, POS_DIR);
        draw_status_line();
        *key = 0;
        break;
    case 0x4B:                          /* freccia sinistra */
        POS_DIR = (u8)((POS_DIR + 6) & 7); /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        h043_190e(0x11);
        /* $2821: muro davanti al party (map_wall sulla casella e direzione); $281C: (word) x del
         * party sulla mappa dell'area 16x16; $281E: (word) y del party sulla mappa dell'area 16x16;
         * $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        H005_B(0x2821) = (u8)map_wall(POS_X, POS_Y, POS_DIR);
        /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party sulla
         * mappa dell'area 16x16; $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        draw_3d_view(POS_X, POS_Y, POS_DIR);
        draw_status_line();
        *key = 0;
        break;
    case 0x4D:                          /* freccia destra */
        POS_DIR = (u8)((POS_DIR + 2) & 7); /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        h043_190e(0x11);
        /* $2821: muro davanti al party (map_wall sulla casella e direzione); $281C: (word) x del
         * party sulla mappa dell'area 16x16; $281E: (word) y del party sulla mappa dell'area 16x16;
         * $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        H005_B(0x2821) = (u8)map_wall(POS_X, POS_Y, POS_DIR);
        /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party sulla
         * mappa dell'area 16x16; $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        draw_3d_view(POS_X, POS_Y, POS_DIR);
        draw_status_line();
        *key = 0;
        break;
    default:
        break;
    }
}

/* Voci del menu all'aperto (H068+$1036); restituisce 0 se non c'e' menu. */
static u8 wild_menu(u8 *key, u8 *done, u8 *special)
{
    if (COK_GET16(g_state_a + 0x3EE) == 0) { /* A+$3EE: (word) se nullo niente menu dei comandi all'aperto */
        return 0;
    }
    *done = 0;
    if (!H005_B(0x24B0)) { /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
        *key = ui_request_choice(0, "", 0x0B, "Move Encamp", 0x0D, 0x0A,
                                 0x0F, 1, 0, special);
        if (!*special) {
            if (*key == 'E') {
                *done = 1;
                H005_B(0x2483) = 1; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
            } else if (*key == 'M') {
                clear_message_line();
                H005_B(0x24B0) = 1; /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
            }
        }
        return 1;
    }
    *key = 0;
    if (*key == 0) {
        *key = ui_request_choice(0, "", 4, "Exit", 0x0D, 0x0A, 0x0F, 1, 0,
                                 special);
    }
    if (!*special) {
        if (*key == 'E') {
            H005_B(0x24B0) = 0; /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
        }
        return 1;
    }
    *done = 1;
    switch (*key) {                     /* tastierino: 8 direzioni */
    case 0x48: POS_DIR = 0; break; /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    case 0x49: POS_DIR = 1; break; /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    case 0x4D: POS_DIR = 2; break; /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    case 0x51: POS_DIR = 3; break; /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    case 0x50: POS_DIR = 4; break; /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    case 0x4F: POS_DIR = 5; break; /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    case 0x4B: POS_DIR = 6; break; /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    case 0x47: POS_DIR = 7; break; /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    default: break;
    }
    draw_status_line();
    return 1;
}

/*
 * PORT H068+$0C0E (Exploration_CommandMenu): il menu dei comandi
 * dell'esplorazione, nel dungeon (contesto 4) o all'aperto (3), ripetuto
 * finche' un comando non conclude il turno; restituisce il tasto.
 * All'aperto senza menu ($3E04+$3EE nullo) l'originale restituisce un
 * byte non inizializzato: qui 0.
 */
u8 explore_command_menu(void)
{
    u8 key = 0;                         /* -$1(a5) */
    u8 done = 0;                        /* -$3(a5) */
    u8 special = 0;                     /* -$4(a5) */

    /* B+$592: uso: se >= $FF il passo dell'esplorazione e' annullato (poi 0) */
    COK_PUT16(g_state_b + 0x592, 0);
    switch (H005_B(0x3DE3)) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    case 3:
        do {
            if (!wild_menu(&key, &done, &special)) {
                break;
            }
        } while (!done);
        break;
    case 4:
        do {
            dungeon_menu(&key, &done, &special);
        } while (!done);
        break;
    default:
        break;
    }
    if (!H005_B(0x24B9)) { /* $24B9: 0 dopo testo ECL; il menu comandi pulisce righe $11..$16 e mette 1 */
        clear_text_cells(1, 0x11, 0x26, 0x16);
        H005_B(0x24B9) = 1; /* $24B9: 0 dopo testo ECL; il menu comandi pulisce righe $11..$16 e mette 1 */
    }
    return key;
}

/*
 * Porta chiusa davanti (H068+$128C per il tipo 2, $1428 per il tipo 3):
 * "Locked." con Bash, Pick (un ladro), Knock (incantesimo $1F) ed Exit.
 * Per il tipo 3 Pick toglie solo l'opzione.
 */
static u8 locked_door_menu(u8 wizard)
{
    char text[0x29];                    /* -$2C(a5) */
    u8 special;                         /* -$2(a5) */
    u8 choice;                          /* -$2D(a5) */
    u8 moved = 0;

    text[0] = '\0';
    if (H005_B(0x24E4)) { /* $24E4: opzione Bash disponibile davanti alla porta chiusa */
        strcpy(text, "Bash");
    }
    /* $24E5: opzione Pick disponibile davanti alla porta chiusa */
    if (H005_B(0x24E5) && party_has_class(6)) {
        h026_append(0x28, text, 5, " Pick");
    }
    /* $24E6: opzione Knock disponibile davanti alla porta chiusa */
    if (H005_B(0x24E6) && who_has_spell(0x1F) != NULL) {
        h026_append(0x28, text, 6, " Knock");
    }
    h026_append(0x28, text, 5, " Exit");
    if (h026_compare_nocase(0x28, text, 5, " Exit") == 1) {
        /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party sulla
         * mappa dell'area 16x16; $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        locked_no_action(POS_X, POS_Y, POS_DIR);
        return 0;
    }
    choice = ui_request_choice(8, "Locked. ", 0x28, text, 0x0D, 0x0A, 0x0F,
                               0, 0, &special);
    switch (choice) {
    case 'B':
        moved = bash_door();
        break;
    case 'K':
        moved = cast_knock();
        break;
    case 'P':
        if (wizard) {
            H005_B(0x24E5) = 0; /* $24E5: opzione Pick disponibile davanti alla porta chiusa */
        } else {
            moved = pick_lock();
        }
        break;
    default:
        break;
    }
    return moved;
}

/*
 * PORT H068+$122E (Exploration_MoveOrDoor): esegue il passo scelto: nel
 * dungeon secondo la porta davanti (1 passaggio libero, 2 e 3 chiusa),
 * all'aperto sulla mappa grande; con $3E00+$592 >= $FF il passo e'
 * annullato.  Poi libera le immagini dell'evento.
 */
void explore_move_or_door(void)
{
    u8 moved = 0;                       /* -$1(a5) */

    switch (H005_B(0x3DE3)) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    case 3:
        /* B+$592: uso: se >= $FF il passo dell'esplorazione e' annullato (poi 0) */
        if (COK_GET16(g_state_b + 0x592) < 0xFF) {
            wild_step();
            draw_status_line();
        } else {
            /* B+$592: uso: se >= $FF il passo dell'esplorazione e' annullato (poi 0) */
            COK_PUT16(g_state_b + 0x592, 0);
        }
        break;
    case 4:
        /* B+$592: uso: se >= $FF il passo dell'esplorazione e' annullato (poi 0) */
        if (COK_GET16(g_state_b + 0x592) < 0xFF) {
            H005_B(0x24E1) = 1; /* $24E1: 1: immagine/vista dell'esplorazione da ridisegnare */
            /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party
             * sulla mappa dell'area 16x16; $2820: direzione del party (0 nord, 2 est, 4 sud, 6
             * ovest) */
            switch (map_door(POS_X, POS_Y, POS_DIR)) {
            case 1: moved = 1; break;
            case 2: moved = locked_door_menu(0); break;
            case 3: moved = locked_door_menu(1); break;
            default: break;
            }
            if (moved) {
                explore_step();
            }
            draw_status_line();
        } else {
            /* B+$592: uso: se >= $FF il passo dell'esplorazione e' annullato (poi 0) */
            COK_PUT16(g_state_b + 0x592, 0);
        }
        break;
    default:
        break;
    }
    release_picture_set();
    free_gfx_record(&g_gfx_27b0[0]);
    free_gfx_record(&g_gfx_27b0[1]);
    H005_B(0x27B0) = 0xFF; /* $27B0: 2 voci da 6 byte (id + long gfx a +2): id HEAD caricato, $FF nessuno */
    H005_B(0x27B6) = 0xFF; /* $27B6: id del BODY caricato (2a voce da 6 byte di $27B0), $FF nessuno */
}
