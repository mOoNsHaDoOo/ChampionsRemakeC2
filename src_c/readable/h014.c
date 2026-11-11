/* H014: Presentazione/gestione degli errori del programma. */
#include "h014.h"
#include "h010_input.h"
#include "h026_string.h"
#include "h030.h"
#include "h045.h"

/* PORT H014+$000A: link/unlk, nessun effetto. */
void h014_init(void)
{
}

/*
 * PORT H014+$0018: "msg>valore. " (valore su 8 cifre con zeri) in alto a
 * sinistra, poi attende un tasto.
 */
void error_message(u16 len, const char *msg, u16 value)
{
    char line[0x52];                    /* -$52(a5) */

    format_number(0x50, line, value, 0, 0x0A, 8, '0');
    h026_insert(0x50, line, 1, ">", 0);
    h026_insert(0x50, line, len, msg, 0);
    h026_append(0x50, line, 2, ". ");
    ui_draw_text(1, 1, 0x0F, 0, 0x50, line);
    wait_for_key();
}
