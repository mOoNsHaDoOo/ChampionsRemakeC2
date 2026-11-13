/* H020: writing to the process console (Pascal runtime). */
#ifndef COK_H020_IO_H
#define COK_H020_IO_H
#include "cok.h"
void console_write(u16 len, const char *text);  /* H020+$085A */
void console_write_int(s16 value, u16 width); /* H020+$08C2 */
void console_newline(void);                     /* H020+$082E */
#endif
