/* H020: servizi di I/O e diagnostica testuale. */
#include <stdio.h>
#include "cok.h"
#include "h020_io.h"

u8 g_h020_0055;                 /* H020+$0055 */

/*
 * Runtime di I/O del compilatore Pascal, sostituito da stdio (nessuna
 * funzione C corrispondente):
 * PORT H020+$00C2: svuota il buffer di riga del runtime (via H020+$085A).
 * PORT H020+$00F0: aggiunge un carattere al buffer di riga; pieno a $4F.
 */

/* PORT H020+$00BA */
void h020_init(void)
{
    g_h020_0055 = 1;
}

/*
 * PORT H020+$085A: write del runtime su Output: al piu' len caratteri,
 * fino allo zero.  Con la console interattiva (H020+$2) un carattere
 * alla volta (H074+$0450), altrimenti in blocco (H075+$0132); qui stdio
 * in entrambi i casi.
 */
void console_write(u16 len, const char *text)
{
    u16 i;

    for (i = 0; i < len && text[i] != '\0'; ++i) {
        fputc(text[i], stdout);
    }
    fflush(stdout);
}

/* PORT H020+$082E: writeln senza argomenti: a capo. */
void console_newline(void)
{
    fputc('\n', stdout);
    fflush(stdout);
}

/*
 * PORT H020+$08C2: write di un intero: value in decimale (col segno
 * meno), allineato a destra su width caratteri.
 */
void console_write_int(s16 value, u16 width)
{
    char digits[0x0A];                  /* -$C(a5) */
    u16 n = 0;                          /* -$2(a5) */
    u16 v;                              /* -$4(a5) */

    v = (u16)(value < 0 ? -value : value);
    do {
        digits[n++] = (char)('0' + v % 10);
        v = (u16)(v / 10);
    } while (v != 0);
    if (value < 0) {
        digits[n++] = '-';
    }
    while (width > n) {
        --width;
        fputc(' ', stdout);
    }
    while (n > 0) {
        fputc(digits[--n], stdout);
    }
    fflush(stdout);
}
