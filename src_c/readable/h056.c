/* H056: Diagnostica e nomi degli opcode ECL. */
#include "h056.h"
#include "globals.h"
#include "h026_string.h"
#include "h030.h"
#include "h045.h"

/* PORT H056+$025A: link/unlk, nessun effetto. */
void h056_init(void)
{
}

/*
 * PORT H056+$0886: con il debug attivo ($24D2) mostra "a , b , c" (4
 * cifre) sulla riga 0 e il messaggio text (per valore) fino a un tasto.
 */
void debug_trace(u16 len, const char *text, u8 a, u8 b, u8 c)
{
    char line[0x52];                    /* -$52(a5) */
    char sb[0x52];                      /* -$a4(a5) */
    char sc[0x52];                      /* -$f6(a5) */

    if (!H005_B(0x24D2)) {
        return;
    }
    format_number(0x50, line, a, 0, 0x0A, 4, '0');
    format_number(0x50, sb, b, 0, 0x0A, 4, '0');
    format_number(0x50, sc, c, 0, 0x0A, 4, '0');
    clear_text_cells(0, 0, 0x27, 0);
    h026_append(0x50, line, 3, " , ");
    h026_append(0x50, line, 0x50, sb);
    h026_append(0x50, line, 3, " , ");
    h026_append(0x50, line, 0x50, sc);
    ui_draw_text(0, 0, 0x0E, 0, 0x50, line);
    show_message_wait(0x0E, 0, len, text);
    clear_text_cells(0, 0, 0x27, 0);
}
