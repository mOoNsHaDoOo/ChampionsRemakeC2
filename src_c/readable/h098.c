/*
 * H098: I/O con buffer per il parser IFF (gio.c di Electronic Arts).
 *
 * Dati del modulo (nel codice, H098+$0000..$0013):
 *   $00 wWaterline  $04 wIndex  $08 wNBytes  $0C wBuffer  $10 wFile
 * La scrittura con buffer serve solo a GWrite; in lettura wFile e' nullo e
 * le routine vanno direttamente a Read/Seek.
 */
#include "h098.h"

static s32 s_waterline;         /* H098+$0000 */
static s32 s_index;             /* H098+$0004 */
static s32 s_nbytes;            /* H098+$0008 (usato da GWriteDeclare) */
static u8 *s_buffer;            /* H098+$000C */
static cok_bptr s_file;         /* H098+$0010 */

/* PORT H098+$0018: link/unlk, nessun effetto. */
void h098_init(void)
{
    (void)s_nbytes;
}

/* PORT H098+$007C (GRead): svuota prima il buffer di scrittura del file. */
s32 gio_read(cok_bptr file, void *buffer, s32 n_bytes)
{
    s32 result = 0;

    if (file == s_file) {
        result = gio_write_flush(file);
    }
    if (result >= 0) {
        result = dos_read(file, buffer, n_bytes);
    }
    return result;
}

/* PORT H098+$00D0 (GWriteFlush) */
s32 gio_write_flush(cok_bptr file)
{
    s32 result = 0;

    (void)file;
    if (s_file != 0 && s_buffer != NULL && s_index > 0) {
        result = dos_write(s_file, s_buffer, s_waterline);
    }
    s_waterline = 0;
    s_index = 0;
    return result;
}

/*
 * PORT H098+$0276 (GSeek): dentro il buffer di scrittura si sposta solo
 * l'indice (OFFSET_CURRENT entro il livello raggiunto); altrimenti svuota il
 * buffer e chiama Seek.  -2 significa "usa Seek".
 */
s32 gio_seek(cok_bptr file, s32 position, s32 mode)
{
    s32 result = -2;
    s32 new_index = s_index + position;

    if (file == s_file && s_buffer != NULL) {
        if (mode == OFFSET_CURRENT && new_index >= 0 &&
            new_index <= s_waterline) {
            result = s_index;
            s_index = new_index;
        } else {
            result = gio_write_flush(file);
            if (result >= 0) {
                result = -2;
            }
        }
    }
    if (result == -2) {
        result = dos_seek(file, position, mode);
    }
    return result;
}
