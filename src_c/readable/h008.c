/* H008: Interazioni UI, richieste di scelta e menu. */
#include "h008.h"
#include "h030.h"
#include "h010_input.h"
#include "h021_intuition.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h003_exec.h"
#include "globals.h"
#include "character.h"
#include "unported.h"
#include "h046.h"
#include "h042_seq.h"
#include "h077.h"
#include "h048.h"

/* PORT H008+$009A: link/unlk, nessun effetto. */
void h008_init(void)
{
}

/* PORT H008+$139E: cancella (penna 0) l'ultima riga di testo, la 24. */
void clear_message_line(void)
{
    fill_text_cells(0, 0x18, 0, 0x28);
}

/* PORT H008+$01A0: 1 per le lettere maiuscole e le cifre. */
static u8 is_hotkey_char(u8 c)
{
    return (u8)((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'));
}

/*
 * Variabili locali di UI_RequestChoice (frame di H008+$01FC) usate anche
 * dalle sotto-procedure annidate $020A e $03C8, che nell'originale le
 * raggiungono attraverso il frame del chiamante.
 */
typedef struct ChoiceFrame {
    /* argomenti */
    const char *options;        /* $1A(a5) */
    u16 title_pen;              /* $18(a5) */
    u16 normal_pen;             /* $16(a5) */
    u16 highlight_pen;          /* $14(a5) */
    u8 digits_map;              /* $12(a5) */
    u8 animate;                 /* $10(a5) */
    u8 *special;                /* $C(a5) */
    /* locali */
    struct { u16 start; u16 end; } item[20];    /* -$C4: inizio/fine */
    u16 count;                  /* -$74: numero di opzioni */
    u16 title_len;              /* -$72: lunghezza del titolo */
    u16 options_len;            /* -$70: lunghezza delle opzioni */
    u8 key;                     /* -$5E */
    u8 done;                    /* -$C5 */
    u8 result;                  /* -$5F */
    s16 col;                    /* -$68 */
    s16 row;                    /* -$6A */
} ChoiceFrame;

/*
 * PORT H008+$020A: divide le opzioni in voci: ogni voce comincia con una
 * maiuscola o una cifra e finisce due caratteri prima della successiva
 * (lo spazio separatore escluso); l'ultima finisce alla fine della
 * stringa.  Le voci non usate valgono 0..0.
 */
static void parse_options(ChoiceFrame *f, u16 len, const char *options)
{
    u16 i;
    u16 j;
    u16 n = 1;                          /* -$2 */
    u16 length;                         /* -$8 */

    for (i = 1; i <= 0x14; ++i) {
        for (j = 0; j <= 1; ++j) {
            if (j == 0) {
                f->item[i - 1].start = 0x3E7;
            } else {
                f->item[i - 1].end = 0x3E7;
            }
        }
    }
    length = h026_strlen(len, options);
    for (i = 0; i <= length; ++i) {
        if (is_hotkey_char((u8)options[i])) {
            if (f->item[n - 1].start == 0x3E7) {
                f->item[n - 1].start = i;
            } else {
                f->item[n - 1].end = (u16)(i - 2);
                ++n;
                f->item[n - 1].start = i;
            }
        }
        if (i == 0xFFFF) {
            break;
        }
    }
    f->item[n - 1].end = (u16)(length - 1);
    for (i = 1; i <= 0x14; ++i) {
        if (f->item[i - 1].start == 0x3E7) {
            f->item[i - 1].start = 0;
        }
        if (f->item[i - 1].end == 0x3E7) {
            f->item[i - 1].end = 0;
        }
    }
    f->count = n;
}

/*
 * PORT H008+$03C8: disegna le opzioni nella riga 24 dopo il titolo: la
 * voce selezionata in negativo (se c'e' una penna di evidenza), le
 * iniziali con la penna di evidenza, il resto con la penna normale; poi
 * cancella fino alla colonna 39.
 */
static void draw_options(ChoiceFrame *f, u8 selected)
{
    u16 i;

    if (f->options_len == 0) {
        return;
    }
    for (i = 0; i <= (u16)(f->options_len - 1); ++i) {
        u16 col = (u16)(f->title_len + i);
        u8 ch = (u8)f->options[i];

        if (i >= f->item[selected - 1].start &&
            i <= f->item[selected - 1].end && f->highlight_pen != 0) {
            draw_char_run(col, 0x18, 0, f->highlight_pen, 1, ch, 1);
        } else if (is_hotkey_char(ch)) {
            draw_char_run(col, 0x18, f->highlight_pen, 0, 1, ch, 1);
        } else {
            draw_char_run(col, 0x18, f->normal_pen, 0, 1, ch, 1);
        }
    }
    if ((u16)(f->title_len + f->options_len) < 0x27) {
        draw_char_run((u16)(f->title_len + f->options_len), 0x18, 0, 0,
                      (u16)(0x27 - f->options_len - f->title_len + 1), ' ', 1);
    }
}

/* Indice dell'opzione selezionata (H005+$2483, persistente tra le chiamate). */
/* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
#define CHOICE_SELECTED H005_B(0x2483)

/* Coordinate di combattimento/mappa del cursore (rami $07F8/$0D8E). */
static void map_target(s16 *dx, s16 *dy)
{
    const u8 *area = g_combat_area;

    if (H005_B(0x24CC)) { /* $24CC: 1 nel modo Manual: cursore sulla mappa di combattimento */
        /* $2438: X del cursore sulla mappa del combattimento (word, 0..49) */
        *dx = (s16)(H005_W(0x2438) - COK_GET16(area + 2) + 1);
        /* $2436: Y del cursore sulla mappa del combattimento (word, 0..24) */
        *dy = (s16)(H005_W(0x2436) - COK_GET16(area + 4) + 1);
    } else {
        s16 who = (s16)combatant_index(g_current_char);

        /* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word) */
        *dx = (s16)(H005_W(0x3154 + (who - 1) * 6) - COK_GET16(area + 2) + 1);
        /* $3156: posizioni combattenti +2: riga sulla mappa (word) */
        *dy = (s16)(H005_W(0x3154 + (who - 1) * 6 + 2) - COK_GET16(area + 4) + 1);
    }
}

/* Il cursore e' sulla mappa di combattimento (22x22 celle)? */
static int over_combat_map(const ChoiceFrame *f)
{
    /* $24CB: 1 nel modo Move/Attack: cursore sulla mappa di combattimento; $24CC: 1 nel modo
     * Manual: cursore sulla mappa di combattimento; $3DE3: modo/contesto di gioco corrente (0 menu,
     * 1 vista, 5 combattimento) */
    return (H005_B(0x24CB) || H005_B(0x24CC)) && H005_B(0x3DE3) == 5 &&
           f->col >= 0 && f->col <= 0x16 && f->row >= 0 && f->row <= 0x16;
}

/*
 * Il cursore e' sulla vista dell'esplorazione: dentro la vista 3..13, o
 * (fuori dalla vista, senza la mappa a tutto schermo, nel contesto 3) in
 * 1..38 x 1..15.
 */
static int over_area_view(const ChoiceFrame *f)
{
    if (f->col >= 3 && f->col <= 0x0D && f->row >= 3 && f->row <= 0x0D) {
        return 1;
    }
    /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto; $3DE3: modo/contesto di gioco
     * corrente (0 menu, 1 vista, 5 combattimento) */
    return COK_GET16(g_state_a + 0x1CC) == 0 && H005_B(0x3DE3) == 3 &&
           f->col >= 1 && f->col <= 0x26 && f->row >= 1 && f->row <= 0x0F;
}

/* Direzione o azione sotto il cursore nella vista (H046 o tabella $4F86). */
static u8 area_view_code(const ChoiceFrame *f)
{
    if (COK_GET16(g_state_a + 0x1CC) == 0) { /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto */
        /* A+$186: (word) x del party sulla mappa all'aperto (38x15) */
        return cursor_direction((u16)(COK_GET16(g_state_a + 0x186) + 1),
                         /* A+$188: (word) y del party sulla mappa all'aperto (38x15) */
                         (u16)(COK_GET16(g_state_a + 0x188) + 1),
                         (u16)f->col, (u16)f->row);
    }
    /* $4F86: azione sotto il cursore nella vista: righe da $0C, da (3,3) */
    return H005_B(0x4F86 + (f->row - 3) * 0x0C + (f->col - 3));
}

/*
 * Tasto Invio o clic (ramo $0BA6).  Senza clic: la voce selezionata.  Con
 * un clic, in ordine: H047 attivo; ritratti del party; mappa di
 * combattimento; vista dell'esplorazione; la riga delle opzioni; le aree
 * di $24DA; la lista di H005+$2778.
 */
static void enter_or_click(ChoiceFrame *f)
{
    if (!G_MOUSE_CLICK) { /* $249E: 1 se il tasto viene dal mouse (clic) */
        /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
        f->key = (u8)f->options[f->item[CHOICE_SELECTED - 1].start];
        if (f->key == 0) {
            f->key = 0x0D;
        }
        f->done = 1;
        return;
    }
    f->row = (s16)((s16)H005_W(0x2354) / 8); /* $2354: Y del mouse (word, iniziale $64) */
    f->col = (s16)((s16)H005_W(0x2356) / 8); /* $2356: X del mouse (word, iniziale $A0) */
    if (g_h047_0001) {
        *f->special = 1;
        f->done = 1;
        return;
    }
    if (H005_B(0x24A2) && /* $24A2: 1: il clic su un nome del party sceglie il personaggio */
        /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento); A+$270: (word)
         * area citta': niente ridisegno vista ne' EXIT dal campo */
        (H005_B(0x3DE3) != 3 || COK_GET16(g_state_a + 0x270) != 0) &&
        /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento; $3DE3: modo/contesto
         * di gioco corrente (0 menu, 1 vista, 5 combattimento) */
        !H005_B(0x24B0) && H005_B(0x3DE3) != 5 &&
        /* $248D: area cliccabile del party: prima colonna (1 o $11); $248C: area cliccabile del
         * party: ultima colonna ($26) */
        f->col >= H005_B(0x248D) && f->col <= H005_B(0x248C) &&
        /* $248B: area cliccabile del party: prima riga (4); $248A: area cliccabile del party:
         * ultima riga (3 + membri) */
        f->row >= H005_B(0x248B) && f->row <= H005_B(0x248A)) {
        /* Clic su un personaggio del party. */
        u16 index = (u16)(f->row - H005_B(0x248B)); /* $248B: area cliccabile del party: prima riga (4) */
        Character *member = g_party_head;
        u16 i;

        for (i = 1; i <= index; ++i) {
            if (member != NULL) {
                member = member->next;
            }
        }
        if (member != NULL) {
            f->key = 'H';
            *f->special = 1;
            f->done = 1;
            if (H005_B(0x24D8)) { /* $24D8: modo di scelta membro: il clic va in $2508 e non nel corrente */
                g_h005_2508 = member;
            } else if (g_current_char == member) {
                *f->special = 0;
                /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                f->key = (u8)f->options[f->item[CHOICE_SELECTED - 1].start];
                if (f->key == 0) {
                    f->key = 0x0D;
                }
            } else {
                g_current_char = member;
            }
        }
        return;
    }
    if (over_combat_map(f)) {
        s16 dx;
        s16 dy;

        *f->special = 1;
        map_target(&dx, &dy);
        f->key = cursor_direction((u16)dx, (u16)dy, (u16)((f->col + 2) / 3),
                           (u16)((f->row + 2) / 3));
        f->done = 1;
        return;
    }
    /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
    if (H005_B(0x24B0) && over_area_view(f)) {
        *f->special = 1;
        f->key = area_view_code(f);
        f->done = 1;
        return;
    }
    if (f->row == 0x18 && !f->done) {
        u16 i;

        ++f->col;
        if (!(f->col > (s16)f->title_len)) {
            /* Clic sul titolo: l'originale esce subito (ramo $0F56). */
            f->done = 2;
            return;
        }
        f->col = (s16)(f->col - f->title_len);
        for (i = 1; i <= f->count; ++i) {
            if ((s16)(f->item[i - 1].start + 1) <= f->col &&
                (s16)(f->item[i - 1].end + 1) >= f->col) {
                f->key = (u8)f->options[f->item[i - 1].start];
                /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                CHOICE_SELECTED = (u8)i;
                /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                draw_options(f, CHOICE_SELECTED);
                f->done = 1;
            }
        }
        return;
    }
    if (H005_B(0x24DA) && !f->done) { /* $24DA: 1 in Modify Character: il clic sceglie il campo ($2506) */
        f->done = 1;
        switch (f->row) {
        case 1:
            if (f->col >= 1 && f->col <= 0x10) {
                /* $2506: (word) campo cliccato in Modify Character (0..7), $FF nessuno */
                H005_SET_W(0x2506, 6);
            }
            break;
        case 3:
            if (f->col >= 0x1F && f->col <= 0x21) {
                /* $2506: (word) campo cliccato in Modify Character (0..7), $FF nessuno */
                H005_SET_W(0x2506, 7);
            }
            break;
        case 9: case 10: case 11: case 12: case 13: case 14:
            if (f->col >= 5 && f->col <= 9) {
                /* $2506: (word) campo cliccato in Modify Character (0..7), $FF nessuno */
                H005_SET_W(0x2506, (u16)(f->row - 9));
            }
            break;
        default:
            f->done = 0;
            break;
        }
        *f->special = 1;
        f->key = 'G';
        return;
    }
    /* $2504: (word) prima colonna dell'area cliccabile del menu a elenco */
    if (!f->done && f->col >= (s16)H005_W(0x2504) &&
        /* $2502: (word) ultima colonna dell'area cliccabile del menu a elenco */
        f->col <= (s16)H005_W(0x2502)) {
        u16 i;

        for (i = 1; i <= 0x19; ++i) {
            /* $2777: base 1-based della tabella righe voci menu ($2778 + i - 1) */
            u8 limit = H005_B(0x2778 + i - 1);

            if (limit == 0xFF) {
                break;
            }
            if (!f->done && !(limit > f->row)) {
                f->done = 1;
                /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                f->key = (u8)f->options[f->item[CHOICE_SELECTED - 1].start];
            }
        }
    }
}

/* Cifre 1..9 (e '\\' come 7) tradotte con la tabella H005+$4F7C. */
static void map_digit(ChoiceFrame *f)
{
    f->key = H005_B(0x4F7C + f->key - '1'); /* $4F7C: traduzione dei tasti cifra 1..9 in tasti azione */
    *f->special = 1;
}

/*
 * PORT H008+$01FC (UI_RequestChoice): mostra nella riga 24 il titolo e le
 * opzioni (voci con iniziale maiuscola) e restituisce la scelta: la lettera
 * della voce, Invio/clic sulla voce selezionata, Esc (0), o un tasto
 * speciale con *special = 1 (frecce/'4' '6' per scorrere, Alt+a/m/q/x,
 * clic nelle aree del gioco).  Con un tempo massimo (G_PROMPT_TIMEOUT, in
 * centesimi) restituisce G_PROMPT_KEY.  La voce selezionata resta in
 * H005+$2483.  Durante l'attesa anima l'insieme di immagini di $27BC e
 * aggiorna la forma del puntatore.
 */
u8 ui_request_choice(u16 title_len, const char *title, u16 options_len,
                     const char *options, u16 title_pen, u16 normal_pen,
                     u16 highlight_pen, u8 digits_map, u8 animate,
                     u8 *special)
{
    ChoiceFrame f;
    s32 last_time;                      /* -$56 */
    s32 now;                            /* -$5A */
    s16 shape_code;                     /* -$5C */
    u8 shape;                           /* -$5D */

    memset(&f, 0, sizeof(f));
    f.options = options;
    f.title_pen = title_pen;
    f.normal_pen = normal_pen;
    f.highlight_pen = highlight_pen;
    f.digits_map = digits_map;
    f.animate = animate;
    f.special = special;

    intuition_modify_idcmp(g_window, g_window->IDCMPFlags | 0x00400000UL);
    H005_B(0x249D) = 0; /* $249D: 1 se l'ultima UI_RequestChoice ha dato un tasto speciale */
    f.title_len = h026_strlen(title_len, title);
    parse_options(&f, options_len, options);
    /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
    if (CHOICE_SELECTED > f.count || CHOICE_SELECTED == 0) {
        CHOICE_SELECTED = 1; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
    }
    f.options_len = h026_strlen(options_len, options);
    f.key = 0;
    *special = 0;
    f.done = 0;
    last_time = time_hundredths();
    if (title[0] != 0) {
        ui_draw_text(0, 0x18, title_pen, 0, title_len, title);
    }
    /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
    draw_options(&f, CHOICE_SELECTED);

    do {
        f.key = 0;
        /* Animazione dell'insieme di immagini ($069E). */
        /* A+$3FE: uso: forza l'animazione in attesa scelta; sommato alla direzione */
        if ((COK_GET16(g_state_a + 0x3FE) != 0 || animate) &&
            /* $27BE: (word) fotogramma corrente dell'animazione della sequenza (1..n) */
            H005_W(0x27BE) > 0) {
            u16 frame;
            s16 wait;

            now = time_hundredths();
            /* $27BE: (word) fotogramma corrente dell'animazione della sequenza (1..n) */
            frame = (u16)(H005_W(0x27BE) + 1);
            /* $27BC: (word) fotogrammi della sequenza caricata (max 6), base del blocco */
            if (frame > H005_W(0x27BC)) {
                frame = 1;
            }
            /* $27CA: tab. word per fotogramma (idx frame-1): durata in 1/10 s */
            wait = (s16)(H005_W(0x27BC + 0x0E + (frame - 1) * 2) * 10 - 0x0B);
            if (wait < 0) {
                wait = 0;
            }
            /* A+$3FE: uso: forza l'animazione in attesa scelta; sommato alla direzione */
            if (COK_GET16(g_state_a + 0x3FE) != 0 ||
                !(now - last_time < (s32)wait)) {
                /* $27BE: (word) fotogramma corrente dell'animazione della sequenza (1..n) */
                H005_SET_W(0x27BE, frame);
                show_picture(3, 3, animate, sequence_frame(frame));
                last_time = now;
            }
        }
        /* Forma del puntatore ($076A). */
        if (H005_B(0x24E2)) { /* $24E2: 1 durante il riposo: puntatore d'attesa, messaggi dalla riga $12 */
            shape_code = 9;
        } else {
            f.col = (s16)(g_window->MouseX / 8);
            f.row = (s16)(g_window->MouseY / 8);
            shape = 0;
            if (over_combat_map(&f)) {
                s16 dx;
                s16 dy;

                map_target(&dx, &dy);
                shape = cursor_direction((u16)dx, (u16)dy, (u16)((f.col + 2) / 3),
                                  (u16)((f.row + 2) / 3));
            /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
            } else if (H005_B(0x24B0) && over_area_view(&f)) {
                shape = area_view_code(&f);
            }
            shape_code = 0x0A;
            switch (shape) {
            case 0x47: shape_code = 7; break;
            case 0x48: shape_code = 0; break;
            case 0x49: shape_code = 1; break;
            case 0x4B: shape_code = 6; break;
            case 0x4D: shape_code = 2; break;
            case 0x4F: shape_code = 5; break;
            case 0x50: shape_code = 4; break;
            case 0x51: shape_code = 3; break;
            default: break;
            }
        }
        set_pointer_shape(shape_code);

        /* Tempo massimo o input ($0A12). */
        /* $2792: (long) tempo massimo di attesa della scelta, in 1/100 s (0 nessuno) */
        if (G_PROMPT_TIMEOUT > 0) {
            s32 elapsed = time_hundredths() - last_time;

            if (elapsed < 0) {
                elapsed = -elapsed;
            }
            /* $2792: (long) tempo massimo di attesa della scelta, in 1/100 s (0 nessuno) */
            if (!(elapsed < G_PROMPT_TIMEOUT)) {
                f.key = G_PROMPT_KEY; /* $52FB: tasto restituito alla scadenza dell'attesa (G_PROMPT_KEY) */
                f.done = 1;
            }
        }
        if (!f.done) {
            poll_intuition_events();
            f.key = G_KEY; /* $5305: tasto/azione pendente dall'input (G_KEY) */
        }
        if (f.key != 0 && !f.done) {
            *special = 0;
            if (G_KEY > 0 && G_KEY < 5) { /* $5305: tasto/azione pendente dall'input (G_KEY) */
                f.done = 1;
                *special = 1;
            } else {
                switch (f.key) {
                case 0x0D:
                    enter_or_click(&f);
                    if (f.done == 2) {
                        /*
                         * Clic sul titolo: l'originale toglie INTUITICKS e
                         * restituisce -$5F, che qui non e' stato scritto
                         * (sullo stack: valore indefinito); qui 0.
                         */
                        intuition_modify_idcmp(g_window, g_window->IDCMPFlags &
                                                         ~0x00400000UL);
                        return f.result;
                    }
                    break;
                case 0x1B:
                    f.done = 1;
                    f.key = 0;
                    break;
                case '4':
                    *special = 1;
                    if (f.count > 1) {
                        /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                        if (CHOICE_SELECTED == 1) {
                            /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                            CHOICE_SELECTED = (u8)f.count;
                        } else {
                            /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                            CHOICE_SELECTED = (u8)(CHOICE_SELECTED - 1);
                        }
                        /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                        draw_options(&f, CHOICE_SELECTED);
                    } else {
                        if (digits_map) {
                            map_digit(&f);
                        }
                        f.done = 1;
                    }
                    break;
                case '6':
                    *special = 1;
                    if (f.count > 1) {
                        /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                        if (CHOICE_SELECTED == f.count) {
                            /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                            CHOICE_SELECTED = 1;
                        } else {
                            /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                            add_to_byte(&CHOICE_SELECTED, 1);
                        }
                        /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
                        draw_options(&f, CHOICE_SELECTED);
                    } else {
                        f.done = 1;
                        if (digits_map) {
                            map_digit(&f);
                        }
                    }
                    break;
                default:
                    /* Lettera di una voce, spazio, cifre ($11BA). */
                    if (f.key >= 'a' && f.key <= 'z') {
                        f.key = (u8)(f.key & 0x5F);
                    }
                    if (is_hotkey_char(f.key) || f.key == ' ') {
                        if (f.key == ' ') {
                            f.done = 1;
                        } else {
                            u16 i;

                            for (i = 0; i <= f.options_len; ++i) {
                                if ((u8)options[i] == f.key) {
                                    u16 n;

                                    f.done = 1;
                                    /*
                                     * L'originale cerca la voce che inizia
                                     * qui senza limite; qui al massimo 20.
                                     */
                                    for (n = 1; n <= 0x14 &&
                                                f.item[n - 1].start != i; ++n) {
                                    }
                                    if (n <= 0x14) {
                                        /* $2483: indice dell'opzione selezionata nei menu a riga
                                         * (persistente) */
                                        CHOICE_SELECTED = (u8)n;
                                        /* $2483: indice dell'opzione selezionata nei menu a riga
                                         * (persistente) */
                                        draw_options(&f, CHOICE_SELECTED);
                                    }
                                }
                            }
                        }
                    }
                    if (digits_map && ((f.key >= '1' && f.key <= '9') ||
                                       f.key == '\\')) {
                        if (f.key == '\\') {
                            f.key = '7';
                        } else {
                            /* $4F7C: traduzione dei tasti cifra 1..9 in tasti azione */
                            f.key = H005_B(0x4F7C + f.key - '1');
                        }
                        *special = 1;
                        f.done = 1;
                    }
                    break;
                }
            }
        }
    } while (!f.done);

    /* A+$3FE: uso: forza l'animazione in attesa scelta; sommato alla direzione */
    COK_PUT16(g_state_a + 0x3FE, 0);
    f.result = f.key;
    H005_B(0x249D) = *special; /* $249D: 1 se l'ultima UI_RequestChoice ha dato un tasto speciale */
    intuition_modify_idcmp(g_window, g_window->IDCMPFlags & ~0x00400000UL);
    return f.result;
}

/* PORT H008+$0102: voce index (0 = la prima), NULL se la lista e' corta. */
CokMenuItem *menu_nth(CokMenuItem *list, u16 index)
{
    u16 i = 0;
    CokMenuItem *node = list;

    while (node != NULL && i != index) {
        node = node->next;
        ++i;
    }
    return i == index ? node : NULL;
}

/* PORT H008+$0162: numero di voci. */
u16 menu_length(CokMenuItem *list)
{
    u16 n = 0;
    CokMenuItem *node = list;

    while (node != NULL) {
        ++n;
        node = node->next;
    }
    return n;
}

/*
 * Variabili di list_menu (frame di H008+$13C0) usate dalle sotto-procedure
 * annidate $1448..$1A60 attraverso il frame del chiamante.
 */
typedef struct ListFrame {
    CokMenuItem *list;             /* $1A(a5) */
    u16 *index;                 /* $10(a5): voce selezionata */
    u16 first_col;              /* $24 */
    u16 first_row;              /* $22 */
    u16 last_col;               /* $20 */
    u16 last_row;               /* $1E */
    u16 title_pen;              /* $2A: intestazioni */
    u16 normal_pen;             /* $28: voci */
    u16 highlight_pen;          /* $26: voce selezionata (sfondo) */
    char text[0x52];            /* -$52 */
    u16 width;                  /* -$54 */
    u16 row_no;                 /* -$56 */
    u16 count;                  /* -$58 */
    u16 visible;                /* -$5C */
} ListFrame;

/* Prima riga mostrata dei menu a elenco (H005+$2796). */
#define LIST_TOP H005_W(0x2796) /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
/* $2796: (word) indice della prima voce mostrata nei menu a elenco */
#define SET_LIST_TOP(v) H005_SET_W(0x2796, (u16)(v))

/*
 * PORT H008+$13CE: ultima intestazione prima della voce index (o la prima
 * voce se e' un'intestazione).  Il risultato non e' usato dal chiamante.
 */
static CokMenuItem *last_header_before(CokMenuItem *list, s16 index)
{
    s16 i = 0;
    CokMenuItem *node = list;
    CokMenuItem *found = NULL;

    while (node != NULL && i < index) {
        if (node->header) {
            found = node;
        }
        node = node->next;
        ++i;
    }
    if (found == NULL && list->header) {
        return list;
    }
    return found;
}

/*
 * PORT H008+$1448: disegna le voci da top nell'area del menu (intestazioni
 * con title_pen, voci con normal_pen), annotando in H005+$2778 la riga di
 * ciascuna ($FF = fine).
 */
static void draw_menu_items(ListFrame *f, u16 top)
{
    CokMenuItem *node;
    s16 row;
    u16 len;

    /* $2778: tab. 25 byte: riga a schermo di ogni voce menu mostrata, $FF fine */
    h029_fill_bytes(0x18, &g_h005[0x2778], 0x19, 0xFF);
    clear_text_cells(f->first_col, f->first_row, f->last_col, f->last_row);
    node = menu_nth(f->list, top);
    (void)last_header_before(f->list, (s16)top);
    row = (s16)f->first_row;
    f->row_no = 1;
    while (node != NULL && row <= (s16)f->last_row) {
        /* $2777: base 1-based della tabella righe voci menu ($2778 + i - 1) */
        H005_B(0x2778 + f->row_no - 1) = (u8)row;
        ui_draw_text(f->first_col, (u16)row,
                     node->header ? f->title_pen : f->normal_pen, 0, 0x28,
                     node->text);
        len = h026_strlen(0x28, node->text);
        if (len < f->width) {
            draw_char_run((u16)(h026_strlen(0x28, node->text) + f->first_col),
                          (u16)row, 0, 0,
                          (u16)(f->width - h026_strlen(0x28, node->text)),
                          ' ', 1);
        }
        node = node->next;
        ++row;
        ++f->row_no;
    }
}

/* PORT H008+$15DC: spazi iniziali del testo. */
static u16 leading_spaces(u16 len, const char *text)
{
    u16 i = 0;
    u16 n = h026_strlen(len, text);

    while (i < n && text[i] == ' ') {
        ++i;
    }
    return i;
}

/*
 * PORT H008+$164E: posizione dopo l'ultimo carattere non spazio; parte dal
 * NUL, quindi in pratica e' la lunghezza della stringa.
 */
static u16 text_end(u16 len, const char *text)
{
    u16 n = h026_strlen(len, text);

    while (n > 1 && text[n] == ' ') {
        --n;
    }
    return n;
}

/* Testo della voce index senza spazi iniziali in f->text; restituisce la colonna. */
static u16 trimmed_text(ListFrame *f, u16 index)
{
    CokMenuItem *node = menu_nth(f->list, index);
    u16 lead = leading_spaces(0x28, node->text);
    u16 count = (u16)(text_end(0x28, node->text) - lead + 1);

    h026_substr(0x50, f->text, 0x28, node->text, lead, count);
    return (u16)(f->first_col + lead);
}

/* PORT H008+$16BA: evidenzia la voce index (testo 0 su highlight_pen). */
static void highlight_item(ListFrame *f, u16 index)
{
    u16 col = trimmed_text(f, index);

    /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
    ui_draw_text(col, (u16)(index - LIST_TOP + f->first_row), 0,
                 f->highlight_pen, 0x50, f->text);
}

/* PORT H008+$176A: ridisegna la voce index senza evidenza. */
static void unhighlight_item(ListFrame *f, u16 index)
{
    CokMenuItem *node = menu_nth(f->list, index);
    u16 col = trimmed_text(f, index);

    /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
    ui_draw_text(col, (u16)(index - LIST_TOP + f->first_row),
                 node->header ? f->title_pen : f->normal_pen, 0, 0x50,
                 f->text);
}

/*
 * PORT H008+$188A: sposta la selezione oltre le intestazioni nella
 * direzione down (con giro dentro la pagina), al massimo visible passi.
 * Oltre la fine della lista l'originale legge il flag da un puntatore
 * nullo, cioe' il byte all'indirizzo $2A (tabella dei vettori della CPU,
 * normalmente diverso da zero): la riga vuota viene saltata come
 * un'intestazione.  Qui un nodo nullo conta come intestazione.
 */
static void skip_headers(ListFrame *f, u8 down)
{
    s16 i = 0;
    CokMenuItem *node = menu_nth(f->list, *f->index);

    if (down) {
        while (i < (s16)f->visible && (node == NULL || node->header)) {
            ++i;
            ++*f->index;
            /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
            if ((s16)*f->index > (s16)(LIST_TOP + f->visible - 1)) {
                *f->index = LIST_TOP; /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
            }
            node = menu_nth(f->list, *f->index);
        }
    } else {
        while (i < (s16)f->visible && (node == NULL || node->header)) {
            ++i;
            --*f->index;
            /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
            if ((s16)*f->index < (s16)LIST_TOP) {
                /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
                *f->index = (u16)(LIST_TOP + f->visible - 1);
            }
            node = menu_nth(f->list, *f->index);
        }
    }
}

/*
 * PORT H008+$19A8: pagina successiva (next) o precedente, mantenendo la
 * posizione della selezione nella pagina; ridisegna.
 */
static void page_menu(ListFrame *f, u8 next)
{
    /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
    s16 rel = (s16)(*f->index - LIST_TOP);

    if (next) {
        /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        SET_LIST_TOP(LIST_TOP + f->visible);
        /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        if ((s16)LIST_TOP > (s16)(f->count - f->visible)) {
            /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
            SET_LIST_TOP(f->count - f->visible);
        }
    } else {
        /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        SET_LIST_TOP(LIST_TOP - f->visible);
        if ((s16)LIST_TOP < 0) { /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
            SET_LIST_TOP(0); /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        }
    }
    *f->index = (u16)(LIST_TOP + rel); /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
    skip_headers(f, next);
    draw_menu_items(f, LIST_TOP); /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
}

/* PORT H008+$1A60: selezione giu' (down) o su, con giro nella pagina. */
static void move_selection(ListFrame *f, u8 down)
{
    if (down) {
        ++*f->index;
        /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        if ((s16)*f->index > (s16)(LIST_TOP + f->visible - 1)) {
            *f->index = LIST_TOP; /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        }
    } else {
        --*f->index;
        /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        if ((s16)*f->index < (s16)LIST_TOP) {
            /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
            *f->index = (u16)(LIST_TOP + f->visible - 1);
        }
    }
    skip_headers(f, down);
}

/*
 * PORT H008+$13C0 (corpo a $1AF4): menu a elenco.  Mostra le voci di list
 * nell'area (first_col, first_row)..(last_col, last_row), la voce *index
 * evidenziata e, nella riga 24, title e options con " Next"/" Prev" (se ci
 * sono altre pagine) e " Exit" (with_exit).  Frecce su/giu' (tastierino
 * 8/2) muovono, 9/3 cambiano pagina, N e P anche; Invio o un'opzione
 * scelgono: *chosen = voce selezionata e restituisce il tasto.  Un clic su
 * una voce la seleziona, un secondo clic la sceglie.  Esc, E o 0: *chosen
 * = NULL e 0.  *redraw: ridisegnare le voci.
 */
u8 list_menu(u16 title_len, const char *title, u16 options_len,
             const char *options, u16 title_pen, u16 normal_pen,
             u16 highlight_pen, u16 first_col, u16 first_row,
             u16 last_col, u16 last_row, CokMenuItem *list, u8 with_exit,
             u8 *redraw, u16 *index, CokMenuItem **chosen)
{
    ListFrame f;
    char opts[0x2A];                    /* -$88 */
    u8 has_next;                        /* -$89 */
    u8 has_prev;                        /* -$8A */
    u8 special;                         /* -$59 */
    u8 key;                             /* -$5D */
    u8 prev_key = 'N';                  /* -$5E */
    u16 leading;                        /* -$90 */
    u16 total;                          /* -$92 */
    s16 row;                            /* -$96 */
    s16 col;                            /* -$94 */
    CokMenuItem *node;

    if (list == NULL) {
        *index = 0;
        *chosen = NULL;
        return 0;
    }
    memset(&f, 0, sizeof(f));
    f.list = list;
    f.index = index;
    f.first_col = first_col;
    f.first_row = first_row;
    f.last_col = last_col;
    f.last_row = last_row;
    f.title_pen = title_pen;
    f.normal_pen = normal_pen;
    f.highlight_pen = highlight_pen;

    H005_SET_W(0x2504, first_col); /* $2504: (word) prima colonna dell'area cliccabile del menu a elenco */
    H005_SET_W(0x2502, last_col); /* $2502: (word) ultima colonna dell'area cliccabile del menu a elenco */
    f.width = (u16)(last_col - first_col + 1);
    f.count = menu_length(list);
    f.visible = (u16)(last_row - first_row + 1);
    leading = 0;
    for (node = list; node != NULL && node->header; node = node->next) {
        ++leading;
    }
    total = menu_length(list);
    if (!((s16)total > (s16)f.visible)) {
        SET_LIST_TOP(0); /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
    }
    if ((s16)LIST_TOP > (s16)*index) { /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        SET_LIST_TOP(*index); /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        *redraw = 1;
    }
    if ((s16)LIST_TOP > (s16)total) { /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        SET_LIST_TOP(0); /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        *redraw = 1;
    }
    ++*index;
    move_selection(&f, 0);
    if (*redraw) {
        draw_menu_items(&f, LIST_TOP); /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
    }
    *redraw = 0;

    for (;;) {
        highlight_item(&f, *index);
        h026_copy(0x28, opts, options_len, options);
        has_next = 0;
        has_prev = 0;
        /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        if ((s16)LIST_TOP < (s16)(f.count - f.visible)) {
            h026_append(0x28, opts, 5, " Next");
            has_next = 1;
        }
        /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
        if ((s16)LIST_TOP > (s16)leading) {
            h026_append(0x28, opts, 5, " Prev");
            has_prev = 1;
        }
        if (with_exit) {
            h026_append(0x28, opts, 5, " Exit");
        }
        key = ui_request_choice(title_len, title, 0x28, opts, title_pen,
                                normal_pen, highlight_pen, 1, 0, &special);
        row = (s16)((s16)H005_W(0x2354) / 8); /* $2354: Y del mouse (word, iniziale $64) */
        col = (s16)((s16)H005_W(0x2356) / 8); /* $2356: X del mouse (word, iniziale $A0) */
        unhighlight_item(&f, *index);
        if (special) {
            switch (key) {
            case 'H':
                move_selection(&f, 0);
                break;
            case 'P':
                move_selection(&f, 1);
                break;
            case 'I':
                if (has_prev) {
                    page_menu(&f, 0);
                }
                break;
            case 'Q':
                if (has_next) {
                    page_menu(&f, 1);
                }
                break;
            default:
                break;
            }
            continue;
        }
        switch (key) {
        case 0:
        case 0x1B:
        case 'E':
            *chosen = NULL;
            return 0;
        case 'P':
            if (!G_MOUSE_CLICK || row == 0x18) { /* $249E: 1 se il tasto viene dal mouse (clic) */
                page_menu(&f, 0);
            }
            break;
        case 'N':
            if (!G_MOUSE_CLICK || row == 0x18) { /* $249E: 1 se il tasto viene dal mouse (clic) */
                page_menu(&f, 1);
            }
            break;
        default:
            if (G_MOUSE_CLICK && row != 0x18) { /* $249E: 1 se il tasto viene dal mouse (clic) */
                /* $2504: (word) prima colonna dell'area cliccabile del menu a elenco; $2502: (word)
                 * ultima colonna dell'area cliccabile del menu a elenco */
                if (col >= (s16)H005_W(0x2504) && col <= (s16)H005_W(0x2502)) {
                    u16 i;

                    for (i = 1; i <= 0x19; ++i) {
                        /* $2777: base 1-based della tabella righe voci menu ($2778 + i - 1) */
                        u8 item_row = H005_B(0x2778 + i - 1);

                        if (item_row == 0xFF) {
                            break;
                        }
                        if ((s16)item_row == row) {
                            /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
                            if ((u16)(i - 1 + LIST_TOP) == *index) {
                                *chosen = menu_nth(list, *index);
                                return key;
                            }
                            unhighlight_item(&f, *index);
                            /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
                            *index = (u16)(i - 1 + LIST_TOP);
                            highlight_item(&f, *index);
                        }
                    }
                }
            } else if (!G_MOUSE_CLICK || prev_key == key) { /* $249E: 1 se il tasto viene dal mouse (clic) */
                *chosen = menu_nth(list, *index);
                return key;
            }
            break;
        }
        prev_key = key;
    }
}

/*
 * PORT H008+$203C: domanda "Yes No" (parte da No) finche' la risposta e' Y
 * o N; la restituisce.
 */
u8 ask_yes_no(u16 text_len, const char *text, u16 title_pen,
              u16 normal_pen, u16 highlight_pen)
{
    u8 special;                         /* -$1(a5) */
    u8 key;

    H005_B(0x2483) = 2; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
    do {
        key = ui_request_choice(text_len, text, 6, "Yes No", title_pen,
                                normal_pen, highlight_pen, 0, 0, &special);
    } while (key != 'Y' && key != 'N');
    return key;
}

/* PORT H008+$20C2: lista di count voci vuote (almeno una). */
void menu_alloc(u16 count, CokMenuItem **list)
{
    CokMenuItem *node;
    s16 i;

    *list = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem), COK_MEMF_CLEAR);
    (*list)->next = NULL;
    (*list)->header = 0;
    (*list)->text[0] = 0;
    node = *list;
    for (i = 2; i <= (s16)count; ++i) {
        node->next = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                COK_MEMF_CLEAR);
        node = node->next;
        node->next = NULL;
        node->header = 0;
        node->text[0] = 0;
    }
}

/* PORT H008+$2178: libera la lista e azzera *list. */
void menu_free(CokMenuItem **list)
{
    CokMenuItem *node;
    CokMenuItem *dead;

    if (*list == NULL) {
        return;
    }
    node = *list;
    while (node != NULL) {
        dead = node;
        node = node->next;
        exec_free_mem(dead, sizeof(CokMenuItem));
    }
    *list = NULL;
}
