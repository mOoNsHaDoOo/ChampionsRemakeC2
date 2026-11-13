/* H020: I/O services and text diagnostics. */
#include <stdio.h>
#include "cok.h"
#include "h020_io.h"

u8 g_h020_0055;                 /* H020+$0055 */

/*
 * I/O runtime of the Pascal compiler, replaced by stdio (no
 * corresponding C function):
 * PORT H020+$00C2: flushes the line buffer of the runtime (via H020+$085A).
 * PORT H020+$00F0: adds a character to the line buffer; full at $4F.
 */

/* PORT H020+$00BA */
void h020_init(void)
{
    g_h020_0055 = 1;
}

/*
 * PORT H020+$085A: runtime write to Output: at most len characters,
 * up to the zero.  With the interactive console (H020+$2) one character
 * at a time (H074+$0450), otherwise as a block (H075+$0132); here stdio
 * in both cases.
 */
void console_write(u16 len, const char *text)
{
    u16 i;

    for (i = 0; i < len && text[i] != '\0'; ++i) {
        fputc(text[i], stdout);
    }
    fflush(stdout);
}

/* PORT H020+$082E: writeln without arguments: newline. */
void console_newline(void)
{
    fputc('\n', stdout);
    fflush(stdout);
}

/*
 * PORT H020+$08C2: write of an integer: value in decimal (with the minus
 * sign), right-aligned on width characters.
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
