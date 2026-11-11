/* H098: I/O con buffer per il parser IFF (gio.c di Electronic Arts). */
#ifndef COK_H098_H
#define COK_H098_H

#include "h002_dos.h"

s32 gio_read(cok_bptr file, void *buffer, s32 n_bytes);      /* H098+$007C */
s32 gio_write_flush(cok_bptr file);                           /* H098+$00D0 */
s32 gio_seek(cok_bptr file, s32 position, s32 mode);          /* H098+$0276 */

#endif
