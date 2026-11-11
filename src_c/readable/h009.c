/* H009: Verifica preliminare della distribuzione fornita; non modificata. */
#include "h009.h"
#include "h023_shared.h"
#include "h026_string.h"
#include "h030.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h049.h"
#include "globals.h"

/* PORT H009+$0070: link/unlk, nessun effetto. */
void h009_init(void)
{
}

/*
 * PORT H009+$007E: decodifica la risposta della voce: carattere = byte +
 * $46 + lunghezza (lunghezza >= 40 vale 0).
 */
static void decode_answer(char *out, QuizEntry *entry)
{
    const u8 *p = entry->answer;
    s16 i;

    if ((s16)entry->length >= 0x28) {
        entry->length = 0;
    }
    for (i = 0; i <= (s16)(entry->length - 1); ++i) {
        out[i] = (char)(*p + 0x46 + entry->length);
        ++p;
    }
    out[entry->length] = 0;
}

/*
 * PORT H009+$010C: verifica del manuale.  Chiede la parola di una pagina e
 * riga del manuale ("the best quartex" o "tavern tale", scelta a caso) e la
 * legge con H030+$0718.  Nella versione dei dati i due salti dopo il
 * confronto della risposta sono stati sostituiti da NOP: qualunque
 * risposta e' accettata e il risultato e' sempre 1.  Lungo il percorso
 * somma $2001 + $402 + $1B04 + $88 = $3F8F nella word di controllo
 * (H009+$0000), che il main verifica.
 */
u8 manual_check(void)
{
    char reply[0x2A];                   /* -$5A(a5) */
    char answer[0x2A];                  /* -$30(a5) */
    char line[0x2A];                    /* -$8C(a5) */
    char book[0x2A];                    /* -$B6(a5) */
    char tail[0x2A];                    /* -$E0(a5) */
    QuizEntry *entry;                   /* -$62(a5) */
    u16 tries = 0;                      /* -$5E(a5) */
    u16 which;                          /* -$5C(a5) */
    u16 index;                          /* -$4(a5) */

    draw_screen_frame(1);
    g_distribution_check = 0;
    ++tries;
    answer[0] = 0;
    which = (u16)random_below(2);
    g_distribution_check = (u16)(g_distribution_check + 0x2001);
    ui_draw_text(3, 2, 0x0A, 0, 0x0E, "broken by    #");
    if (which == 0) {
        index = (u16)random_below(0x19);
        h026_copy(0x28, book, 0x13, "the best quartex # ");
        h026_copy(0x28, tail, 0x1C, "(  type any word     , page ");
    } else {
        index = (u16)(random_below(0x19) + 0x19);
        h026_copy(0x28, book, 0x11, "of tavern tale # ");
        h026_copy(0x28, tail, 0x1C, "(  type any word     , page ");
    }
    entry = quiz_entry(index);
    decode_answer(answer, entry);

    format_number(0x28, line, (s32)(s16)entry->page, 0, 0x0A, 2, ' ');
    h026_append(0x28, line, 4, "    ");
    ui_draw_text(0x11, 2, 0x0A, 0, 0x28, line);
    format_number(0x28, line, (s32)(s16)entry->line, 0, 0x0A, 2, ' ');
    h026_insert(0x28, line, 0x28, book, 0);
    h026_append(0x28, line, 4, "    ");
    ui_draw_text(3, 4, 0x0A, 0, 0x28, line);
    format_number(0x28, line, (s32)(s16)entry->word, 0, 0x0A, 2, ' ');
    h026_insert(0x28, line, 0x28, tail, 0);
    h026_append(0x28, line, 6, ")?    ");
    ui_draw_text(3, 6, 0x0A, 0, 0x28, line);
    g_distribution_check = (u16)(g_distribution_check + 0x402);

    input_line(6, "Enter ", 0x0E, 0, 0x14, 0x28, reply);
    if (tries != 3) {
        (void)h026_compare(0x28, answer, 0x28, reply);  /* esito ignorato */
    }
    g_distribution_check = (u16)(g_distribution_check + 0x1B04);
    (void)h026_compare(0x28, answer, 0x28, reply);      /* esito ignorato */
    g_distribution_check = (u16)(g_distribution_check + 0x88);
    return 1;
}
